# frozen_string_literal: true

require 'jwt'

# V1::BaseController
class V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
  rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

  rescue_from UriShortnerErrors::BadRequestError, with: :handle_bad_request
  rescue_from UriShortnerErrors::UnauthorizedError, with: :handle_unauthorized
  rescue_from UriShortnerErrors::RequiredParamsMissingError, with: :handle_params_missing
  rescue_from UriShortnerErrors::UnprocessableEntityError, with: :handle_unprocessable_entity
  rescue_from UriShortnerErrors::NotFoundError, with: :handle_not_found
  rescue_from UriShortnerErrors::PreconditionFailedError, with: :handle_precondition_failed

  def set_class_and_entity_names
    @class_name = controller_name.singularize.camelize.constantize
    @entity_symbol = get_entity_symbol(self)
  end

  def get_entity_symbol(controller)
    controller.controller_name.singularize.to_sym
  end

  def get_association_name(association)
    return association.options[:class_name] if association.options.key?(:class_name)

    association.name.to_s.treetop_camelize
  end

  # Basic Actions
  def create
    set_class_and_entity_names
    check_params(@entity_symbol)
    @entity = @class_name.new(params[@entity_symbol].permit!)
    raise UriShortnerErrors::UnprocessableEntityError, @entity.errors.full_messages unless @entity.save

    @partial = get_base_partial
    render :show
  end

  def update
    set_class_and_entity_names
    check_params(:id, @entity_symbol)
    @entity = @class_name.find(params[:id])
    entity_updated = @entity.update_attributes(params[@entity_symbol].permit!)
    raise UriShortnerErrors::UnprocessableEntityError, @entity.errors.full_messages.join(', ') unless entity_updated

    @partial = get_base_partial
    render :show
  end

  def destroy
    check_params(:id)
    set_class_and_entity_names
    @entity = @class_name.find(params[:id])
    raise UriShortnerErrors::UnprocessableEntityError, @entity.errors.full_messages unless @entity.destroy

    @partial = get_base_partial
    render :show
  end

  def index
    collection_maker(params) do |params|
      class_scope = @class_name.all
      index_filtering(params, class_scope)
    end
  end

  # Collection Maker is used to produce a collection of entities, normally used in index and "index like" actions.
  # This function uses the Controller inhereted functions: index_paging and index_sorting, it expects you to provide
  # the equivalent of index_filtering
  # For a single controller, index_paging and index_sorting are shared across all actions that use the collection_maker
  # method
  #
  # The impementation of this function is likely to change in the future, probably getting pulled out of BaseController
  # and put in it's own class or module.
  #
  # @param [Hash] params Any params needed specific to the implementation, this can include paging, sorting, and
  # filtering parameters.
  # @param [Block] blk called with yield below.  It's a block that takes a params (same as above) and returns a scope
  # for the entity (e.g. Company.scoped) the last line of the must evaluate to a scope
  def collection_maker(params)
    set_class_and_entity_names
    limit, offset, @page = index_paging(params)

    class_scope = yield(params)

    @count = class_scope.length

    class_scope = index_sorting(params, class_scope)

    class_scope = class_scope.limit(limit) if limit > 0
    @entities = class_scope.offset(offset).all

    @partial = get_base_partial
  end

  def get_allowed_index_parameters
    @class_name.new.attributes.keys.map(&:to_sym)
  end

  def show
    check_params(:id)
    set_class_and_entity_names
    @entity = @class_name.find(params[:id])
    @class_name.reflect_on_all_associations(:has_one).each do |association|
      next if association.name == :api_credential

      association_name = get_association_name(association)
      sub_entity = association_name.constantize.where(association.foreign_key.to_sym => @entity.id).first
      @entity.send("#{association.name}=".to_sym, sub_entity)
    end
    @partial = get_base_partial
  end

  def check_params(*keys)
    if keys[0].is_a?(Array)
      keys.each do |key|
        return if all_params_provided?(key)
      end
      raise UriShortnerErrors::RequiredParamsMissingError, 'No valid parameter sets were provided.'
    else
      show_parameter_error(keys) unless all_params_provided?(keys)
    end
  end

  def all_params_provided?(keys)
    keys.delete_if { |x| params.key?(x) && !params[x].blank? }
    keys.empty?
  end

  def show_parameter_error(keys)
    error_string = "Required Parameter(s): #{keys.join(', ')} #{keys.length > 1 ? 'are' : 'is'} missing."
    raise UriShortnerErrors::RequiredParamsMissingError, error_string
  end

  def require_universal_credentials
    return unless token_from_request && signature_from_request

    raise UriShortnerErrors::Unauthorized, 'Unauthorized private api access.' if @credentials.authorizable_type != 'Universal'
  end

  # Time Limit set at 15 minutes.
  TIME_LIMIT = (60 * 60)

  protected

  # Gets the base partial, if overridden in child controllers gets the specified partial file name
  def get_base_partial
    'base'
  end

  # find values for limit, offset, page from params
  def index_paging(params, default_limit = 20)
    limit = (params[:limit] || default_limit).to_i
    offset = 0

    if params.key?(:page)
      if params[:page] == 'all'
        page = 1
        limit = 0
      else
        page = params[:page].to_i
        page = 1 if page < 1
        offset = (page - 1) * limit
      end
    else
      page = 1
      offset = 0
    end

    [limit, offset, page]
  end

  # mutate scope to include filtering for "get_allowed_index_parameters"
  def index_filtering(params, class_scope)
    get_allowed_index_parameters.each do |parameter|
      class_scope = class_scope.where(parameter => params[parameter]) if params.key?(parameter)
    end

    class_scope
  end

  # mutate scope to include order, if stipulated
  def index_sorting(params, class_scope)
    sort_by = nil
    if params.key?(:sort_by)
      sort_by = params[:sort_by]
      sort_by = "#{sort_by} #{params[:sort_direction]}" if params.key?(:sort_direction)
    end
    class_scope = class_scope.order(sort_by) if sort_by

    class_scope
  end

  def record_not_found_error(exception)
    @errors = exception.message
    render status: :not_found
  end

  def record_not_unique(exception)
    @errors = exception.message
    render status: :bad_request
  end

  def handle_bad_request(exception)
    @errors = exception.errors
    render status: :bad_request
  end

  def handle_unauthorized(exception)
    @errors = exception.errors
    render status: :unauthorized
  end

  def handle_params_missing(exception)
    @errors = exception.errors
    render status: :precondition_failed
  end

  def handle_unprocessable_entity(exception)
    @errors = exception.errors
    render status: :unprocessable_entity
  end

  def handle_not_found(exception)
    @errors = exception.errors
    render status: :not_found
  end

  def handle_precondition_failed(exception)
    @errors = exception.errors
    render status: :precondition_failed
  end

  def convert_to_md5(password)
    Digest::MD5.hexdigest(password)
  end

  # API Authorization
  def authorize_access
    render status: :unauthorized unless authorized?
  end

  def authorize_access_via_api_key
    render status: :unauthorized unless authorized_using_api_key?
  end

  private

  def authorized?
    if token_from_request && signature_from_request
      raise bad_request_error if request_expired?
      raise UriShortnerErrors::UnauthorizedError.new('Unauthorized access.', @last_message, true, params) unless hmac_valid?

      @credentials.last_access = Time.current
      @credentials.save
    else
      payload = decode(auth_header)
      raise bad_request_error unless valid?(payload)

      @current_user = load_user(payload)
      @current_user_session = AuthService.get_session(payload['session'])

      if @current_user.present? && @current_user_session.present? && @current_user_session.is_alive # && !expired?(@current_user_session.latest_transaction)
        # update the latest field
        AuthService.update_session(@current_user_session)
      else
        raise bad_request_error
      end
    end
    true
  end

  def bad_request_error
    UriShortnerErrors::BadRequestError.new('Bad request.', true, params)
  end

  def encode(user_id, session, access)
    payload = {
      user_id: user_id,
      session: session,
      access: access
    }
    JWT.encode(payload, nil, Rails.application.secrets.secret_key_base)
  end

  def decode(token)
    JWT.decode(token, nil, Rails.application.secrets.secret_key_base)[0]
  rescue JWT::VerificationError
    raise UriShortnerErrors::UnauthorizedError.new('Unauthorized access.', @last_message, true, params)
  end

  def valid?(payload)
    payload.key?('user_id') && payload.key?('session') && payload.key?('access')
  end

  def load_user(payload)
    User.find(payload['user_id'])
  end

  def expired?(latest)
    (Time.current.utc - latest) > TIME_LIMIT
  end

  # Protect against API replay attacks.
  def request_expired?
    return true unless params.key?('nonce') && params['nonce'].present?

    (Time.current.utc - Time.parse(CGI.unescape(params['nonce'])).utc) > TIME_LIMIT
  end

  def hmac_valid?
    signature_from_request == OpenSSL::HMAC.hexdigest('sha256', secret_key, message)
  end

  def message
    query = params.clone
    query.delete_if { |_k, v| v.is_a?(Hash) && v.empty? }

    %w[action controller format id activation_code key email_key data_file].each do |key|
      query.delete(key)
    end
    query['method'] = request.method.downcase
    sorted = query.sort

    message = ''
    sorted.each_index do |x|
      message << '&' unless x.zero?
      message << "#{sorted[x][0]}=#{sorted[x][1]}"
    end
    @last_message = message
    message
  end

  def secret_key
    Rails.logger.info(token_from_request)
    @credentials = ApiCredential.where(access_key: token_from_request).limit(1).first
    @credentials.present? ? @credentials.access_secret : ''
  end

  def token_from_request
    match = /(?<=token\=\")\w+(?=")/.match(auth_header)
    return match[0] unless match.blank?
  end

  def signature_from_request
    match = /(?<=signature\=\")\w+(?=")/.match(auth_header)
    return match[0] unless match.blank?
  end

  def auth_header
    if Rails.env.test?
      request.headers['Authorization']
    else
      request.authorization.to_s
    end
  end

  def authorized_using_api_key?
    payload = decode(auth_header)
    raise bad_request_error unless valid?(payload)

    @current_user = load_user(payload)

    if @current_user.present? && @current_user.active_auth_detail.auth_key == params[:api_key]
      true
    else
      raise bad_request_error
    end

    true
  end
end

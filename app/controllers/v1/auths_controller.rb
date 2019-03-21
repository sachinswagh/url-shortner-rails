# frozen_string_literal: true

# V1
module V1
  # AuthsController
  class AuthsController < V1::BaseController
    before_action(only: %i[login sign_up]) { |c| c.check_params(:user) }
    before_action :validate_params, only: %i[login sign_up]

    def login
      set_user
      response = @user.present? ? login_success : login_failure

      render json: response
    end

    def logout
      if @current_user_session.present?
        @current_user_session.is_alive = false
        @current_user_session.latest_transaction = Time.current
        @current_user_session.save
      end

      render json: { status: :ok }
    end

    def sign_up
      save_user
      response = @user.persisted? ? sign_up_success : sign_up_failure
      render json: response
    end

    private

    def validate_params
      if params[:user].blank? || params[:user][:email].blank? || params[:user][:password].blank?
        err_message = 'Required parameter(s) email/password missing'
        raise UriShortnerErrors::PreconditionFailedError, err_message
      end
    end

    def login_success
      user_id = @user.id
      session = AuthService.create_session(user_id)
      authorization = encode(user_id, session.identifier, ['user'])

      {
        token: authorization,
        user_first_name: @user.first_name,
        user_last_name: @user.last_name,
        user_id: @user.id,
        email: @user.email
      }
    end

    def login_failure
      {
        status: :not_found
      }
    end

    def sign_up_success
      {
        email: @user.email,
        user_first_name: @user.first_name,
        user_last_name: @user.last_name,
        status: :created
      }
    end

    def sign_up_failure
      {
        status: :not_created,
        errors: @user.errors.messages.join(', ')
      }
    end

    def email
      params[:user][:email]
    end

    def password
      params[:user][:password]
    end

    def crypted_password
      convert_to_md5(password)
    end

    def set_user
      @user = User.where('email = ? and crypted_password = ?', email, crypted_password).last
    end

    def save_user
      @user = User.new(
        email: email,
        crypted_password: crypted_password,
        first_name: params[:user][:first_name],
        last_name: params[:user][:last_name]
      )
      @user.save
    end
  end
end

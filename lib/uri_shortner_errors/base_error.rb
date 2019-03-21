# frozen_string_literal: true

module UriShortnerErrors
  class BaseError < StandardError
    attr_accessor :errors, :params, :notify_handler

    def initialize(message = self.class.name, notify_handler = false, params = {})
      @errors ||= message
      @errors       = @errors.is_a?(Array) ? @errors : [@errors]
      @params       = params
      error_message = @errors.join(',')
      super(error_message)
      @notify_handler = notify_handler
      notify!
    end

    def write_to_log!
      Rails.logger.error { message.to_s }
      Rails.logger.error { filtered_params.to_s }
      Rails.logger.error { backtrace.to_yaml.to_s }
    end

    def notify!
      write_to_log!
      Raven.capture_message(self, extra: { parameters: params }) if notify_handler
    end

    # Use the parameter filters set up in the application config when we log.
    # @return [Hash] the filtered parameters
    def filtered_params
      return if params.nil?

      filters = Rails.application.config.filter_parameters
      pf      = ActionDispatch::Http::ParameterFilter.new filters
      pf.filter(params)
    end
  end
end

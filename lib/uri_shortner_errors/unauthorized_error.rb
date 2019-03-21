# frozen_string_literal: true

module UriShortnerErrors
  class UnauthorizedError < BaseError
    def initialize(message = self.class.name, last_message = nil, notify_handler = false, params = {})
      errors = []
      errors << message
      errors << last_message unless last_message.blank?
      super(errors, notify_handler, params)
    end
  end
end

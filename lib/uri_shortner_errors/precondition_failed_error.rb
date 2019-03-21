# frozen_string_literal: true

module UriShortnerErrors
  class PreconditionFailedError < BaseError
    def initialize(messages, notify_handler = false, params = {})
      super(messages.blank? ? self.class.name : messages, notify_handler, params)
    end
  end
end

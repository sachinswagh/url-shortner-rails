# frozen_string_literal: true

module UriShortnerErrors
  class UnprocessableEntityError < BaseError
    def initialize(messages, should_notify = false, params = {})
      super(messages.blank? ? self.class.name : messages, should_notify, params)
    end
  end
end

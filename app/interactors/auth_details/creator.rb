# frozen_string_literal: true

# AuthDetails
module AuthDetails
  # Creator
  class Creator
  	attr_reader :user

    def initialize(user_id)
      @user = User.find(user_id)
    end

    def process
      return if user.blank?

      auth_detail = create
      return unless auth_detail.persisted?

      auth_detail.auth_key
    end

    def create
      auth_detail = user.auth_details.new(auth_key: new_auth_key)
      auth_detail.save

      auth_detail
    end

    def new_auth_key
      SecureRandom.hex(30)
    end
  end
end

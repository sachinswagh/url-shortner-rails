# frozen_string_literal: true

# V1
module V1
  # AuthDetailsController
  class AuthDetailsController < V1::BaseController
    before_action :authorize_access

    def create
      api_key = AuthDetails::Creator.new(@current_user.id).process

      render json: {api_key: api_key}
    end

    def show
    end
  end
end

# frozen_string_literal: true

# V1
module V1
  # UriController
  class UriController < V1::BaseController
    before_action :authorize_access_via_api_key, except: %i[resolve]

    def shorten
      short_url = Uri::Shortner.new(params).process
      render json: { short_url: short_url, status: 200 }
    rescue StandardError => e
      render json: { errors: e.message, status: 200 }
    end

    def resolve
      long_url = Uri::Finder.new(params).process

      if long_url.present?
        redirect_to long_url
      else
        render json: { text: 'invalid_uri' }
      end
    end
  end
end

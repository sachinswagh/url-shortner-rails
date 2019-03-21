# frozen_string_literal: true

# Uri
module Uri
  # This class shortens the given long_url.
  class Shortner
    attr_reader :long_url
    attr_accessor :short_url

    def initialize(params)
      @long_url = params[:long_url]
      @short_url = nil
    end

    def process
      return existing_mapping.short_url if existing_mapping.present?

      shorten
      save
      short_url
    end

    def shorten
      @short_url ||= generate_shortened_url
    end

    def save
      return if short_url.blank?

      url_mapping = UrlMapping.new(
        short_url: short_url,
        long_url: long_url
      )

      url_mapping.save
    end

    private

    def generate_shortened_url
      shortened_url = "#{APP_DOMAIN}/#{short_pattern}"
      shortened_url_exists = UrlMapping.where(short_url: shortened_url).exists?

      generate_shortened_url if shortened_url_exists
      shortened_url
    end

    def existing_mapping
      @existing_mapping ||= UrlMapping.where(long_url: long_url).last
    end

    def short_pattern
      [*('A'..'Z'), *('a'..'z'), *(0..9)].sample(8).join
    end
  end
end

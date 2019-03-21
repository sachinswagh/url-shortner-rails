# frozen_string_literal: true

# Uri
module Uri
  # Finder
  class Finder
    attr_reader :options
    attr_accessor :long_url

    def initialize(options)
      @options = options
      @long_url = nil
    end

    def process
      return if short_url.blank?

      url_mapping.long_url if url_mapping.present?
    end

    private

    def short_url
      return if options[:path].blank?

      @short_url ||= "#{APP_DOMAIN}/#{options[:path]}"
    end

    def url_mapping
      @url_mapping ||= UrlMapping.where(short_url: short_url).last
    end
  end
end

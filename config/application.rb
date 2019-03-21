# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UriShortner
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/services
      #{config.root}/app/interactors
    ]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # origins 'https://localhost:3000'
        origins '*'
        resource '*', headers: :any, methods: %i[get post options put delete]
      end
    end

    config.action_controller.default_protect_from_forgery = false
  end
end

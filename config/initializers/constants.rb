# frozen_string_literal: true

case Rails.env
when 'development'
  APP_DOMAIN = 'http://localhost:3001'
when 'staging'
  APP_DOMAIN = 'http://localhost:3001'
when 'test'
  APP_DOMAIN = 'http://localhost:3001'
when 'production'
  APP_DOMAIN = 'http://localhost:3001'
end

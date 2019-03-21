# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'uri_shortner@gmail.com'
  layout 'mailer'
end

# frozen_string_literal: true

# UrlMapping model
class UrlMapping < ApplicationRecord
  # Validations
  validates_uniqueness_of :short_url, :long_url
end

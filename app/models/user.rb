# frozen_string_literal: true

# User model.
class User < ApplicationRecord
  # Associations
  has_one :user_session
  has_many :auth_details

  # Validations
  validates_uniqueness_of :email

  def active_auth_detail
    auth_details.where(expired_at: [nil, '']).last
  end
end

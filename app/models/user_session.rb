# frozen_string_literal: true

# UserSession
class UserSession < ApplicationRecord
  # Associations
  belongs_to :user
end

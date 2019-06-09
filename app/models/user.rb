# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string
#  crypted_password :string
#  first_name       :string
#  last_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

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

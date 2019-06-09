# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_details
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  auth_key   :text
#  expired_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# AuthDetail model.
class AuthDetail < ApplicationRecord
  # Associations
  belongs_to :user

  # Callbacks
  before_create :expire_existing_details

  # Instance Methods
  def expire_existing_details
    user.auth_details.where(expired_at: [nil, '']).update_all(expired_at: Time.current)
  end

  def expired?
    expired_at.present?
  end

  def active?
    !expired?
  end
end

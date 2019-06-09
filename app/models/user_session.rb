# frozen_string_literal: true

# == Schema Information
#
# Table name: user_sessions
#
#  id                 :integer          not null, primary key
#  identifier         :string
#  user_id            :integer
#  role               :integer
#  latest_transaction :datetime
#  is_alive           :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# UserSession
class UserSession < ApplicationRecord
  # Associations
  belongs_to :user
end

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

FactoryBot.define do
  factory :auth_detail do
    user_id { 1 }
    auth_key { 'asdhfasdfasdhafsd' }
    expired_at { '2019-03-14 21:59:07' }
  end
end

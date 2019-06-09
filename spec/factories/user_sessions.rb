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

FactoryBot.define do
  factory :user_session do
    identifier { 'SJAGsASJGAs162hhh' }
    user_id { 1 }
    role { 1 }
    latest_transaction { '2019-03-09 21:32:51' }
    is_alive { false }
  end
end

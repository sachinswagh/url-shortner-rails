# frozen_string_literal: true

FactoryBot.define do
  factory :auth_detail do
    user_id { 1 }
    auth_key { 'asdhfasdfasdhafsd' }
    expired_at { '2019-03-14 21:59:07' }
  end
end

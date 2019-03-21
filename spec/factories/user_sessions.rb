# frozen_string_literal: true

FactoryBot.define do
  factory :user_session do
    identifier { 'SJAGsASJGAs162hhh' }
    user_id { 1 }
    role { 1 }
    latest_transaction { '2019-03-09 21:32:51' }
    is_alive { false }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'sample_email@gmail.com' }
    crypted_password { 'asdh1hg3a3sARFS' }
    first_name { 'Sachin' }
    last_name { 'Wagh' }
  end
end

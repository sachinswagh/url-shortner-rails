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

FactoryBot.define do
  factory :user do
    email { 'sample_email@gmail.com' }
    crypted_password { 'asdh1hg3a3sARFS' }
    first_name { 'Sachin' }
    last_name { 'Wagh' }
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: url_mappings
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :text
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :url_mapping do
    short_url { 'http://localhost:3001/ufx4eqc3' }
    long_url { 'https://docs.google.com/spreadsheets/d/1Qk0aQMk' }
    active { false }
  end
end

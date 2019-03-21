# frozen_string_literal: true

FactoryBot.define do
  factory :url_mapping do
    short_url { 'http://localhost:3001/ufx4eqc3' }
    long_url { 'https://docs.google.com/spreadsheets/d/1Qk0aQMk' }
    active { false }
  end
end

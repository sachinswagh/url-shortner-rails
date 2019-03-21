# frozen_string_literal: true

require 'rails_helper'

describe ::Uri::Finder do
  let(:long_url) { 'http://www.example.com/users/78/edit' }
  let(:short_url) { "#{APP_DOMAIN}/#{sample_short_pattern}" }
  let(:sample_short_pattern) { 'UBHvSzrj' }

  let(:url_mapping) do
    FactoryBot.create(:url_mapping,
                      long_url: long_url,
                      short_url: short_url)
  end

  let(:params) { { path: sample_short_pattern } }

  subject { described_class.new(params) }

  context '#process' do
    it 'returns nil if short_url is blank' do
      subject = described_class.new({})
      result = subject.process
      expect(result).to be_nil
    end

    it 'returns nil if mapping does not exist' do
      result = subject.process
      expect(result).to be_nil
    end

    it 'should return long_url if mapping exists' do
      url_mapping.reload
      result = subject.process
      expect(result).to eq(long_url)
    end
  end
end

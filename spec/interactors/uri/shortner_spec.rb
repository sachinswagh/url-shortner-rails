# frozen_string_literal: true

require 'rails_helper'

describe ::Uri::Shortner do
  let(:long_url) { 'http://www.example.com/users/78/edit' }
  let(:short_url) { "#{APP_DOMAIN}/#{sample_short_pattern}" }
  let(:sample_short_pattern) { 'UBHvSzrj' }

  let(:url_mapping) do
    FactoryBot.create(:url_mapping,
                      long_url: long_url,
                      short_url: short_url)
  end

  let(:params) { { long_url: long_url } }

  subject { described_class.new(params) }

  context '#process' do
    it 'returns existing short_url if mapping exists' do
      url_mapping.reload
      result = subject.process
      expect(result).to eq(short_url)
    end

    it 'receives methods required to shorten if mapping does not exist' do
      expect(subject).to receive(:shorten)
      result = expect(subject).to receive(:save)
      subject.process
    end
  end

  context '#shorten' do
    it 'returns short_url' do
      expect(subject).to receive(:short_pattern).and_return(sample_short_pattern)
      result = subject.shorten
      expect(result).to eq(short_url)
    end
  end

  context '#save' do
    it 'returns nil if short_url is blank' do
      result = subject.save
      expect(result).to be_nil
    end

    it 'saves url_mapping if short_url is set' do
      subject.short_url = short_url
      result = subject.save
      expect(result).to be_truthy
    end
  end
end

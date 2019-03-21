# frozen_string_literal: true

require 'rails_helper'

describe ::AuthDetails::Creator do
  # let(:long_url) { 'http://www.example.com/users/78/edit' }
  # let(:short_url) { "#{APP_DOMAIN}/#{sample_short_pattern}" }
  # let(:sample_short_pattern) { 'UBHvSzrj' }

  let(:user) { FactoryBot.create(:user) }
  let(:api_key) { 'dshjsdhfsdfhj' }
  let(:params) { { path: sample_short_pattern } }

  subject { described_class.new(user.id) }

  context '#process' do
    it 'returns nil if user is blank' do
      expect(User).to receive(:find).and_return(nil)
      result = subject.process
      expect(result).to be_nil
    end

    it 'returns auth_key' do
      expect(SecureRandom).to receive(:hex).with(30).and_return(api_key)

      result = subject.process
      expect(result).to eq(api_key)
    end
  end

  context '#create' do
    it 'returns auth_detail' do
      expect(SecureRandom).to receive(:hex).with(30).and_return(api_key)

      auth_detail = subject.create
      expect(auth_detail.auth_key).to eq(api_key)
    end
  end
end

require 'spec_helper'

RSpec.describe Payoneer::Configuration do
  subject do
    self.extend(described_class)
  end

  before do
    subject.configure do |c|
      c.environment = :sandbox
      c.client_id = SecureRandom.uuid
      c.client_secret = SecureRandom.uuid
      c.program_id = 1
    end
  end

  describe '.authorize_url' do
    it 'returns authorization url' do
      expect(described_class.authorize_url).to eq(
        "#{described_class.auth_url}/authorize?"\
        "client_id=#{subject.client_id}&"\
        "redirect_uri=#{subject.callback_url}&"\
        "scope=read%20write%20openid%20personal-details&"\
        "response_type=code"
      )
    end
  end

  describe '.token_url' do
    it 'returns token url' do
      expect(described_class.token_url).to eq(
        "#{described_class.auth_url}/token"
      )
    end
  end

  describe '.api_url' do
    it 'returns url based on env' do
      expect(described_class.api_url).to eq(
        'https://api.sandbox.payoneer.com/v4'
      )
    end
  end

  describe '.auth_url' do
    it 'returns url based on env' do
      expect(described_class.auth_url).to eq(
        'https://login.sandbox.payoneer.com/api/v2/oauth2'
      )
    end
  end
end

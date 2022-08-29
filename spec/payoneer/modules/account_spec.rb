require 'spec_helper'

RSpec.describe Payoneer::Account do
  before do
    allow(HTTParty).to receive(:post)
      .with(
        /.+\/token/,
        body: hash_including(:grant_type),
        headers: hash_including('Content-Type'),
        basic_auth: hash_including(:username, :password)
      )
      .and_return(
        double(
          'HTTParty::Response',
          code: 200,
          body: {
            access_token: '',
            expires_in: 120000
          }.to_json
        )
      )
  end

  describe '.access_token' do
    it 'returns a token in the response' do
      response = described_class.access_token('123')
      expect(response.body['access_token']).to_not be_nil
    end
  end

  describe '.refresh_token' do
    it 'returns a token in the response' do
      response = described_class.refresh_token('12903jnsa0e2e901ndsa')
      expect(response.body['access_token']).to_not be_nil
    end
  end

  describe '.details' do
    before do
      allow(described_class).to receive(:get)
        .and_return({
          'result' => {
            'account_details' => {
              'contact' => {
                'email' => 'test@example.com'
              },
              'address' => {
                'city' => 'Berlin'
              }
            }
          }
        })
    end

    context 'when token and id provided' do
      it 'returns merged contact and address data' do
        response = described_class.details('213921321n0dsa09dn2', '12345')
        expect(response['email']).to_not be_nil
        expect(response['city']).to_not be_nil
      end
    end

    context 'when token is nil' do
      it 'returns nil' do
        expect(described_class.details(nil, '12345')).to be_nil
      end
    end
  end
end

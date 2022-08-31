require 'spec_helper'

RSpec.describe Payoneer::Account do
  describe '.details' do
    before do
      allow(HTTParty).to receive(:get)
        .and_return(double(
          'HTTParty::Response',
          code: 200,
          body: {
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
          }.to_json
        ))
    end

    context 'when token and id provided' do
      it 'returns account details' do
        response = described_class.details(account_id: '12345', access_token: '213921321n0dsa09dn2', )

        expect(response.account_details[:contact][:email]).to eq 'test@example.com'
        expect(response.account_details[:address][:city]).to eq 'Berlin'
      end
    end

    context 'when token is nil' do
      it 'returns nil' do
        expect(described_class.details(account_id: '12345')).to be_nil
      end
    end
  end
end

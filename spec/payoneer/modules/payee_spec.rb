require 'spec_helper'

RSpec.describe Payoneer::Payee do
  describe '.create_link' do
    before do
      allow(HTTParty).to receive(:post)
        .with(/.+\/registration-link/, hash_including(:body, headers: hash_including('Authorization')))
        .and_return(stub_http_response(
          body: {
            'result' => {
              'registration_link' => 'http://example.com'
            }
          }
        ))
    end

    it 'returns link in the response' do
      result = described_class.create_link(params: {}, access_token: '')
      expect(result.registration_link).to eq 'http://example.com'
    end
  end

  describe '.status' do
    before do
      allow(HTTParty).to receive(:get)
        .with(/.+\/status/, anything())
        .and_return(stub_http_response(
          body: {
            'result' => {
              'status' => 'Active'
            }
          }
        ))
    end

    it 'returns result from body' do
      expect(described_class.status(payee_id: '').status).to eq 'Active'
    end
  end

  describe '.release' do
    before do
      allow(HTTParty).to receive(:delete)
        .with(/.+\/payees\/.*/, anything())
        .and_return(stub_http_response(
          body: {
            'result' => {
              'payee_id' => '12345'
            }
          }
        ))
    end

    it 'returns result from body' do
      expect(described_class.release(payee_id: '').payee_id).to eq '12345'
    end
  end

  describe '.details' do
    before do
      allow(HTTParty).to receive(:get)
        .with(/.+\/details/, anything())
        .and_return(stub_http_response(
          body: {
            'result' => {
              'account_id' => '5510700',
              'type' => 'INDIVIDUAL',
              'contract' => {
                'email' => 'demo008@yopmail.com'
              },
              'address' => {
                'city' => 'Berlin'
              }
            }
          }
        ))
    end

    it 'returns result from body' do
      response = described_class.details(payee_id: '')

      expect(response[:contract][:email]).to eq 'demo008@yopmail.com'
      expect(response[:address][:city]).to eq 'Berlin'
    end
  end
end

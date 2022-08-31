require 'spec_helper'

RSpec.describe Payoneer::Payee do
  describe '.create_link' do
    before do
      allow(HTTParty).to receive(:post)
        .with(/.+\/registration-link/, anything())
        .and_return(stub_http_response(
          body: {
            'result' => {
              'registration_link' => 'http://example.com'
            }
          }
        ))
    end

    it 'returns link in the response' do
      result = described_class.create_link({})
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
      expect(described_class.status('').status).to eq 'Active'
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
      expect(described_class.release('').payee_id).to eq '12345'
    end
  end
end

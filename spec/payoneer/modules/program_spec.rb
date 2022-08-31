require 'spec_helper'

RSpec.describe Payoneer::Program do
  describe '.balance' do
    before do
      allow(HTTParty).to receive(:get)
        .with(/.+\/balance/, anything())
        .and_return(stub_http_response(
          body: {
            'result' => {
              'balance' => 50.0,
              'currency' => 'USD'
            }
          }
        ))
    end

    it 'returns result from the response' do
      response = described_class.balance
      expect(response.balance).to eq 50.0
      expect(response.currency).to eq 'USD'
    end
  end
end

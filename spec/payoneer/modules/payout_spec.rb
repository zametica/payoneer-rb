require 'spec_helper'

RSpec.describe Payoneer::Payout do
  describe '.create' do
    before do
      allow(HTTParty).to receive(:post)
        .with(/.+\/masspayouts/, hash_including(:body, :headers))
        .and_return(stub_http_response(
          body: {
            'result' => 'Payments Created'
          }
        ))
    end

    context 'when successful' do
      before do
        allow(HTTParty).to receive(:get)
          .with(/.+\/payouts/, hash_including(:body, :headers))
          .and_return(stub_http_response(
            body: {
              'result' => {
                'status' => 'Pending'
              }
            }
          ))
      end

      it 'returns status successfully' do
        response = described_class.create(
          payment_id: '12345',
          payee_id: '000',
          amount: 50.0,
          description: 'test'
        )
        expect(response.payment_id).to eq '12345'
        expect(response.status).to eq 'Pending'
      end
    end

    context 'when fails' do
      before do
        allow(described_class).to receive(:get)
          .with(path: /.+\/payouts/, options: hash_including(:serializer, :response_params))
          .and_raise(Payoneer::Error.new(description: 'Payout not found'))
      end

      it 'returns response with status Failed' do
        response = described_class.create(
          payment_id: '12345',
          payee_id: '000',
          amount: 50.0,
          description: 'test'
        )
        expect(response.status).to eq 'Failed'
        expect(response.payment_id).to_not be_nil
      end
    end
  end

  describe '.status' do
    before do
      allow(HTTParty).to receive(:get)
        .with(/.+\/payouts/, hash_including(:body, :headers))
        .and_return(stub_http_response(
          body: {
            'result' => {
              'status' => 'Pending'
            }
          }
        ))
    end

    it 'returns status response merged with payment_id' do
      response = described_class.status('12345')
      expect(response.status).to eq 'Pending'
      expect(response.payment_id).to eq '12345'
    end
  end
end

require 'spec_helper'

RSpec.describe Payoneer::Payout do
  describe '.create' do
    context 'when successful' do
      before do
        allow(HTTParty).to receive(:post)
          .with(/.+\/masspayouts/, hash_including(:body, :headers))
          .and_return(stub_http_response(
            body: {
              'result' => 'Payments Created'
            }
          ))
      end

      it 'returns payment id successfully' do
        response = described_class.create(
          payment_id: '12345',
          payee_id: '000',
          amount: 50.0,
          description: 'test',
          access_token: ''
        )

        expect(response.result).to eq 'Payments Created'
        expect(response.payment_id).to eq '12345'
      end
    end

    context 'when fails' do
      before do
        allow(HTTParty).to receive(:post)
          .with(/.+\/masspayouts/, hash_including(:body, :headers))
          .and_return(stub_http_response(
            code: 400,
            body: {
              'error' => 'Bad request'
            }
          ))
      end

      it 'raises the payoneer error' do
        expect { described_class.create(
          payment_id: '12345',
          payee_id: '000',
          amount: 50.0,
          description: 'test'
        ) }.to raise_error(Payoneer::Error)
      end
    end
  end

  describe '.status' do
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

      it 'returns status response merged with payment_id' do
        response = described_class.status(payment_id: '12345')

        expect(response.status).to eq 'Pending'
        expect(response.payment_id).to eq '12345'
      end
    end

    context 'when fails' do
      before do
        allow(HTTParty).to receive(:get)
          .with(/.+\/payouts/, hash_including(:body, :headers))
          .and_return(stub_http_response(
            code: 400,
            body: {
              'error' => 'Not found'
            }
          ))
      end

      it 'returns status Failed' do
        response = described_class.status(payment_id: '12345')

        expect(response.status).to eq 'Failed'
        expect(response.payment_id).to eq '12345'
      end
    end
  end
end

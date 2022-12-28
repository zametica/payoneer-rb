require 'spec_helper'

RSpec.describe Payoneer::Auth do
  def stub_token(code: 200)
    allow(HTTParty).to receive(:post)
      .with(
        /.+\/token/,
        hash_including(:body, :headers)
      )
      .and_return(
        stub_http_response(
          code: code,
          body: {
            access_token: SecureRandom.uuid,
            expires_in: 120_000
          }
        )
      )
  end

  describe '.application_token' do
    context 'when successful' do
      before { stub_token }

      it 'returns access_token' do
        result = described_class.application_token(client_id: 1, client_secret: 1)
        expect(result.access_token).to_not be_nil
      end
    end

    context 'when request fails' do
      before { stub_token(code: 401) }

      it 'raises an error' do
        expect { described_class.application_token(client_id: 1, client_secret: 1) }.to(
          raise_error(Payoneer::Error)
        )
      end
    end
  end

  describe '.access_token' do
    context 'when successful' do
      before { stub_token }

      it 'returns access_token' do
        result = described_class.access_token(code: 1, client_id: 1, client_secret: 1)
        expect(result.access_token).to_not be_nil
      end
    end

    context 'when request fails' do
      before { stub_token(code: 401) }

      it 'raises an error' do
        expect { described_class.access_token(code: 1, client_id: 1, client_secret: 1) }.to(
          raise_error(Payoneer::Error)
        )
      end
    end
  end

  describe '.refresh_token' do
    context 'when successful' do
      before { stub_token }

      it 'returns access_token' do
        result = described_class.refresh_token(refresh_token: 1, client_id: 1, client_secret: 1)
        expect(result.access_token).to_not be_nil
      end
    end

    context 'when request fails' do
      before { stub_token(code: 401) }

      it 'raises an error' do
        expect { described_class.refresh_token(refresh_token: 1, client_id: 1, client_secret: 1) }.to(
          raise_error(Payoneer::Error)
        )
      end
    end
  end

  describe '.revoke_token' do
    context 'when successful' do
      before do
        allow(HTTParty).to receive(:post)
          .with(
            /.+\/revoke/,
            hash_including(:body, :headers)
          )
          .and_return(
            stub_http_response(
              body: {
                status: 'success'
              }
            )
          )
      end

      it 'returns status in the response' do
        result = described_class.revoke_token(token: 1, client_id: 1, client_secret: 1)
        expect(result.status).to eq 'success'
      end
    end

    context 'when request fails' do
      before do
        allow(HTTParty).to receive(:post)
          .with(
            /.+\/revoke/,
            hash_including(:body, :headers)
          )
          .and_return(
            stub_http_response(
              code: 401,
              body: {
                error: 'Failed'
              }
            )
          )
      end

      it 'raises an error' do
        expect { described_class.revoke_token(token: 1, client_id: 1, client_secret: 1) }.to(
          raise_error(Payoneer::Error)
        )
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Payoneer::RemoteApi do
  def stub_request(method:, path: '', code: 200, body: {})
    allow(HTTParty).to receive(:send)
      .with(method, path, hash_including(:body, :headers))
      .and_return(stub_http_response(code: code, body: body))
  end

  it 'extends the base class' do
    test_module = Module.new
    test_module.extend described_class

    expect(test_module.singleton_class.included_modules).to include test_module
  end

  subject do
    extend(described_class)
  end

  %w[post get put delete].each do |method|
    describe ".#{method}" do
      context 'when successful' do
        before do
          stub_request(
            method: method.to_sym,
            path: /.+\/#{method}-success/,
            body: { result: { status: :ok } }
          )
        end

        it 'returns body successfully' do
          response = subject.send(method, path: "/#{method}-success", options: { access_token: '' })

          expect(response).to be_kind_of(Payoneer::Response)
          expect(response.status).to eq 'ok'
        end
      end

      context 'when fails' do
        before do
          stub_request(method: method.to_sym, path: /.+\/#{method}-fail/, code: 500)
        end

        it 'raises an error' do
          expect { subject.send(method, path: "/#{method}-fail") }.to raise_error(Payoneer::Error)
        end
      end

      context 'when it raises a response error' do
        before do
          allow(HTTParty).to receive(:send)
            .with(method.to_sym, /.+\/#{method}-fail/, hash_including(:body, :headers))
            .and_raise(HTTParty::Error)
        end

        it 'raises a payoneer error' do
          expect { subject.send(method, path: "/#{method}-fail") }.to raise_error(Payoneer::Error)
        end
      end
    end
  end
end

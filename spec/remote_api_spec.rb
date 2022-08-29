require 'spec_helper'

RSpec.describe Payoneer::RemoteApi do
  def stub_request(method:, path: '', code: 200, body: {})
    allow(HTTParty).to receive(:send)
      .with(method, path, hash_including(:body, :headers))
      .and_return(double(
        'HTTParty::Response',
        code: code,
        body: body.to_json
      ))
  end

  it 'extends the base class' do
    _module = Module.new
    _module.extend described_class

    expect(_module.singleton_class.included_modules).to include _module
  end

  subject do
    self.extend(described_class)
  end

  before do
    allow(HTTParty).to receive(:post)
      .with(
        /.+\/token/,
        body: hash_including(:grant_type, :scope),
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
    allow(Rails).to receive(:cache)
      .and_return(ActiveSupport::Cache.lookup_store(:memory_store))
  end

  %w[post get put delete].each do |method|
    describe ".#{method}" do
      context 'when successful' do
        before do
          stub_request(method: method.to_sym, path: /.+\/#{method}-success/, body: { status: :ok })
        end
  
        it 'returns body successfully' do
          response = subject.send(method, path: "/#{method}-success")
          expect(response).to_not be_nil
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

  describe 'expired token in cache' do
    before do
      allow(Rails.cache).to receive(:fetch)
        .with(
          key: 'payoneer_access_token',
          expires_in: 1.day,
          force: false
        )
        .and_return({ access_token: '', expires_at: Time.current })
      allow(Rails.cache).to receive(:fetch)
        .with(
          key: 'payoneer_access_token',
          expires_in: 1.day,
          force: true
        )
        .and_call_original
      stub_request(method: :get, path: /.+\/get-token/)
    end

    it 'fetches a new one' do
      expect(HTTParty).to receive(:post)
        .with(
          /.+\/token/,
          body: hash_including(:grant_type, :scope),
          basic_auth: hash_including(:username, :password)
        )
      subject.get(path: '/get-token')
    end
  end
end

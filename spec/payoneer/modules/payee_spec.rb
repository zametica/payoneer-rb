require 'spec_helper'

RSpec.describe Payoneer::Payee do
  describe '.create_link' do
    before do
      allow(described_class).to receive(:post)
        .with(path: /.+\/registration-link/, body: hash_including(:redirect_url))
        .and_return({
          'result' => {
            'registration_link' => 'http://example.com'
          }
        })
    end

    it 'returns link in the response' do
      expect(described_class.create_link({})).to eq 'http://example.com'
    end
  end

  describe '.status' do
    before do
      allow(described_class).to receive(:get)
        .with(path: /.+\/status/)
        .and_return({
          'result' => {
            'status' => 'Active'
          }
        })
    end

    it 'returns result from body' do
      expect(described_class.status('')['status']).to eq 'Active'
    end
  end

  describe '.release' do
    before do
      allow(described_class).to receive(:delete)
        .with(path: /.+\/payees\/.*/)
        .and_return({
          'result' => {
            'payee_id' => '12345'
          }
        })
    end

    it 'returns result from body' do
      expect(described_class.release('')['result']['payee_id']).to_not be_nil
    end
  end
end

require 'spec_helper'

RSpec.describe Payoneer::Util do
  describe '.parse_account_id' do
    context 'when token valid' do
      it 'parses the id_token' do
        id_encoded = Base64.encode64({account_id: 1}.to_json)
        expect(
          described_class.parse_account_id("0.#{id_encoded}")
        ).to eq 1
      end
    end

    context 'when token invalid' do
      it 'raises an exception' do
        expect { described_class.parse_account_id('') }.to(
          raise_error(NoMethodError)
        )
      end
    end

    context 'when token does not include id' do
      it 'returns nil' do
        token = Base64.encode64({ test: '1' }.to_json)
        expect(described_class.parse_account_id("1.#{token}")).to be_nil
      end
    end
  end
end

require 'spec_helper'

RSpec.describe Payoneer::Response do
  describe '.convert' do
    let(:array) do
      [
        { id: 1 },
        { id: 2 }
      ]
    end

    context 'when response is an array' do
      it 'creates an instance for each object in array' do
        result = described_class.convert(array)

        expect(result).to all be_kind_of(described_class)
        expect(result).to all respond_to(:id)
        expect(result).to all respond_to(:body)
      end
    end

    context 'when response is a hash' do
      let(:hash) do
        {
          status: :ok,
          nested: {
            child: :value
          }
        }
      end

      it 'creates a getter for each key in the hash' do
        result = described_class.convert(hash)

        expect(result.body).to_not be_nil
        expect(result.status).to eq :ok
        expect(result.nested).to include({ child: :value })
      end
    end

    context 'when response is neither an array nor a hash' do
      it 'returns the response itself' do
        result = described_class.convert('Hello World')

        expect(result).to eq 'Hello World'
      end
    end
  end
end

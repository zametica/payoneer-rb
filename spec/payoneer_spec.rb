require 'spec_helper'

RSpec.describe Payoneer do
  it 'has a version' do
    expect(described_class::VERSION).to_not be_nil
  end

  describe 'configuration' do
    it 'yields the configuration' do
      described_class.configure do |config|
        config.environment = :sandbox
      end

      expect(described_class.environment).to eq :sandbox
    end
  end
end
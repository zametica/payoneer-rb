$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'payoneer'
require 'pry'
require 'support/stub_response'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.include StubResponse
end

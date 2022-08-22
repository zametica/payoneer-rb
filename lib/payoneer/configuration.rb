module Payoneer
  module Configuration
    def configure
      yield self
    end

    mattr_accessor :api_url
    @@api_url = nil

    mattr_accessor :login_url
    @@login_url = nil

    mattr_accessor :callback_url
    @@callback_url = nil

    mattr_accessor :client_id
    @@client_id = nil

    mattr_accessor :client_secret
    @@client_secret = nil

    mattr_accessor :program_id
    @@callback_url = nil
  end
end

module Payoneer
  module Configuration
    def configure
      yield self
    end

    def self.authorize_url
      "#{auth_url}/authorize?"\
      "client_id=#{client_id}&"\
      "redirect_uri=#{callback_url}&"\
      "scope=read%20write%20openid%20personal-details&"\
      "response_type=code"
    end

    def self.token_url
      "#{auth_url}/token"
    end

    mattr_accessor :api_url
    @@api_url = 'https://api.sandbox.payoneer.com/v4'

    mattr_accessor :auth_url
    @@auth_url = 'https://login.sandbox.payoneer.com/api/v2/oauth2'

    mattr_accessor :callback_url
    @@callback_url = nil

    mattr_accessor :client_id
    @@client_id = nil

    mattr_accessor :client_secret
    @@client_secret = nil

    mattr_accessor :program_id
    @@program_id = nil
  end
end

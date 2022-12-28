module Payoneer
  module Configuration
    def configure
      yield self
    end

    ENV_URLS = {
      sandbox: {
        api: 'https://api.sandbox.payoneer.com/v4',
        auth: 'https://login.sandbox.payoneer.com/api/v2/oauth2'
      },
      production: {
        api: 'https://api.payoneer.com/v4',
        auth: 'https://login.payoneer.com/api/v2/oauth2'
      }
    }.freeze

    def self.authorize_url
      "#{auth_url}/authorize?"\
      "redirect_uri=#{callback_url}&"\
      'scope=read%20write%20openid%20personal-details&'\
      'response_type=code'
    end

    def self.api_url
      ENV_URLS[environment][:api]
    end

    def self.auth_url
      ENV_URLS[environment][:auth]
    end

    mattr_accessor :environment
    @@environment = :sandbox

    mattr_accessor :callback_url
    @@callback_url = nil

    mattr_accessor :program_id
    @@program_id = nil
  end
end

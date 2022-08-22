require 'httparty'

module Payoneer::Account
  module Auth
    extend self

    def access_token(code)
      fetch_token({
        grant_type: 'authorization_code',
        redirect_uri: Payoneer::Configuration.callback_url,
        code: code
      })
    end

    def refresh_token(refresh_token)
      fetch_token({
        grant_type: 'refresh_token',
        refresh_token: refresh_token
      })
    end

    private

    def fetch_token(body: {})
      HTTParty.post(
        Payoneer::Configuration.login_url,
        body: body,
        basic_auth: {
          username: Payoneer::Configuration.client_id,
          password: Payoneer::Configuration.client_secret
        }
      )
    end
  end
end

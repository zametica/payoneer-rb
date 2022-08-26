module Payoneer
  module Account
    extend Payoneer::RemoteApi

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

    def details(access_token, account_id)
      return unless access_token && account_id

      get_details(access_token, account_id)
    end

    private

    def fetch_token(body)
      HTTParty.post(
        Payoneer::Configuration.token_url,
        body: body,
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        basic_auth: {
          username: Payoneer::Configuration.client_id,
          password: Payoneer::Configuration.client_secret
        }
      )
    end

    def get_details(access_token, account_id)
      response = get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: access_token
        }
      )
      details = response.dig('result', 'account_details')
      details['contact'].merge(details['address'])
    end
  end
end

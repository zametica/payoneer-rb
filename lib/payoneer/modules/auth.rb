module Payoneer
  module Auth
    extend Payoneer::RemoteApi

    def application_token(client_id:, client_secret:)
      token(
        body: {
          grant_type: 'client_credentials',
          scope: 'read write',
          client_id: client_id,
          client_secret: client_secret
        }
      )
    end

    def access_token(code:, client_id:, client_secret:)
      token(
        body: {
          grant_type: 'authorization_code',
          redirect_uri: Payoneer::Configuration.callback_url,
          code: code,
          client_id: client_id,
          client_secret: client_secret
        }
      )
    end

    def refresh_token(refresh_token:, client_id:, client_secret:)
      token(
        body: {
          grant_type: 'refresh_token',
          refresh_token: refresh_token,
          client_id: client_id,
          client_secret: client_secret
        }
      )
    end

    def revoke_token(token:, client_id:, client_secret:)
      token(
        path: '/revoke',
        body: {
          token_type_hint: 'access_token',
          token: token,
          client_id: client_id,
          client_secret: client_secret,
        }
      )
    end

    private

    def token(body:, path: '/token')
      post(
        path: path,
        body: body,
        options: {
          base_url: Payoneer::Configuration.auth_url,
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        }
      )
    end
  end
end

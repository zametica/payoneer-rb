module Payoneer
  module Auth
    extend Payoneer::RemoteApi

    def application_token(client_id:, client_secret:)
      token(
        body: {
          grant_type: 'client_credentials',
          scope: 'read write'
        },
        client_id: client_id,
        client_secret: client_secret
      )
    end

    def access_token(code:, client_id:, client_secret:)
      token(
        body: {
          grant_type: 'authorization_code',
          redirect_uri: Payoneer::Configuration.callback_url,
          code: code
        },
        client_id: client_id,
        client_secret: client_secret
      )
    end

    def refresh_token(refresh_token:, client_id:, client_secret:)
      token(
        body: {
          grant_type: 'refresh_token',
          refresh_token: refresh_token
        },
        client_id: client_id,
        client_secret: client_secret
      )
    end

    def revoke_token(token:, client_id:, client_secret:)
      token(
        path: '/revoke'
        body: {
          token_type_hint: 'access_token',
          token: token
        },
        client_id: client_id,
        client_secret: client_secret,
      )
    end

    private

    def token(path: '/token', body:, client_id:, client_secret:)
      response = post(
        path: path,
        body: body,
        options: {
          base_url: Payoneer::Configuration.auth_url,
          headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
          basic_auth: {
            username: client_id,
            password: client_secret
          }
        }
      )
      
      response.merge(
        expires_at: response['expires_in'].seconds.from_now
      ).with_indifferent_access if response['expires_in']
    end
  end
end

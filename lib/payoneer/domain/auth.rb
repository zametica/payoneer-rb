# frozen_string_literal: true

module Payoneer
  module Auth # :nodoc:
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
          client_secret: client_secret
        }
      )
    end

    private

    def token(body:, path: '/token')
      if body[:client_id].blank? || body[:client_secret].blank?
        raise Payoneer::Errors::AuthError.new(description: 'Missing client credentials')
      end

      perform_request(body, path)
    end

    def perform_request(body, path)
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

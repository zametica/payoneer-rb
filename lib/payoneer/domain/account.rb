# frozen_string_literal: true

module Payoneer
  module Account # :nodoc:
    extend Payoneer::RemoteApi

    def details(account_id:, **args)
      raise missing_token_error if args[:access_token].blank?

      get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: args[:access_token]
        }
      )
    end

    private

    def missing_token_error
      Payoneer::Errors::AuthError.new(description: 'Missing access token')
    end
  end
end

# frozen_string_literal: true

module Payoneer
  module Account # :nodoc:
    extend Payoneer::RemoteApi

    def details(account_id:, **args)
      return if args[:access_token].blank? || account_id.blank?

      get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: args[:access_token]
        }
      )
    end
  end
end

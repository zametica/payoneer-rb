module Payoneer
  module Account
    extend Payoneer::RemoteApi

    def details(access_token:, account_id:)
      return unless access_token && account_id

      get_details(access_token, account_id)
    end

    private

    def get_details(access_token, account_id)
      get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: access_token
        }
      )
    end
  end
end

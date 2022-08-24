module Payoneer::Account
  module Details
    extend Payoneer::RemoteApi

    def call(access_token, account_id)
      return unless access_token && account_id
      
      map get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: access_token
        }
      )
    end

    private

    def map(response)
      details = response.dig('result', 'account_details')
      details['contact'].merge(details['address'])
    end
  end
end

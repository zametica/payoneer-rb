module Payoneer::Account
  module Details
    extend Payoneer::RemoteApi

    def call(token)
      return unless token
      
      account_id = JWT.decode(token)['account_id']
      map get(
        path: "/accounts/#{account_id}/details",
        options: {
          access_token: token
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

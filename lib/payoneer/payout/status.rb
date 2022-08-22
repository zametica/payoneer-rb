module Payoneer::Payout
  module Status
    extend Payoneer::RemoteApi

    def call(client_reference_id)
      get(path: "/programs/#{Payoneer::Configuration.program_id}/payouts/#{client_reference_id}/status")['result']
    end
  end
end

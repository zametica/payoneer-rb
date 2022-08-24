module Payoneer::Payee
  module Status
    extend Payoneer::RemoteApi

    def call(payee_id)
      get(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/status")['result']
    end
  end
end

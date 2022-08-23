module Payoneer::Payee
  module Release
    extend Payoneer::RemoteApi

    def call(payee_id)
      delete(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}")
    end
  end
end

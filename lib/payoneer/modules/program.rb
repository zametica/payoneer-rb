module Payoneer
  module Program
    extend Payoneer::RemoteApi

    def balance
      response = get(path: "/programs/#{Payoneer::Configuration.program_id}/balance")
      Balance.new(response)
    end
  end
end

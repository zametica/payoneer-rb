module Payoneer
  module Program
    extend Payoneer::RemoteApi

    def balance
      get(path: "/programs/#{Payoneer::Configuration.program_id}/balance")['result']
    end
  end
end

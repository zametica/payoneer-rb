module Payoneer::Program
  module Balance
    extend Payoneer::RemoteApi

    def call
      get(path: "/programs/#{Payoneer::Configuration.program_id}/balance")['result']
    end
  end
end

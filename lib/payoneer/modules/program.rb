module Payoneer
  module Program
    extend Payoneer::RemoteApi

    def balance(**args)
      get(
        path: "/programs/#{Payoneer::Configuration.program_id}/balance",
        options: args
      )
    end
  end
end

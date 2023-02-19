# frozen_string_literal: true

module Payoneer
  module Program # :nodoc:
    extend Payoneer::RemoteApi

    def balance(**args)
      get(
        path: "/programs/#{Payoneer::Configuration.program_id}/balance",
        options: args
      )
    end
  end
end

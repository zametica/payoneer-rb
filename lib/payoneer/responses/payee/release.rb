module Payoneer::Payee
  class Release < BaseResponse
    attr_reader :payee_id, :release_date

    def initialize(response = {})
      super(response['result'])

      @payee_id = response[:payee_id]
      @release_date = response[:release_date]
    end
  end
end
module Payoneer::Payout
  class Balance < BaseResponse
    attr_reader :amount, :currency

    def initialize(response = {})
      super(response['result'])

      @amount = response[:amount]
      @currency = response[:currency]
    end
  end
end

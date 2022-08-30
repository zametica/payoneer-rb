module Payoneer::Payee
  class Status < BaseResponse
    attr_reader :account_id, :status, :registration_date, :payout_type

    def initialize(response = {})
      super(response['result'])

      @account_id = response[:account_id]
      @status = response[:status][:description]
      @registration_date = response[:registration_date]
      @payout_type = response[:payout_method][:type]
    end
  end
end

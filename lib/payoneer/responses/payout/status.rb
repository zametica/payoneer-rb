module Payoneer::Payout
  class Status < BaseResponse
    attr_reader :payout_date, :amount, :currency, :status,
                :payee_id, :payout_id, :payment_id

    def initialize(response = {}, payment_id)
      super(response['result'])

      @payout_date = response[:payout_date]
      @amount = response[:amount]
      @currency = response[:currency]
      @status = response[:status]
      @payee_id = response[:payee_id]
      @payout_id = response[:payout_id]
      @payment_id = payment_id
    end

    def rejected?
      response[:reason_code].present?
    end

    def cancelled?
      status == 'Cancelled'
    end

    def success?
      status == 'Transferred'
    end

    def pending?
      status.in? %w[Pending Pending \Payee]
    end

    def reason
      {
        code: response[:reason_code] || response[:cancel_reason_code],
        description: response[:reason_description] || response[:cancel_reason_description]
      }
    end

    def error
      response.dig('error', 'description')
    end
  end
end

module Payoneer::Payout
  module Create
    extend Payoneer::RemoteApi

    def call(payment_id:, payee_id:, amount:, description:, currency: 'USD')
      @payment_id = payment_id
      @payee_id = payee_id
      @amount = amount
      @description = description
      @currency = currency

      submit_payout
      payout_status
    rescue Payoneer::Error => e
      {
        status: 'Failed',
        error: e.description,
        reason: e.details,
        payment_id: payment_id
      }.with_indifferent_access
    end

    private

    attr_reader :payment_id, :payee_id, :amount, :description, :currency

    def submit_payout
      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/masspayouts",
        body: transfer_params
      )
    end

    def payout_status
      status = Payoneer::Payout::Status.call(payment_id)
      status.merge(payment_id: payment_id)
    end

    def transfer_params
      {
        payments: [
          {
            client_reference_id: payment_id,
            payee_id: payee_id,
            amount: amount,
            description: description,
            currency: currency
          }
        ]
      }
    end
  end
end

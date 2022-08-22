module Payoneer::Payout
  module Create
    extend Payoneer::RemoteApi

    def call(payment_id:, payee_id:, amount:, description:, currency: 'USD')
      @payment_id = payment_id
      @payee_id = payee_id
      @amount = amount
      @description = description
      @currency = currency

      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/masspayouts",
        body: transfer_params
      )
    end

    private

    attr_reader :payment_id, :payee_id, :amount, :description, :currency

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

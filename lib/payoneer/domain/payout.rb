# frozen_string_literal: true

module Payoneer
  module Payout # :nodoc:
    extend Payoneer::RemoteApi

    def mass_payout(payments: [], **args)
      submit_payout(
        {
          payments: payments
        },
        args
      )
    end

    def create(payment_id:, payee_id:, amount:, description:, currency: 'USD', **args)
      submit_payout(
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
        },
        args
      )
    end

    def status(payment_id:, **args)
      payout_status(payment_id, args)
    end

    private

    def submit_payout(params, args)
      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/masspayouts",
        body: params,
        options: {
          response_params: {
            payment_id: params[:payments][0][:client_reference_id]
          },
          **args
        }
      )
    end

    def payout_status(payment_id, args)
      get(
        path: "/programs/#{Payoneer::Configuration.program_id}/payouts"\
              "/#{payment_id}/status",
        options: {
          serializer: Status,
          response_params: {
            payment_id: payment_id
          },
          **args
        }
      )
    rescue Payoneer::Error => e
      Status.convert(
        {
          status: 'Failed',
          payment_id: payment_id,
          error: {
            description: e.description,
            reason: e.details
          }
        }
      )
    end
  end
end

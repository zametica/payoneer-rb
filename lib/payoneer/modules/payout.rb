module Payoneer
  module Payout
    extend Payoneer::RemoteApi

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
      payout_status(payment_id, args.merge(retry: true))
    end

    def status(payment_id:, **args)
      payout_status(payment_id, args)
    end

    private

    def submit_payout(params, args)
      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/masspayouts",
        body: params,
        options: args
      )
    end

    def payout_status(payment_id, args)
      attempts ||= 0

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
      attempts += 1

      retry if args[:retry] && attempts <= 3

      Status.convert({
        status: 'Failed',
        payment_id: payment_id,
        error: {
          description: e.description,
          reason: e.details
        }
      })
    end
  end
end

module Payoneer
  module Payee
    extend Payoneer::RemoteApi

    def create_link(params: {}, **args)
      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/registration-link",
        body: registration_params(params),
        options: args
      )
    end

    def status(payee_id:, **args)
      get(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/status",
        options: args
      )
    end

    def release(payee_id:, **args)
      delete(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}",
        options: args
      )
    end

    private

    def registration_params(params)
      {
        payee_id: params[:payee_id],
        already_have_an_account: params[:existing] || false,
        redirect_url: "#{Payoneer::Configuration.authorize_url}&client_id=#{params[:client_id]}&state=#{params[:user_id]}"
      }.compact
    end
  end
end

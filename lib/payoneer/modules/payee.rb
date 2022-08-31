module Payoneer
  module Payee
    extend Payoneer::RemoteApi
    
    def create_link(params = {})
      post(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/registration-link",
        body: registration_params(params)
      )
    end

    def status(payee_id)
      get(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/status")
    end

    def release(payee_id)
      delete(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}")
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

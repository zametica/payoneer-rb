module Payoneer
  module Payee
    extend Payoneer::RemoteApi
    
    def create_link(params = {})
      response = post(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/registration-link",
        body: registration_params(params)
      )
      CreateLink.new(response)
    end

    def status(payee_id)
      response = get(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/status")
      Status.new(response)
    end

    def release(payee_id)
      response = delete(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}")
      Release.new(response)
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

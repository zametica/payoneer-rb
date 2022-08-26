module Payoneer
  module Payee
    extend Payoneer::RemoteApi
    
    def create_link(params = {})
      response = post(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/registration-link",
        body: registration_params(params)
      )
      response.dig('result', 'registration_link')
    end

    def status(payee_id)
      get(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/status")['result']
    end

    def release(payee_id)
      delete(path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}")
    end

    private

    def registration_params(params)
      {
        payee_id: params[:payee_id],
        already_have_an_account: params[:existing] || false,
        redirect_url: "#{Payoneer::Configuration.authorize_url}&state=#{params[:user_id]}"
      }.compact
    end
  end
end

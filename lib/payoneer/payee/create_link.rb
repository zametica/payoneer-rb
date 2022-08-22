module Payoneer::Payee
  module CreateLink
    extend Payoneer::RemoteApi
  
    def call(params = {})
      @params = params
      response = post(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/registration-link",
        body: registration_params
      )
      response.dig('result', 'registration_link')
    end

    private

    attr_reader :params

    def registration_params
      request_params = {
        payee_id: params[:payee_id],
        already_have_an_account: params[:existing] || false,
        redirect_url: Payoneer::Configuration.callback_url
      }
      request_params.merge(user_params) if params[:user]

      request_params.compact
    end

    def user_params
      {
        payee: {
          first_name: params[:user][:firstname],
          last_name: params[:user][:lastname],
          email: params[:user][:email]
        }
      }
    end
  end
end

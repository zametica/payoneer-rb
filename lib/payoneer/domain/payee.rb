# frozen_string_literal: true

module Payoneer
  module Payee # :nodoc:
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

    def details(payee_id:, **args)
      get(
        path: "/programs/#{Payoneer::Configuration.program_id}/payees/#{payee_id}/details",
        options: args
      )
    end

    private

    def registration_params(params)
      registration_params = {
        payee_id: params[:payee_id],
        already_have_an_account: params[:existing] || false
      }

      registration_params.merge!(consent_flow_params) if params[:consent]
      registration_params
    end

    def consent_flow_params
      {
        redirect_url: "#{Payoneer::Configuration.authorize_url}&\
                         client_id=#{params[:client_id]}&\
                         state=#{params[:user_id]}"
      }
    end
  end
end

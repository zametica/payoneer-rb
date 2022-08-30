module Payoneer::Payee
  class CreateLink < BaseResponse
    attr_reader :link, :token

    def initialize(response = {})
      super(response['result'])

      @link = response[:registration_link]
      @token = response[:token]
    end
  end
end

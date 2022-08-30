module Payoneer::Account
  class Details < BaseResponse
    attr_reader :first_name, :last_name, :email, :mobile
                :phone, :country, :state, :zip_code
                :address_line_1, :address_line_2, :city

    def initialize(response = {})
      super(response['result'])
      account_details
      address_details
    end

    private

    def account_details
      return unless response[:account_details]

      @first_name = response[:account_details][:first_name]
      @last_name = response[:account_details][:last_name]
      @email = response[:account_details][:email]
      @mobile = response[:account_details][:mobile]
      @phone = response[:account_details][:phone]
    end

    def address_details
      return unless response[:address]

      @country = response[:address][:country]
      @state = response[:address][:state]
      @zip_code = response[:address][:zip_code]
      @address_line_1 = response[:address][:address_line_1]
      @address_line_2 = response[:address][:address_line_2]
      @city = response[:address][:city]
    end
  end
end

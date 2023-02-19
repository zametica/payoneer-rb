# frozen_string_literal: true

module Payoneer
  module Util # :nodoc:
    module_function

    def parse_account_id(id_token)
      payload = id_token.split('.')[1]
      payload_decoded = Base64.decode64(payload)
      JSON.parse(payload_decoded)['account_id']
    rescue JSON::ParserError => e
      raise Payoneer::Errors::ParseError.new(description: 'Unable to parse the id token')
    end
  end
end

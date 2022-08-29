module Payoneer
  module Util
    extend self

    def parse_account_id(id_token)
      payload = id_token.split('.')[1]
      payload_decoded = Base64.decode64(payload)
      JSON.parse(payload_decoded)['account_id']
    end
  end
end

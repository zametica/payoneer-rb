module Payoneer
  module Util
    extend self

    def parse_account_id(id_token)
      payload = id_token.split('.')[1]
      JSON.parse(Base64.decode64(payload))['account_id']
    end
  end
end

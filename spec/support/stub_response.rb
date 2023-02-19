# frozen_string_literal: true

module StubResponse # :nodoc:
  def stub_http_response(code: 200, body: {})
    net_request = HTTParty::Request.new Net::HTTP::Get, '/'
    net_response = ::Net::HTTPResponse::CODE_TO_OBJ[code.to_s].new('1.1', code, 'OK')
    allow(net_response).to receive_messages(body: body.to_json)

    HTTParty::Response.new(net_request, net_response, -> { body })
  end
end

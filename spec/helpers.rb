module Helpers
  def stub_http_response(code: 200, body: {})
    double(
      'HTTParty::Response',
      code: code,
      body: body.to_json
    )
  end
end

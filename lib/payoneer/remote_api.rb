require 'httparty'

module Payoneer
  module RemoteApi
    def self.extended(base)
      base.extend base
    end

    def post(path:, body: {}, options: {})
      request(
        method: :post,
        path: path,
        body: body,
        options: options
      )
    end
  
    def get(path:, options: {})
      request(
        method: :get,
        path: path,
        options: options
      )
    end
    
    def put(path:, body: {}, options: {})
      request(
        method: :put,
        path: path,
        body: body,
        options: options
      )
    end

    def delete(path:, body: {}, options: {})
      request(
        method: :delete,
        path: path,
        body: body,
        options: options
      )
    end

    private

    def request(method:, path:, body: {}, options: {})
      parse HTTParty.send(
        method,
        "#{Payoneer::Configuration.api_url}#{path}",
        body: body.to_json,
        headers: headers(options)
      )
    rescue HTTParty::Error => e
      raise Payoneer::Error.new(description: e.message)
    end

    def parse(response)
      body = JSON.parse(response.body)

      if response.code != 200
        raise Payoneer::Error.new(
          description: body['error_description'],
          details: body['error_details']
        )
      end

      body
    end

    def headers(options = {})
      {
        'Content-Type'  => 'application/json',
        'Authorization' => "Bearer #{options[:access_token] || access_token}"
      }
    end

    def access_token
      Rails.cache.fetch(key: 'payoneer_access_token', expires_in: 1.hour) do
        response = HTTParty.post(
          Payoneer::Configuration.login_url,
          body: {
            grant_type: 'client_credentials',
            scope: 'read write'
          },
          basic_auth: {
            username: Payoneer::Configuration.client_id,
            password: Payoneer::Configuration.client_secret
          }
        )
        JSON.parse(response.body)['access_token']
      end
    end
  end
end

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

      body.with_indifferent_access
    end

    def headers(options = {})
      {
        'Content-Type'  => 'application/json',
        'Authorization' => "Bearer #{options[:access_token] || access_token}"
      }
    end

    def access_token(force: false)
      response = Rails.cache.fetch(
        key: 'payoneer_access_token',
        expires_in: 1.day,
        force: force
      ) { fetch_token }

      access_token(force: true) if 1.day.from_now >= response[:expires_at]

      response[:access_token]
    end

    def fetch_token
      response = HTTParty.post(
        Payoneer::Configuration.token_url,
        body: {
          grant_type: 'client_credentials',
          scope: 'read write'
        },
        basic_auth: {
          username: Payoneer::Configuration.client_id,
          password: Payoneer::Configuration.client_secret
        }
      )

      parsed_body = JSON.parse(response.body)
      {
        access_token: parsed_body['access_token'],
        expires_at: parsed_body['expires_in'].seconds.from_now
      }
    end
  end
end

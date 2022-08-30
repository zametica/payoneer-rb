require 'httparty'

module Payoneer
  module RemoteApi
    def self.extended(base)
      return unless base.is_a? Module

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
        "#{options[:base_url] || Payoneer::Configuration.api_url}#{path}",
        body: body.to_json,
        headers: headers(options),
        *options
      )
    rescue HTTParty::Error => e
      raise Payoneer::Error.new(description: e.message)
    end

    def parse(response)
      body = JSON.parse(response.body)

      unless response.code == 200
        raise Payoneer::Error.new(
          description: body['error_description'],
          details: body['error_details']
        )
      end

      body.with_indifferent_access
    end

    def headers(options = {})
      headers = {
        'Content-Type'  => 'application/json'
      }

      if (options[:access_token])
        headers.merge('Authorization' => "Bearer #{options[:access_token]}")
      end

      headers
    end
  end
end

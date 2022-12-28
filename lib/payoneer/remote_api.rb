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
      body = parse(
        HTTParty.send(
          method,
          "#{options[:base_url] || Payoneer::Configuration.api_url}#{path}",
          body: request_body(body, options),
          headers: options[:headers] || headers(options)
        )
      )

      convert(body['result'] || body, options)
    rescue HTTParty::Error => e
      raise Payoneer::Error.new(description: e.message)
    end

    def parse(response)
      body = JSON.parse(response.body)

      unless response.code == 200
        raise Payoneer::Error.new(
          description: body['error_description'] || 'Server Error',
          details: body['error_details'],
          code: response.code
        )
      end

      body
    end

    def convert(result, options)
      result = { result: result } unless result.is_a? Hash

      serializer = if options[:serializer]&.superclass == Payoneer::Response
                     options[:serializer]
                   else
                     Payoneer::Response
                   end

      result.merge!(options[:response_params]) if options[:response_params].is_a? Hash
      serializer.convert(result)
    end

    def request_body(body, options)
      content_type = options.stringify_keys.dig('headers', 'Content-Type')
      return body if content_type && content_type != 'application/json'

      body.to_json
    end

    def headers(options)
      headers = {
        'Content-Type' => 'application/json'
      }

      headers.merge!('Authorization' => "Bearer #{options[:access_token]}") if options[:access_token]
      headers
    end
  end
end

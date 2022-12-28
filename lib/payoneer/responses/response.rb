module Payoneer
  class Response
    attr_reader :body

    delegate :[], to: :body

    def self.convert(response)
      case response
      when Array
        response.map { |i| convert(i) }
      when Hash
        new(response)
      else
        response
      end
    end

    def initialize(response = {})
      @body = {}.with_indifferent_access

      add_methods(response.keys)
      update_attributes(response)
    end

    private

    def add_methods(keys)
      instance_eval do
        keys.each do |k|
          self.class.send(:define_method, k.to_s.underscore) { @body[k] }
        end
      end
    end

    def update_attributes(response)
      response.each { |k, v| @body[k] = v }
    end
  end
end

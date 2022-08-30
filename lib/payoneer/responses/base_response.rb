module Payoneer
  class BaseResponse
    attr_reader :response

    def initialize(response = {})
      @response = response.with_indifferent_access
    end
  end
end

module Payoneer
  class Error < StandardError
    attr_reader :description, :details, :code

    def initialize(description: '', details: {}, code: 0)
      super(description)
      @description = description
      @details = details
      @code = code
    end
  end
end
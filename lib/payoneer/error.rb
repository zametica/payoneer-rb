module Payoneer
  class Error < StandardError
    attr_reader :description, :details

    def initialize(description:, details: {})
      super(description)
      @description = description
      @details = details
    end
  end
end
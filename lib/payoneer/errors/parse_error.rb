# frozen_string_literal: true

module Payoneer
  module Errors
    class ParseError < Payoneer::Error # :nodoc:
      def initialize(description:)
        super(description: description)
      end
    end
  end
end

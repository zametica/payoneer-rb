# frozen_string_literal: true

module Payoneer
  module Payee
    class Status < Payoneer::Response # :nodoc:
      STATUSES = {
        0 => 'PENDING',
        1 => 'ACTIVE',
        99 => 'INACTIVE'
      }.freeze

      def current_status
        STATUSES[status[:type].to_i]
      end
    end
  end
end

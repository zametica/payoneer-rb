# frozen_string_literal: true

module Payoneer
  module Payout
    class Status < Payoneer::Response # :nodoc:
      PAYOUT_NOT_FOUND_CODE = 2306

      def rejected?
        reason_code.present?
      end

      def cancelled?
        status == 'Cancelled'
      end

      def success?
        status == 'Transferred'
      end

      def pending?
        %w[Pending Pending \Payee].include? status
      end

      def not_found?
        error&.dig('reason', 'code') == PAYOUT_NOT_FOUND_CODE
      end
    end
  end
end

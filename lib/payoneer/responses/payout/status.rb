module Payoneer::Payout
  class Status < Payoneer::Response
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
      status.in? %w[Pending Pending \Payee]
    end
  end
end

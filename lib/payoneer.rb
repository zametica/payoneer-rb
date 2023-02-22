# frozen_string_literal: true

require 'active_support'
require 'active_support/time'
require 'active_support/core_ext/hash/indifferent_access'

require 'payoneer/version'
require 'payoneer/configuration'
require 'payoneer/remote_api'
require 'payoneer/error'

require 'payoneer/responses/response'
require 'payoneer/responses/payout/status'
require 'payoneer/responses/payee/status'

require 'payoneer/domain/account'
require 'payoneer/domain/auth'
require 'payoneer/domain/payee'
require 'payoneer/domain/payout'
require 'payoneer/domain/program'
require 'payoneer/domain/util'

require 'payoneer/errors/parse_error'
require 'payoneer/errors/auth_error'

module Payoneer
  extend Configuration
end

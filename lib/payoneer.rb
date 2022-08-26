require 'payoneer/version'
require 'payoneer/configuration'
require 'payoneer/remote_api'
require 'payoneer/error'

require 'payoneer/modules/account'
require 'payoneer/modules/payee'
require 'payoneer/modules/payout'
require 'payoneer/modules/program'
require 'payoneer/modules/util'

module Payoneer
  extend Configuration
end

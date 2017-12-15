# frozen_string_literal: true

require 'resque'
require 'emittance'

require 'emittance/resque/version'
require 'emittance/resque/errors'

require 'emittance/resque/broker'
require 'emittance/resque/dispatcher'

module Emittance
  ##
  # Top-level namespace for the Resque emittance broker.
  #
  module Resque
  end
end


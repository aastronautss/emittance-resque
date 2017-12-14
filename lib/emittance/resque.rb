# frozen_string_literal: true

require 'emittance/resque/version'
require 'emittance/resque/errors'

require 'resque'

module Emittance
  ##
  # Top-level namespace for the Resque emittance broker.
  #
  class Resque
    class << self
      def process_event(event)
        dispatcher.process_event event
      end
    end
  end
end

require 'emittance/resque/dispatcher'

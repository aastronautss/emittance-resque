# frozen_string_literal: true

module Emittance
  module Resque
    ##
    # The Resque broker for Emittance.
    #
    class Broker < Emittance::Broker
      class << self
        def process_event(event)
          dispatcher.process_event event
        end

        def dispatcher
          Emittance::Resque::Dispatcher
        end
      end
    end
  end
end

Emittance::Brokerage.register_broker Emittance::Resque::Broker, :resque

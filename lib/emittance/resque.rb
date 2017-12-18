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
    class << self
      def use_serializer(serializer)
        Emittance::Resque::EventSerializer.use_serializer serializer
      end
    end
  end
end

# :nocov:
Emittance::Brokerage.register_broker Emittance::Resque::Broker, :resque

if defined?(Rails)
  require 'emittance/resque/event_serializer/rails'
  Emittance::Resque.use_serializer Emittance::Resque::EventSerializer::Rails
else
  Emittance::Resque.use_serializer Emittance::Resque::EventSerializer::Default
end
# :nocov:

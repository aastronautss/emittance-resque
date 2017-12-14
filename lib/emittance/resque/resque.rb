# frozen_string_literal: true

require 'emittance'

module Emittance
  module Resque
    class Resque < Emittance::Broker
      class << self
        def process_event(event)

        end
      end
    end
  end
end

require 'emittance/resque/dispatcher'

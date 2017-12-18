# frozen_string_literal: true

require 'emittance/resque/event_serializer'

module Emittance
  module Resque
    ##
    # Wrapper calls for resque jobs to dispatch.
    #
    class Job
      class << self
        def perform(event)
          deserialized_event = Emittance::Resque::EventSerializer.deserialize(event)

          new.perform(deserialized_event)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Emittance
  module Resque
    class EventSerializer
      class << self
        def serialize(event)
          {
            identifier: event.identifiers.first,
            emitter: event.emitter,
            timestamp: event.timestamp,
            payload: event.payload
          }
        end

        def deserialize(event_hash)
          identifier = event_hash[:identifier]
          event_klass = Emittance::EventLookup.find_event_klass(identifier)

          event_klass.new(event_hash[:emitter], event_hash[:timestamp], event_hash[:payload])
        end
      end
    end
  end
end

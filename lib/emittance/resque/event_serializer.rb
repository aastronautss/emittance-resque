# frozen_string_literal: true

module Emittance
  module Resque
    ##
    # Entry point for serialization.
    #
    module EventSerializer
      class << self
        def use_serializer(serializer)
          self.serializer = serializer
        end

        def serialize(event)
          serializer.serialize event
        end

        def deserialize(event_hash)
          serializer.deserialize event_hash
        end

        private

        attr_accessor :serializer
      end
    end
  end
end

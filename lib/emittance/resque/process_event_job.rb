# frozen_string_literal: true

module Emittance
  module Resque
    ##
    # The job that is enqueued when an event is emitted.
    #
    class ProcessEventJob
      @queue = :default

      class << self
        def perform(klass_name, method_name, serialized_event)
          deserialized_event = Emittance::Resque::EventSerializer.deserialize(serialized_event)
          new(klass_name, method_name, deserialized_event).perform
        end
      end

      def initialize(klass_name, method_name, event)
        @klass_name = klass_name
        @method_name = method_name
        @event = event
      end

      def perform
        klass.send method_name, event
      end

      private

      attr_reader :klass_name, :method_name, :event

      def klass
        Object.const_get(klass_name)
      end
    end
  end
end

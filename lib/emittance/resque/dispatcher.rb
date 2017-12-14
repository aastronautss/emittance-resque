# frozen_string_literal: true

module Emittance
  module Resque
    ##
    # The Resque dispatcher for Emittance.
    #
    module Dispatcher
      Registrations = Module.new

      class << self
        def process_event(event)
          klass_name = job_klass_name(event.class)
          registration = Registrations.const_get klass_name

          Resque.enqueue registration, event
        end

        def registrations_for(identifier); end

        def register(identifier, &callback)
          event_klass = find_event_klass(identifier)
          klass_name = job_klass_name(event_klass)
          klass = job_klass(callback)

          Registrations.const_set klass_name, klass
        end

        def register_method_call(identifier, object, method_name)
          register identifier, &lambda_for_method_call(object, method_name)
        end

        def clear_registrations!; end

        def clear_registrations_for!(identifier); end

        private

        def find_event_klass(event)
          Emittance::EventLookup.find_event_klass(event)
        end

        def job_klass_name(event_klass)
          JobKlassName.new(event_klass).generate
        end

        def job_klass(callback)
          JobKlass.new(callback).generate
        end

        def lambda_for_method_call(object, method_name)
          ->(event) { object.send method_name, event }
        end
      end

      ##
      # Generates a unique but deterministic name for the job class.
      #
      class JobKlassName
        def initialize(event_klass)
          @event_klass = event_klass
        end

        def generate
          "#{base_name}#{job_name}"
        end

        private

        attr_reader :event_klass

        def base_name
          event_klass.to_s
        end

        def job_name
          'Job'
        end
      end

      ##
      # Use this to build a job class from a callback block/proc/lambda.
      #
      class JobKlass
        # The name of the method used by the background job library to perform the job.
        PERFORM_METHOD_NAME = :perform

        def initialize(callback)
          @callback = callback
        end

        def generate
          Class.new { define_method PERFORM_METHOD_NAME, callback }
        end

        private

        attr_reader :callback
      end
    end
  end
end

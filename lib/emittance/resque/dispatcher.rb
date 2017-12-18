# frozen_string_literal: true

require 'set'

require 'emittance/resque/job'
require 'emittance/resque/dispatcher/job_klass_name'
require 'emittance/resque/dispatcher/job_klass'

module Emittance
  module Resque
    ##
    # The Resque dispatcher for Emittance.
    #
    module Dispatcher
      Jobs = Module.new

      @registrations = {}

      class << self
        include Emittance::Helpers::ConstantHelpers

        # Find jobs corresponding with the event and enqueue them.
        def process_event(event)
          jobs = registrations_for(event.class)
          serialized_event = serialize_event(event)

          jobs.each { |job| enqueue_job job, serialized_event }
        end

        # Fetch all registrations for a perticular event type.
        def registrations_for(identifier)
          event_klass = find_event_klass(identifier)
          registrations[event_klass] ||= new_registration
          registrations[event_klass]
        end

        def register(_identifier, &_callback)
          raise InvalidCallbackError, 'Emittance::Resque cannot accept closures as callbacks at this time'
        end

        def register_method_call(identifier, object, method_name)
          validate_method_call object, method_name

          event_klass = find_event_klass(identifier)
          klass_name = method_call_job_klass_name(event_klass, object, method_name)
          klass = method_call_job_klass(object, method_name)

          set_namespaced_constant_by_name("#{Jobs.name}::#{klass_name}", klass) unless Jobs.const_defined?(klass_name)
          registrations_for(event_klass) << klass
        end

        def clear_registrations!
          registrations.each_key { |key| clear_registrations_for! key }
        end

        def clear_registrations_for!(identifier)
          registrations_for(identifier).clear
        end

        private

        attr_reader :registrations

        def new_registration
          Set.new
        end

        def enqueue_job(job, event)
          ::Resque.enqueue job, event
        end

        def find_event_klass(event)
          Emittance::EventLookup.find_event_klass(event)
        end

        def serialize_event(event)
          event
        end

        def method_call_job_klass_name(event_klass, object, method_name)
          JobKlassName.new(event_klass, object, method_name).generate
        end

        def job_klass(callback)
          JobKlass.new(callback).generate
        end

        def method_call_job_klass(object, method_name)
          callback = lambda_for_method_call(object, method_name)
          job_klass callback
        end

        def validate_method_call(object, _method_name)
          error_msg = 'Emittance::Resque can only call methods on classes and modules'
          raise InvalidCallbackError, error_msg unless object.is_a?(Module)
        end

        def lambda_for_method_call(object, method_name)
          ->(event) { object.send method_name, event }
        end
      end
    end
  end
end

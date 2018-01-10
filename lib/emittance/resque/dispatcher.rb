# frozen_string_literal: true

require 'set'

module Emittance
  module Resque
    class Dispatcher < Emittance::Dispatcher; end
  end
end

require 'emittance/resque/process_event_job'
require 'emittance/resque/event_serializer'
require 'emittance/resque/event_serializer/default'

module Emittance
  module Resque
    ##
    # The Resque dispatcher for Emittance.
    #
    class Dispatcher
      MethodCallRegistration = Struct.new(:klass_name, :method_name, :queue)

      PROCESS_EVENT_JOB = Emittance::Resque::ProcessEventJob
      DEFAULT_QUEUE = :default

      class << self
        include Emittance::Helpers::ConstantHelpers

        attr_writer :default_queue

        def default_queue
          @default_queue || DEFAULT_QUEUE
        end

        private

        def _process_event(event)
          registrations = registrations_for(event.class)
          serialized_event = serialize_event(event)

          registrations.each { |registration| enqueue_job registration, serialized_event }
        end

        def _register(_identifier, _params = {}, &_callback)
          raise InvalidCallbackError, 'Emittance::Resque cannot accept closures as callbacks at this time'
        end

        def _register_method_call(identifier, object, method_name, params = {})
          validate_method_call object, method_name

          registrations_for(identifier) << new_registration(object, method_name, params)
        end

        def new_registration(object, method_name, params = {})
          queue = params[:queue]

          MethodCallRegistration.new(object.name, method_name, queue)
        end

        def enqueue_job(registration, event)
          queue = queue_from_registration(registration)

          ::Resque.enqueue_to queue, PROCESS_EVENT_JOB, registration.klass_name, registration.method_name, event
        end

        def queue_from_registration(registration)
          registration.queue || default_queue
        end

        def serialize_event(event)
          Emittance::Resque::EventSerializer.serialize event
        end

        def validate_method_call(object, _method_name)
          error_msg = 'Emittance::Resque can only call methods on classes and modules'
          raise InvalidCallbackError, error_msg unless object.is_a?(Module)
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'emittance/resque/process_event_job'

module Emittance
  module Resque
    ##
    # A job that fans out events to their proper listeners.
    #
    class EventFanoutJob
      PROCESS_EVENT_JOB = Emittance::Resque::ProcessEventJob

      @queue = :default

      class << self
        def perform(registrations, event)
          registrations.each { |registration| enqueue_job registration, event }
        end

        private

        def enqueue_job(registration_h, event)
          queue = queue_from_registration(registration_h)

          ::Resque.enqueue_to(
            queue, PROCESS_EVENT_JOB, registration_h['klass_name'], registration_h['method_name'], event
          )
        end

        def queue_from_registration(registration)
          registration['queue'] || default_queue
        end

        def default_queue
          Emittance::Resque::Dispatcher.default_queue
        end
      end
    end
  end
end

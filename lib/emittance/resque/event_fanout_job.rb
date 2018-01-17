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
        def perform(event)
          new(event).perform
        end
      end

      def initialize(event)
        @event = event
      end

      def perform
        registrations.each { |registration| enqueue_job registration, event }
      end

      private

      attr_reader :event

      def registrations
        identifier = event['identifier']
        Emittance::Resque::Dispatcher.registrations_for(identifier)
      end

      def enqueue_job(registration, event)
        queue = queue_from_registration(registration)

        ::Resque.enqueue_to(
          queue, PROCESS_EVENT_JOB, registration.klass_name, registration.method_name, event
        )
      end

      def queue_from_registration(registration)
        registration.queue || default_queue
      end

      def default_queue
        Emittance::Resque::Dispatcher.default_queue
      end
    end
  end
end

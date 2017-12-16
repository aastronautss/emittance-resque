# frozen_string_literal: true

module Emittance
  module Resque
    module Dispatcher
      ##
      # Use this to build a job class from a callback block/proc/lambda.
      #
      class JobKlass
        # The name of the method used by the background job library to perform the job.
        PERFORM_METHOD_NAME = :perform

        def initialize(callback, queue: :default)
          @callback = callback
          @queue = queue
        end

        def generate
          klass = Class.new(Emittance::Resque::Job)
          klass.send(:define_method, PERFORM_METHOD_NAME, callback)
          klass.instance_variable_set '@queue', queue

          klass
        end

        private

        attr_reader :callback, :queue
      end
    end
  end
end

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

        def initialize(callback)
          @callback = callback
        end

        def generate
          klass = Class.new(Emittance::Resque::Job)
          klass.send(:define_method, PERFORM_METHOD_NAME, callback)

          klass
        end

        private

        attr_reader :callback
      end
    end
  end
end

module Emittance
  module Resque
    ##
    # The job that performs the callback.
    #
    class Job < Struct.new(:emitter, :timestamp, :payload)
      class << self
        def perform(*args)
          new(args).perform
        end
      end

      def perform

      end
    end
  end
end

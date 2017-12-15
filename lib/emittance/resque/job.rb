# frozen_string_literal: true

module Emittance
  module Resque
    class Job
      class << self
        def perform(event)
          new.perform(event)
        end
      end
    end
  end
end

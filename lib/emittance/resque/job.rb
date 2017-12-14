# frozen_string_literal: true

module Emittance
  class Resque
    class Job
      class << self
        def perform(event)
          new.perform(event)
        end
      end
    end
  end
end

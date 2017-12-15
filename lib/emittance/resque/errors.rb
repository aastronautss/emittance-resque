# frozen_string_literal: true

module Emittance
  module Resque
    # Raised when validation fails for a callback.
    class InvalidCallbackError < StandardError; end
  end
end

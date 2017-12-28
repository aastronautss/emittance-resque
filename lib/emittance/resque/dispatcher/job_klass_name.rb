# frozen_string_literal: true

module Emittance
  module Resque
    class Dispatcher
      ##
      # Use this to build job class names.
      #
      class JobKlassName
        include Emittance::Helpers::StringHelpers

        SUFFIX = 'Job'

        def initialize(event_klass, object, method_name)
          @event_klass = event_klass
          @object = object
          @method_name = method_name
        end

        def generate
          "#{prefix}::#{base_name}#{suffix}"
        end

        private

        attr_reader :event_klass, :object, :method_name

        def prefix
          event_klass.name
        end

        def base_name
          "#{object}::#{formatted_method_name}"
        end

        def suffix
          SUFFIX
        end

        def formatted_method_name
          camel_case(method_name.to_s)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Emittance
  module Resque
    module Dispatcher
      ##
      # Use this to build job class names.
      #
      JobKlassName = Struct.new(:event_klass, :object, :method_name) do
        include Emittance::Helpers::StringHelpers

        SUFFIX = 'Job'

        def generate
          "#{prefix}#{base_name}#{suffix}"
        end

        private

        def prefix
          event_klass.name
        end

        def base_name
          "#{object}#{formatted_method_name}"
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

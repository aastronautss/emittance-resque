# frozen_string_literal: true

module Emittance
  class Resque
    module Dispatcher
      ##
      # Use this to build job class names.
      #
      class JobKlassName < Struct.new(:event_klass, :object, :method_name)
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
          "#{object.to_s}#{formatted_method_name}"
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

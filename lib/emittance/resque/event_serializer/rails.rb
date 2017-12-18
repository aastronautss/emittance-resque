# frozen_string_literal: true

module Emittance
  module Resque
    module EventSerializer
      ##
      # Essentially the same as the default serializer, with the added ability to store the metadata for +ActiveRecord+
      # objects, so that it will re-fetch the record when the job is dequeued. Will serialize +ActiveRecord+ objects
      # even if inside of an array (or nested array), or if added as a value in a hash.
      #
      module Rails
        class << self
          def serialize(event)
            {
              identifier: event.identifiers.first,
              emitter: serialize_object(event.emitter),
              timestamp: serialize_timestamp(event.timestamp),
              payload: serialize_object(event.payload)
            }
          end

          def deserialize(event_hash)
            identifier = event_hash[:identifier]
            event_klass = Emittance::EventLookup.find_event_klass(identifier)

            emitter = deserialize_object(event_hash[:emitter])
            timestamp = deserialize_timestamp(event_hash[:timestamp])
            payload = deserialize_object(event_hash[:payload])

            event_klass.new(emitter, timestamp, payload)
          end

          private

          def serialize_object(obj)
            if obj.is_a? Hash
              serialize_hash(obj)
            elsif obj.is_a? Enumerable
              serialize_enum(obj)
            elsif obj.is_a? ActiveRecord::Base
              serialize_persisted(obj)
            else
              obj
            end
          end

          def serialize_timestamp(time)
            time.to_s
          end

          def serialize_hash(obj)
            Hash[
              obj.map { |k, v| [k, serialize_object(v)] }
            ]
          end

          def serialize_enum(obj)
            obj.map { |ele| serialize_object(ele) }
          end

          def serialize_persisted(obj)
            {
              _persisted: true,
              persisted_type: obj.class.name,
              persisted_id: obj.id
            }
          end

          def deserialize_object(obj)
            if obj.is_a? Hash
              deserialize_hash(obj)
            elsif obj.is_a? Enumerable
              deserialize_enum(obj)
            else
              obj
            end
          end

          def deserialize_hash(obj)
            if obj[:_persisted]
              deserialize_persisted(obj)
            else
              Hash[
                obj.map { |k, v| [k, serialize_object(v)] }
              ]
            end
          end

          def deserialize_enum(obj)
            obj.map { |ele| serialize_object(ele) }
          end

          def deserialize_persisted(obj)
            klass = Object.const_get obj[:persisted_type]
            klass.find obj[:persisted_id]
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

# Assists in rendering of EventTypes for JSON API
class SerializableEmployee < JSONAPI::Serializable::Resource
  type :event_types

  attribute :key
  attribute :description
end

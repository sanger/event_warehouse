# frozen_string_literal: true

# Render EventTypes
class EventTypeResource < ApplicationResource
  type :event_types

  has_many :events,
           scope: -> { Event.all },
           foreign_key: :event_type_id,
           resource: EventResource
end

# frozen_string_literal: true

# Render EventTypes
class EventTypeResource < JSONAPI::Resource
  model_name 'Event'
  has_many :events
end

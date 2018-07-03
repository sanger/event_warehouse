# frozen_string_literal: true

# Render Event
class EventResource < ApplicationResource
  type :event

  has_many :roles,
           scope: -> { Role.all },
           foreign_key: :event_id,
           resource: RoleResource

  has_and_belongs_to_many :subjects,
                          scope: -> { Subject.all },
                          foreign_key: { roles: :event_id },
                          resource: SubjectResource

  belongs_to :event_type,
             scope: -> { EventType.all },
             foreign_key: :event_type_id,
             resource: EventTypeResource
end

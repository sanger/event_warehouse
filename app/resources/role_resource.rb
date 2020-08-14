# frozen_string_literal: true

# Render Roles
class RoleResource < ApplicationResource
  type :roles

  belongs_to :event,
             scope: -> { Event.all },
             resource: EventResource

  belongs_to :subject,
             scope: -> { Subject.all },
             resource: SubjectResource

  belongs_to :role_type,
             scope: -> { RoleType.all },
             resource: RoleTypeResource
end

# frozen_string_literal: true

# rubocop:disable Rails/RedundantForeignKey
# Render Roles
class RoleResource < ApplicationResource
  type :roles

  belongs_to :event,
             scope: -> { Event.all },
             foreign_key: :event_id,
             resource: EventResource

  belongs_to :subject,
             scope: -> { Subject.all },
             foreign_key: :subject_id,
             resource: SubjectResource

  belongs_to :role_type,
             scope: -> { RoleType.all },
             foreign_key: :role_type_id,
             resource: RoleTypeResource
end
# rubocop:enable Rails/RedundantForeignKey

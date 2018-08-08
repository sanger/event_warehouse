# frozen_string_literal: true

# Render Subjects
class SubjectResource < ApplicationResource
  type :subjects

  belongs_to :subject_type,
             scope: -> { SubjectType.all },
             foreign_key: :subject_type_id,
             resource: SubjectTypeResource

  has_many :roles,
           scope: -> { Role.all },
           foreign_key: :subject_id,
           resource: RoleResource

  has_and_belongs_to_many :events,
                          scope: -> { Event.all },
                          foreign_key: { roles: :subject_id },
                          resource: EventResource

  allow_filter :friendly_name
  allow_filter :uuid
end

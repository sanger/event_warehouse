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

  allow_filter :uuid

  allow_filter :occured_before do |scope, value|
    scope.where('occured_at < ?', value)
  end

  allow_filter :occured_after do |scope, value|
    scope.where('occured_at > ?', value)
  end

  extra_field :metadata do |scope|
    scope.includes(:metadata)
  end
end

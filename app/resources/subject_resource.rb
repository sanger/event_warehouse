# frozen_string_literal: true

# Render Subjects
class SubjectResource < JSONAPI::Resource
  has_one :subject_type

  has_many :roles

  has_many :events

  filter :friendly_name
  filter :uuid
end

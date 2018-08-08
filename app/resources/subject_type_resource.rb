# frozen_string_literal: true

# Render SubjectTypes
class SubjectTypeResource < ApplicationResource
  type :subject_types

  has_many :subjects,
           scope: -> { Subject.all },
           foreign_key: :subject_type_id,
           resource: SubjectResource
end

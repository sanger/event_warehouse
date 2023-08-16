# frozen_string_literal: true

# Render SubjectTypes
class SubjectTypeResource < JSONAPI::Resource
  has_many :subjects
end

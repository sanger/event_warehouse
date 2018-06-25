# frozen_string_literal: true

# A dictionary of subject types.
# Subject types distinguish themselves from role types in that it is something
# which describes the subject regardless of what event it is part of.
class SubjectType < ApplicationRecord
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_subject_type_description
  preregistration_required false
end

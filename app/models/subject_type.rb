class SubjectType < ActiveRecord::Base
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_subject_type_description
  preregistration_required false
end

# frozen_string_literal: true

class RoleType < ActiveRecord::Base
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_role_type_description
  preregistration_required false
end

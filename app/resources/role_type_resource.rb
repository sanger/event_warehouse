# frozen_string_literal: true

# Render RoleTypes
class RoleTypeResource < ApplicationResource
  type :role_types

  has_many :roles,
           scope: -> { Role.all },
           foreign_key: :role_type_id,
           resource: RoleResource
end

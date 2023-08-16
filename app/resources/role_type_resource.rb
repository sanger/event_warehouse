# frozen_string_literal: true

# Render RoleTypes
class RoleTypeResource < JSONAPI::Resource
  has_many :roles
end

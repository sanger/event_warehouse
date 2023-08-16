# frozen_string_literal: true

# Render Roles
class RoleResource < JSONAPI::Resource
  has_one :event

  has_one :subject

  has_one :role_type
end

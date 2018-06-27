# frozen_string_literal: true

# Lists of roles
class RolesController < ApplicationController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: RoleResource

  # Start with a base scope and pass to render_jsonapi
  def index
    roles = Role.all
    render_jsonapi(roles)
  end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(Role.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false)
  end
end

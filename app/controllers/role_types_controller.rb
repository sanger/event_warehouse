# frozen_string_literal: true

# Lists of role types (Doubt this'll get much use)
class RoleTypesController < ApplicationController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: RoleTypeResource

  # Start with a base scope and pass to render_jsonapi
  def index
    role_types = RoleType.all
    render_jsonapi(role_types)
  end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(RoleType.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance

    render_jsonapi(instance, scope: false)
  end
end

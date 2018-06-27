# frozen_string_literal: true

# Handles subject types.
class SubjectTypesController < ApplicationController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: SubjectTypeResource

  # Start with a base scope and pass to render_jsonapi
  def index
    subject_types = SubjectType.all
    render_jsonapi(subject_types)
  end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(SubjectType.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false)
  end
end

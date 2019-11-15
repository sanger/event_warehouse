# frozen_string_literal: true

# Lists of subjects (Doubt this'll get much use)
class SubjectsController < ApplicationController
  # Mark this as a JSONAPI controller, associating with the given resource
  jsonapi resource: SubjectResource

  # Start with a base scope and pass to render_jsonapi
  def index
    subjects = Subject.all
    render_jsonapi(subjects)
  end

  # Call jsonapi_scope directly here so we can get behavior like
  # sparse fieldsets and statistics.
  def show
    scope = jsonapi_scope(Subject.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance

    render_jsonapi(instance, scope: false)
  end
end

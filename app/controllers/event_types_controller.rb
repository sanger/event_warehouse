# frozen_string_literal: true

# List event types
class EventTypesController < ApplicationController
  jsonapi resource: EventTypeResource

  def index
    render_jsonapi(EventType.all)
  end

  def show
    scope = jsonapi_scope(EventType.where(id: params[:id]))
    instance = scope.resolve.first
    raise JsonapiCompliable::Errors::RecordNotFound unless instance
    render_jsonapi(instance, scope: false)
  end
end

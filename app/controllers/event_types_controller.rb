# frozen_string_literal: true

# List event types
class EventTypesController < ApplicationController
  jsonapi resource: EventTypeResource

  def index
    render_jsonapi(EventType.all)
  end

  def show
    scope = jsonapi_scope(EventType.where(id: params[:id]))
    render_jsonapi(scope.resolve.first, scope: false)
  end
end

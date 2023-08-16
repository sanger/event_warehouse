# frozen_string_literal: true

# Swagger documentation endpoint
class DocsController < ActionController::API
  # include JsonapiSwaggerHelpers::DocsControllerMixin

  # swagger_root do
  #   key :swagger, '2.0'
  #   info do
  #     key :version, Deployed::VERSION_ID
  #     key :title, 'Event Warehouse'
  #     key :description, 'The API provides a means of querying the Event Warehouse programtically,
  #       without needing to connect to the MySQL database. The API is read-only, so does not provide
  #       a means of adding or modifying events. For more background information, please follow the
  #       link to the github repository above.'
  #     contact do
  #       key :name, 'Production Software Development'
  #     end
  #   end
  #   key :basePath, '/api'
  #   key :consumes, ['application/json']
  #   key :produces, ['application/json']
  # end

  # jsonapi_resource '/v1/events'
  # jsonapi_resource '/v1/event_types'
  # jsonapi_resource '/v1/roles'
  # jsonapi_resource '/v1/role_types'
  # jsonapi_resource '/v1/subjects'
  # jsonapi_resource '/v1/subject_types'
end

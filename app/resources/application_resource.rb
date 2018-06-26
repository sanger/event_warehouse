# frozen_string_literal: true

# Base class for JSON API resources
class ApplicationResource < JsonapiCompliable::Resource
  use_adapter JsonapiCompliable::Adapters::ActiveRecord
end

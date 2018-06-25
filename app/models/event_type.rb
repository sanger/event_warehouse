# frozen_string_literal: true

# A dictionary of observed or accepted event types with a description.
# Associated with an event and describes the nature of the event.
class EventType < ApplicationRecord
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_event_type_description
  preregistration_required EventWarehouse::Application.config.event_type_preregistration
end

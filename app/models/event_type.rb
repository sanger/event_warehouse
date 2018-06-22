class EventType < ActiveRecord::Base
  include ResourceTools::TypeDictionary

  has_default_description EventWarehouse::Application.config.default_event_type_description
  preregistration_required EventWarehouse::Application.config.event_type_preregistration
end

# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventWarehouse
  # Rails application configuration
  # Sets defaults for all environments
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.autoload_paths += ["#{config.root}/app"]
    config.eager_load_paths += ["#{config.root}/app"]

    # Events must be preregistered in the event types dictionary before they are recorded
    config.event_type_preregistration = false

    # Default descriptions are used in the event of autoregistration
    default_descriptions = 'This %s has been recorded automatically and does not have a custom description'
    config.default_event_type_description = default_descriptions % 'event type'
    config.default_subject_type_description = default_descriptions % 'subject type'
    config.default_role_type_description = default_descriptions % 'role type'

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post options]
      end
    end
  end
end

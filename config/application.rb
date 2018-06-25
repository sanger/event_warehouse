require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventWarehouse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
    config.autoload_paths += ["#{config.root}/lib"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # Configure the worker death messages
    config.worker_death_from    = 'Projects Exception Notifier <example@example.com>'
    config.worker_death_to      = 'example@example.com'
    config.worker_death_restart = 'Please restart the worker.'

    # We're going to need a specialised configuration for our AMQP consumer
    config.amqp                       = ActiveSupport::Configurable::Configuration.new
    config.amqp.main                  = ActiveSupport::Configurable::Configuration.new
    config.amqp.main.deadletter       = ActiveSupport::Configurable::Configuration.new
    config.amqp.deadletter            = ActiveSupport::Configurable::Configuration.new

    # Events must be preregistered in the event types dictionary before they are recorded
    config.event_type_preregistration = false

    # Default descriptions are used in the event of autoregistration
    default_descriptions = 'This %s has been recorded automatically and does not have a custom description'
    config.default_event_type_description = default_descriptions % 'event type'
    config.default_subject_type_description = default_descriptions % 'subject type'
    config.default_role_type_description = default_descriptions % 'role type'
  end
end

# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w[development test]))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module EventWarehouse
  class Application < Rails::Application
    config.autoload_paths    += ["#{config.root}/lib"]
    config.time_zone          = 'UTC'
    config.encoding           = 'utf-8'
    config.filter_parameters += [:password]
    config.assets.enabled     = false
    config.assets.version     = '1.0'

    # Configure the worker death messages
    config.worker_death_from    = 'Projects Exception Notifier <example@example.com>'
    config.worker_death_to      = 'example@example.com'
    config.worker_death_restart = %(Please restart the worker.)

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

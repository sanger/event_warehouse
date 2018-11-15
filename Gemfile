# frozen_string_literal: true

source 'https://rubygems.org'

# TODO: We pretty much just use active record and active mailer, do we need rails?

gem 'daemons'
gem 'mysql2', '~> 0.4'
gem 'rails', '~> 5.2'

# Rails dependencies
gem 'bootsnap'
gem 'puma'

# TODO: COnsider switching to Bunny if possible
gem 'amqp', '~> 1.5'
gem 'mysql-binuuid-rails'
gem 'whenever', require: false
# We use a special version of hashie to bypass rails protected attributes.
# Consider removing Hashie entirely
gem 'hashie-forbidden_attributes'
gem 'migration_comments'
gem 'rest-client'

# For JSON API support
gem 'jsonapi-rails', '~> 0.3'
gem 'jsonapi_suite', '~> 0.7'
gem 'jsonapi_swagger_helpers', '~> 0.6', require: false
# Used by swagger to generate docs
gem 'jsonapi_spec_helpers', require: false
gem 'kaminari' # Pagination. Used by jsonapi_suite
gem 'rack-cors', require: 'rack/cors'

group :test, :development do
  gem 'database_cleaner'
  # Easier testing of AMQP client
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-byebug', platform: :mri
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'swagger-diff', '~> 1.1'
end

group :development do
  gem 'guard'
  gem 'guard-bundler', require: false
  gem 'guard-rspec', require: false
  gem 'rubocop'
  gem 'travis'
end


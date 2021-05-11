# frozen_string_literal: true

source 'https://rubygems.org'

gem 'mysql2', '~> 0.4'
gem 'rails', '~> 5.2'

# Rails dependencies
gem 'bootsnap'
gem 'puma'

# RabbitMQ client
gem 'sanger_warren'

gem 'mysql-binuuid-rails'

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

gem 'oj'
gem 'rainbow'

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
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

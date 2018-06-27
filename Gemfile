# frozen_string_literal: true

source 'https://rubygems.org'

# TODO: We pretty much just use active record and active mailer, do we need rails?
gem 'mysql2', '~> 0.4'
gem 'rails', '~> 5.2'

# Rails dependencies
gem 'bootsnap'
gem 'puma'

# TODO: COnsider switching to Bunny if possible
gem 'amqp', '~> 1.5'
gem 'mysql-binuuid-rails'

# We use a special version of hashie to bypass rails protected attributes.
# Consider removing Hashie entirely
gem 'hashie-forbidden_attributes'
gem 'migration_comments'
gem 'rest-client'

# For JSON API support
gem 'jsonapi-rails', '~> 0.3'
gem 'jsonapi_spec_helpers'
gem 'jsonapi_suite', '~> 0.7'
gem 'kaminari' # Pagination. Used by jsonapi_suite

group :test, :development do
  gem 'database_cleaner'
  # Easier testing of AMQP client
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-byebug', platform: :mri
  gem 'rspec-rails'
  gem 'simplecov'
end

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'rubocop'
  gem 'travis'
end

group :deployment do
  gem 'psd_logger', git: 'https://github.com/sanger/psd_logger.git'
end

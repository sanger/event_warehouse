# frozen_string_literal: true

source 'https://rubygems.org'

# TODO: We pretty much just use active record and active mailer, do we need rails?
gem 'mysql2', '~> 0.4'
gem 'rails', '~> 5.0'

# Rails dependencies
gem 'bootsnap'

# TODO: COnsider switching to Bunny if possible
gem 'amqp', '~> 1.5'

# Replaces use of lib/uuidable.rb as the latter was provind to
# be a bit brittle. Allows use of binary uuid columns.
gem 'mysql-binuuid-rails'

# We use a special version of hashie to bypass rails protected attributes.
# Consider removing Hashie entirely
gem 'hashie-forbidden_attributes'
gem 'migration_comments'
gem 'rest-client'

group :test, :development do
  gem 'database_cleaner'
  # Easier testing of AMQP client
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'rspec-rails'
  gem 'simplecov'
end

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'rubocop'
end

group :deployment do
  gem 'psd_logger', git: 'git+ssh://git@github.com/sanger/psd_logger.git'
end

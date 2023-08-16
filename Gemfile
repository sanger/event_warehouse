# frozen_string_literal: true

source 'https://rubygems.org'

gem 'mysql2'
gem 'rails', '~> 7.0.3'

# Rails dependencies
gem 'bootsnap'

# RabbitMQ client
gem 'sanger_warren'

gem 'mysql-binuuid-rails'
gem 'rest-client'

gem 'oj'
gem 'rainbow'

group :test, :development do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'simplecov', require: false
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

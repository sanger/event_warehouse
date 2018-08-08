# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require './db/seeds/event_types.rb'
require './db/seeds/role_types.rb'
require './db/seeds/subject_types.rb'

EVENT_TYPES.each do |key, description|
  EventType.create!(key: key, description: description)
end

ROLE_TYPES.each do |key, description|
  RoleType.create!(key: key, description: description)
end

SUBJECT_TYPES.each do |key, description|
  SubjectType.create!(key: key, description: description)
end

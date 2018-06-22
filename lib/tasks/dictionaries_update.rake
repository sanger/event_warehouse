# frozen_string_literal: true

namespace :dictionaries do
  desc 'Update all dictionaries with the listed entries and their descriptions'
  task update: :environment do
    require './db/seeds/event_types.rb'
    require './db/seeds/role_types.rb'
    require './db/seeds/subject_types.rb'

    EVENT_TYPES.each do |key, description|
      EventType.find_or_create_by(key: key).update_attributes!(description: description)
    end

    ROLE_TYPES.each do |key, description|
      RoleType.find_or_create_by(key: key).update_attributes!(description: description)
    end

    SUBJECT_TYPES.each do |key, description|
      SubjectType.find_or_create_by(key: key).update_attributes!(description: description)
    end
  end
end

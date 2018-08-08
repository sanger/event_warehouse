# frozen_string_literal: true

namespace :mock do
  desc 'Generate a number of mock events for testing and development'
  task data: :environment do
    require './db/seeds/event_types.rb'

    studies = Array.new(5) do |i|
      { role_type: 'study', subject_type: 'study', friendly_name: "Study #{i}", uuid: SecureRandom.uuid }
    end
    samples = Array.new(10) do |i|
      { role_type: 'sample', subject_type: 'sample', friendly_name: "Sample #{i}", uuid: SecureRandom.uuid }
    end
    labware = Array.new(10) do |i|
      type = %w[tube plate].sample
      { role_type: 'labware', subject_type: type, friendly_name: "DN#{i * 12}", uuid: SecureRandom.uuid }
    end
    users = %w[ab1 cd2 eg3]

    EVENT_TYPES.each do |event_type|
      20.times do
        Event.create!(
          uuid: SecureRandom.uuid,
          event_type: event_type.first,
          subjects: studies.sample(1) + samples.sample(rand(1..4)) + labware.sample(1),
          user_identifier: users.sample,
          metadata: {
            'library_type' => %w[WGS ISC PCRFree].sample,
            'pcr_cycles' => rand(3..8)
          },
          occured_at: Time.zone.now - rand(12).hours,
          lims_id: 'mock_data'
        )
      end
    end
  end
end

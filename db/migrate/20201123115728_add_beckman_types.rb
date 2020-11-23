# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# Add role, subject and event types for Beckman
class AddBeckmanTypes < ActiveRecord::Migration[5.2]
  def change
    RoleType.create!(
      key: 'robot',
      description: 'The robot on which processing occurred which led to the event'
    )
    RoleType.create!(
      key: 'cherrypicking_source_labware',
      description: 'The labware that entered the cherrypicking process'
    )
    RoleType.create!(
      key: 'cherrypicking_destination_labware',
      description: 'The labware created from a cherrypicking process'
    )

    SubjectType.create!(
      key: 'robot',
      description: 'A robot capable of performing automating processes'
    )

    EventType.create!(
      key: 'lh_beckman_cp_source_completed',
      description: 'When a lighthouse source plate has been marked as completed during Beckman cherrypicking'
    )
    EventType.create!(
      key: 'lh_beckman_cp_source_plate_unrecognised',
      description: 'When a lighthouse source plate is not recognised during Beckman cherrypicking'
    )
    EventType.create!(
      key: 'lh_beckman_cp_source_no_plate_map_data',
      description: 'When a lighthouse source plate has no plate map data available for Beckman cherrypicking'
    )
    EventType.create!(
      key: 'lh_beckman_cp_source_all_negatives',
      description: 'When a lighthouse source plate contains no positives for Beckman cherrypicking'
    )
    EventType.create!(
      key: 'lh_beckman_cp_destination_created',
      description: 'When the Beckman cherrypicking process has created a new destination plate'
    )
  end
end
# rubocop:enable Metrics/MethodLength

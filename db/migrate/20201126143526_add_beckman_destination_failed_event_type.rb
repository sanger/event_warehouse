# frozen_string_literal: true

# Add destination failed Beckman event type
class AddBeckmanDestinationFailedEventType < ActiveRecord::Migration[5.2]
  def change
    EventType.find_or_create_by!(
      key: 'lh_beckman_cp_destination_failed',
      description: 'When the Beckman cherrypicking process has destructively failed to create a destination plate'
    )
  end
end

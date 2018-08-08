# frozen_string_literal: true

# Add the event_types table to store the event type dictionary
class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string :key, null: false, comment: 'The identifier for the event'
      t.text :description, null: false, comment: 'A description of the meaning of the event'
      t.timestamps

      t.index :key, unique: true
    end
  end
end

# frozen_string_literal: true

class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.integer :event_id, null: false, comment: 'References the event with which the metadata is associated'
      t.string :key, null: false, comment: 'The metadata type'
      t.string :value, null: false, comment: 'The metadata value. NULL indicates no value was set.'
      t.timestamps
    end
  end
end

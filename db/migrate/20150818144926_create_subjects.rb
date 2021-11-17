# frozen_string_literal: true

# Create the subjects table to store things that are associated with events
class CreateSubjects < ActiveRecord::Migration
  def change # rubocop:disable Metrics/MethodLength
    create_table :subjects do |t|
      t.binary :uuid, null: false,
                      comment: 'A binary encoded UUID use HEX(uuid) to retrieve the original (minus dashes)',
                      limit: 16
      t.string :friendly_name,
               null: false,
               comment: 'A user readable identifier for the subject',
               index: true
      t.integer :subject_type_id,
                null: false,
                comment: 'References the event type'
      t.timestamps

      t.index :uuid, unique: true, length: 16
    end
  end
end

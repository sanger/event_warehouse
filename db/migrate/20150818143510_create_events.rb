# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :lims_id,
               null: false,
               comment: 'Identifier for the originating LIMS. eg. SQSCP for Sequencesacape'
      t.uuid :uuid,
             null: false,
             comment: 'A binary encoded UUID use HEX(uuid) to retrieve the original (minus dashes)',
             limit: 16
      t.integer :event_type_id,
                null: false,
                comment: 'References the event type'
      t.datetime :occured_at,
                 null: false,
                 comment: 'The time at which the event was recorded as happening. '\
                 'Other timestamps record when the event entered the database'
      t.string :user_identifier,
               null: false,
               comments: 'An identifier for the user associated with the event. Preferably a login'
      t.timestamps

      t.index :uuid, unique: true, length: 16
    end
  end
end

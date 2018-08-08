# frozen_string_literal: true

# Add the roles table to associated subjects with events
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :event_id,
                null: false,
                comment: 'Associate with the event (what happened)',
                index: true
      t.integer :subject_id,
                null: false,
                comment: 'Associate with the subject (what it happened to, or what might care)',
                index: true
      t.integer :role_type_id,
                null: false,
                comment: 'References the role_types table, describing the role'
      t.timestamps
    end
  end
end

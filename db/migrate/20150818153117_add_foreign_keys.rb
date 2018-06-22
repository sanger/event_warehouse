# frozen_string_literal: true

class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :events,   :event_types
    add_foreign_key :metadata, :events
    add_foreign_key :roles,    :events
    add_foreign_key :roles,    :subjects
    add_foreign_key :roles,    :role_types
    add_foreign_key :subjects, :subject_types
  end
end

# frozen_string_literal: true

# Add the subject_types table to store the subject type dictionary
class CreateSubjectTypes < ActiveRecord::Migration
  def change
    create_table :subject_types do |t|
      t.string :key, null: false, comment: 'The identifier for the role type'
      t.text :description, null: false, comment: 'A description of the subject type'
      t.timestamps

      t.index :key, unique: true
    end
  end
end

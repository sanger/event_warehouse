# frozen_string_literal: true

# Metadata can have nulls for values
class ModifyMetadataValueColumnToAcceptNull < ActiveRecord::Migration
  def change
    change_column_null(:metadata, :value, true)
  end
end

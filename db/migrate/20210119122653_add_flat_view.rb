# frozen_string_literal: true

require './lib/views_schema'

# Flattened view of the events database with one row per subject.
# Metadata is excluded
class AddFlatView < ActiveRecord::Migration[5.2]
  def up # rubocop:disable Metrics/MethodLength
    ViewsSchema.create_view(
      'flat_events_view',
      <<~SQL.squish
        SELECT
          events.id AS wh_event_id,
          events.uuid AS event_uuid_bin,
          INSERT(INSERT(INSERT(INSERT(LOWER(HEX(events.uuid)),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-') AS event_uuid,
          event_types.key AS event_type,
          events.occured_at AS occured_at,
          events.user_identifier AS user_identifier,
          role_types.key AS role_type,
          subject_types.key AS subject_type,
          subjects.friendly_name AS subject_friendly_name,
            INSERT(INSERT(INSERT(INSERT(LOWER(HEX(subjects.uuid)),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-') AS subject_uuid,
          subjects.uuid AS subject_uuid_bin
        FROM events
        LEFT OUTER JOIN event_types ON events.event_type_id = event_types.id
        LEFT OUTER JOIN roles ON roles.event_id = events.id
        LEFT OUTER JOIN role_types ON roles.role_type_id = role_types.id
        LEFT OUTER JOIN subjects ON roles.subject_id = subjects.id
        LEFT OUTER JOIN subject_types ON subjects.subject_type_id = subject_types.id
      SQL
    )
  end

  def down
    ViewsSchema.drop_view('flat_events_view')
  end
end

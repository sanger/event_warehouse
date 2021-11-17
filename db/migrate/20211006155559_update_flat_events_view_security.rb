# frozen_string_literal: true

require './lib/views_schema'

# Change the events security to allow for better portability between databases
# The DBAs manage a weekly task which dumps the production event_warehouse
# into a separate database. This proves very useful for training purposes
# and is an integration point for several users who are otherwise
# disconnected from our development environments.

# However, the admin user on the production environment didn't exist,
# which caused issues accessing the view. While an appropriate admin
# user has been registered, the DBAs would like to restrict its
# privileges. This change ensures they can be limited completely.
class UpdateFlatEventsViewSecurity < ActiveRecord::Migration[5.2]
  # rubocop:disable Metrics/MethodLength
  def up
    ViewsSchema.update_view(
      'flat_events_view',
      <<~SQL.squish,
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
      security: 'INVOKER'
    )
  end

  def down
    ViewsSchema.update_view(
      'flat_events_view',
      <<~SQL.squish,
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
      security: 'DEFINER'
    )
  end
  # rubocop:enable Metrics/MethodLength
end

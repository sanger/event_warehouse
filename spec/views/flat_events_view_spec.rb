# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'flat_events_view' do
  # @note We use before_type_cast in a few places here, as the raw view SQL query doesn't cast its values.
  # This is a little useful for testing the uuids (although oddly we need to reload to get the correct behaviour)
  # but as the actual interface will be with the SQL directly, we don't actually care about the details of what
  # comes back from
  let(:event) { create(:event, event_type: 'event_name') }
  let(:roles) { create_list :role, 3, event: event }
  let(:results) do
    ApplicationRecord.connection.execute('SELECT * FROM flat_events_view')
  end

  let(:expected_role_rows) do
    event_bin_uuid = event.reload.uuid_before_type_cast
    roles.map do |role|
      [
        event.id, event_bin_uuid, event.uuid, 'event_name', event.occured_at_before_type_cast, event.user_identifier,
        role.role_type.key, role.subject.subject_type.key, role.subject.friendly_name, role.subject.uuid,
        role.subject.reload.uuid_before_type_cast
      ]
    end
  end

  before do
    roles
    create_list :metadatum, 4, event: event
  end

  it 'lists finished activities at the role level' do
    expect(results.size).to eq 3
  end

  it 'has the expected columns' do
    expect(results.fields).to eq %w[
      wh_event_id event_uuid_bin event_uuid event_type occured_at user_identifier
      role_type subject_type subject_friendly_name subject_uuid subject_uuid_bin
    ]
  end

  it 'lists the correct information' do
    expect(results.to_a).to include(*expected_role_rows)
  end
end

# frozen_string_literal: true

BECKMAN_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-3333-111111111111',
    "event_type": 'lh_beckman_cp_destination_created',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_1',
        "uuid": '00000000-1111-2222-3333-888888888888'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

CHERRYPICK_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-3333-222222222222',
    "event_type": 'cherrypick_layout_set',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_2',
        "uuid": '00000000-1111-2222-3333-999999999999'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

OTHER_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-3333-444444444444',
    "event_type": 'delivery',
    "occured_at": '2012-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'sender',
        "subject_type": 'person',
        "friendly_name": 'alice@example.com',
        "uuid": '00000000-1111-2222-3333-555555555555'
      },
      {
        "role_type": 'recipient',
        "subject_type": 'person',
        "friendly_name": 'bob@example.com',
        "uuid": '00000000-1111-2222-3333-666666666666'
      },
      {
        "role_type": 'package',
        "subject_type": 'plant',
        "friendly_name": 'Chuck',
        "uuid": '00000000-1111-2222-3333-777777777777'
      }
    ],
    "metadata": {
      "delivery_method": 'courier',
      "shipping_cost": '15.00'
    }
  },
  "lims": 'example'
}.freeze

BIOSERO_PLATE_COMPLETED_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-4444-111111111111',
    "event_type": 'lh_biosero_cp_destination_plate_completed',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_3',
        "uuid": '00000000-1111-2222-4444-222222222222'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

### WE ARE HERE
BIOSERO_PARTIAL_PLATE_COMPLETED_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-4444-333333333333',
    "event_type": 'lh_biosero_cp_destination_plate_partial_completed',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_4',
        "uuid": '00000000-1111-2222-4444-444444444444'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

BIOSERO_ERROR_RECOVERED_PLATE_COMPLETED_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-4444-555555555555',
    "event_type": 'lh_biosero_cp_error_recovered_destination_plate_completed',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_5',
        "uuid": '00000000-1111-2222-4444-666666666666'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

BIOSERO_ERROR_RECOVERED_PARTIAL_PLATE_COMPLETED_RECORD = {
  "event": {
    "uuid": '00000000-1111-2222-4444-777777777777',
    "event_type": 'lh_biosero_cp_error_recovered_destination_plate_partial_completed',
    "occured_at": '2020-03-11 10:22:42',
    "user_identifier": 'postmaster@example.com',
    "subjects": [
      {
        "role_type": 'source',
        "subject_type": 'sample',
        "friendly_name": 'MY_SANGER_SAMPLE_ID_6',
        "uuid": '00000000-1111-2222-4444-888888888888'
      }
    ],
    "metadata": {
    }
  },
  "lims": 'example'
}.freeze

EVENTS = [BECKMAN_RECORD, CHERRYPICK_RECORD, OTHER_RECORD, BIOSERO_PLATE_COMPLETED_RECORD,
          BIOSERO_PARTIAL_PLATE_COMPLETED_RECORD, BIOSERO_ERROR_RECOVERED_PLATE_COMPLETED_RECORD,
          BIOSERO_ERROR_RECOVERED_PARTIAL_PLATE_COMPLETED_RECORD].freeze

EVENTS.each do |data|
  Event.create_or_update_from_json(data[:event], data[:lims])
end

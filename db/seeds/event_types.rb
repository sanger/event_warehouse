# frozen_string_literal: true

EVENT_TYPES = [
  # ['event_key','Event description']
  [
    'library_start',
    'Records the beginning of the library creation lab process'
  ],
  [
    'library_complete',
    'Records the completion of the library creation lab process'
  ],
  [
    'labwhere_create',
    "When a new labware is scanned into the LabWhere application 'scans' form or via the API"
  ],
  [
    'labwhere_update',
    "When an existing labware is scanned into the LabWhere application 'scans' form or via the API"
  ],
  [
    'labwhere_uploaded_from_manifest',
    "When labwares are uploaded via a csv file in the LabWhere application 'upload labwares' form"
  ],
  [
    'labwhere_update_when_location_emptied',
    "When a location is emptied via the LabWhere application 'empty location' form"
  ],
  [
    'labware.received',
    'When a labware is received via Sequencescape Labwhere Reception'
  ],
  [
    'lh_beckman_cp_source_completed',
    'When a lighthouse source plate has been marked as completed during Beckman cherrypicking'
  ],
  [
    'lh_beckman_cp_source_plate_unrecognised',
    'When a lighthouse source plate is not recognised during Beckman cherrypicking'
  ],
  [
    'lh_beckman_cp_source_no_plate_map_data',
    'When a lighthouse source plate has no plate map data available for Beckman cherrypicking'
  ],
  [
    'lh_beckman_cp_source_all_negatives',
    'When a lighthouse source plate contains no positives for Beckman cherrypicking'
  ],
  [
    'lh_beckman_cp_destination_created',
    'When the Beckman cherrypicking process has created a new destination plate'
  ],
  [
    'lh_beckman_cp_destination_failed',
    'When the Beckman cherrypicking process has destructively failed to create a destination plate'
  ]
].freeze

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
  ]
].freeze

# frozen_string_literal: true

ROLE_TYPES = [
  ['order', 'The order under which this event was conducted'],
  ['study', 'The study for which this event was conducted'],
  ['project', 'The cost centre which funded this event'],
  ['submission', 'The submission under which this event was conducted'],
  ['stock_plate', 'The plate register by manifest that contains one or more samples in this event'],
  ['sample', 'A sample which was processed in this event'],
  ['library_source_labware', 'The plate or tube that entered the library prep process'],
  ['sequencing_source_labware', 'The library tube or strip tube entering a sequencing process'],
  ['labware', 'The piece of labware, such as a plate or tube, which was processed in this event'],
  ['robot', 'The robot on which processing occurred which led to the event'],
  ['cherrypicking_source_labware', 'The labware that entered the cherrypicking process'],
  ['cherrypicking_destination_labware', 'The labware created from a cherrypicking process']
].freeze

# frozen_string_literal: true

# Render Event
class EventResource < JSONAPI::Resource
  has_many :roles

  has_many :subjects

  has_one :event_type

  filter :uuid

  filter :occured_before, apply: lambda { |records, value, _options|
    records.where('occured_at < ?', value)
  }

  filter :occured_after, apply: lambda { |records, value, _options|
    records.where('occured_at > ?', value)
  }

  attributes :metadata, &:include_metadata
end

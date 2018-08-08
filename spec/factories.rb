# frozen_string_literal: true

FactoryBot.define do
  sequence :key do |i|
    "example_key_#{i}"
  end

  sequence :friendly_name do |i|
    "example_#{i}@example.com"
  end

  # It might seem like it makes sense just to generate
  # a random uuid. However sequential uuids identified
  # an indexing bug
  sequence :uuid do |i|
    "00000000-0000-0000-0000-#{i.to_s.rjust(12, '0')}"
  end

  factory :event_type do
    key
    description 'EventType generated through the factory'
  end

  factory :role_type do
    key
    description 'RoleType generated through the factory'
  end

  factory :subject_type do
    key
    description 'SubjectType generated through the factory'
  end

  factory :event do
    uuid
    lims_id 'example_lims'
    event_type
    occured_at { 5.seconds.ago }
    user_identifier 'example@example.com'
  end

  factory :metadatum do
    key 'key'
    value 'value'
    event
  end

  factory :role do
    role_type
    event
    subject
  end

  factory :subject do
    friendly_name
    subject_type
    uuid
  end
end

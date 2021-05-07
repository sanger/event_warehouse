# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
# As Event is effectively our main API we conduct integration tests through here
RSpec.describe Event do
  let(:example_lims) { 'postal_service' }
  let(:registered_event_type) { 'delivery' }
  let(:missing_event_type) { 'package_lost' }
  let(:expected_roles) { %w[sender recipient package] }
  let(:expected_subjects) do
    [
      ExpectedSubject.new('00000000-1111-2222-3333-555555555555', 'alice@example.com', 'person', 'sender'),
      # Bob is pre-registered by the tests
      ExpectedSubject.new('00000000-1111-2222-3333-666666666666', 'existing_bob@example.com', 'person', 'recipient'),
      ExpectedSubject.new('00000000-1111-2222-3333-777777777777', 'Chuck', 'plant', 'package')
    ]
  end

  let(:event_uuid) { '00000000-1111-2222-3333-444444444444' }
  let(:occured_at) { 'occured_at' }

  let(:json) do
    {
      'uuid' => event_uuid,
      'event_type' => event_type,
      occured_at => '2012-03-11 10:22:42',
      'user_identifier' => 'postmaster@example.com',
      'subjects' => [
        {
          'role_type' => 'sender',
          'subject_type' => 'person',
          'friendly_name' => 'alice@example.com',
          'uuid' => '00000000-1111-2222-3333-555555555555'
        },
        {
          'role_type' => 'recipient',
          'subject_type' => 'person',
          'friendly_name' => 'bob@example.com',
          'uuid' => '00000000-1111-2222-3333-666666666666'
        },
        {
          'role_type' => 'package',
          'subject_type' => 'plant',
          'friendly_name' => 'Chuck',
          'uuid' => '00000000-1111-2222-3333-777777777777'
        }
      ],
      'metadata' => metadata
    }
  end

  let(:metadata) do
    {
      'delivery_method' => 'courier',
      'shipping_cost' => '15.00'
    }
  end

  # We have a single pre-registered event type
  before do
    stub_const('ExpectedSubject', Struct.new(:uuid, :friendly_name, :subject_type, :role_type))
    @pre_count = described_class.count
    create(:event_type, key: registered_event_type)
    # preregister one of our subjects so we can check we look stuff up correctly
    create(:subject,
           friendly_name: 'existing_bob@example.com',
           uuid: '00000000-1111-2222-3333-666666666666',
           subject_type: 'person')
  end

  it_behaves_like 'it has a type dictionary'

  context 'message receipt' do
    let(:preregistration_required) { false }

    before do
      allow(EventType).to receive(:preregistration_required?).and_return preregistration_required
      described_class.create_or_update_from_json(json, example_lims)
    end

    shared_examples_for 'a recorded event' do
      it 'creates an event' do
        expect(described_class.count - @pre_count).to eq(1)
      end

      context 'with an occurred_at attribute' do
        let(:occured_at) { 'occurred_at' }

        it 'translates to occured_at' do
          expect(described_class.count - @pre_count).to eq(1)
          expect(described_class.last.occured_at).to eq(Time.zone.parse('2012-03-11 10:22:42'))
        end
      end

      it 'has the right event type' do
        expect(described_class.last).to be_instance_of(described_class)
        expect(described_class.last.event_type).to be_instance_of(EventType)
        expect(described_class.last.event_type.key).to eq(event_type)
      end

      it 'has the expected uuid' do
        expect(described_class.last.uuid.to_s).to eq(event_uuid)
      end
    end

    shared_examples_for 'it registers metadata' do
      it 'has 2 metadata with the right values' do
        expect(described_class.last.metadata_records.count).to eq(2)
        metadata.each do |key, value|
          expect(described_class.last.metadata_records.where(key: key).first.value).to eq(value)
        end
      end

      it 'can reserialize metadata as a hash' do
        expect(described_class.last.metadata).to eq(metadata)
      end
    end

    shared_examples_for 'it finds and registers subjects' do
      it 'records all roles' do
        expect(described_class.last.roles.count).to eq(expected_roles.length)
        registered_roles = described_class.last.roles.map { |role| role.role_type.key }
        expected_roles.each do |expected_role|
          expect(registered_roles.delete(expected_role)).to eq(expected_role)
        end
      end

      it 'does\'t register existing subjects' do
        expect(Subject.count).to eq(expected_subjects.length)
      end

      it 'records all subjects' do
        expect(described_class.last.subjects.count).to eq(expected_subjects.length)
        registered_subjects = described_class.last.subjects.map do |s|
          [s.uuid.to_s, s.friendly_name, s.subject_type.key]
        end
        expected_subjects.each do |expected|
          found = registered_subjects.detect { |s| s.first == expected.uuid }
          expect(found).not_to be_nil
          expect(found[1]).to eq(expected.friendly_name)
          expect(found[2]).to eq(expected.subject_type)
        end
      end

      it 'assigns subject the right roles' do
        registered_roles = described_class.last.roles.map { |role| [role.subject.uuid.to_s, role.role_type.key] }
        expected_subjects.each do |expected|
          matching_role = registered_roles.detect { |r| r.first == expected.uuid }
          expect(matching_role.last).to eq(expected.role_type)
        end
      end
    end

    shared_examples_for 'an ignored event' do
      it 'does not create an event' do
        expect(described_class.count).to eq(0)
      end
    end

    context 'when pre-registration is required' do
      let(:preregistration_required) { true }

      context 'and the event type is registered' do
        let(:event_type) { registered_event_type }

        it_behaves_like 'a recorded event'
      end

      context 'and the event type is unregistered' do
        let(:event_type) { missing_event_type }

        it_behaves_like 'an ignored event'
      end
    end

    context 'when pre-registration is not required' do
      let(:preregistration_required) { false }
      let(:event_type) { missing_event_type }

      it_behaves_like 'a recorded event'
      it_behaves_like 'it registers metadata'
      it_behaves_like 'it finds and registers subjects'
    end
  end

  context 'repeat message receipt' do
    let(:event_type) { registered_event_type }

    before do
      create(:event, uuid: event_uuid)
    end

    it 'does not register a new event with the same uuid' do
      expect { described_class.create_or_update_from_json(json, example_lims) }
        .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Uuid has already been taken')
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers

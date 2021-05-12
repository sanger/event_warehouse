# frozen_string_literal: true

require 'rails_helper'
require 'warren/fox'

RSpec.describe Warren::Subscriber::EventConsumer do
  subject(:event_consumer) { described_class.new(fox, delivery_info, properties, payload) }

  let(:fox) { instance_spy(Warren::Fox) }
  let(:delivery_info) { instance_spy(Bunny::DeliveryInfo) }
  let(:properties) { instance_spy(Bunny::MessageProperties) }

  describe '#process' do
    context 'when a non-JSON payload' do
      let(:payload) { 'Not a valid message!' }

      it 'raises Warren::Subscriber::EventConsumer::InvalidMessage' do
        expect { event_consumer.process }.to raise_error(Warren::Subscriber::EventConsumer::InvalidMessage)
      end
    end

    context 'when no lims is specified' do
      let(:payload) do
        {
          'event' => {
            'uuid' => '00000000-1111-2222-3333-444444444444',
            'event_type' => 'delivery',
            'occured_at' => '2012-03-11 10:22:42',
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
            'metadata' => { 'courier' => 'Pony Express' }
          }
        }.to_json
      end

      it 'raises Warren::Subscriber::EventConsumer::InvalidMessage' do
        expect { event_consumer.process }.to raise_error(Warren::Subscriber::EventConsumer::InvalidMessage)
      end
    end

    context 'when no event is specified' do
      let(:payload) do
        {
          'lims' => 'lims'
        }.to_json
      end

      it 'raises Warren::Subscriber::EventConsumer::InvalidMessage' do
        expect { event_consumer.process }.to raise_error(Warren::Subscriber::EventConsumer::InvalidMessage)
      end
    end

    context 'when a valid payload' do
      let(:payload) do
        {
          'event' => {
            'uuid' => '00000000-1111-2222-3333-444444444444',
            'event_type' => 'delivery',
            'occured_at' => '2012-03-11 10:22:42',
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
            'metadata' => { 'courier' => 'Pony Express' }
          },
          'lims' => 'lims'
        }.to_json
      end

      it 'processes the message' do
        expect { event_consumer.process }.to change(Event, :count).by(1)
      end
    end

    context 'when we hit a race condition' do
      let(:payload) do
        {
          'event' => {
            'uuid' => '00000000-1111-2222-3333-444444444444',
            'event_type' => 'delivery',
            'occured_at' => '2012-03-11 10:22:42',
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
            'metadata' => { 'courier' => 'Pony Express' }
          },
          'lims' => 'lims'
        }.to_json
      end

      before do
        called = 0
        original = Event.method(:transaction)
        # We raise the first time, and work the second
        allow(Event).to receive(:transaction) do |&block|
          called += 1
          raise ActiveRecord::RecordNotUnique, 'Mysql2::Error: Duplicate entry' if called == 1

          original.call(&block)
        end
      end

      it 'processes the message' do
        expect { event_consumer.process }.to change(Event, :count).by(1)
      end
    end

    context 'when we repeatedly a race condition' do
      let(:payload) do
        {
          'event' => {
            'uuid' => '00000000-1111-2222-3333-444444444444',
            'event_type' => 'delivery',
            'occured_at' => '2012-03-11 10:22:42',
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
            'metadata' => { 'courier' => 'Pony Express' }
          },
          'lims' => 'lims'
        }.to_json
      end

      before do
        # I'm wary of introducing an infinite loop. So we want to eventually give
        # up our retries.
        allow(Event).to receive(:transaction).and_raise(ActiveRecord::RecordNotUnique, 'Mysql2::Error: Duplicate entry')
      end

      it 'processes the message' do
        expect { event_consumer.process }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end

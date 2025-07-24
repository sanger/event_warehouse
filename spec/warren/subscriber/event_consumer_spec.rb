# frozen_string_literal: true

require 'rails_helper'
require 'warren/fox'

RSpec.describe Warren::Subscriber::EventConsumer do
  subject(:event_consumer) { described_class.new(fox, delivery_info, properties, payload) }

  let(:fox) { instance_spy(Warren::Fox) }
  let(:delivery_info) { instance_spy(Bunny::DeliveryInfo) }
  let(:properties) { instance_spy(Bunny::MessageProperties) }

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

  describe '#process' do
    context 'when there is a non-JSON payload' do
      let(:payload) { 'Not a valid message!' }

      it 'raises Warren::Subscriber::EventConsumer::InvalidMessage' do
        expect { event_consumer.process }.to raise_error(Warren::Subscriber::EventConsumer::InvalidMessage)
      end
    end

    context 'when no lims is specified' do
      # Payload without the 'lims' entry
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

    context 'when there is a valid payload' do
      it 'processes the message' do
        expect { event_consumer.process }.to change(Event, :count).by(1)
      end
    end

    # For exceptions that can occur during processing.
    [
      [ActiveRecord::RecordNotUnique, 'Mysql2::Error: Duplicate entry'],
      [ActiveRecord::Deadlocked, 'Mysql2::Error: Deadlock found when trying to get lock']
    ].each do |error_class, error_message|
      context "when we hit a race condition with #{error_class}" do
        before do
          called = 0
          original = Event.method(:transaction)
          # Allow the first attempt to fail, then succeed.
          allow(Event).to receive(:transaction) do |&block|
            called += 1
            raise error_class, error_message if called == 1

            original.call(&block)
          end
        end

        it 'retries and processes the message' do
          expect { event_consumer.process }.to change(Event, :count).by(1)
        end
      end

      context "when we repeatedly hit a race condition with #{error_class}" do
        before do
          allow(Event).to receive(:transaction).and_raise(error_class, error_message)
        end

        it "raises #{error_class} after several attempts" do # rubocop:disable RSpec/MultipleExpectations
          expect { event_consumer.process }.to raise_error(error_class, error_message)
          expect(Event).to have_received(:transaction).exactly(Warren::Subscriber::RETRY_ATTEMPTS + 1).times
        end
      end
    end
  end
end

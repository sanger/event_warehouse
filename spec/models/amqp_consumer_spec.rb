# frozen_string_literal: true

require 'rails_helper'

# The AmqpConsumer handles queue subscription and message receipt
RSpec.describe AmqpConsumer do
  # Ran into a few issues trying to use evented_spec as I kept receiving
  # an undefined_method amqp error. The library hasn't been updated for
  # several years.
  subject(:amqp_consumer) { described_class.new(dummy_config) }

  let(:dummy_config) do
    ActiveSupport::Configurable::Configuration.new(
      url: 'exchange_url',
      queue: queue_name,
      prefetch: prefetch_count,
      requeue: true,
      reconnect_interval: 10,
      deadletter: deadletter_settings
    )
  end
  let(:prefetch_count) { 50 }
  let(:queue_name) { 'queue' }
  let(:deadletter_disabled) { true }
  let(:deadletter_settings) do
    ActiveSupport::Configurable::Configuration.new(
      deactivated: deadletter_disabled,
      exchange: 'deadletters',
      routing_key: 'test.deadletter'
    )
  end
  let(:mock_client) { instance_double(AMQP::Session) }
  let(:mock_chanel) { instance_double(AMQP::Channel) }
  let(:mock_queue) { instance_double(AMQP::Queue) }
  let(:mock_exchange) { instance_double(AMQP::Exchange) }
  let(:chanel_creation) { expect(AMQP::Channel).to receive(:new).with(mock_client).and_return(mock_chanel) }

  before do
    expect(AMQP).to receive(:start).with('exchange_url') do |_, &block|
      block.call(mock_client, true)
    end
    chanel_creation
    expect(mock_client).to receive(:on_error)
    expect(mock_client).to receive(:on_recovery)

    expect(mock_chanel).to receive(:on_error)
    expect(mock_chanel).to receive(:prefetch).with(prefetch_count)
    expect(mock_chanel).to receive(:queue).with(queue_name, passive: true) do |_, &block|
      block.call(mock_queue, true)
    end
  end

  describe '#run' do
    before { expect(mock_queue).to receive(:subscribe).with(ack: true) }

    it 'sets up an exchange' do
      amqp_consumer.run
    end
  end

  describe 'receiving a message' do
    # We can't use an instance double here, as routing_key is handled by method_missing, which the
    # instance
    let(:metadata) do
      double('AMQP::Header', ack: true, delivery_tag: 'delivery_tag', routing_key: 'queue', redelivered?: redelivered)
    end

    before do
      expect(mock_queue).to receive(:subscribe).with(ack: true) do |_, &block|
        block.call(metadata, payload)
      end
    end

    context 'invalid payload' do
      let(:payload) { 'Not a valid message!' }

      context 'on the first run' do
        let(:redelivered) { false }

        context 'without deadlettering' do
          it 'processes the message' do
            expect(mock_chanel).to receive(:reject).with('delivery_tag', true)
            amqp_consumer.run
          end
        end

        context 'with deadlettering' do
          let(:deadletter_disabled) { false }
          let(:mock_dl_chanel) { instance_double(AMQP::Channel, 'Deadletter Chanel', on_error: nil) }
          # Execution order here is important, but it is a result of the way the code behaves,
          # rather than a pre-requisite
          let(:chanel_creation) do
            expect(AMQP::Channel).to receive(:new).with(mock_client).and_return(mock_dl_chanel, mock_chanel)
          end

          it 'processes the message' do
            expect(mock_dl_chanel).to receive(:direct).with('deadletters', passive: true)
            expect(mock_chanel).to receive(:reject).with('delivery_tag', true)
            amqp_consumer.run
          end
        end
      end

      context 'on the second run' do
        let(:redelivered) { true }

        context 'without deadlettering' do
          it 'processes the message' do
            expect(mock_chanel).to receive(:reject).with('delivery_tag', false)
            amqp_consumer.run
          end
        end

        context 'with deadlettering' do
          let(:deadletter_disabled) { false }
          let(:mock_dl_chanel) { instance_double(AMQP::Channel, 'Deadletter Chanel', on_error: nil) }
          # Execution order here is important, but it is a result of the way the code behaves,
          # rather than a pre-requisite
          let(:chanel_creation) do
            expect(AMQP::Channel).to receive(:new).with(mock_client).and_return(mock_dl_chanel, mock_chanel)
          end

          it 'processes the message' do
            expect(mock_dl_chanel).to receive(:direct).with('deadletters', passive: true).and_return(mock_exchange)
            expect(mock_chanel).to receive(:reject).with('delivery_tag', false)
            expect(mock_exchange).to receive(:publish)
            amqp_consumer.run
          end
        end
      end
    end

    context 'valid payload' do
      let(:redelivered) { false }
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
        # Shouldn't actually trigger this, but it makes debugging easier to follow
        allow(mock_chanel).to receive(:reject)
        expect { amqp_consumer.run }.to change(Event, :count).by(1)
      end
    end
  end
end

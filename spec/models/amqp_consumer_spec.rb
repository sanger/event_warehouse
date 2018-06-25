# frozen_string_literal: true

require 'spec_helper'

# The AmqpConsumer handles queue subscription and message receipt
describe AmqpConsumer do
  # Ran into a few issues trying to use evented_spec as I kept receiving
  # an undefined_method amqp error. The library hasn't been updated for
  # several years.
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
  let(:deadletter_settings) { ActiveSupport::Configurable::Configuration.new(deactivated: true, exchange: 'deadletters', routing_key: 'test.deadletter') }
  let(:mock_client) { instance_double(AMQP::Session) }
  let(:mock_chanel) { instance_double(AMQP::Channel) }
  let(:mock_queue) { instance_double(AMQP::Queue) }

  subject(:amqp_consumer) { AmqpConsumer.new(dummy_config) }

  before do
    expect(AMQP).to receive(:start).with('exchange_url') do |_, &block|
      block.call(mock_client, true)
    end
    expect(AMQP::Channel).to receive(:new).with(mock_client).and_return(mock_chanel)
    expect(mock_client).to receive(:on_error)
    expect(mock_client).to receive(:on_recovery)

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
    let(:metadata) { double('AMQP::Header', ack: true, delivery_tag: 'devlivery_tag', routing_key: 'queue', redelivered?: false) }
    before do
      expect(mock_queue).to receive(:subscribe).with(ack: true) do |_, &block|
        block.call(metadata, payload)
      end
    end

    context "invalid payload" do
      let(:payload) { "Not a valid message!" }
      it 'processes the message' do
        expect(mock_chanel).to receive(:reject).with('devlivery_tag', true)
        amqp_consumer.run
      end
    end

    context "valid payload" do
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
            'metadata' => metadata
          },
          'lims' => 'lims'
        }.to_json
      end
      it 'processes the message' do
        expect { amqp_consumer.run }.to change { Event.count }.by(1)
      end
    end
  end
end

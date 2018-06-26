# frozen_string_literal: true

require 'amqp'

# Subscribes to a message queue, and passes the messages into the correct object.
# Need to be simplified
class AmqpConsumer
  include Logging

  class InvalidMessage < StandardError; end

  def initialize(config)
    @config = config
  end

  def run
    info { 'Starting AMQP consumer ...' }

    AMQP.start(url) do |client, _opened_ok|
      install_show_stopper_into(client)
      setup_error_handling(client)
      build_client(client, prepare_deadlettering(client))
    end
  end

  delegate :url, :queue, :deadletter, :prefetch, :requeue, :reconnect_interval, to: :@config
  alias requeue? requeue

  private

  # Override the logging behaviour so that we have consistent message format
  %i[debug warn info error].each do |level|
    define_method(level) do |metadata = nil, &message|
      identifier = if metadata.present?
                     "(#{metadata.delivery_tag.inspect}:#{metadata.routing_key.inspect}): "
                   else
                     ''
                   end
      super() { "#{identifier}#{message.call}" }
    end
  end

  def empty_queue_disconnect_interval
    @config.empty_queue_disconnect_interval || 0
  end

  def received(metadata, payload)
    insert_record(metadata, ActiveSupport::JSON.decode(payload))
  end

  def insert_record(metadata, json)
    lims = json.delete('lims') || raise(InvalidMessage, 'No Lims specified')
    payload_name = json.keys.first
    ActiveRecord::Base.transaction do
      payload_name.classify.constantize.create_or_update_from_json(json[payload_name], lims)
    end
    metadata.ack # Acknowledge receipt!
  end

  def setup_error_handling(client)
    client.on_error do |connection, connection_close|
      if connection_close.reply_code == 320
        warn { "Connection has been disconnected, retrying at #{reconnect_interval}s" }
        connection.periodically_reconnect(reconnect_interval)
      else
        error { "Connection error #{connection_close.reply_code}: #{connection_close.reply_text}" }
        EventMachine.stop # Brutally stop the consumer!
      end
    end

    client.on_recovery do |*_args|
      info { 'Connection has recovered, rebuilding system ...' }
      build_client(client)
    end
  end

  # Returns a callback that can be used to dead letter any messages.
  def prepare_deadlettering(client)
    return ->(m, _p, e) { warn(m) { "No dead lettering for #{e.message}: #{e.backtrace}" } } if deadletter.deactivated

    channel  = AMQP::Channel.new(client)
    exchange = channel.direct(deadletter.exchange, passive: true)
    lambda do |metadata, payload, exception|
      warn(metadata) { "Dead lettering due to #{exception.message}" }
      exchange.publish({
        routing_key: metadata.routing_key,
        exception: { message: exception.message, backtrace: exception.backtrace },
        message: payload
      }.to_json, routing_key: "#{deadletter.routing_key}.#{metadata.routing_key}")
    end
  end

  def build_client(client, deadletter)
    info { "Connecting to queue #{queue.inspect} ..." }

    channel = AMQP::Channel.new(client)
    channel.prefetch(prefetch)
    channel.queue(queue, passive: true) do |queue, _queue_declared|
      info { 'Waiting for messages ...' }

      stop_when_queue_empty(channel, queue) unless empty_queue_disconnect_interval.zero?

      queue.subscribe(ack: true) do |metadata, payload|
        debug { "Message received from queue: #{payload.inspect}" }
        begin
          received(metadata, payload)
        rescue StandardError => exception
          debug(metadata) { 'failed!' }

          # If this is the first time we've seen this message then we requeue.  If it's not to be requeued
          # then we deadletter it ourselves rather than using RabbitMQ's deadletter queueing which seems
          # unreliable for some reason.  If the message is not requeued then we need to record the error.

          requeue_message = requeue? && !metadata.redelivered?

          if !requeue_message && longterm_issue(exception)
            # It is our second attempt, and the issue is longterm
            channel.reject(metadata.delivery_tag, true)
            error(metadata) { "Closing message client following: #{exception.message}" }
            WorkerDeath.failure(exception).deliver
            client.close { EventMachine.stop }
          else
            channel.reject(metadata.delivery_tag, requeue_message)
            unless requeue_message
              deadletter.call(metadata, payload, exception)
              raise
            end

          end
        end
      rescue StandardError => exception
        error(metadata) { exception.message }
        debug(metadata) { payload }
      end
    end
  end

  def stop_when_queue_empty(channel, queue)
    EventMachine.add_periodic_timer(empty_queue_disconnect_interval) do
      queue.status do |messages_in_queue, _|
        if messages_in_queue.zero?
          info { 'Queue has no messages, quitting ...' }
          channel.close { EventMachine.stop }
        end
      end
    end
  end

  def longterm_issue(exception)
    # We can't just use the exception class, as many Rails MySQL exceptions share the same class
    if exception.is_a? ActiveRecord::StatementInvalid
      # Example exceptions, we may need to add more in future:
      # <ActiveRecord::StatementInvalid: Mysql2::Error: closed MySQL connection: SELECT sleep(10) FROM studies;>
      # Mysql2::Error: closed MySQL connection: SELECT sleep(10) FROM studies; Connection closed.
      [/Mysql2::Error: closed MySQL connection:/, /Mysql2::Error: MySQL server has gone away/].each do |regex|
        return true if regex.match(exception.message).present?
      end
    end
    false
  end

  # Deals with the signals that should stop the show!
  def install_show_stopper_into(client)
    %w[TERM INT].each do |signal|
      Signal.trap(signal, proc do
        info { "Received #{signal} signal, so quitting ..." }
        client.close { EventMachine.stop }
      end)
    end
  end
end

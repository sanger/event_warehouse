# frozen_string_literal: true

module Warren
  module Subscriber
    # Number of times to retry on race condition to avoid infinite loops
    RETRY_ATTEMPTS = 10

    # Warren powered event_consumer consumers
    # Takes events off the queue and records them in the warehouse
    # Takes messages from the psd.event_warehouse.event_consumer queue
    #
    # == Example Message
    # {
    #   "event":{
    #     "uuid":"00000000-1111-2222-3333-444444444444",
    #     "event_type":"delivery",
    #     "occured_at":"2012-03-11 10:22:42",
    #     "user_identifier":"postmaster@example.com",
    #     "subjects":[
    #       {
    #         "role_type":"sender",
    #         "subject_type":"person",
    #         "friendly_name":"alice@example.com",
    #         "uuid":"00000000-1111-2222-3333-555555555555"
    #       },
    #       {
    #         "role_type":"recipient",
    #         "subject_type":"person",
    #         "friendly_name":"bob@example.com",
    #         "uuid":"00000000-1111-2222-3333-666666666666"
    #       },
    #       {
    #         "role_type":"package",
    #         "subject_type":"plant",
    #         "friendly_name":"Chuck",
    #         "uuid":"00000000-1111-2222-3333-777777777777"
    #       }
    #     ],
    #     "metadata":{
    #       "delivery_method":"courier",
    #       "shipping_cost":"15.00"
    #     }
    #   },
    #   "lims":"example"
    # }
    #
    class EventConsumer < Warren::Subscriber::Base
      class InvalidMessage < StandardError; end
      # == Handling messages
      # Message processing is handled in the {#process} method. The following
      # methods will be useful:
      #
      # @!attribute [r] payload
      #   @return [String] the payload of the message
      # @!attribute [r] delivery_info
      #   @return [Bunny::DeliveryInfo] mostly used internally for nack/acking messages
      #                                 http://rubybunny.info/articles/queues.html#accessing_message_properties_metadata
      # @!attribute [r] properties
      #   @return [Bunny::MessageProperties] additional message properties.
      #                             http://rubybunny.info/articles/queues.html#accessing_message_properties_metadata

      # Handles message processing. Messages are acknowledged automatically
      # on return from the method assuming they haven't been handled already.
      # In the event of an uncaught exception, the message will be dead-lettered.
      def process
        attempts ||= 0
        Event.transaction { Event.create_or_update_from_json(event_payload, lims) }
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::Deadlocked => e
        # If multiple messages are processed simultaneously we could end up
        # with a race condition. In this case we just retry processing the message
        # immediately. In most cases this will be sufficient, but in the unlikely
        # event we hit another race condition, we'll try again.
        # We give up eventually, just to avoid the situation where we get into
        # an infinite loop due to unidentified bugs elsewhere in the code.
        attempts += 1
        raise e if attempts > RETRY_ATTEMPTS

        retry
      end

      private

      def lims
        json.fetch('lims') { raise(InvalidMessage, 'No Lims specified') }
      end

      def event_payload
        json.fetch('event') { raise(InvalidMessage, 'No event specified') }
      end

      def json
        @json ||= extract_json
      end

      def extract_json
        Oj.load(payload)
      rescue Oj::ParseError => e
        raise InvalidMessage, "Payload #{payload} is not JSON: #{e.message}"
      end
    end
  end
end

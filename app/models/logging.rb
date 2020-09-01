# frozen_string_literal: true

# Wraps the rails logger, and prepends each message with the originating class
module Logging
  %i[debug warn info error].each do |level|
    define_method(level) do |metadata = nil, &message|
      identifier = if metadata.present?
                     "(#{metadata.delivery_tag.inspect}:#{metadata.routing_key.inspect}): "
                   else
                     ''
                   end
      Rails.logger.public_send(level) { "#{self.class.name}: #{identifier}#{message.call}" }
    end
  end
end

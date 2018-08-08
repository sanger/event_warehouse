# frozen_string_literal: true

# Wraps the rails logger, and prepends each message with the originating class
module Logging
  %i[debug info warn error].each do |level|
    define_method(level) do |&message|
      Rails.logger.public_send(level) { "#{self.class.name}: #{message.call}" }
    end
  end
end

# frozen_string_literal: true

module Logging
  %i[debug info warn error].each do |level|
    define_method(level) do |&message|
      Rails.logger.public_send(level) { "#{self.class.name}: #{message.call}" }
    end
  end
end

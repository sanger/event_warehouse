# frozen_string_literal: true

module Logging
  %i[debug info warn error].each do |level|
    line = __LINE__ + 1
    class_eval(%{
      def #{level}(&message)
        Rails.logger.#{level} { "\#{self.class.name}: \#{message.call}" }
      end
    }, __FILE__, line)
  end
end

# frozen_string_literal: true

module ResourceTools::CoreExtensions
  module Array
    extend ActiveSupport::Concern

    module ClassMethods
      def convert(object)
        return object if object.is_a?(Array)
        [object]
      end
    end
  end

  module Hash
    # Does the opposite of slice, returning a hash that does not have the specified keys!
    def reverse_slice(*keys)
      keys.flatten!
      dup.delete_if { |k, _| keys.include?(k) }
    end
  end

  module Numeric
    extend ActiveSupport::Concern

    included do
      delegate :numeric_tolerance, to: 'self.class'
    end

    module ClassMethods
      def numeric_tolerance
        @numeric_tolerance ||= EventWarehouse::Application.config.numeric_tolerance
      end
    end
  end
end

# Extend the core classes with the behaviour we need
class Array; include ResourceTools::CoreExtensions::Array; end
class Hash; include ResourceTools::CoreExtensions::Hash; end
class Numeric; include ResourceTools::CoreExtensions::Numeric; end

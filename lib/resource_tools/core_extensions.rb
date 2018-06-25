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

  module String
    def to_boolean_from_arguments
      if %w[true yes].include?(downcase) then true
      elsif %w[false no].include?(downcase) then false
      else raise "Cannot convert #{inspect} to a boolean safely!"
      end
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

  module NilClass
    def latest(_object)
      yield(nil)
    end
  end

  module SelfReferencingBoolean
    def to_boolean_from_arguments
      self
    end
  end
end

# Extend the core classes with the behaviour we need
class Array; include ResourceTools::CoreExtensions::Array; end
class Hash; include ResourceTools::CoreExtensions::Hash; end
class String; include ResourceTools::CoreExtensions::String; end
class Numeric; include ResourceTools::CoreExtensions::Numeric; end
class NilClass
  include ResourceTools::CoreExtensions::NilClass
  include ResourceTools::CoreExtensions::SelfReferencingBoolean
end
class TrueClass; include ResourceTools::CoreExtensions::SelfReferencingBoolean; end
class FalseClass; include ResourceTools::CoreExtensions::SelfReferencingBoolean; end

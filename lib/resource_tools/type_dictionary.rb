# frozen_string_literal: true

# Include in models which have a 'type' referenced in a dictionary
module ResourceTools::TypeDictionary
  extend ActiveSupport::Concern

  RECORD_NOT_UNIQUE_RETRIES = 3

  class_methods do
    attr_accessor :default_description

    def for_key(key)
      tries = 0
      begin
        if preregistration_required?
          find_by(key: key)
        else
          create_with(description: default_description).find_or_create_by(key: key)
        end
      rescue ActiveRecord::RecordNotUnique => e
        # If we have two similar events arriving at the same time, we might conceivably run into a
        # race condition. We retry a few times, then give up and re-raise our exception;
        tries += 1
        retry if tries <= RECORD_NOT_UNIQUE_RETRIES
        raise e
      end
    end

    def preregistration_required(bool)
      @preregistration_required = bool
    end

    def preregistration_required?
      # Default to false
      @preregistration_required || false
    end
  end

  included do
    validates_presence_of :key
    validates_uniqueness_of :key

    validates_presence_of :description
  end

  # Include in MyClass to set up MyClassType associations and setters
  # The setter can receive either the key, or the type itself
  module HasDictionary
    extend ActiveSupport::Concern
    included do
      type_assn = "#{name.downcase}_type"
      type_class = "#{name}Type".constantize

      belongs_to :"#{type_assn}"
      define_method(:"#{type_assn}=") do |assn_key|
        key_object = assn_key.is_a?(String) ? type_class.for_key(assn_key) : assn_key
        super(key_object)
      end
    end
  end
end

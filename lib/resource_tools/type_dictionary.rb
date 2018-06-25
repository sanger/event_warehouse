# frozen_string_literal: true

module ResourceTools::TypeDictionary
  RECORD_NOT_UNIQUE_RETRIES = 3

  module ClassMethods
    attr_reader :default_description

    def for_key(key)
      tries = 0
      begin
        if preregistration_required?
          where(key: key).first
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

    def has_default_description(description)
      @default_description = description
    end

    def preregistration_required(bool)
      @preregistration_required = bool
    end

    def preregistration_required?
      # Default to false
      @preregistration_required || false
    end
  end

  def self.included(base)
    base.class_eval do
      validates_presence_of :key
      validates_uniqueness_of :key

      validates_presence_of :description

      extend ClassMethods
    end
  end

  # Include in MyClass to set up MyClassType associations and setters
  # The setter can receive either the key, or the type itself
  module HasDictionary
    def self.included(base)
      base.class_eval do
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
end

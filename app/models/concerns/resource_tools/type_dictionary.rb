# frozen_string_literal: true

# Include in models which have a 'type' referenced in a dictionary
module ResourceTools::TypeDictionary
  extend ActiveSupport::Concern

  RECORD_NOT_UNIQUE_RETRIES = 3

  class_methods do
    attr_accessor :default_description, :preregistration_required

    def for_key(key)
      tries = 0
      begin
        if preregistration_required?
          find_by(key: key)
        else
          create_with(description: default_description).find_or_create_by!(key: key)
        end
      rescue ActiveRecord::RecordNotUnique => e
        # If we have two similar events arriving at the same time, we might conceivably run into a
        # race condition. We retry a few times, then give up and re-raise our exception;
        tries += 1
        retry if tries <= RECORD_NOT_UNIQUE_RETRIES
        raise e
      end
    end

    def preregistration_required?
      # Default to false
      @preregistration_required || false
    end
  end

  included do
    described_assn = name.chomp('Type').pluralize.underscore
    validates :key, presence: true
    validates :key, uniqueness: true

    validates :description, presence: true

    has_many :"#{described_assn}", dependent: :restrict_with_exception
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

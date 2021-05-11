# frozen_string_literal: true

# Handle JSON parsing.
module ResourceTools::Json
  extend ActiveSupport::Concern

  class_methods do
    def create_or_update_from_json(json_data, lims)
      create_or_update(json.collection_from(json_data, lims))
    end

    private

    def json(&block)
      const_set(:JsonHandler, Class.new(ResourceTools::Json::Handler)) unless const_defined?(:JsonHandler)
      const_get(:JsonHandler).tap { |json_handler| json_handler.instance_eval(&block) if block_given? }
    end
  end

  # Holds the parameters for a JSON resource
  class Handler < ActiveSupport::HashWithIndifferentAccess
    class_attribute :translations
    self.translations = {}

    class << self
      # JSON attributes can be translated into the attributes on the way in.
      def translate(details)
        self.translations = details.stringify_keys
                                   .transform_values(&:to_s)
                                   .reverse_merge(translations)
      end

      def collection_from(json_data, lims)
        new(json_data.reverse_merge(lims_id: lims))
      end
    end

    def convert_key(key)
      translations[key.to_s] || key.to_s
    end

    translate(updated_at: :last_updated, created_at: :created)
  end
end

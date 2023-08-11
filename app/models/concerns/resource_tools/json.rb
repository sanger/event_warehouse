# frozen_string_literal: true

# Include in an ActiveRecord::Base object to handle JSON parsing and translation.
#
# @example Including a basic parser
#   class MyClass < ApplicationRecord
#     include ResourceTools
#
#     json do
#       translate(
#         side_walk: :pavement,
#         trunk: :boot
#       )
#     end
#   end
#
# The example above will create a new subclass of `ResourceTools::Json::Handler`
# called `MyClass::JsonHandler`. This can be accessed via the class method
# {ResourceTools::Json::json}
#
# The JsonHandler will automatically take parsed json (ie. covered to a Hash)
# and will:
# - convert each key to a string
# - perform any translations specified via {ResourceTools::Json::Handler::translate}
#
# @example Invoking the Handler
#   MyClass.create_or_update_from_json(parsed_json, 'Lims')
#
# This will extract the translated attributes from parsed_json and pass them
# into the create_or_update method.
module ResourceTools::Json
  extend ActiveSupport::Concern

  class_methods do
    #
    # Translates the provided json_data with the appropriate
    # {ResourceTools::Json::Handler} and passes into create_or_update
    #
    # @param json_data [Hash] parse JSON data
    # @param lims [String] Identifier for the originating lims
    #
    # @return [ApplicationRecord] An Active Record object built from the provided json
    #
    def create_or_update_from_json(json_data, lims)
      create_or_update(json.collection_from(json_data, lims))
    end

    private

    #
    # Creates, configures and returns a JsonHandler based on the class in which
    # it is evaluated. See {ResourceTools::Json} for usage example.
    #
    # @yield [] Provided block is evaluated in the context of the new class to configure it.
    #
    # @return [ResourceTools::Json::Handler] New subclass of ResourceTools::Json::Handler named YourClass::JsonHandler
    #
    def json(&block)
      const_set(:JsonHandler, Class.new(ResourceTools::Json::Handler)) unless const_defined?(:JsonHandler)
      const_get(:JsonHandler).tap { |json_handler| json_handler.instance_eval(&block) if block }
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

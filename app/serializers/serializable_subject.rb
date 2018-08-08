# frozen_string_literal: true

# Serializers define the rendered JSON for a model instance.
# We use jsonapi-rb, which is similar to active_model_serializers.
class SerializableSubject < JSONAPI::Serializable::Resource
  type :subjects

  # Add attributes here to ensure they get rendered, .e.g.
  #
  # attribute :name
  #
  # To customize, pass a block and reference the underlying @object
  # being serialized:
  #
  # attribute :name do
  #   @object.name.upcase
  # end
  attribute :friendly_name
  attribute :uuid

  belongs_to :subject_type
  has_many :roles
  has_many :events
end

# frozen_string_literal: true

#
# A single action that can occur, and may be of interest to multiple parties.
# Events may be associated with one or more Subjects, and may have any number of metadata.
#
class Event < ApplicationRecord
  include ResourceTools
  include ImmutableResourceTools
  include ResourceTools::TypeDictionary::HasDictionary

  has_many :roles, dependent: :destroy, inverse_of: :event
  has_many :subjects, through: :roles

  has_many :metadata, inverse_of: :event, dependent: :destroy do
    def build_from_json(metadata_hash)
      build(metadata_hash.map do |key, value|
        { key: key, value: value }
      end)
    end

    def to_h
      each_with_object({}) do |metadatum, store|
        store[metadatum.key] = metadatum.value
      end
    end
  end

  attribute :uuid, MySQLBinUUID::Type.new

  validates :event_type, presence: true
  validates :lims_id, presence: true
  validates :occured_at, presence: true
  validates :user_identifier, presence: true
  validates :uuid, uniqueness: true

  def ignorable?
    event_type.nil?
  end

  def subjects=(subject_array)
    role_array = subject_array.map do |subject_data|
      role_type = subject_data[:role_type]
      subject = Subject.lookup(subject_data)
      { role_type: role_type, subject: subject }
    end
    roles.build(role_array)
  end

  def metadata=(metadata_hash)
    metadata.build_from_json(metadata_hash)
  end

  def metadata_hash
    metadata.to_h
  end

  json do
  end
end

class Event < ActiveRecord::Base
  include ResourceTools
  include ImmutableResourceTools
  include ResourceTools::TypeDictionary::HasDictionary

  has_many :roles
  has_many :subjects, through: :roles

  has_many :metadata do
    def build_from_json(metadata_hash)
      build(metadata_hash.map do |key, value|
        { key: key, value: value }
      end)
    end
  end

  validates_presence_of :event_type
  validates_presence_of :lims_id
  validates_presence_of :occured_at
  validates_presence_of :user_identifier
  validates_uniqueness_of :uuid

  def ignorable?
    event_type.nil?
  end

  def subjects=(subject_array)
    role_array = subject_array.map do |subject_data|
      role_type = subject_data.delete(:role_type)
      subject = Subject.lookup(subject_data)
      { role_type: role_type, subject: subject }
    end
    roles.build(role_array)
  end

  def metadata=(metadata_hash)
    metadata.build_from_json(metadata_hash)
  end

  json do
  end
end

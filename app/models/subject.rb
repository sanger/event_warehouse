# frozen_string_literal: true

# Something associated with a event.
# An subject can be considered an interested party, either because it was directly subject to an event,
# or because it is indirectly affected. Subjects may belong to many events.
# While their subject type will remain constant, the role may be different for each event.
class Subject < ApplicationRecord
  include ResourceTools::TypeDictionary::HasDictionary

  attribute :uuid, MySQLBinUUID::Type.new

  validates :subject_type, :friendly_name, :uuid, presence: true
  validates :uuid, uniqueness: true

  has_many :roles, inverse_of: :subject, dependent: :restrict_with_exception
  has_many :events, through: :roles

  def self.lookup(subject)
    create_with(
      friendly_name: subject[:friendly_name],
      subject_type: subject[:subject_type]
    ).find_or_create_by!(uuid: subject[:uuid])
  end
end

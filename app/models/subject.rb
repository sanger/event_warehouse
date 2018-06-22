# frozen_string_literal: true

class Subject < ActiveRecord::Base
  include ResourceTools::TypeDictionary::HasDictionary

  validates :subject_type, :friendly_name, :uuid, presence: true
  validates :uuid, uniqueness: true

  def self.lookup(subject)
    create_with(friendly_name: subject[:friendly_name], subject_type: subject[:subject_type]).find_or_create_by(uuid: subject[:uuid])
  end
end

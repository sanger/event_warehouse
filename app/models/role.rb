# frozen_string_literal: true

# Links Subjects to Events, and describes the role they are performing
# in the event
class Role < ApplicationRecord
  include ResourceTools::TypeDictionary::HasDictionary

  belongs_to :subject
  belongs_to :event
end

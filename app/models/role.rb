# frozen_string_literal: true

class Role < ActiveRecord::Base
  include ResourceTools::TypeDictionary::HasDictionary

  belongs_to :subject
  belongs_to :event
end

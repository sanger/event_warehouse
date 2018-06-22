# frozen_string_literal: true

class Metadatum < ActiveRecord::Base
  belongs_to :event
end

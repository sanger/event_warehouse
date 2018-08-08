# frozen_string_literal: true

# Key value pair describing custom information regarding an event.
class Metadatum < ApplicationRecord
  belongs_to :event
end

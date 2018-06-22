# frozen_string_literal: true

class IgnoreableResource
  def self.create_or_update_from_json(*args)
    new
  end

  def id
    'ignored'
  end
end

# frozen_string_literal: true

# An immutable resource can only be recorded once. And further messages with the same
# uuid will be ignored. Even if their content is different.
module ImmutableResourceTools
  extend ActiveSupport::Concern
  # Class Methods extend the resource automatically thanks to ActiveSupport::Concern
  module ClassMethods
    private

    def create_or_update(attributes)
      # return false if with_uuid(new_atts["uuid"]).exists?
      new_atts = attributes.reverse_merge(data: attributes)
      new_record = new(new_atts)
      return nil if new_record.ignorable?

      new_record.save!
    end
  end
end

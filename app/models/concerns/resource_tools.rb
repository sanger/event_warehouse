# frozen_string_literal: true

# Include in records to enable them to be created by the
# AMQP builder.
module ResourceTools
  extend ActiveSupport::Concern
  include ResourceTools::Json

  included do |_base|
    # The original data information is stored here
    attr_accessor :data

    scope :for_lims,  ->(lims) { where(lims_id: lims) }
    scope :with_uuid, ->(uuid) { where(uuid: uuid) }
  end
end

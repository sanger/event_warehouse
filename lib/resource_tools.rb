# frozen_string_literal: true

module ResourceTools
  require 'resource_tools/core_extensions'

  extend ActiveSupport::Concern
  include ResourceTools::Json

  included do |_base|
    # scope :updating, lambda { |r| where(:uuid => r.uuid).current }

    # The original data information is stored here
    attr_accessor :data

    scope :for_lims,  ->(lims) { where(lims_id: lims) }
    scope :with_uuid, ->(uuid) { where(uuid: uuid) }
  end

  IGNOREABLE_ATTRIBUTES = ['dont_use_id'].freeze
end

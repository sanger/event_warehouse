# frozen_string_literal: true

module ResourceTools
  require 'resource_tools/core_extensions'

  extend ActiveSupport::Concern
  include ResourceTools::Json

  included do |_base|
    # scope :updating, lambda { |r| where(:uuid => r.uuid).current }

    # The original data information is stored here
    attr_accessor :data

    # Before saving store whether this is a new record.  This allows us to determine whether we have inserted a new
    # row, which we use in the checks of whether the AmqpConsumer is working: if the ApiConsumer inserts a row then
    # we're probably not capturing all of the right messages.
    before_save :remember_if_we_are_a_new_record

    scope :for_lims,  ->(lims) { where(lims_id: lims) }
    scope :with_uuid, ->(uuid) { where(uuid: uuid) }
  end

  def remember_if_we_are_a_new_record
    @inserted_record = new_record?
    true
  end
  private :remember_if_we_are_a_new_record

  IGNOREABLE_ATTRIBUTES = ['dont_use_id'].freeze
end

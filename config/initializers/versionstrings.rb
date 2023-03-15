# frozen_string_literal: true

begin
  require 'deployed_version'
rescue LoadError
  module Deployed
    VERSION_ID = 'LOCAL'
    VERSION_STRING = "#{Rails.root.split.last.capitalize} LOCAL [#{Rails.env}]"
    RELEASE_NAME = 'Running locally'
  end
end

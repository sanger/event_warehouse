# frozen_string_literal: true

# Basic controller
class ApplicationController < ActionController::API
  include JsonapiSuite::ControllerMixin
end

# frozen_string_literal: true

# Basic controller
class ApplicationController < ActionController::Base
  include JSONAPI::ActsAsResourceController
end

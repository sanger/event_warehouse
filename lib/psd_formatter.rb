# frozen_string_literal: true

require 'syslog/logger'
require 'ostruct'

# Formats logs for passing to Kibana
# Logs in the format "(thread-THREAD_ID) [APP_NAME:VERSION:ENV] LEVEL -- : MESSAGE"
class PsdFormatter < Syslog::Logger::Formatter
  LINE_FORMAT = "(thread-%s) [%s] %5s -- : %s\n"

  # Severity label for logging (max 5 chars).
  SEV_LABEL = %w[DEBUG INFO WARN ERROR FATAL ANY].each(&:freeze).freeze

  def initialize(deployment_info)
    info = OpenStruct.new(deployment_info) # rubocop:todo Style/OpenStructUse
    @app_tag = [info.name, info.version, info.environment].compact.join(':').freeze
    super()
  end

  def call(severity, _timestamp, _progname, msg)
    thread_id = Thread.current.object_id
    format(LINE_FORMAT, thread_id, @app_tag, format_severity(severity), msg)
  end

  private

  def format_severity(severity)
    if severity.is_a?(Integer)
      SEV_LABEL[severity] || 'ANY'
    else
      severity
    end
  end
end

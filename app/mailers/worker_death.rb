# frozen_string_literal: true

class WorkerDeath < ActionMailer::Base
  default from: EventWarehouse::Application.config.worker_death_from,
          to: EventWarehouse::Application.config.worker_death_to,
          subject: "[#{Rails.env.upcase}] Unified Warehouse worker death"

  def failure(exception)
    @exception = exception
    mail
  end
end

# frozen_string_literal: true

# Notifies us when the workers have died due to database connection issues
class WorkerDeath < ApplicationMailer
  default from: EventWarehouse::Application.config.worker_death_from,
          to: EventWarehouse::Application.config.worker_death_to,
          subject: "[#{Rails.env.upcase}] Unified Warehouse worker death"

  def failure(exception)
    @exception = exception
    mail
  end
end

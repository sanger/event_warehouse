set :output, lambda { '2>&1 | logger -t event_warehouse_cron' }

every 1.hour do
  script 'amqp_loader deadletter'
end

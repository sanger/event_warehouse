#!/bin/sh

if test "${INTEGRATION_TEST_SETUP}" = "true" ; then
  echo "Setting up for integration tests"
  RAILS_ENV=test bundle exec rake db:reset
  RAILS_ENV=test bundle exec rails runner /code/spec/data/integration/seed_for_unified_wh.rb
  sleep 5
fi

./bin/amqp_client start

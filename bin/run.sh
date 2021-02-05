#!/bin/bash
set -Eeuxo pipefail

if test "${INTEGRATION_TEST_SETUP:-}" = "true" ; then
  echo "Setting up for integration tests"
  RAILS_ENV=test bundle exec rake db:reset
  if test -n $INTEGRATION_TEST_SEED ; then
    RAILS_ENV=test bundle exec rails runner $INTEGRATION_TEST_SEED
  fi
fi

echo "Starting the service"
mkdir tmp/pids || true

./bin/amqp_client start

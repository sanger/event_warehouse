#!/bin/bash
set -eo pipefail
shopt -s nullglob


# check to see if this file is being run or sourced from another script
_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_main() {
  if test "${INTEGRATION_TEST_SETUP}" = "true" ; then
    echo "Setting up for integration tests"
    RAILS_ENV=test bundle exec rake db:reset
    RAILS_ENV=test bundle exec rails runner /code/spec/data/integration/seed_for_unified_wh.rb
    tail -f /dev/null
  fi
  exec "$@"
}

# If we are sourced from elsewhere, don't perform any further actions
if ! _is_sourced; then
	_main "$@"
fi
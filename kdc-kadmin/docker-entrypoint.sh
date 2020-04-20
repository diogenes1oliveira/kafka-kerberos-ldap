#!/usr/bin/env bash

set -euo pipefail

initpath="/docker-entrypoint-init.d"

kerberos-initialize

if [ -d "$initpath" ]; then
  for s in `find "$initpath" -mindepth 1 -maxdepth 1 -name '*.sh' | sort`; do
    source "$s"
  done
fi

# first arg is `-f` or `--some-option`
# or there are no args
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	exec bash -c "krb5kdc && kadmind -nofork"
fi

exec "$@"

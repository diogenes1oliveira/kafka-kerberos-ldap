#!/usr/bin/env bash

set -euo pipefail

initpath="/docker-entrypoint-init.d"

if [ -d "$initpath" ]; then
  for s in `find "$initpath" -mindepth 1 -maxdepth 1 -name '*.sh' | sort`; do
    source "$s"
  done
fi

kerberos-initialize
kerberos-as-admin --wait

IFS=',' read -ra ADDR <<< "${KERBEROS_KEYTABS:-}"
for k in "${ADDR[@]}"; do
  principal="${k}/${k}.${KERBEROS_REALM}@${KERBEROS_REALM}"
  kerberos-as-admin -q "addprinc -randkey ${principal}"
  kerberos-as-admin -q "ktadd -k /etc/security/keytabs/${k}.keytab ${principal}"
done

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
  # first arg is a flag
  exec kerberos-as-admin "$@"
fi

exec "$@"

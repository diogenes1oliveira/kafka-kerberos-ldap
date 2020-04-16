#!/usr/bin/env bash

set -euo pipefail

export KADMIN_PRINCIPAL="${KADMIN_PRINCIPAL:-kadmin/admin}"
export KADMIN_PRINCIPAL_FULL="${KADMIN_PRINCIPAL}@${REALM}"
export KCLIENT_MAX_WAIT_TIME="${KCLIENT_MAX_WAIT_TIME:-30}"

function info {
	awk -v prefix="# (${1:-INFO}): " '{ print prefix $0 }' >&2
}

function uptime_now {
  cat /proc/uptime | awk '{print $1}'
}

uptime_start="$(uptime_now)"

echo "waiting ${KCLIENT_MAX_WAIT_TIME}s for Kerberos" | info

until kadmin -p "${KADMIN_PRINCIPAL_FULL}" -w "${KADMIN_PASSWORD}" -q "list_principals ${KADMIN_PRINCIPAL_FULL}"; do
  if echo "$(uptime_now) - ${uptime_start} > ${KCLIENT_MAX_WAIT_TIME}" | bc; then
    echo "timeout of ${KCLIENT_MAX_WAIT_TIME}s expired while waiting for Kerberos" | info 'ERROR'
    exit 1
  fi

  sleep 1
done

echo "Kerberos is ready" | info

if [ "${1:-}" = "--wait" ]; then
  exit 0
fi

kadmin -p "${KADMIN_PRINCIPAL_FULL}" -w "${KADMIN_PASSWORD}" -q "$1"

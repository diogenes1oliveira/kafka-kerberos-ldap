#!/usr/bin/env bash

set -euo pipefail

max_wait_time='30'

function usage {
  cat <<eof
Waits for a command to exit with status 0.

Usage: $0 [-s=<SERVICE>]

Options:
  -t=<TIME>    time to wait for the command (default: 30s)
eof
}

function main {
  echo "INFO: waiting $max_wait_time seconds for $@" >&2
  t0="$(clock_now)"

  while ! $@ > /dev/null 2> /dev/null; do
    t="$(clock_now)"

    if [ "$((t-t0))" -gt "${max_wait_time}" ]; then
      echo "FATAL: timeout exceeded" >&2
      exit 1
    fi

    sleep 1
  done

  echo "INFO: command succeeded" >&2
}

function clock_now {
  cat /proc/uptime | awk '{print $1}' | xargs printf "%.0f"
}

while getopts "t:h" OPT; do
  case "$OPT" in
  t)
    max_wait_time="$OPTARG"
    ;;
  h)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 1
    ;;
  esac
done

main "$@"

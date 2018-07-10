#!/bin/bash

ATTEMPTS=${ATTEMPTS:-10}
SLEEP=${SLEEP:-5}

# check: provide a way to check the availability of a host:port
#
# check {location} {port} {payload}
#
# example:
#  check 10.43.0.111 9999 ""
check() {
  echo "Awaiting availability [$1:$2]..."
  i=0
  while [ $i -lt $ATTEMPTS ]; do
    i=$((i+1))

    echo "Starting attempt $i"

    # Telnet may return a non-zero status
    set +eo pipefail
    echo $3 | telnet $1 $2
    res=$?
    set -eo pipefail

    echo "Got result $res"

    if [ $res -eq 0 ]; then
      echo "Connected!"
      return 0
    fi

    echo "No connection after $i attempts, sleeping for $SLEEP secs"

    sleep $SLEEP
  done

  echo "Failed."
  exit 1
}

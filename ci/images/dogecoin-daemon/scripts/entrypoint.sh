#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for dogecoind"

  set -- dogecoind "$@"
fi

echo
exec "$@"

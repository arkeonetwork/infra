#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

source ./scripts/install.sh

echo
echo "=> Waiting for Arkeo Node daemon to be ready"
kubectl rollout status -w deployment/arkeo -n "$NAME" --timeout=5m

if [ "$TYPE" != "fullnode" ]; then
  echo
  source ./scripts/set-version.sh
fi

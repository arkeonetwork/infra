#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

echo "Performing snapshot and backup for Arkeo Node and Bifrost..."
confirm

if snapshot_available; then
  make_snapshot arkeo
  make_snapshot sentinel
else
  warn "Snapshot not available in this cluster, performing backup only..."
  echo
fi

make_backup arkeo
make_backup sentinel

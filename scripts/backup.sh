#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

if [ "$SERVICE" = "" ]; then
  echo "=> Select a Arkeo Node service to backup"
  menu arkeo arkeo sentinel
  SERVICE=$MENU_SELECTED
fi

if ! kubectl -n "$NAME" get pvc "$SERVICE" >/dev/null 2>&1; then
  warn "Volume $SERVICE not found"
  echo
  exit 0
fi

make_backup "$SERVICE"

#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short
get_node_service

case $SERVICE in
  midgard | midgard-timescaledb)
    kubectl logs -f -n "$NAME" sts/"$SERVICE"
    ;;
  ethereum-daemon)
    menu ethereum-daemon ethereum-daemon ethereum-daemon-beacon
    kubectl logs -f -n "$NAME" deploy/ethereum-daemon -c "$MENU_SELECTED"
    ;;
  *)
    kubectl logs -f -n "$NAME" deploy/"$SERVICE"
    ;;
esac
exit 0

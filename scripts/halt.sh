#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short
get_node_service

echo "=> Halting service $boldyellow$SERVICE$reset of a Arkeo Node named $boldyellow$NAME$reset"
echo
confirm

case $SERVICE in
  midgard)
    kubectl delete -n "$NAME" sts/midgard
    ;;

  midgard-timescaledb)
    kubectl delete -n "$NAME" sts/midgard-timescaledb
    ;;

  *)
    kubectl delete -n "$NAME" "deploy/$SERVICE"
    ;;
esac

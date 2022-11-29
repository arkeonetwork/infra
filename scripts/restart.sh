#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short
get_node_service

kubectl delete -n "$NAME" pod -l app.kubernetes.io/name="$SERVICE"

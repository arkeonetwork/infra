#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Pausing node global halt from a Arkeo Node named $boldyellow$NAME$reset"
confirm

kubectl exec -it -n "$NAME" -c arkeo deploy/arkeo -- /kube-scripts/pause.sh
sleep 5
echo THORChain paused

display_status

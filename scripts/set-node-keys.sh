#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Setting Arkeo Node keys"
kubectl exec -it -n "$NAME" -c arkeo deploy/arkeo -- /kube-scripts/set-node-keys.sh
sleep 5
echo Arkeo Node Keys updated

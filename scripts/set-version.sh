#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Setting Arkeo Node version"
kubectl exec -it -n "$NAME" -c arkeo deploy/arkeo -- /kube-scripts/retry.sh /kube-scripts/set-version.sh
sleep 5
echo Arkeo Node version updated

display_status

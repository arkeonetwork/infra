#!/usr/bin/env bash

set -e

source ./scripts/core.sh

get_node_info_short

echo "=> Setting Arkeo Node IP address"
kubectl exec -it -n "$NAME" deploy/arkeo -- /kube-scripts/set-ip-address.sh "$(kubectl -n "$NAME" get configmap gateway-external-ip -o jsonpath="{.data.externalIP}")"
sleep 5
echo Arkeo Node IP address updated

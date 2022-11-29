#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short
get_node_address

echo "=> Banning node address $boldyellow$NODE_ADDRESS$reset. Banning a node cost 0.1% of minimum bond."
echo
confirm

kubectl exec -it -n "$NAME" -c arkeo deploy/arkeo -- /kube-scripts/ban.sh "$NODE_ADDRESS"

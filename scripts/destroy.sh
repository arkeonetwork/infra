#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

display_status

echo -e "=> Destroying a $boldgreen$TYPE$reset Arkeo Node on $boldgreen$NET$reset named $boldgreen$NAME$reset"
echo
echo
warn "!!! Make sure your got your BOND back before destroying your Arkeo Node !!!"
confirm
echo "=> Deleting Arkeo Node"
helm delete "$NAME" -n "$NAME"
kubectl delete namespace "$NAME"

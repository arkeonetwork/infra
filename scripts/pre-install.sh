#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info

if node_exists; then
  warn "Found an existing Arkeo Node, make sure this is the node you want to update"
  echo
fi

echo -e "=> Deploying a $boldgreen$TYPE$reset Arkeo Node on $boldgreen$NET$reset named $boldgreen$NAME$reset"
confirm

create_namespace
if [ "$TYPE" != "daemons" ]; then
  create_password
  create_mnemonic
fi

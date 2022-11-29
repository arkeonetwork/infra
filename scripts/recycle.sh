#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

if [ "$TYPE" != "validator" ]; then
  die "Only validators should be recycled"
fi

display_status

echo -e "=> Recycling a $boldgreen$TYPE$reset Arkeo Node on $boldgreen$NET$reset named $boldgreen$NAME$reset"
echo
echo
warn "!!! Make sure your got your BOND back before recycling your Arkeo Node !!!"
confirm

# delete gateway resources
echo "=> Recycling Arkeo Node - deleting gateway resources..."
kubectl -n "$NAME" delete deployment gateway
kubectl -n "$NAME" delete service gateway
kubectl -n "$NAME" delete configmap gateway-external-ip

# delete arkeo resources
echo "=> Recycling Arkeo Node - deleting arkeo resources..."
kubectl -n "$NAME" delete deployment arkeo
kubectl -n "$NAME" delete pvc arkeo
kubectl -n "$NAME" delete configmap arkeo-external-ip
kubectl -n "$NAME" delete secret arkeo-password
kubectl -n "$NAME" delete secret arkeo-mnemonic

# delete sentinel resources
echo "=> Recycling Arkeo Node - deleting sentinel resources..."
kubectl -n "$NAME" delete deployment sentinel
kubectl -n "$NAME" delete pvc sentinel
kubectl -n "$NAME" delete configmap sentinel-external-ip

# recreate resources
echo "=> Recycling Arkeo Node - recreating deleted resources..."
NET=$NET TYPE=$TYPE NAME=$NAME ./scripts/install.sh

echo "=> Recycle complete."

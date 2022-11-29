#!/usr/bin/env bash

set -e

source ./scripts/core.sh

helm get all loki -n loki-system
echo -n "The above resources will be deleted "
confirm

echo "=> Deleting Loki Logs Management"
helm delete loki -n loki-system
kubectl delete namespace loki-system
echo

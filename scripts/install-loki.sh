#!/usr/bin/env bash

set -e

source ./scripts/core.sh

if helm -n loki-system status loki >/dev/null 2>&1; then
  helm diff -C 3 upgrade loki grafana/loki-stack --install -n loki-system -f ./loki/values.yaml
  confirm
fi

echo "=> Installing Loki Logs Management"
helm upgrade loki grafana/loki-stack --install -n loki-system --create-namespace --wait -f ./loki/values.yaml
echo Waiting for services to be ready...
kubectl wait --for=condition=Ready --all pods -n loki-system --timeout=5m
echo

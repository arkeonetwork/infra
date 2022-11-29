#!/usr/bin/env bash

set -e

source ./scripts/core.sh

helm get all prometheus -n prometheus-system
echo -n "The above resources will be deleted "
confirm

echo "=> Deleting Prometheus/Grafana Stack"
helm delete prometheus -n prometheus-system
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
kubectl delete namespace prometheus-system
echo

#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

echo "=> Debugging Arkeo Node in $boldgreen$NAME$reset"
confirm

IMAGE=$(kubectl -n "$NAME" get deploy/arkeo -o jsonpath='{$.spec.template.spec.containers[:1].image}')
SPEC="
{
  \"apiVersion\": \"v1\",
  \"spec\": {
    \"containers\": [
      {
        \"command\": [
          \"sh\"
        ],
        \"name\": \"debug-arkeo\",
        \"stdin\": true,
        \"tty\": true,
        \"image\": \"$IMAGE\",
        \"volumeMounts\": [{\"mountPath\": \"/root\", \"name\":\"data\"}]
      }
    ],
    \"volumes\": [{\"name\": \"data\", \"persistentVolumeClaim\": {\"claimName\": \"arkeo\"}}]
  }
}"

kubectl scale -n "$NAME" --replicas=0 deploy/arkeo --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=arkeo -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
kubectl run -n "$NAME" -it --rm debug-arkeo --restart=Never --image="$IMAGE" --overrides="$SPEC"
kubectl scale -n "$NAME" --replicas=1 deploy/arkeo --timeout=5m

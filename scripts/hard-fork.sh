#!/usr/bin/env bash

source ./scripts/core.sh

if [ -z "$HARDFORK_BLOCK_HEIGHT" ]; then
  warn "HARDFORK_BLOCK_HEIGHT must be set"
  exit 1
fi

if [ -z "$CHAIN_ID" ]; then
  warn "CHAIN_ID must be set"
  exit 1
fi

if [ -z "$NEW_GENESIS_TIME" ]; then
  warn "NEW_GENESIS_TIME must be set"
  exit 1
fi

get_node_info_short

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

echo "=> Hard forking Arkeo Node chain state at block height $boldyellow$HARDFORK_BLOCK_HEIGHT$reset from $boldgreen$NAME$reset"
confirm

if [ -z "$IMAGE" ]; then
  IMAGE=$(kubectl -n "$NAME" get deploy/arkeo -o jsonpath='{$.spec.template.spec.containers[:1].image}')
  echo "IMAGE was unset - using current Arkeo Node image for export: $IMAGE"
fi

SPEC="
{
  \"apiVersion\": \"v1\",
  \"spec\": {
    \"containers\": [
      {
        \"command\": [
          \"sh\",
          \"-C\",
          \"/scripts/hard-fork.sh\"
        ],
        \"env\": [
          {
            \"name\": \"HARDFORK_BLOCK_HEIGHT\",
            \"value\":\"$HARDFORK_BLOCK_HEIGHT\"
          },
          {
            \"name\": \"CHAIN_ID\",
            \"value\":\"$CHAIN_ID\"
          },
          {
            \"name\": \"SIGNER_NAME\",
            \"value\":\"thorchain\"
          },
          {
            \"name\": \"SIGNER_PASSWD\",
            \"valueFrom\": {
              \"secretKeyRef\": {
                \"key\": \"password\",
                \"name\": \"arkeo-password\"
              }
            }
          },
          {
            \"name\": \"NEW_GENESIS_TIME\",
            \"value\":\"$NEW_GENESIS_TIME\"
          }
        ],
        \"name\": \"hard-fork\",
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
kubectl run -n "$NAME" -it --rm --quiet hard-fork --restart=Never --image="$IMAGE" --overrides="$SPEC"
# don't scale it back up after hard fork , need to run make install instead

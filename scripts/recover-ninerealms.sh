#!/usr/bin/env bash

set -e

source ./scripts/core.sh

echo "Nine Realms only provides mainnet snapshots. Continue?"
confirm
NET="mainnet"

get_node_info_short

if ! node_exists; then
  die "No existing Arkeo Node found, make sure this is the correct name"
fi

PREFIX="arkeo"
echo "=> Select recover type"
menu pruned pruned archive
if [ "$MENU_SELECTED" = "pruned" ]; then
  PREFIX="$PREFIX/pruned"
fi

HEIGHTS=$(
  curl -s "https://storage.googleapis.com/storage/v1/b/public-snapshots-ninerealms/o?delimiter=%2F&prefix=$PREFIX/" |
    jq -r ".prefixes | map(match(\"$PREFIX/([0-9]+)/\").captures[0].string) | map(tonumber) | sort | reverse | map(tostring) | join(\" \")"
)
LATEST_HEIGHT=$(echo "$HEIGHTS" | awk '{print $1}')
echo "=> Select block height to recover"
# shellcheck disable=SC2068
menu "$LATEST_HEIGHT" ${HEIGHTS[@]}
HEIGHT=$MENU_SELECTED

echo "=> Recovering height Nine Realms snapshot at height $HEIGHT in Arkeo Node in $boldgreen$NAME$reset"
confirm

# stop arkeo
echo "stopping arkeo..."
kubectl scale -n "$NAME" --replicas=0 deploy/arkeo --timeout=5m
kubectl wait --for=delete pods -l app.kubernetes.io/name=arkeo -n "$NAME" --timeout=5m >/dev/null 2>&1 || true

# create recover pod
echo "creating recover pod"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: recover-arkeo
  namespace: $NAME
spec:
  containers:
  - name: recover
    image: google/cloud-sdk@sha256:f94bacf262ad8f5e7173cea2db3d969c43b938a036e3c6294036c3d96261f2f4
    command:
      - tail
      - -f
      - /dev/null
    volumeMounts:
    - mountPath: /root
      name: data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: arkeo
EOF

# reset node state
echo "waiting for recover pod to be ready..."
kubectl wait --for=condition=ready pods/recover-arkeo -n "$NAME" --timeout=5m >/dev/null 2>&1

# note to user on resume
echo "${boldyellow}If the snapshot fails to sync resume by re-running the make target.$reset"

# unset gcloud account to access public bucket in GKE clusters with workload identity
kubectl exec -n "$NAME" -it recover-arkeo -- /bin/sh -c 'gcloud config set account none'

# recover nine realms snapshot
echo "pulling nine realms snapshot..."
kubectl exec -n "$NAME" -it recover-arkeo -- gsutil -m rsync -r -d \
  "gs://public-snapshots-ninerealms/$PREFIX/$HEIGHT/" /root/.arkeo/data/

echo "repeat sync pass in case of errors..."
kubectl exec -n "$NAME" -it recover-arkeo -- gsutil rsync -r -d \
  "gs://public-snapshots-ninerealms/$PREFIX/$HEIGHT/" /root/.arkeo/data/

echo "=> ${boldgreen}Proceeding to clean up recovery pod and restart arkeo$reset"
confirm

echo "cleaning up recover pod"
kubectl -n "$NAME" delete pod/recover-arkeo

# start arkeo
kubectl scale -n "$NAME" --replicas=1 deploy/arkeo --timeout=5m

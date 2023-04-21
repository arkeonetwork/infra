#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short
echo "=> Select a Arkeo Node service to reset"
menu arkeo bitcoin-daemon litecoin-daemon binance-daemon gaia-daemon ethereum-daemon-execution ethereum-daemon-beacon avalanche-daemon
SERVICE=$MENU_SELECTED

if node_exists; then
  echo
  warn "Found an existing Arkeo Node, make sure this is the node you want to update:"
  display_status
  echo
fi

echo "=> Resetting service $boldyellow$SERVICE$reset of a Arkeo Node named $boldyellow$NAME$reset"
echo
warn "Destructive command, be careful, your service data volume data will be wiped out and restarted to sync from scratch"
confirm

case $SERVICE in
  arkeo)
    kubectl scale -n "$NAME" --replicas=0 deploy/arkeo --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=arkeo -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it recover-thord --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "cd /root/.arkeo/data && rm -rf bak && mkdir -p bak && mv application.db blockstore.db cs.wal evidence.db state.db tx_index.db bak/"], "name": "recover-thord", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/root", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "arkeo"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/arkeo --timeout=5m
    ;;

  binance-daemon)
    kubectl scale -n "$NAME" --replicas=0 deploy/binance-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=binance-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-binance --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["rm", "-rf", "/bnb/config", "/bnb/data", "/bnb/.probe_last_height"], "name": "reset-binance", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/bnb", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "binance-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/binance-daemon --timeout=5m
    ;;

  gaia-daemon)
    kubectl scale -n "$NAME" --replicas=0 deploy/gaia-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=gaia-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-gaia --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /root/.gaia/data"], "name": "reset-gaia", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/root/.gaia", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "gaia-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/gaia-daemon --timeout=5m
    ;;

  ethereum-daemon-execution)
    kubectl scale -n "$NAME" --replicas=0 deploy/ethereum-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=ethereum-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-ethereum --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /root/.ethereum"], "name": "reset-ethereum", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/root", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "ethereum-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/ethereum-daemon --timeout=5m
    ;;

  ethereum-daemon-beacon)
    kubectl scale -n "$NAME" --replicas=0 deploy/ethereum-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=ethereum-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-ethereum --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /root/beacon"], "name": "reset-ethereum", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/root", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "ethereum-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/ethereum-daemon --timeout=5m
    ;;

  avalanche-daemon)
    kubectl scale -n "$NAME" --replicas=0 deploy/avalanche-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=avalanche-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-avalanche --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /root/.avalanchego/db"], "name": "reset-avalanche", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/root/.avalanchego", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "avalanche-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/avalanche-daemon --timeout=5m
    ;;

  bitcoin-daemon)
    kubectl scale -n "$NAME" --replicas=0 deploy/bitcoin-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=bitcoin-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-bitcoin --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /home/bitcoin/.bitcoin/*"], "name": "reset-bitcoin", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/home/bitcoin/.bitcoin", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "bitcoin-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/bitcoin-daemon --timeout=5m
    ;;

  litecoin-daemon)
    kubectl scale -n "$NAME" --replicas=0 deploy/litecoin-daemon --timeout=5m
    kubectl wait --for=delete pods -l app.kubernetes.io/name=litecoin-daemon -n "$NAME" --timeout=5m >/dev/null 2>&1 || true
    kubectl run -n "$NAME" -it reset-litecoin --rm --restart=Never --image=busybox --overrides='{"apiVersion": "v1", "spec": {"containers": [{"command": ["sh", "-c", "rm -rf /home/litecoin/.litecoin/*"], "name": "reset-litecoin", "stdin": true, "stdinOnce": true, "tty": true, "image": "busybox", "volumeMounts": [{"mountPath": "/home/litecoin/.litecoin", "name":"data"}]}], "volumes": [{"name": "data", "persistentVolumeClaim": {"claimName": "litecoin-daemon"}}]}}'
    kubectl scale -n "$NAME" --replicas=1 deploy/litecoin-daemon --timeout=5m
    ;;
esac

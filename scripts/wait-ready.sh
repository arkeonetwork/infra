#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

kubectl wait --for=condition=Ready --all pods -n "$NAME" --timeout=5m

#!/usr/bin/env bash

source ./scripts/core.sh

get_node_info_short

watch -n 1 kubectl -n "$NAME" get pods

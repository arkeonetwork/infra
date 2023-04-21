#!/bin/bash
set -eo pipefail

EXTRA_ARGS=""
if [ "$NET" = "mocknet" ]; then
  EXTRA_ARGS="-regtest"
elif [ "$NET" = "testnet" ]; then
  EXTRA_ARGS="-testnet"
fi

bitcoin-cli -rpcuser=infra \
            -rpcpassword=password \
            $EXTRA_ARGS ping

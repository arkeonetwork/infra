#!/bin/bash

set -ex

BNET=${BNET:-mainnet}
EXE="ulimit -n 65535 && /release/linux/bnbchaind start --home ${BNCHOME}"

# initialize config
if [ ! -d "${BNCHOME}/config/" ]; then
  cp -r "/release/${BNET}" "${BNCHOME}/config/"
fi
chown -R bnbchaind:bnbchaind "${BNCHOME}/config/"

# turn on console logging
sed -i 's/logToConsole = false/logToConsole = true/g' "${BNCHOME}/config/app.toml"

# enable telemetry
sed -i "s/prometheus = false/prometheus = true/g" "${BNCHOME}/config/config.toml"
sed -i -e "s/prometheus_listen_addr = \":26660\"/prometheus_listen_addr = \":28660\"/g" "${BNCHOME}/config/config.toml"

# reduce log noise
sed -i "s/consensus:info/consensus:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/dexkeeper:info/dexkeeper:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/dex:info/dex:error/g" "${BNCHOME}/config/config.toml"
sed -i "s/state:info/state:error/g" "${BNCHOME}/config/config.toml"

# fix testnet seed
if [ "${BNET}" == "testnet" ]; then
  sed -i -e "s/seeds =.*/seeds = \"9612b570bffebecca4776cb4512d08e252119005@3.114.127.147:27146,8c379d4d3b9995c712665dc9a9414dbde5b30483@3.113.118.255:27146,7156d461742e2a1e569fd68426009c4194830c93@52.198.111.20:27146\"/g" "${BNCHOME}/config/config.toml"
fi

echo "Running $0 in $PWD"
su bnbchaind -c "$EXE"

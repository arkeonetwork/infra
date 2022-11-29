#!/bin/bash

# initialize config
if [[ ! -f "/root/.gaia/config/app.toml" ]]; then
	cp /etc/gaia/app.toml /root/.gaia/config/app.toml
fi

exec /gaiad start --log_format json --rpc.laddr tcp://0.0.0.0:26657 --x-crisis-skip-assert-invariants "$@"

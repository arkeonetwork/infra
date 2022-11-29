# Multi Validator Cluster

Some node operators may desire to run multiple validators within the same cluster, while sharing a single set of daemons among them to save resource cost. This can be performed via the following method. These instructions are relevant for mainnet at the time of writing, but please ensure that correct network and current set of daemons are used.

1. Install daemons into their own namespace

```bash
NAME=daemons TYPE=daemons NET=mainnet make install
```

2. On a separate branch, add the following to the values to `thornode-stack/chaosnet.yaml`

```yaml
# point bifrost at shared daemons
bifrost:
  binanceDaemon:
    mainnet: http://binance-daemon.daemons.svc.cluster.local:27147
  bitcoinDaemon:
    mainnet: bitcoin-daemon.daemons.svc.cluster.local:8332
  litecoinDaemon:
    mainnet: litecoin-daemon.daemons.svc.cluster.local:9332
  bitcoinCashDaemon:
    mainnet: bitcoin-cash-daemon.daemons.svc.cluster.local:8332
  dogecoinDaemon:
    mainnet: dogecoin-daemon.daemons.svc.cluster.local:22555
  ethereumDaemon:
    mainnet: http://ethereum-daemon.daemons.svc.cluster.local:8545
  gaiaDaemon:
    enabled: true
    mainnet:
      rpc: http://gaia-daemon.daemons.svc.cluster.local:26657
      grpc: gaia-daemon.daemons.svc.cluster.local:9090
      grpcTLS: false
  avaxDaemon:
    mainnet: http://avalanche-daemon.daemons.svc.cluster.local:9650/ext/bc/C/rpc

# disable all daemons in node namespace
binance-daemon:
  enabled: false

bitcoin-daemon:
  enabled: false

litecoin-daemon:
  enabled: false

bitcoin-cash-daemon:
  enabled: false

ethereum-daemon:
  enabled: false

dogecoin-daemon:
  enabled: false

gaia-daemon:
  enabled: false

avalanche-daemon:
  enabled: false
```

3. Install each of the validator nodes in their own namespaces

```yaml
NAME=thornode-1 TYPE=validator NET=mainnet make install
NAME=thornode-2 TYPE=validator NET=mainnet make install
```

4. On each release, install both the daemons and the validators separately from the appropriate branch

```
# from master branch
NAME=daemons TYPE=daemons NET=mainnet make install

# from your branch after merging master
NAME=thornode-1 TYPE=validator NET=mainnet make update
NAME=thornode-2 TYPE=validator NET=mainnet make update
```

# Thornode Snapshot Recovery and Storage Management

There are a number of ways to recover `thornode` from snapshot to sync quickly time and reclaim disk space, these options will be outlined below.

## 1. Recover Nine Realms StateSync Pruned Snapshot

Nine Realms provides bi-weekly (at the time of writing) pruned snapshots from an archive node. These snapshots are created from a node recovered from statesync - which Nine Realms provides as a convenience since the network-native statesync process requires memory that exceeds the capacity of most nodes.

```bash
make recover-ninerealms  # select pruned
```

### Managing Disk Utilization

Since Thornode disk utilization will increase over time, at some point the volume will reach capacity. Just as the current practice to reset Binance and Ethereum daemons, the above recover can simply be run on an existing node to avoid manual increases in the PVC size. Active nodes should churn out before this recover, and then churn back in after - alternatively the PVC size can be manually increased until a convenient time to perform the recover and reset utilization.

### Midgard on StateSync Fullnode

Since the history is truncated in these approaches, it's possible that the Midgard blockstore does not contain the blocks near the tip that have already been pruned from the snapshot. If Thornode reaches sync and Midgard is stuck unable to complete sync, perform the following to update the blockstore manifest with latest:

```bash
make update-trust-state
make install
make restart # select midgard
```

## 2. Recover Network Native StateSync Snapshot

Nine Realms runs statesync peers which are configured as the defaults in Thornode [here](https://gitlab.com/thorchain/thornode/-/blob/d2bd7c61635c606d10a3f7b8bdbacdd280794d04/config/default.yaml#L135) and both RPC servers used for verification [here](https://gitlab.com/thorchain/thornode/-/blob/d2bd7c61635c606d10a3f7b8bdbacdd280794d04/config/default.yaml#L177). These defaults are used when auto statesync is enabled, and we hope that over time other parties in the community will run public RPC nodes and StateSync peers to extend these defaults. These defaults are provide for mainnet only, and must be overwritten via the environment variables `THOR_AUTO_STATE_SYNC_PEERS` and `THOR_TENDERMINT_STATE_SYNC_RPC_SERVERS` respectively if used on a different network.

It's important to note that in order to recover via network statesync, at the time of writing this will require significant memory (at the time of writing `80Gi`), so your cluster must be configured with nodes of sufficient size. Assuming that prerequisite is in place, you can enable auto statesync by setting the following overrides in `thornode-stack/chaosnet.yaml`:

```yaml
thornode:
  statesync:
    auto: true
  resources:
    requests:
      memory: 80Gi
```

- See [Managing Disk Utilization](#managing-disk-utilization) section above.

- See [Midgard on StateSync Fullnode](#midgard-on-statesync-fullnode) section above if this is a fullnode.

### Hosting a StateSync Peer

If you would like to run a statesync peer to aid in the decentralization of the network, you can set the following in `thornode-stack/chaosnet.yaml`:

```yaml
thornode:
  statesync:
    snapshotInterval: <block-interval>
```

It is important to note that you may need to monitor the memory utilization of your node and periodically increase it to successfully create a snapshot - at the time of writing this process requires 32G. Additionally snapshots may take hours to fully create (at the time of writing Nine Realms observes about 6 hours), and during this time your node will periodically fall behind, as such this should not be enabled on nodes that are depended on by other services - they should be viewed as a contribution to the network decentralization.

Once you're running a statesync peer creating valid snapshots, submit a pull request to extend the default list linked above to include your node.

## 3. Recover Nine Realms Full Archive Snapshot

Nine Realms provides monthly (at the time of writing) full snapshots from an archive node. These snapshots contain the full block history and state for the current fork, and at the time of writing are 1.3Tb in size. This approach is only recommended if you require the entire chain history for your application.

If you require the full history for your application, check the current full chain size at https://dashboards.ninerealms.com/#thornode on the chart labeled "Thornode Archive Node Storage Usage" and set the disk size for your install to at least 150% of this size in by setting the following override in `thornode-stack/chaosnet.yaml`:

```yaml
thornode:
  persistence:
    size:
      mainnet: 1.5Ti # override with new size
```

After the install with the new size has been applied, recover the latest full archive snapshot:

```bash
make recover-ninerealms  # select archive
```

Since the disk utilization with this method is high, you will need to monitor the PVC utilization and periodically increase it.

# docker

Production and development container images for the OpenFiat ecosystem.

| Image | Dockerfile | Built from |
|---|---|---|
| `openfiat-node` | `node.Dockerfile` | `openfiat-core` (Rust, multi-stage) |
| `openfiat-web` | `web.Dockerfile` | any Next.js app in `openfiat-apps` / `openfiat-org` (build arg selects app) |

```bash
docker build -f node.Dockerfile -t openfiat-node:local ../../openfiat-core
docker compose -f docker-compose.dev.yml up
```

## Local devnet cluster (`docker-compose.dev.yml`)

Brings up a real, persistently-running 3-node cluster — `node0`
(bootstrap, also `NodeChainMode::RpcConnected` against Solana devnet),
`node1`/`node2` (followers, dialing `node0` on startup). Each node gets
its own named volume (`node0-data`/`node1-data`/`node2-data`) for real
RocksDB persistence across restarts, and its own wallet — a fresh
identity is generated and saved into that volume on first run.

RPC is reachable on the host at `localhost:7080` (node0), `:7081`
(node1), `:7082` (node2); gossip stays internal to the compose network.

`node0` defaults to Solana's free public devnet RPC
(`https://api.devnet.solana.com`). To use a faster/private endpoint
instead, put it in a `docker/.env` file (already `.gitignore`d — never
commit a real RPC URL/API key):

```
CLI_SOLANA_RPC_URLS=https://your-provider/?api-key=...
```

Verify replication once the cluster is up: submit a signed write (e.g.
`sendAdvertisementCreate`, via either SDK) to any one node's `/rpc` and
confirm `getAdvertisements` on another node's `/rpc` shows it within a
few seconds.

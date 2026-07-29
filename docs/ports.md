# Port allocation

Every port the project binds, in one table, so a new service can be given one
without guessing and two of them never collide on the same host.

## The table

| Port | Proto | Bound by | Default? | Notes |
|------|-------|----------|----------|-------|
| 4001 | UDP | Node gossip (libp2p QUIC) | `CLI_LISTEN_ADDR` | Must be reachable from the internet for a public node. |
| 4002 | UDP | Explorer indexer gossip | `INDEXER_LISTEN_ADDR` | The indexer joins gossip as its own libp2p peer, so it cannot share 4001 with a node on the same host. |
| 7080 | TCP | Node HTTP | `CLI_HTTP_ADDR` | JSON-RPC (`POST /rpc`), WebSocket (`GET /ws`), REST, `GET /health`, `GET /metrics` — all one port. |
| 7081–7089 | TCP | Reserved: extra nodes | — | Host mappings for a multi-node cluster. The dev cluster uses 7080/7081/7082 for node0/1/2. |
| 7090 | TCP | Explorer indexer HTTP | `INDEXER_HTTP_ADDR` | |
| 7091 | TCP | Explorer API HTTP | `PORT` | |
| 3000 | TCP | Explorer web (dev) | `-p` in `package.json` | Next.js dev servers; local development only. |
| 3001 | TCP | Merchant dashboard (dev) | `-p` in `package.json` | |

Anything not listed here is not bound by this project.

## Why 7080 and not 8080

8080 is one of the most contended ports on a typical server — reverse proxies,
application servers and other containers all reach for it — and a node that
fails to start because something else got there first is a poor introduction.
7080 is unclaimed by convention, and moving the node off 8080 also resolved a
latent collision with the explorer API, which used to default to 8080 as well.

## Rules for adding a service

1. Take the next free port in the 7090+ range for an HTTP service, and record
   it in the table above in the same commit.
2. Never default to a port another service in the table already uses, even if
   the two are "not normally run together" — someone will run them together.
3. Make it overridable by environment variable, and keep the default in exactly
   one place in code. Config files, compose files, Helm values, firewall rules
   and docs are all derived from that default and must agree with it.
4. libp2p services each need their own UDP port; they cannot share one.

## Where the defaults actually live

| Service | Source of truth |
|---------|-----------------|
| Node HTTP + gossip | `openfiat-core/crates/cli/src/main.rs` |
| Explorer indexer | `openfiat-apps/explorer/indexer/src/main.rs` |
| Explorer API | `openfiat-apps/explorer/api/src/server.ts` |
| Container ports | `openfiat-infra/docker/node.Dockerfile` |
| Dev cluster host mappings | `openfiat-infra/docker/docker-compose.dev.yml` |
| Kubernetes | `openfiat-infra/kubernetes/charts/openfiat/values.yaml` (templates read it from there) |
| Prometheus scrape target | `openfiat-infra/monitoring/prometheus.yml` |

`openfiat-apps` is no longer actively developed — see its own README — but its
ports are listed here because it still runs and still has to not collide.

# Getting started — openfiat-infra

## Run a single node in Docker

```bash
docker build -f docker/node.Dockerfile -t openfiat-node:local ../openfiat-core
docker run -p 4001:4001/udp -p 7080:7080/tcp openfiat-node:local
curl -s http://localhost:7080/health
```

## Run a local 3-node cluster

```bash
cd docker
docker compose -f docker-compose.dev.yml up
```

Brings up `node0` (bootstrap, `RpcConnected` against Solana devnet by
default), `node1`, and `node2` (followers). RPC/health/metrics are
reachable at `localhost:7080`/`:7081`/`:7082`. Full details, including how
to point `node0` at a private RPC endpoint, are in `docker/README.md`.

## Render the Helm chart locally

```bash
helm template kubernetes/charts/openfiat
```

No cluster required — this only renders the manifests so you can review
what `helm install` would apply. `helm lint kubernetes/charts/openfiat`
checks the chart itself; both run in this repo's CI.

## Bring up the monitoring stack

```bash
cd monitoring
docker compose up
```

Prometheus scrapes `openfiat-node`'s own `/metrics` (same HTTP port as
everything else — see `docs/architecture.md`); Grafana, Loki, Tempo, and
Alertmanager come up alongside it.

## Terraform modules

Each `terraform/modules/<provider>` currently defines variables and
outputs only — resource blocks are commented scaffolding until target
account/project details are supplied. `terraform init`/`validate` still
run cleanly per module; see `terraform/README.md`.

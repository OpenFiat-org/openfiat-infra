<div align="center">

# openfiat-infra

**Docker images, Kubernetes Helm charts, Terraform modules, and the monitoring stack for OpenFiat infrastructure.**

[![CI](https://github.com/OpenFiat-org/openfiat-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/OpenFiat-org/openfiat-infra/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Discussions](https://img.shields.io/github/discussions/OpenFiat-org/openfiat-infra)](https://github.com/orgs/OpenFiat-org/discussions)

[Website](https://openfiat.network) · [Docs](https://docs.openfiat.network) · [Specs](https://github.com/OpenFiat-org/openfiat-specs) · [Contributing](CONTRIBUTING.md)

</div>

---

## About

`openfiat-infra` packages deployment surface for one real binary,
`openfiat-node` (built in [openfiat-core](https://github.com/OpenFiat-org/openfiat-core)),
across every path from a laptop to a fleet: a Dockerfile, a real
persistent 3-node local cluster, a Helm chart, six cloud Terraform
modules, and the monitoring stack that watches all of them. It carries no
protocol logic of its own — see [`docs/architecture.md`](docs/architecture.md)
for how the pieces fit together, including the node's actual two-port
surface (UDP 4001 for gossip, TCP 7080 for everything else), which every
config file here is written against.

For the full protocol motivation and design, see the
[whitepaper](https://github.com/OpenFiat-org/openfiat-specs) and the
[protocol specifications](https://github.com/OpenFiat-org/openfiat-specs/tree/main/Whitepaper/Specifications).

## Repository layout

```
.
├── docker/          # node.Dockerfile, web.Dockerfile, dev compose
├── kubernetes/
│   └── charts/openfiat/    # Helm chart: deployment, service, ingress, HPA, configmap, secret
├── terraform/
│   └── modules/{aws,azure,gcp,hetzner,digitalocean,ovh}/
├── monitoring/      # Prometheus, Grafana, Loki, Tempo, Alertmanager, OTel Collector
├── docs/
└── examples/
```


## Quick start

```bash
# Local dev container build
docker build -f docker/node.Dockerfile -t openfiat-node:local ../openfiat-core

# Monitoring stack
(cd monitoring && docker compose up)

# Helm chart (dry run)
helm template kubernetes/charts/openfiat
```


## Development

Docker, Helm, and Terraform are required for local iteration. CI runs
`hadolint` against both Dockerfiles, `helm lint`/`helm template` against
the chart, and `terraform validate` against every provider module on
every push — a green CI run is the real verification gate for changes
here, in addition to whatever you run locally.


## Testing

```bash
hadolint docker/node.Dockerfile docker/web.Dockerfile
helm lint kubernetes/charts/openfiat
(cd terraform/modules/aws && terraform init -backend=false && terraform validate)
```


## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) and
our [Code of Conduct](CODE_OF_CONDUCT.md) before opening a pull request.
Security issues should be reported per [SECURITY.md](SECURITY.md), not as
public issues.

See [ROADMAP.md](ROADMAP.md) for current priorities and
[CHANGELOG.md](CHANGELOG.md) for release history.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).

## Ports

Every port this project binds — nodes, explorer services and dev web apps —
is listed in [docs/ports.md](docs/ports.md), along with where each default
lives in code. Add a service's port there in the same commit that introduces
it.

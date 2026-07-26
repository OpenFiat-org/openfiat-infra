<div align="center">

# openfiat-infra

**Docker images, Kubernetes Helm charts, Terraform modules, and the monitoring stack for OpenFiat infrastructure.**

[![CI](https://github.com/OpenFiat-org/openfiat-infra/actions/workflows/ci.yml/badge.svg)](https://github.com/OpenFiat-org/openfiat-infra/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Discussions](https://img.shields.io/github/discussions/OpenFiat-org/openfiat-infra)](https://github.com/orgs/OpenFiat-org/discussions)

[Website](https://openfiat.org) · [Docs](https://docs.openfiat.org) · [Specs](https://github.com/OpenFiat-org/openfiat-specs) · [Contributing](CONTRIBUTING.md)

</div>

---

## About

`openfiat-infra` is part of the [OpenFiat](https://github.com/OpenFiat-org)
ecosystem — an open, decentralized peer-to-peer protocol for exchanging
stablecoins for local fiat currency. Solana secures asset settlement through
audited smart contracts; OpenFiat coordinates the peer-to-peer marketplace
layer (discovery, advertisements, reputation, governance, notifications, and
more) without centralized infrastructure.

This repository (Infrastructure) — docker images, kubernetes helm charts, terraform modules, and the monitoring stack for openfiat infrastructure.

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

Docker/Helm/Terraform binaries are required for full local iteration; none
were available in the environment that generated this scaffold, so syntax
was hand-verified (YAML/TOML parsing) rather than tool-verified. The CI
workflow (`hadolint`, `helm lint`, `terraform validate`) is the source of
truth — treat a green CI run as the real verification gate before relying on
any file here.


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

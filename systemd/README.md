# systemd units

Unit files for running OpenFiat components directly on a host, as an
alternative to the Docker and Kubernetes paths elsewhere in this
repository.

| Unit | What it runs |
|---|---|
| `openfiat-node.service` | `openfiat-node`, the one binary this repository packages. |

## The FX oracle is not here

There was a `openfiat-devnet-oracle` service and timer in this directory.
They ran an example that lived in `openfiat-core`, which has since become
a service of its own and moved to a separate repository, taking its unit
files with it — a publisher and the timer that drives it belong together,
and a unit here pointing at a binary built somewhere else was already
half a deployment.

Nothing about running an oracle is specific to that repository. A rate
provider registers itself with `sendProviderRegister` as a
`MarketData(FxOracle)` service and publishes signed records with
`sendOraclePublish`; both are on every node's public RPC and specified in
OFS-1500 and OFS-7000. Anyone can run one, and the network prefers that
they do — a single publisher is a single point of failure the median is
supposed to protect against.

What a publisher must do, whoever writes it: refuse to publish when it
cannot reach its sources, refuse when a source's own data has gone stale,
and say in its registered capabilities where its numbers came from. A
feed that fills gaps with its last known value prices every floating
advertisement off a number nobody measured, and looks healthy doing it.

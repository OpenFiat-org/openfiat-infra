# syntax=docker/dockerfile:1
# Multi-stage build for the openfiat-node reference implementation.
# Build context must be the openfiat-core repository root.

FROM rust:1-slim-bookworm AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev clang cmake build-essential \
    && rm -rf /var/lib/apt/lists/*
COPY . .
RUN cargo build --release --bin openfiat-node

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --create-home --shell /usr/sbin/nologin openfiat \
    && mkdir -p /data && chown openfiat:openfiat /data
COPY --from=builder /build/target/release/openfiat-node /usr/local/bin/openfiat-node
USER openfiat
WORKDIR /data
# The real surface this binary actually exposes (crates/cli's own
# CLI_HTTP_ADDR/CLI_LISTEN_ADDR defaults) — not the Substrate-convention
# ports (30333/9944/9615) this line previously carried over from a
# different reference project, for a binary that was never real.
EXPOSE 8080/tcp 4001/udp
HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=6 \
    CMD curl -sf http://127.0.0.1:8080/health || exit 1
ENTRYPOINT ["/usr/local/bin/openfiat-node"]

# syntax=docker/dockerfile:1
# Multi-stage build for the openfiat-node reference implementation.
# Build context must be the openfiat-core repository root.

FROM rust:1-slim-bookworm AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev clang cmake \
    && rm -rf /var/lib/apt/lists/*
COPY . .
RUN cargo build --release --bin openfiat-node

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --create-home --shell /usr/sbin/nologin openfiat
COPY --from=builder /build/target/release/openfiat-node /usr/local/bin/openfiat-node
USER openfiat
EXPOSE 30333 9944 9615
ENTRYPOINT ["/usr/local/bin/openfiat-node"]

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

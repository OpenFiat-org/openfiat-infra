# syntax=docker/dockerfile:1
# Generic multi-stage build for any Next.js app in openfiat-apps / openfiat-org.
# Build with: docker build -f web.Dockerfile --build-arg APP_DIR=merchant ../../openfiat-apps

FROM node:20-slim AS base
RUN corepack enable

FROM base AS deps
ARG APP_DIR
WORKDIR /app
COPY pnpm-lock.yaml* package.json* ./
COPY ${APP_DIR}/package.json ./${APP_DIR}/package.json
RUN pnpm install --frozen-lockfile || pnpm install

FROM base AS build
ARG APP_DIR
WORKDIR /app
COPY --from=deps /app /app
COPY . .
RUN pnpm --filter "./${APP_DIR}" build

FROM base AS runtime
ARG APP_DIR
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /app/${APP_DIR}/.next ./.next
COPY --from=build /app/${APP_DIR}/public ./public
COPY --from=build /app/${APP_DIR}/package.json ./package.json
EXPOSE 3000
CMD ["pnpm", "start"]

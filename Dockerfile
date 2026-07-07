# syntax=docker/dockerfile:1.7

FROM node:24-alpine AS base
WORKDIR /app
ENV NPM_CONFIG_LOGLEVEL=silent

FROM base AS deps
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
    npm ci --no-audit --no-fund

FROM base AS production-deps
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
    npm ci --omit=dev --no-audit --no-fund

FROM deps AS build
COPY . .

FROM base AS development
ENV NODE_ENV=development
COPY --from=build --chown=node:node /app ./
USER node
EXPOSE 3000
CMD ["node", "--watch", "src/server.js"]

FROM base AS production
ENV NODE_ENV=production
COPY --from=production-deps --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/package*.json ./
COPY --from=build --chown=node:node /app/src ./src
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]

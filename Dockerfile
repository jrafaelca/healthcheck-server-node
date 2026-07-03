FROM node:24-alpine AS base
WORKDIR /app

FROM base AS deps
COPY package.json ./

FROM deps AS build
COPY src ./src

FROM base AS development
ENV NODE_ENV=development
COPY --from=build --chown=node:node /app/src ./src
COPY --chown=node:node package.json ./
USER node
CMD ["node", "--env-file-if-exists=.env", "src/server.js"]

FROM base AS production
ENV NODE_ENV=production
COPY --from=build --chown=node:node /app/src ./src
COPY --chown=node:node package.json ./
USER node
CMD ["node", "src/server.js"]

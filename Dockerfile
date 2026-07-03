FROM node:24-alpine AS base
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

FROM base AS deps
COPY package.json ./

FROM deps AS build
COPY src ./src

FROM base AS development
ENV NODE_ENV=development
COPY --from=build --chown=appuser:appgroup /app/src ./src
COPY --chown=appuser:appgroup package.json ./
USER appuser
CMD ["node", "--env-file-if-exists=.env", "src/server.js"]

FROM base AS production
ENV NODE_ENV=production
COPY --from=build --chown=appuser:appgroup /app/src ./src
COPY --chown=appuser:appgroup package.json ./
USER appuser
CMD ["node", "src/server.js"]

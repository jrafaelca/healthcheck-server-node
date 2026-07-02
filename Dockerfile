FROM node:24-alpine AS base
WORKDIR /app

FROM base AS runtime
ENV NODE_ENV=production
COPY package.json ./
COPY src ./src
CMD ["node", "src/server.js"]

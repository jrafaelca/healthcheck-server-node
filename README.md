# healthcheck-server-node

Minimal Node 24 HTTP server for exposing a health endpoint.

## What it does

- `GET /health` returns `200` with JSON: `{ "status": "ok" }`
- any other route returns `404` with JSON: `{ "error": "not found" }`
- no external dependencies

## Requirements

- Node.js 24+
- Docker and Docker Compose, if you want to use the compose files

## Environment variables

- `HOST` default: `0.0.0.0`
- `PORT` default: `3000`

You can set them through your shell, Docker Compose, or any deployment environment.
`.env.example` is just a reference template.

## Run locally

```bash
npm start
```

## Run tests

```bash
npm test
```

## Local Docker

Start the app from source with a local build:

```bash
docker compose up --build
```

## Deploy with the published image

Use the image published in GHCR:

```bash
docker compose -f compose.deploy.yml up -d
```

## Image

The published image is:

```text
ghcr.io/jrafaelca/healthcheck-server-node:latest
```

## Structure

- `src/server.js`: HTTP server
- `test/server.test.js`: native tests with `node:test`
- `compose.yml`: compose for local development
- `compose.deploy.yml`: compose for deployment using GHCR
- `.github/workflows/publish.yml`: CI/CD that tests and publishes the image

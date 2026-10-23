# Installation and startup

[← Documentation](README.md) · [Next: Configuration →](configuration.md)

Run all commands from `frameflow/`, which contains `package.json` and `compose.yaml`.

## Requirements

- Node.js `>=24.15.0 <25`.
- pnpm `10.34.5`, pinned in `packageManager`.
- Docker Engine/Desktop and Docker Compose v2 for container-based development.
- Python 3.13 for AI development; it is not required to run the Node applications.

```sh
node --version
pnpm --version
pnpm install --frozen-lockfile
```

If pnpm is missing, install the pinned version:

```sh
npm install --global pnpm@10.34.5
```

## Local development without Docker

Run each command in a separate terminal:

| Application | Command | URL |
| --- | --- | --- |
| Frontend | `pnpm dev` | `http://localhost:3000` |
| Identity | `pnpm dev:identity-service` | `http://localhost:3001/` |
| Document | `pnpm dev:document-service` | `http://localhost:3002/` |
| Workspace | `pnpm dev:workspace-service` | `http://localhost:3003/` |

The NestJS applications return `{"message":"Hello World!"}`. Storage services are not required for this check. Stop an application with `Ctrl+C` in its terminal.

This mode does not start Nginx on port 8080. Compose reads the root `.env` automatically, but the NestJS bootstrap does not load that file itself. Pass local settings through environment variables:

```sh
HTTP_HOST=127.0.0.1 HTTP_PORT=3013 pnpm dev:workspace-service
```

The relative API path `/v1` is intended for access through Nginx. Running the frontend and backend separately requires an appropriate proxy/CORS setup and API URL.

## Prepare the Compose environment

Keep an existing `.env` file. On a new machine, create it from the example:

```sh
cp -n .env.example .env
chmod 600 .env
```

Replace every `replace-with-*` password with your own value. See [Configuration](configuration.md) for details.

Validate the configuration without starting containers:

```sh
pnpm compose:check
```

## Run in containers

```sh
docker compose up --build -d
```

This starts Nginx, the frontend, three NestJS services, PostgreSQL, Redis, MinIO, and the one-shot `minio-init` service. AI is excluded by default. The first MinIO/mc build downloads source archives and Go dependencies and can take some time.

| URL | Expected response after startup |
| --- | --- |
| `http://localhost:8080` | Next.js frontend |
| `http://localhost:8080/healthz` | `nginx ready` |
| `http://localhost:8080/v1/identity-service` | JSON Hello World |
| `http://localhost:8080/v1/document-service` | JSON Hello World |
| `http://localhost:8080/v1/workspace-service` | JSON Hello World |
| `http://localhost:9000` | MinIO S3 endpoint, not an application page |
| `http://localhost:9001` | MinIO Console; use root credentials from `.env` |

Check a service after the environment is ready:

```sh
curl -i http://localhost:8080/v1/workspace-service
```

The base Compose configuration does not publish NestJS ports to the host. For watch mode and direct access to ports 3001–3003, use the development override:

```sh
docker compose -f compose.yaml -f compose.dev.yaml up --build -d
```

The frontend continues to use its compiled image. Stop locally running NestJS applications if they occupy the same ports.

## Other modes

Storage only:

```sh
docker compose up --build -d postgres redis minio minio-init
```

Include the AI container:

```sh
docker compose --profile scaffold up --build -d
```

AI runs `sleep infinity`; this mode does not expose a working HTTP/gRPC endpoint.

## Container status, logs, and shutdown

```sh
docker compose ps -a
docker compose logs --tail=100 identity-service document-service workspace-service
docker compose logs --tail=100 minio-init
docker compose down
```

Use the same configuration files when stopping the development environment:

```sh
docker compose -f compose.yaml -f compose.dev.yaml down
```

For the AI profile, use `docker compose --profile scaffold down`. A regular `down` preserves named volumes. The `-v` option removes storage data and is therefore excluded from the normal shutdown command.

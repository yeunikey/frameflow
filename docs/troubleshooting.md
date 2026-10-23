# Troubleshooting

[← Documentation](README.md) · [Back to Getting started →](getting-started.md)

## pnpm rejects the Node.js version

Check `node --version` and `pnpm --version`. `.npmrc` enables `engine-strict`; use Node.js `>=24.15.0 <25` and pnpm 10.34.5. After switching versions, run `pnpm install --frozen-lockfile`.

## A command or service cannot be found

Run commands from `frameflow/`, not its parent directory. Use service names ending in `-service`, such as `pnpm dev:workspace-service`. Reinstall from the lockfile after dependency changes.

## Compose reports a missing variable

Create `.env` from `.env.example`, supply the required passwords, and run `pnpm compose:check`. Do not share `.env` contents or full `compose config` output containing passwords.

## The Docker daemon is unavailable

Static Compose validation can run without a running daemon. Docker Engine/Desktop must be running for `up`, `build`, `ps`, and `logs`.

## A port is already in use

Check for another running application. Local NestJS applications and the development Compose override use ports 3001–3003. Stop one mode or select a different local `HTTP_PORT`. Set the Nginx host port in the root `.env`; published development ports are defined in `compose.dev.yaml`.

## localhost:8080 does not open after pnpm dev

`pnpm dev` starts only Next.js on port 3000. Nginx and `/v1/*-service` routes on port 8080 require Compose. A locally started Workspace service responds at `http://localhost:3003/`.

## Nginx returns 404 or 503

Use `/v1/identity-service`, `/v1/document-service`, or `/v1/workspace-service`. The older `/api/...` and `/v1/workspace` routes are not configured. Check that the requested path matches a controller route.

For a running environment:

```sh
docker compose ps -a
docker compose logs --tail=100 nginx workspace-service
```

503 `service_unavailable` means the backend cannot be reached by the proxy. Check the application's startup, health check, and logs. A successful `/healthz` response checks Nginx only.

## Document and Workspace are waiting for MinIO

Inspect `docker compose ps -a` and `docker compose logs --tail=100 minio minio-init`. Exit code 0 is the expected result for the one-shot `minio-init` container; dependent services can then start.

MinIO and mc builds download pinned source archives and Go dependencies. Resolve network, checksum, or build errors before initialization.

## A PostgreSQL password change in .env has no effect

Initialization only runs on a new volume. Existing databases and roles retain their settings. Update existing roles separately using administrative access; do not remove a data volume just to change a password.

## Changes are not visible in Docker

Base Compose runs compiled images; source changes require a rebuild. For NestJS watch mode, use both files: `docker compose -f compose.yaml -f compose.dev.yaml up --build -d`.

The development override mounts only `src`. Dependency changes, `tsconfig` changes, and frontend build variables require a rebuild even in development mode. The frontend runs from its compiled image in Compose.

## AI or gRPC endpoints do not respond

The AI container in the `scaffold` profile runs `sleep infinity` and does not listen on HTTP/gRPC ports. gRPC calls require a server transport and a Protocol Buffer contract; configuring port variables alone does not start a server.

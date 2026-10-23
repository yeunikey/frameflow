# Docker and infrastructure

[← Documentation](README.md) · [Startup commands →](getting-started.md)

## Compose and images

The [base Compose file](../compose.yaml) defines the frontend, Nginx, three NestJS applications, and storage. The [development override](../compose.dev.yaml) enables NestJS watch mode, mounts `src`, and publishes ports 3001–3003 on `127.0.0.1`.

The [shared NestJS Dockerfile](../services/Dockerfile) accepts `SERVICE_NAME` and includes dependencies, development, build, production-dependencies, and runtime stages. The runtime image contains production dependencies and runs `dist/main.js` as the `node` user.

The frontend has its [own Dockerfile](../apps/frontend/Dockerfile) with a Next.js standalone build. AI uses a [Python Dockerfile](../services/ai-service/Dockerfile), is enabled through the `scaffold` profile, and runs `sleep infinity`.

Nginx waits for the frontend and NestJS health checks. NestJS containers wait for PostgreSQL and Redis; Document and Workspace also wait for `minio-init` to complete.

## Nginx

Configuration: [nginx.conf](../infra/nginx/nginx.conf), [default.conf](../infra/nginx/conf.d/default.conf).

| Public path | Internal destination |
| --- | --- |
| `/` | `frontend:3000` |
| `/v1/identity-service` | `identity-service:3001/` |
| `/v1/document-service` | `document-service:3002/` |
| `/v1/workspace-service` | `workspace-service:3003/` |
| `/healthz` | Nginx response: `nginx ready` |

The `/v1/<service>` prefix is stripped. For example, `/v1/document-service/example?id=1` becomes `/example?id=1`. This illustrates URL rewriting rather than an available API method. Service roots accept requests with or without a trailing slash.

Unknown `/v1/*` routes return 404 `api_route_not_found`; backend connection failures return 503 `service_unavailable`. Internal DNS resolution refreshes container addresses after restarts. AI has no public route.

The request body limit is 25 MB. The local environment uses HTTP, and published ports bind to loopback. `/healthz` checks Nginx; the NestJS health check verifies a successful `/` response rather than database readiness or business operations.

## Networks

| Network | Connections |
| --- | --- |
| `edge` | Nginx and frontend |
| `api` | Nginx and three NestJS services; internal |
| `data` | NestJS, AI, PostgreSQL, Redis, MinIO, and initialization; internal |
| `egress` | AI outbound connectivity |

Nginx is not connected to the storage network. PostgreSQL and Redis do not publish host ports. Browser requests to the business API pass through Nginx.

## PostgreSQL

PostgreSQL 17 is configured with an [initialization script](../infra/postgres/init/01-service-databases.sh) that creates separate databases and owners for Identity, Document, and Workspace on first startup with an empty `postgres_data` volume.

Changing `.env` does not rerun initialization or change existing role passwords. Do not delete working volumes to apply routine configuration changes.

## Redis

Redis 8 uses password authentication and AOF persistence in `redis_data`.

## MinIO

MinIO server and `mc` are built from official source releases, with archive SHA-256 verification in the [Dockerfile](../infra/minio/Dockerfile). Release tags and base image digests are pinned. The initial build downloads sources and dependencies.

Once MinIO is ready, the [initialization script](../infra/minio/init.sh) creates private buckets:

| Default bucket | Purpose |
| --- | --- |
| `frameflow-documents` | Source documents |
| `frameflow-pages` | Pages and region images |
| `frameflow-exports` | Exported files |
| `frameflow-models` | Model weights |

Anonymous access is disabled. Applications use a separate user with a bucket-scoped [policy](../infra/minio/policy.json.template); root credentials are used for initialization and Console access. Initialization can be repeated with the same configuration.

## Persistent data

Named volumes: `postgres_data`, `redis_data`, and `minio_data`. A regular `docker compose down` preserves them.

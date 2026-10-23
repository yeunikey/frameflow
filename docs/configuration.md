# Environment configuration

[← Documentation](README.md) · [Next: Infrastructure →](infrastructure.md)

## Environment files

[`.env.example`](../.env.example) lists variables and safe sample values. Do not commit your local `.env`. Copy the example on a new machine and replace the passwords. Keep existing files that contain your own settings.

Compose reads the root `.env` for interpolation and passes only the variables declared in `environment` or `build.args` to applications. NestJS does not automatically load this file. When running locally, bootstrap reads `process.env` and defaults to `0.0.0.0` and the service's HTTP port.

## Main variables

| Group | Variables | Purpose |
| --- | --- | --- |
| Compose | `COMPOSE_PROJECT_NAME` | Environment name and resource prefix; defaults to `frameflow` |
| Public ports | `HTTP_PORT`, `MINIO_API_PORT`, `MINIO_CONSOLE_PORT` | Host ports: 8080, 9000, 9001 |
| PostgreSQL | `POSTGRES_USER`, `POSTGRES_DB`, `POSTGRES_PASSWORD` | Administrative account and control database |
| Service databases | `IDENTITY_DB*`, `DOCUMENT_DB*`, `WORKSPACE_DB*` | Database name, user, and password per service |
| Redis | `REDIS_PASSWORD` | Redis password |
| MinIO root | `MINIO_ROOT_USER`, `MINIO_ROOT_PASSWORD` | Server administration and initial setup |
| MinIO application | `MINIO_APP_USER`, `MINIO_APP_PASSWORD` | Separate application user with a restricted policy |
| S3 | `S3_REGION`, `S3_BUCKET_DOCUMENTS`, `S3_BUCKET_PAGES`, `S3_BUCKET_EXPORTS`, `S3_BUCKET_MODELS` | Region and private bucket names |
| Frontend | `NEXT_PUBLIC_API_BASE_URL` | Browser API base path, `/v1` |

`IDENTITY_DB*` stands for `IDENTITY_DB`, `IDENTITY_DB_USER`, and `IDENTITY_DB_PASSWORD`; the other database groups follow the same pattern.

## Internal addresses

Containers use Compose service names: `postgres:5432`, `redis:6379`, and `http://minio:9000`. The browser-facing S3 endpoint defaults to `http://localhost:9000`.

Compose derives `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`, `REDIS_HOST`, `S3_ENDPOINT`, and S3 credentials from `.env`. PostgreSQL and MinIO root credentials are not passed to business services.

`HTTP_PORT` in the root `.env` controls the Nginx host port. Inside NestJS containers, the variable is set separately to 3001, 3002, or 3003. Published development ports 3001–3003 are defined in `compose.dev.yaml`.

## Applying changes

- Recreate the relevant containers to apply Compose configuration changes.
- `NEXT_PUBLIC_API_BASE_URL` is passed at frontend build time. Rebuild the image after changing it.
- PostgreSQL initialization only runs on a new volume. Changing passwords in `.env` does not automatically update existing roles.
- Changing `COMPOSE_PROJECT_NAME` creates a different resource namespace; previous volumes remain in place.

Use `pnpm compose:check` for static validation. Do not share full `docker compose config` output: it may contain interpolated passwords. The `--quiet` option validates without printing them.

Validate the example without a local `.env`:

```sh
docker compose --env-file .env.example config --quiet
```

This validates the template only. Create your own `.env` and replace sample passwords before starting the environment.

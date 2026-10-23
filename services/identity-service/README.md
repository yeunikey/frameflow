# identity-service

[← Services](../README.md) · [Getting started](../../docs/getting-started.md) · [Configuration](../../docs/configuration.md)

A minimal NestJS application: `GET /` returns `{"message":"Hello World!"}`.

Run from the `frameflow/` root:

```sh
pnpm --filter @frameflow/identity-service start:dev
pnpm --filter @frameflow/identity-service build
pnpm --filter @frameflow/identity-service start:prod
```

Local URL: `http://localhost:3001/`. Environment settings: `HTTP_HOST` (default `0.0.0.0`) and `HTTP_PORT` (default `3001`). The shared `services/Dockerfile` selects the application through `SERVICE_NAME`.

## Structure

```text
src/
├── main.ts
├── app.module.ts
└── modules/
    └── identity/
        ├── identity.module.ts
        ├── application/
        │   └── identity.service.ts
        ├── domain/
        │   └── entities/
        ├── infrastructure/
        │   └── migrations/
        └── presentation/
            ├── identity.controller.ts
            └── dto/
```

`AppModule` imports `IdentityModule`; the controller delegates to the application service. See the [service structure guide](../README.md) for layer responsibilities.

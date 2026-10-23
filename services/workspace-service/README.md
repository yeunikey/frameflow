# workspace-service

[← Services](../README.md) · [Getting started](../../docs/getting-started.md) · [Configuration](../../docs/configuration.md)

A minimal NestJS application: `GET /` returns `{"message":"Hello World!"}`.

Run from the `frameflow/` root:

```sh
pnpm --filter @frameflow/workspace-service start:dev
pnpm --filter @frameflow/workspace-service build
pnpm --filter @frameflow/workspace-service start:prod
```

Local URL: `http://localhost:3003/`. Environment settings: `HTTP_HOST` (default `0.0.0.0`) and `HTTP_PORT` (default `3003`). The shared `services/Dockerfile` selects the application through `SERVICE_NAME`.

## Structure

```text
src/
├── main.ts
├── app.module.ts
└── modules/
    └── workspace/
        ├── workspace.module.ts
        ├── application/
        │   └── workspace.service.ts
        ├── domain/
        │   └── entities/
        ├── infrastructure/
        │   └── migrations/
        └── presentation/
            ├── workspace.controller.ts
            └── dto/
```

`AppModule` imports `WorkspaceModule`; the controller delegates to the application service. See the [service structure guide](../README.md) for layer responsibilities.

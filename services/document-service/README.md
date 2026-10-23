# document-service

[← Services](../README.md) · [Getting started](../../docs/getting-started.md) · [Configuration](../../docs/configuration.md)

A minimal NestJS application: `GET /` returns `{"message":"Hello World!"}`.

Run from the `frameflow/` root:

```sh
pnpm --filter @frameflow/document-service start:dev
pnpm --filter @frameflow/document-service build
pnpm --filter @frameflow/document-service start:prod
```

Local URL: `http://localhost:3002/`. Environment settings: `HTTP_HOST` (default `0.0.0.0`) and `HTTP_PORT` (default `3002`). The shared `services/Dockerfile` selects the application through `SERVICE_NAME`.

## Structure

```text
src/
├── main.ts
├── app.module.ts
└── modules/
    └── documents/
        ├── documents.module.ts
        ├── application/
        │   └── documents.service.ts
        ├── domain/
        │   └── entities/
        ├── infrastructure/
        │   └── migrations/
        └── presentation/
            ├── documents.controller.ts
            └── dto/
```

`AppModule` imports `DocumentsModule`; the controller delegates to the application service. See the [service structure guide](../README.md) for layer responsibilities.

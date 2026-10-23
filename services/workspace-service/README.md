# workspace-service

[← Сервисы](../README.md) · [Запуск](../../docs/getting-started.md) · [Окружение](../../docs/configuration.md)

Минимальное NestJS-приложение: `GET /` возвращает `{"message":"Hello World!"}`.

Из корня `frameflow/`:

```sh
pnpm --filter @frameflow/workspace-service start:dev
pnpm --filter @frameflow/workspace-service build
pnpm --filter @frameflow/workspace-service start:prod
```

Локальный адрес — `http://localhost:3003/`. Настройки: `HTTP_HOST` (по умолчанию `0.0.0.0`), `HTTP_PORT` (по умолчанию `3003`). Общий Dockerfile — `services/Dockerfile`, сборка выбирает сервис через `SERVICE_NAME`.

## Структура

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

`AppModule` подключает `WorkspaceModule`; контроллер вызывает application-сервис. Правила слоёв — [services/README.md](../README.md).

# document-service

[← Сервисы](../README.md) · [Запуск](../../docs/getting-started.md) · [Окружение](../../docs/configuration.md)

Минимальное NestJS-приложение: `GET /` возвращает `{"message":"Hello World!"}`.

Из корня `frameflow/`:

```sh
pnpm --filter @frameflow/document-service start:dev
pnpm --filter @frameflow/document-service build
pnpm --filter @frameflow/document-service start:prod
```

Локальный адрес — `http://localhost:3002/`. Настройки: `HTTP_HOST` (по умолчанию `0.0.0.0`), `HTTP_PORT` (по умолчанию `3002`). Общий Dockerfile — `services/Dockerfile`, сборка выбирает сервис через `SERVICE_NAME`.

## Структура

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

`AppModule` подключает `DocumentsModule`; контроллер вызывает application-сервис. Правила слоёв — [services/README.md](../README.md).

# identity-service

[← Сервисы](../README.md) · [Запуск](../../docs/getting-started.md) · [Окружение](../../docs/configuration.md)

Минимальное NestJS-приложение: `GET /` возвращает `{"message":"Hello World!"}`.

Из корня `frameflow/`:

```sh
pnpm --filter @frameflow/identity-service start:dev
pnpm --filter @frameflow/identity-service build
pnpm --filter @frameflow/identity-service start:prod
```

Локальный адрес — `http://localhost:3001/`. Настройки: `HTTP_HOST` (по умолчанию `0.0.0.0`), `HTTP_PORT` (по умолчанию `3001`). Общий Dockerfile — `services/Dockerfile`, сборка выбирает сервис через `SERVICE_NAME`.

## Структура

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

`AppModule` подключает `IdentityModule`; контроллер вызывает application-сервис. Правила слоёв — [services/README.md](../README.md).

# Структура сервисов

[← Документация](../docs/README.md) · [Запуск](../docs/getting-started.md) · [Архитектура](../docs/architecture.md)

Внутри каждого сервиса используется структура `src/modules/<name>/{application,domain,infrastructure,presentation}`. Каждый NestJS-сервис остаётся отдельным приложением в pnpm workspace.

| Сервис | Подключение | Корень |
| --- | --- | --- |
| [Identity](identity-service/README.md) | `IdentityModule` | `identity-service/src/modules/identity/` |
| [Document](document-service/README.md) | `DocumentsModule` | `document-service/src/modules/documents/` |
| [Workspace](workspace-service/README.md) | `WorkspaceModule` | `workspace-service/src/modules/workspace/` |
| [AI](ai-service/README.md) | Python / FastAPI | `ai-service/src/frameflow_ai/modules/processing/` |

В NestJS `main.ts` запускает приложение, `app.module.ts` подключает модули из `modules/`. Файл `<name>.module.ts` регистрирует контроллеры из `presentation/` и providers из `application/`.

- `presentation/` — HTTP/gRPC-контроллеры; `dto/` — входные и выходные DTO.
- `application/` — сценарии и прикладные сервисы, вызываемые контроллерами.
- `domain/` — сущности, типы и предметные правила; `entities/` — определения сущностей.
- `infrastructure/` — адаптеры БД, Redis, S3 и внешних сервисов; `migrations/` — будущие миграции.

Контроллер передаёт выполнение application-сервису. Адаптеры подключаются в модуле через DI. Общение между отдельными сервисами должно идти через согласованные контракты; импортировать внутренние модули соседнего сервиса не нужно. Новые функциональные модули размещаются в `src/modules/` с таким же набором слоёв.

Общий Dockerfile выбирает NestJS-приложение по `SERVICE_NAME`; dev override монтирует его `src`. AI использует Python/FastAPI.

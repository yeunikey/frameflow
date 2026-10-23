# Docker и инфраструктура

[← Документация](README.md) · [Команды запуска →](getting-started.md)

## Compose и образы

[Базовый Compose](../compose.yaml) содержит frontend, Nginx, три NestJS-приложения и хранилища. [Dev override](../compose.dev.yaml) переключает NestJS на watch, монтирует `src` и публикует порты 3001–3003 на `127.0.0.1`.

[Общий Dockerfile NestJS](../services/Dockerfile) использует `SERVICE_NAME` и стадии dependencies, development, build, production-dependencies и runtime. Конечный runtime запускает `dist/main.js` от пользователя `node` и содержит production-зависимости.

Frontend имеет [собственный Dockerfile](../apps/frontend/Dockerfile) и standalone-сборку Next.js. AI использует [Python Dockerfile](../services/ai-service/Dockerfile), включается профилем `scaffold` и выполняет `sleep infinity`.

Nginx ожидает готовности frontend и NestJS. NestJS-контейнеры ожидают PostgreSQL и Redis; Document и Workspace также ждут завершения `minio-init`.

## Nginx

Конфигурация: [nginx.conf](../infra/nginx/nginx.conf), [default.conf](../infra/nginx/conf.d/default.conf).

| Внешний путь | Внутренний адрес |
| --- | --- |
| `/` | `frontend:3000` |
| `/v1/identity-service` | `identity-service:3001/` |
| `/v1/document-service` | `document-service:3002/` |
| `/v1/workspace-service` | `workspace-service:3003/` |
| `/healthz` | Локальный ответ Nginx `nginx ready` |

Префикс `/v1/<service>` удаляется. Например, `/v1/document-service/example?id=1` станет `/example?id=1`. Это пример преобразования URL, а не описание API-метода. Корни сервисов работают с завершающим слешем и без него.

Неизвестный `/v1/*` возвращает 404 `api_route_not_found`; ошибка соединения с backend — 503 `service_unavailable`. Внутренняя DNS-резолюция позволяет заново находить контейнеры после их перезапуска. AI-маршрута нет.

Лимит тела запроса — 25 МБ. Локальное окружение использует HTTP. Порты хоста привязаны к loopback. `/healthz` проверяет Nginx; NestJS healthcheck проверяет только успешный HTTP-ответ `/`, а не доступность БД или бизнес-сценария.

## Сети

| Сеть | Подключения |
| --- | --- |
| `edge` | Nginx и frontend |
| `api` | Nginx и три NestJS-сервиса; internal |
| `data` | NestJS, AI, PostgreSQL, Redis, MinIO и init; internal |
| `egress` | AI; выход во внешнюю сеть |

Nginx не подключён к сети хранилищ. PostgreSQL и Redis не публикуют порты на хост. Браузер взаимодействует с бизнес-API через Nginx.

## PostgreSQL

Используется PostgreSQL 17. [Init-скрипт](../infra/postgres/init/01-service-databases.sh) создаёт отдельные БД и владельцев Identity, Document и Workspace при первом старте на пустом `postgres_data`.

Для существующего volume изменения `.env` не выполняют повторную инициализацию и не меняют пароли ролей. Не удаляйте рабочие volumes для обычного применения настроек.

## Redis

Redis 8 настроен с паролем и AOF в `redis_data`.

## MinIO

MinIO server и `mc` собираются из официальных source release с проверкой SHA-256 архивов в [Dockerfile](../infra/minio/Dockerfile). Release-теги и digest базовых образов закреплены. Первая сборка скачивает исходники и зависимости.

После готовности MinIO [init-скрипт](../infra/minio/init.sh) создаёт приватные бакеты:

| Бакет по умолчанию | Назначение |
| --- | --- |
| `frameflow-documents` | Исходные документы |
| `frameflow-pages` | Страницы и изображения областей |
| `frameflow-exports` | Результаты экспорта |
| `frameflow-models` | Будущие веса моделей |

Анонимный доступ выключен. Для приложений создаётся отдельный пользователь с [policy](../infra/minio/policy.json.template) на эти бакеты; root-учётные данные используются для инициализации и Console. Скрипт можно повторять с той же конфигурацией.

## Хранение данных

Named volumes: `postgres_data`, `redis_data`, `minio_data`. Обычный `docker compose down` их сохраняет.

# Конфигурация окружения

[← Документация](README.md) · [Далее: инфраструктура →](infrastructure.md)

## Файлы окружения

[`.env.example`](../.env.example) содержит имена переменных и безопасные примеры. Локальный `.env` не коммитится. На новой машине скопируйте пример и замените пароли. Не перезаписывайте существующий файл с собственными настройками.

Compose читает корневой `.env` для подстановок и передаёт приложениям только переменные, указанные в `environment` или `build.args`. Это не автоматическая загрузка `.env` самим NestJS. Локально bootstrap читает `process.env`, по умолчанию использует `0.0.0.0` и HTTP-порт своего сервиса.

## Основные переменные

| Группа | Переменные | Назначение |
| --- | --- | --- |
| Compose | `COMPOSE_PROJECT_NAME` | Имя окружения и префикс ресурсов; по умолчанию `frameflow` |
| Публичные порты | `HTTP_PORT`, `MINIO_API_PORT`, `MINIO_CONSOLE_PORT` | Порты хоста: 8080, 9000, 9001 |
| PostgreSQL | `POSTGRES_USER`, `POSTGRES_DB`, `POSTGRES_PASSWORD` | Административная учётная запись и управляющая БД |
| БД сервисов | `IDENTITY_DB*`, `DOCUMENT_DB*`, `WORKSPACE_DB*` | Имя БД, пользователь и пароль каждого сервиса |
| Redis | `REDIS_PASSWORD` | Пароль Redis |
| MinIO root | `MINIO_ROOT_USER`, `MINIO_ROOT_PASSWORD` | Управление сервером и первичная настройка |
| MinIO application | `MINIO_APP_USER`, `MINIO_APP_PASSWORD` | Отдельный пользователь приложений с ограниченной policy |
| S3 | `S3_REGION`, `S3_BUCKET_DOCUMENTS`, `S3_BUCKET_PAGES`, `S3_BUCKET_EXPORTS`, `S3_BUCKET_MODELS` | Регион и имена приватных бакетов |
| Frontend | `NEXT_PUBLIC_API_BASE_URL` | Базовый путь браузерного API, `/v1` |

Здесь `IDENTITY_DB*` обозначает `IDENTITY_DB`, `IDENTITY_DB_USER`, `IDENTITY_DB_PASSWORD`; остальные группы устроены так же.

## Внутренние адреса

В контейнерах используются имена Compose-сервисов: `postgres:5432`, `redis:6379`, `http://minio:9000`. Для браузера S3 endpoint по умолчанию — `http://localhost:9000`.

`PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`, `REDIS_HOST`, `S3_ENDPOINT` и ключи S3 собираются в Compose из настроек `.env`. Root-доступы PostgreSQL и MinIO не передаются бизнес-сервисам.

`HTTP_PORT` в корневом `.env` задаёт порт Nginx на хосте. Внутри каждого NestJS-контейнера переменная с тем же именем задаётся отдельно: 3001, 3002 или 3003. Порты dev override 3001–3003 фиксированы в `compose.dev.yaml`.

## Изменение настроек

- Изменение параметров Compose применяется при пересоздании соответствующего контейнера.
- `NEXT_PUBLIC_API_BASE_URL` передаётся при сборке frontend. После изменения нужна пересборка его образа.
- PostgreSQL init выполняется только для нового volume. Новые пароли в `.env` не изменяют существующие роли автоматически.
- Смена `COMPOSE_PROJECT_NAME` создаёт другое пространство имён ресурсов; прежние volumes остаются на месте.

Для статической проверки используйте `pnpm compose:check`. Не публикуйте вывод полного `docker compose config`: он может содержать подставленные пароли. Вариант `--quiet` проверяет конфигурацию без их печати.

Без локального `.env` можно проверить конфигурацию на безопасном примере:

```sh
docker compose --env-file .env.example config --quiet
```

Это только проверка шаблона. Для запуска создайте собственный `.env` и замените образцы паролей.

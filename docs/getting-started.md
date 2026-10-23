# Установка и запуск

[← Документация](README.md) · [Далее: конфигурация →](configuration.md)

Все команды ниже выполняются из `frameflow/`, где находятся `package.json` и `compose.yaml`.

## Требования

- Node.js `>=24.15.0 <25`.
- pnpm `10.34.5` — версия указана в `packageManager`.
- Для контейнерного окружения — Docker Engine/Desktop и Docker Compose v2.
- Python 3.13 понадобится при реализации AI; для запуска текущих Node-приложений он не требуется.

```sh
node --version
pnpm --version
pnpm install --frozen-lockfile
```

Если pnpm отсутствует, установите закреплённую версию:

```sh
npm install --global pnpm@10.34.5
```

## Локальная разработка без Docker

Каждую команду запускайте в отдельном терминале:

| Приложение | Команда | Адрес |
| --- | --- | --- |
| Frontend | `pnpm dev` | `http://localhost:3000` |
| Identity | `pnpm dev:identity-service` | `http://localhost:3001/` |
| Document | `pnpm dev:document-service` | `http://localhost:3002/` |
| Workspace | `pnpm dev:workspace-service` | `http://localhost:3003/` |

NestJS-приложения отвечают `{"message":"Hello World!"}`. Для проверки Hello World запуск хранилищ не требуется. Остановка — `Ctrl+C` в соответствующем терминале.

При таком запуске Nginx на порту 8080 отсутствует. `.env` в корне автоматически используется Compose, но NestJS bootstrap самостоятельно этот файл не загружает. Локальные значения можно передать прямо команде:

```sh
HTTP_HOST=127.0.0.1 HTTP_PORT=3013 pnpm dev:workspace-service
```

Относительный адрес API `/v1` используется при работе через Nginx. Для локального frontend с отдельным backend нужно настроить proxy/CORS и адрес API.

## Подготовка окружения Compose

Если `.env` уже существует, сохраните его. На новом рабочем месте создайте файл:

```sh
cp -n .env.example .env
chmod 600 .env
```

Замените пароли `replace-with-*` собственными значениями. Параметры описаны в [конфигурации](configuration.md).

Статическая проверка не запускает контейнеры:

```sh
pnpm compose:check
```

## Запуск в контейнерах

```sh
docker compose up --build -d
```

Будут запущены Nginx, frontend, три NestJS-сервиса, PostgreSQL, Redis, MinIO и одноразовый `minio-init`. AI по умолчанию исключён. Первая сборка MinIO/mc требует доступа к исходникам и Go-зависимостям и может занять заметное время.

| Адрес | Ожидаемый ответ после запуска |
| --- | --- |
| `http://localhost:8080` | Пустой Next.js frontend |
| `http://localhost:8080/healthz` | `nginx ready` |
| `http://localhost:8080/v1/identity-service` | JSON Hello World |
| `http://localhost:8080/v1/document-service` | JSON Hello World |
| `http://localhost:8080/v1/workspace-service` | JSON Hello World |
| `http://localhost:9000` | S3 endpoint MinIO; не страница приложения |
| `http://localhost:9001` | MinIO Console, root-данные из `.env` |

Проверка одного сервиса после готовности окружения:

```sh
curl -i http://localhost:8080/v1/workspace-service
```

В базовом Compose порты NestJS не публикуются на хост. Для watch-режима и прямого доступа к портам 3001–3003 используйте override:

```sh
docker compose -f compose.yaml -f compose.dev.yaml up --build -d
```

Frontend при этом остаётся в собранном режиме. Запущенные локально NestJS-приложения нужно остановить, если они занимают те же порты.

## Другие режимы

Только хранилища:

```sh
docker compose up --build -d postgres redis minio minio-init
```

Дополнительно AI-контейнер:

```sh
docker compose --profile scaffold up --build -d
```

AI выполняет `sleep infinity`; endpoint для запросов не появится.

## Состояние, логи и остановка

```sh
docker compose ps -a
docker compose logs --tail=100 identity-service document-service workspace-service
docker compose logs --tail=100 minio-init
docker compose down
```

Для окружения с override используйте тот же набор файлов:

```sh
docker compose -f compose.yaml -f compose.dev.yaml down
```

Для окружения с AI — `docker compose --profile scaffold down`. Обычный `down` сохраняет named volumes. Флаг `-v` удаляет данные хранилищ, поэтому в обычную команду остановки он не включён.

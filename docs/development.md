# Разработка и работа с Git

[← Документация](README.md) · [Далее: решение проблем →](troubleshooting.md)

## Команды

Все команды выполняются из корня `frameflow/`.

| Команда | Действие |
| --- | --- |
| `pnpm dev` | Только frontend в режиме разработки |
| `pnpm dev:identity-service` | Identity с watch |
| `pnpm dev:document-service` | Document с watch |
| `pnpm dev:workspace-service` | Workspace с watch |
| `pnpm build` | Сборка frontend и трёх NestJS-приложений |
| `pnpm typecheck` | Проверка TypeScript frontend и NestJS |
| `pnpm lint` | ESLint frontend |
| `pnpm compose:check` | Статическая проверка base, dev и scaffold-конфигураций |

Для одного сервиса:

```sh
pnpm --filter @frameflow/workspace-service build
pnpm --filter @frameflow/workspace-service typecheck
pnpm --filter @frameflow/workspace-service start:prod
```

`start:prod` требует предварительной сборки и запускает локальный `dist/main.js`. Остановка — `Ctrl+C`.

## Организация кода

Frontend находится в `apps/frontend/`, отдельные backend-приложения — в `services/*-service/`. Схема слоёв описана в [архитектуре](architecture.md) и [каталоге сервисов](../services/README.md).

Новый бизнес-модуль размещается в `src/modules/<name>/` своего сервиса и подключается в `AppModule`. Контроллеры находятся в `presentation`, сценарии — в `application`, правила и сущности — в `domain`, внешние адаптеры — в `infrastructure`. Пустые каталоги сохранены через `.gitkeep`.

`packages/contracts/proto/` предназначен для согласованных protobuf-контрактов.

Для новых Node-зависимостей используйте pnpm и коммитьте изменение `pnpm-lock.yaml`. Например:

```sh
pnpm --filter @frameflow/workspace-service add <package>
```

`<package>` — имя выбранной зависимости, а не готовая команда для копирования без замены. Docker dev-режим монтирует только `src`; после изменения зависимостей или конфигурации образ нужно пересобрать.

## Что хранить в Git

Коммитятся исходники, документация, Dockerfiles, Compose, `.env.example`, `pnpm-lock.yaml`, конфигурация и `.gitkeep`. [`.gitignore`](../.gitignore) исключает локальные `.env`, ключи, зависимости, сборки, кеши, логи и результаты тестов.

Данные приложения, локальные датасеты, модели, выгрузки и резервные копии в корневых `data/`, `datasets/`, `models/`, `uploads/`, `storage/`, `backups/`, `artifacts/`, `tmp/`, `temp/` также исключены. Рабочие fixtures для тестов можно хранить рядом с тестами, если они подходят для репозитория. Named volumes Docker находятся вне исходников.

Из VS Code разрешены общие `.vscode/settings.json` и `.vscode/extensions.json`. `next-env.d.ts` и `*.tsbuildinfo` генерируются инструментами и игнорируются.

`.gitignore` не удаляет уже отслеживаемые файлы из истории. Проверить правило в Git-репозитории:

```sh
git check-ignore -v .env
git status --short
```

## Задачи и изменения

Используйте ID YouTrack в ветке, коммите и PR: например, `feat/FF-18-region-editor` и `FF-18: add region editor`. Задачи уже существуют в [FrameFlow YouTrack](https://frameflow.youtrack.cloud/issues/FF); перед созданием новых проверяйте дубли.

В описании изменения указывайте результат и выполненные проверки. Отличайте созданные макеты, подготовленные конфигурации и проверенное в работе поведение. Обновляйте соответствующую страницу `docs/`, если меняются команды, пути или маршруты.

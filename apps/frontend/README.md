# Frontend

[← Документация](../../docs/README.md) · [Запуск](../../docs/getting-started.md) · [Архитектура](../../docs/architecture.md)

Официальный `create-next-app@16.4.2 --empty` с App Router, TypeScript, Tailwind и ESLint.

Команды из корня проекта:

```sh
pnpm dev
pnpm --filter @frameflow/frontend build
pnpm --filter @frameflow/frontend lint
pnpm --filter @frameflow/frontend typecheck
```

Зависимости интерфейса: Ant Design, Zustand, Zod, PDF.js и Xior. Маршруты и страницы находятся в `src/app` (App Router); остальные слои — `widgets`, `features`, `entities`, `shared`.

Dockerfile собирает standalone-вывод Next.js и запускает его непривилегированным пользователем. Описание инфраструктуры — на [отдельной странице](../../docs/infrastructure.md).

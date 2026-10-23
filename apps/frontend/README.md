# Frontend

[← Documentation](../../docs/README.md) · [Getting started](../../docs/getting-started.md) · [Architecture](../../docs/architecture.md)

Official `create-next-app@16.4.2 --empty` setup with App Router, TypeScript, Tailwind, and ESLint.

Run commands from the project root:

```sh
pnpm dev
pnpm --filter @frameflow/frontend build
pnpm --filter @frameflow/frontend lint
pnpm --filter @frameflow/frontend typecheck
```

UI dependencies include Ant Design, Zustand, Zod, PDF.js, and Xior. Routes and pages live in `src/app` (App Router); the remaining layers are `widgets`, `features`, `entities`, and `shared`.

The Dockerfile builds Next.js standalone output and runs it as a non-root user. See [Infrastructure](../../docs/infrastructure.md) for details.

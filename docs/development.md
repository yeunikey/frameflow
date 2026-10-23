# Development and Git conventions

[← Documentation](README.md) · [Next: Troubleshooting →](troubleshooting.md)

## Commands

Run commands from the `frameflow/` root.

| Command | Action |
| --- | --- |
| `pnpm dev` | Frontend development server only |
| `pnpm dev:identity-service` | Identity with watch mode |
| `pnpm dev:document-service` | Document with watch mode |
| `pnpm dev:workspace-service` | Workspace with watch mode |
| `pnpm build` | Build the frontend and all three NestJS applications |
| `pnpm typecheck` | Check frontend and NestJS TypeScript |
| `pnpm lint` | Run frontend ESLint |
| `pnpm compose:check` | Validate base, development, and scaffold configurations |

For an individual service:

```sh
pnpm --filter @frameflow/workspace-service build
pnpm --filter @frameflow/workspace-service typecheck
pnpm --filter @frameflow/workspace-service start:prod
```

`start:prod` requires a build and runs the local `dist/main.js`. Stop it with `Ctrl+C`.

## Code organization

The frontend lives in `apps/frontend/`; backend applications live in `services/*-service/`. See [Architecture](architecture.md) and the [service directory](../services/README.md) for layer boundaries.

Add business modules under their service's `src/modules/<name>/` and import them in `AppModule`. Controllers belong in `presentation`, use cases in `application`, rules and entities in `domain`, and external adapters in `infrastructure`. `.gitkeep` preserves empty directories.

`packages/contracts/proto/` is reserved for agreed Protocol Buffer contracts.

Use pnpm for Node dependencies and commit changes to `pnpm-lock.yaml`. For example:

```sh
pnpm --filter @frameflow/workspace-service add <package>
```

Replace `<package>` with the selected dependency name. Docker development mode mounts only `src`; rebuild images after changing dependencies or configuration.

## What belongs in Git

Commit source code, documentation, Dockerfiles, Compose files, `.env.example`, `pnpm-lock.yaml`, configuration, and `.gitkeep` files. [`.gitignore`](../.gitignore) excludes local environment files, keys, dependencies, builds, caches, logs, and test output.

Root directories `data/`, `datasets/`, `models/`, `uploads/`, `storage/`, `backups/`, `artifacts/`, `tmp/`, and `temp/` are excluded for local application data, datasets, model weights, exports, and backups. Suitable test fixtures can live beside tests. Docker named volumes are stored outside the source tree.

Shared VS Code files `.vscode/settings.json` and `.vscode/extensions.json` are allowed. `next-env.d.ts` and `*.tsbuildinfo` are generated and ignored.

`.gitignore` does not remove files already tracked in Git history. Inspect rules with:

```sh
git check-ignore -v .env
git status --short
```

## Issues and changes

Use YouTrack IDs in branch names, commits, and PRs, for example `feat/FF-18-region-editor` and `FF-18: add region editor`. Check existing [FrameFlow issues](https://frameflow.youtrack.cloud/issues/FF) before creating new ones.

Describe the outcome and validation in change descriptions. Distinguish designs, configuration, and behavior verified at runtime. Update the relevant `docs/` page whenever commands, paths, or routes change.

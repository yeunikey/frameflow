# Service structure

[← Documentation](../docs/README.md) · [Getting started](../docs/getting-started.md) · [Architecture](../docs/architecture.md)

Services use `src/modules/<name>/{application,domain,infrastructure,presentation}`. Each NestJS service is a separate application in the pnpm workspace.

| Service | Module | Root |
| --- | --- | --- |
| [Identity](identity-service/README.md) | `IdentityModule` | `identity-service/src/modules/identity/` |
| [Document](document-service/README.md) | `DocumentsModule` | `document-service/src/modules/documents/` |
| [Workspace](workspace-service/README.md) | `WorkspaceModule` | `workspace-service/src/modules/workspace/` |
| [AI](ai-service/README.md) | Python / FastAPI | `ai-service/src/frameflow_ai/modules/processing/` |

In NestJS, `main.ts` starts the application and `app.module.ts` imports modules from `modules/`. Each `<name>.module.ts` registers controllers from `presentation/` and providers from `application/`.

- `presentation/`: HTTP/gRPC controllers; `dto/` contains request and response DTOs.
- `application/`: use cases and application services invoked by controllers.
- `domain/`: entities, types, and business rules; `entities/` contains entity definitions.
- `infrastructure/`: database, Redis, S3, and external service adapters; `migrations/` contains database migrations.

Controllers delegate to application services. Adapters are connected through dependency injection in the module. Services communicate through agreed contracts rather than importing each other's internals. Add new functional modules under `src/modules/` using the same layers.

The shared Dockerfile selects a NestJS application through `SERVICE_NAME`; the development override mounts its `src` directory. AI uses Python/FastAPI.

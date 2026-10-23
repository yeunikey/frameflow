# AI Service

[← Services](../README.md) · [Getting started](../../docs/getting-started.md) · [Configuration](../../docs/configuration.md)

Service stack: Python 3.13 / FastAPI / grpcio. The `scaffold` profile runs this container with `sleep infinity`; Compose ports are reserved but not listened on.

`requirements.txt` pins direct dependencies; it is not a complete lockfile for transitive dependencies.

The processing module follows the same layer structure as the NestJS services: `src/frameflow_ai/modules/processing/{application,domain,infrastructure,presentation}`.

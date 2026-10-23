# FrameFlow

A document processing platform for extracting data from PDFs and images into configurable, linked tables. Users select document regions, define the fields they need, review extracted values, and confirm the results before exporting them.

## Project idea

FrameFlow helps accountants, managers, and administrative staff transfer information from applications, invoices, and other documents into business tables. The source document does not need to contain a table: names, individual identification numbers (IINs), addresses, and bank details can appear in ordinary paragraphs.

The workspace places the document on the left and output tables on the right. Each column is linked to a source region, and each extracted value should retain its provenance. Users resolve errors and ambiguous matches, link records such as Customer → Invoice → Transaction, and export confirmed data.

Core extraction is planned around a self-hosted OCR/NER pipeline. OpenAI is intended for summaries and natural-language answers. Read more about the [project idea and MVP scope](docs/project.md).

## Documentation

[Full documentation index](docs/README.md).

| Page | Contents |
| --- | --- |
| [Project and MVP](docs/project.md) | Users, workflow, and scope |
| [Getting started](docs/getting-started.md) | Installation, local development, Docker, and endpoints |
| [Architecture](docs/architecture.md) | Services, layers, frontend, and component boundaries |
| [Configuration](docs/configuration.md) | Environment variables, ports, database, and S3 settings |
| [Infrastructure](docs/infrastructure.md) | Compose, Nginx, PostgreSQL, Redis, and MinIO |
| [Development](docs/development.md) | Commands, code organization, and Git conventions |
| [Troubleshooting](docs/troubleshooting.md) | Startup, routing, and configuration issues |
| [Services](services/README.md) | Backend modules and internal structure |

Run all commands from the `frameflow/` root. Use Node.js 24.15+ within the 24.x release line and pnpm 10.34.5:

```sh
pnpm install --frozen-lockfile
pnpm dev
```

This starts only the frontend at `http://localhost:3000`. See [Getting started](docs/getting-started.md) for the complete setup.

## Links

- [FrameFlow designs in Figma](https://www.figma.com/design/VsAVVvfZj0pTlVEPEOMa4D/FrameFlow?node-id=0-1)
- [FrameFlow issues in YouTrack](https://frameflow.youtrack.cloud/issues/FF)
- [Sprint 1: Documentation, Design, and Backend](https://frameflow.youtrack.cloud/agiles/204-1/218-2)

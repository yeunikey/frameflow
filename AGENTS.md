# FrameFlow

Это корень программного проекта. Команды pnpm и Docker Compose выполняются отсюда.

Последнее решение пользователя: отдельного API Gateway/BFF нет. Nginx направляет HTTP напрямую в Identity, Document и Workspace; внутренние вызовы остаются gRPC. Три NestJS-приложения отвечают на GET / JSON {"message":"Hello World!"}; gRPC-серверы пока не реализованы.

Перед работой прочитать `../PROJECT_IDEA.md`, `../TECH_STACK.md` и родительский `../AGENTS.md`. Исследовательские документы и дизайн остаются в родительском каталоге.

По последнему запросу пользователя Identity, Document и Workspace содержат минимальный NestJS bootstrap, AppModule, контроллеры и application-сервисы с Hello World. Frontend — прежний empty-шаблон Next.js; AI — пустой Python/FastAPI scaffold. Бизнес-логику без отдельного задания не добавлять. Общий Dockerfile — services/Dockerfile, стандартный Compose запускает NestJS runtime, compose.dev.yaml включает watch. За образец структуры взят /Users/yeunikey/projects/concierge-app; этот проект не изменялся.

Docker, контейнеры, сборку и pull не запускать без нового указания пользователя. `docker compose config --quiet` допускается для статической проверки конфигурации без запуска Docker-движка.

Последняя структура сервисов восстановлена по запросу пользователя: src/modules/<name>/{application,domain,infrastructure,presentation} и <name>.module.ts. AppModule подключает IdentityModule/DocumentsModule/WorkspaceModule. AI содержит пустые Python-слои src/frameflow_ai/modules/processing/{application,domain,infrastructure,presentation}. Схема — services/README.md; бизнес-логику, ORM и очередь не добавляли.

Внешние HTTP-маршруты по последнему запросу: localhost:8080/v1/identity-service, /v1/document-service, /v1/workspace-service. Имена соответствуют Compose-сервисам. Nginx удаляет /v1/<service> перед проксированием и сохраняет остаток пути/query. NEXT_PUBLIC_API_BASE_URL=/v1. AI пока не имеет работающего HTTP-приложения и публичного маршрута.

По последнему запросу все имена сервисов имеют суффикс -service: identity-service, document-service, workspace-service, ai-service. Папки services, pnpm-пакеты, Compose/DNS, Docker build args и публичные /v1/<service> маршруты согласованы. Имена предметных модулей identity/documents/workspace и Python-пакет frameflow_ai не меняются.

Документация проекта разделена: README.md содержит идею и навигацию; docs/README.md — оглавление, docs/project.md — MVP, getting-started.md — запуск, architecture.md — структура, configuration.md — окружение, infrastructure.md — Docker и хранилища, development.md — команды и Git, troubleshooting.md — диагностика. При изменении команд или конфигурации обновлять соответствующую страницу. Все ссылки внутри проектной документации работают без родительских отчётов. Git инициализирован в корне frameflow/, основная ветка main, автор коммитов Yerassyl <erasylunerbekxd@gmail.com>; .gitignore исключает локальные секреты, зависимости, сборки, кеши, runtime-данные и модели, сохраняя .env.example, pnpm-lock.yaml и .gitkeep.

Пользователь попросил не описывать текущее состояние в README и публичной документации. Не добавлять туда отчёты о прогрессе, списки готового/неготового и историю проверок. Сохранять точные инструкции запуска и фактическое поведение конфигурации; планы продукта не выдавать за реализованные функции. Технический контекст и результаты проверок хранить в AGENTS.md и проектных записях.

По указанию пользователя каталог apps/frontend/src/views удалён. Страницы и маршруты frontend находятся в src/app (Next.js App Router), остальные слои — widgets, features, entities, shared. Каталог views не восстанавливать без нового указания.

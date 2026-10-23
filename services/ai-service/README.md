# AI Service

[← Сервисы](../README.md) · [Запуск](../../docs/getting-started.md) · [Окружение](../../docs/configuration.md)

Стек сервиса: Python 3.13 / FastAPI / grpcio. Контейнер профиля `scaffold` ожидает с `sleep infinity`; порты в Compose зарезервированы, но не прослушиваются.

`requirements.txt` фиксирует прямые зависимости; это не полный lock-файл транзитивных зависимостей.

Слои модуля обработки: `src/frameflow_ai/modules/processing/{application,domain,infrastructure,presentation}` по той же схеме, что и в NestJS-сервисах.

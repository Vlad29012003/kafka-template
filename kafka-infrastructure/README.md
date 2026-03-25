# kafka-infrastructure

Инфраструктурный шаблон для локального запуска Kafka и Schema Registry (Docker Compose) и деплоя на сервер (Docker Swarm stack).

## Быстрый старт (локально)

1) Скопируйте переменные окружения:

```bash
cp env.example .env
```

2) Поднимите сервисы:

```bash
cd docker
docker compose --env-file ../.env up -d
```

3) Проверка здоровья:

```bash
../scripts/utils/health-check.sh
```

4) Создание топиков (пример):

```bash
../scripts/topics/create-topics.sh
```

## Структура

- `docker/`: compose/stack манифесты; опционально `docker/kafka-ui/` (после подъёма основного compose)
- `configs/`: справочные конфиги (в рантайме используются переменные env в compose)
- `schemas/`: примеры JSON/Avro схем
- `scripts/`: установка/деплой/топики/утилиты
- `docs/`: документация (установка, деплой, архитектура, troubleshooting)
- `monitoring/`: заготовка Prometheus/Grafana (сервисы в compose не подключены)
- `.gitlab-ci.yml`: в корне репозитория — валидация compose и ручной деплой Swarm

## Kafka UI (опционально)

После `docker compose up` основного стека (сеть `kafka-infra`):

```bash
cd docker/kafka-ui
docker compose --env-file ../../.env up -d
```

Пароль админа: переменная `KAFKA_UI_ADMIN_PASSWORD` в `.env` (по умолчанию в compose — `changeme`).

## Полезные адреса (по умолчанию)

- Kafka: `localhost:9092`
- Schema Registry: `http://localhost:8081`


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

- `docker/`: compose/stack манифесты
- `configs/`: доп. конфиги Kafka/Schema Registry (справочно; ключевые настройки задаются через env)
- `schemas/`: примеры JSON/Avro схем
- `scripts/`: установка/деплой/топики/утилиты
- `docs/`: документация (установка, деплой, архитектура, troubleshooting)
- `monitoring/`: опциональная заготовка Prometheus/Grafana
- `.gitlab-ci.yml`: (в корне репозитория) минимальная CI-валидация compose (опционально)

## Полезные адреса (по умолчанию)

- Kafka: `localhost:9092`
- Schema Registry: `http://localhost:8081`


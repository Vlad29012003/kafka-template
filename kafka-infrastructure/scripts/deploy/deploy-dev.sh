#!/usr/bin/env bash
set -euo pipefail

# Деплой для локальной разработки через docker-compose.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "${ROOT_DIR}/docker"

echo "[deploy-dev] Поднимаю сервисы (docker compose)..."
if [[ ! -f "${ROOT_DIR}/.env" ]]; then
  echo "[deploy-dev] Не найден ${ROOT_DIR}/.env"
  echo "  Скопируйте шаблон: cp ${ROOT_DIR}/env.example ${ROOT_DIR}/.env"
  exit 1
fi

docker compose --env-file "${ROOT_DIR}/.env" up -d

set -a
# shellcheck source=/dev/null
source "${ROOT_DIR}/.env"
set +a

echo "[deploy-dev] Готово. Проверка:"
echo "  - Kafka: localhost:${KAFKA_PORT:-9092}"
echo "  - Schema Registry: http://localhost:${SCHEMA_REGISTRY_PORT:-8081}"
echo "  - Kafka UI (опционально): из docker/kafka-ui: docker compose --env-file ../../.env up -d → http://localhost:${KAFKA_UI_PORT:-8080}"


#!/usr/bin/env bash
set -euo pipefail

# Деплой на сервер через Docker Swarm stack.
# Ожидается, что Swarm уже инициализирован и вы на manager-ноде.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cd "${ROOT_DIR}"

if [[ ! -f "${ROOT_DIR}/.env" ]]; then
  echo "[deploy-prod] Не найден ${ROOT_DIR}/.env"
  echo "  Скопируйте шаблон: cp ${ROOT_DIR}/env.example ${ROOT_DIR}/.env"
  exit 1
fi

set -a
# shellcheck source=/dev/null
source "${ROOT_DIR}/.env"
set +a
STACK_NAME="${STACK_NAME:-kafka}"

: "${KAFKA_PORT:?укажите KAFKA_PORT в .env}"
: "${SCHEMA_REGISTRY_PORT:?укажите SCHEMA_REGISTRY_PORT в .env}"
: "${KAFKA_KRAFT_CLUSTER_ID:?укажите KAFKA_KRAFT_CLUSTER_ID в .env}"
: "${KAFKA_ADVERTISED_HOST:?укажите KAFKA_ADVERTISED_HOST в .env}"
: "${STACK_NAME:?укажите STACK_NAME в .env}"

echo "[deploy-prod] Деплой stack '${STACK_NAME}'..."
docker stack deploy --with-registry-auth --prune --compose-file docker/docker-stack.yml "${STACK_NAME}"

echo "[deploy-prod] Готово. Проверка:"
echo "  docker stack services ${STACK_NAME}"


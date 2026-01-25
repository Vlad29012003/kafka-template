#!/usr/bin/env bash
set -euo pipefail

# Деплой на сервер через Docker Swarm stack.
# Ожидается, что Swarm уже инициализирован и вы на manager-ноде.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STACK_NAME="${STACK_NAME:-kafka}"

cd "${ROOT_DIR}"

if [[ ! -f "${ROOT_DIR}/.env" ]]; then
  echo "[deploy-prod] Не найден ${ROOT_DIR}/.env"
  echo "  Скопируйте шаблон: cp ${ROOT_DIR}/env.example ${ROOT_DIR}/.env"
  exit 1
fi

echo "[deploy-prod] Деплой stack '${STACK_NAME}'..."
docker stack deploy --with-registry-auth --compose-file docker/docker-stack.yml "${STACK_NAME}"

echo "[deploy-prod] Готово. Проверка:"
echo "  docker stack services ${STACK_NAME}"


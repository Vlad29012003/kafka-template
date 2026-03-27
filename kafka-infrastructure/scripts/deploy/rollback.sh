#!/usr/bin/env bash
set -euo pipefail

# Откат манифеста Swarm: деплой из указанного compose-файла или из git (ROLLBACK_COMMIT_SHA).
# Удаление stack — не откат; для автоматического отката при сбое обновления см. update_config.failure_action в docker-stack.yml.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STACK_NAME="${STACK_NAME:-kafka}"
cd "${ROOT_DIR}"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "${ROOT_DIR}/.env"
  set +a
fi

STACK_NAME="${STACK_NAME:?укажите STACK_NAME}"

usage() {
  echo "Использование:" >&2
  echo "  $0 <путь/к/docker-stack.yml>   — задеплоить манифест с диска (например артефакт из CI)" >&2
  echo "  ROLLBACK_COMMIT_SHA=<sha> $0   — взять kafka-infrastructure/docker/docker-stack.yml из коммита" >&2
}

if [[ -n "${1:-}" ]]; then
  COMPOSE_FILE="$1"
  if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "[rollback] Файл не найден: ${COMPOSE_FILE}" >&2
    exit 1
  fi
elif [[ -n "${ROLLBACK_COMMIT_SHA:-}" ]]; then
  REPO_ROOT="$(cd "${ROOT_DIR}/.." && pwd)"
  bash "${ROOT_DIR}/scripts/deploy/resolve-rollback-commit.sh" "${ROLLBACK_COMMIT_SHA}"
  git -C "${REPO_ROOT}" checkout "${ROLLBACK_COMMIT_SHA}" -- kafka-infrastructure/docker/docker-stack.yml
  COMPOSE_FILE="${ROOT_DIR}/docker/docker-stack.yml"
else
  usage
  exit 1
fi

echo "[rollback] docker stack deploy из ${COMPOSE_FILE} (stack=${STACK_NAME})..."
docker stack deploy --with-registry-auth --compose-file "${COMPOSE_FILE}" "${STACK_NAME}"

#!/usr/bin/env bash
set -euo pipefail

# Простейший "rollback" для Swarm: удалить stack и задеплоить снова.
# Для настоящего rollback обычно используют версионирование образов/тегов и GitOps.

STACK_NAME="${STACK_NAME:-kafka}"

echo "[rollback] Удаляю stack '${STACK_NAME}'..."
docker stack rm "${STACK_NAME}" || true

echo "[rollback] Подождите пару секунд и запустите deploy-prod.sh заново."


#!/usr/bin/env bash
set -euo pipefail

# Просмотр логов сервисов (docker-compose).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "${ROOT_DIR}/docker"

docker compose logs -f --tail=200


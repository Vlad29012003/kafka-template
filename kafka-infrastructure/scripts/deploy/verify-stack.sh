#!/usr/bin/env bash
# Smoke-проверка после деплоя Swarm stack: сервисы, Schema Registry, TCP к Kafka.
#
# Переменные окружения:
#   STACK_NAME — имя stack (обязательно)
#   KAFKA_HOST, KAFKA_PORT — хост/порт для TCP (по умолчанию localhost:9092)
#   SCHEMA_REGISTRY_URL — полный URL (иначе http://KAFKA_HOST:SCHEMA_REGISTRY_PORT)
#   SCHEMA_REGISTRY_PORT — если нет SCHEMA_REGISTRY_URL (по умолчанию 8081)
#   CURL_MAX_TIME, TCP_CONNECT_TIMEOUT — таймауты секунд (10 и 5)
#
# Коды выхода: 0 — OK; 1 — общая/CLI ошибка; 2 — stack/replicas; 3 — Schema Registry; 4 — Kafka TCP

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck source=/dev/null
  source "${ROOT_DIR}/.env"
  set +a
fi

STACK_NAME="${STACK_NAME:?укажите STACK_NAME}"
KAFKA_HOST="${KAFKA_HOST:-localhost}"
KAFKA_PORT="${KAFKA_PORT:-9092}"
SCHEMA_REGISTRY_PORT="${SCHEMA_REGISTRY_PORT:-8081}"
SCHEMA_REGISTRY_URL="${SCHEMA_REGISTRY_URL:-http://${KAFKA_HOST}:${SCHEMA_REGISTRY_PORT}}"
CURL_MAX_TIME="${CURL_MAX_TIME:-10}"
TCP_CONNECT_TIMEOUT="${TCP_CONNECT_TIMEOUT:-5}"

err() {
  echo "[verify-stack] $*" >&2
}

verify_stack_replicas() {
  local out line name replicas cur want
  if ! out="$(docker stack services "${STACK_NAME}" --format '{{.Name}} {{.Replicas}}' 2>&1)"; then
    err "stack '${STACK_NAME}': ${out}"
    return 2
  fi
  if [[ -z "${out//[$'\t\r\n ']/}" ]]; then
    err "у stack '${STACK_NAME}' нет сервисов"
    return 2
  fi
  echo "[verify-stack] docker stack services ${STACK_NAME}:"
  docker stack services "${STACK_NAME}"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "${line//[$'\t\r\n ']/}" ]] && continue
    name="${line%% *}"
    replicas="${line#* }"
    if [[ ! "$replicas" =~ ^([0-9]+)/([0-9]+)$ ]]; then
      err "не удалось разобрать replicas для '${name}': '${replicas}'"
      return 2
    fi
    cur="${BASH_REMATCH[1]}"
    want="${BASH_REMATCH[2]}"
    if (( want == 0 || cur != want )); then
      err "сервис ${name}: replicas ${replicas} (нужно running == desired > 0)"
      return 2
    fi
  done <<< "$out"
}

verify_schema_registry() {
  if ! command -v curl >/dev/null 2>&1; then
    err "curl не найден — проверка Schema Registry невозможна"
    return 3
  fi
  echo "[verify-stack] GET ${SCHEMA_REGISTRY_URL}/subjects (max-time ${CURL_MAX_TIME}s)..."
  if ! curl -sfS --max-time "${CURL_MAX_TIME}" "${SCHEMA_REGISTRY_URL}/subjects" >/dev/null; then
    err "Schema Registry не ответил по ${SCHEMA_REGISTRY_URL}/subjects"
    return 3
  fi
}

verify_kafka_tcp() {
  echo "[verify-stack] TCP ${KAFKA_HOST}:${KAFKA_PORT} (таймаут ${TCP_CONNECT_TIMEOUT}s)..."
  if command -v nc >/dev/null 2>&1; then
    if nc -z -w "${TCP_CONNECT_TIMEOUT}" "${KAFKA_HOST}" "${KAFKA_PORT}"; then
      return 0
    fi
    err "Kafka TCP недоступна: ${KAFKA_HOST}:${KAFKA_PORT}"
    return 4
  fi
  # bash /dev/tcp (Linux/Git Bash)
  if command -v timeout >/dev/null 2>&1; then
    if timeout "${TCP_CONNECT_TIMEOUT}" bash -c "echo >/dev/tcp/${KAFKA_HOST}/${KAFKA_PORT}" 2>/dev/null; then
      return 0
    fi
    err "Kafka TCP недоступна: ${KAFKA_HOST}:${KAFKA_PORT}"
    return 4
  fi
  if bash -c "echo >/dev/tcp/${KAFKA_HOST}/${KAFKA_PORT}" 2>/dev/null; then
    return 0
  fi
  err "нужен nc или bash с /dev/tcp для проверки ${KAFKA_HOST}:${KAFKA_PORT}"
  return 4
}

main() {
  if ! command -v docker >/dev/null 2>&1; then
    err "docker не найден в PATH"
    exit 1
  fi
  verify_stack_replicas || exit 2
  verify_schema_registry || exit 3
  verify_kafka_tcp || exit 4
  echo "[verify-stack] OK"
}

main "$@"

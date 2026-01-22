#!/usr/bin/env bash
set -euo pipefail

# Быстрая проверка здоровья локальных сервисов.

KAFKA_HOST="${KAFKA_HOST:-localhost}"
KAFKA_PORT="${KAFKA_PORT:-9092}"
SCHEMA_REGISTRY_URL="${SCHEMA_REGISTRY_URL:-http://localhost:8081}"

echo "[health-check] Проверяю Kafka ${KAFKA_HOST}:${KAFKA_PORT}..."
if command -v nc >/dev/null 2>&1; then
  nc -z "${KAFKA_HOST}" "${KAFKA_PORT}"
else
  # Фолбэк (PowerShell/Windows без nc): просто сообщаем.
  echo "[health-check] nc не найден, пропускаю TCP-проверку."
fi

echo "[health-check] Проверяю Schema Registry ${SCHEMA_REGISTRY_URL}..."
if command -v curl >/dev/null 2>&1; then
  curl -sf "${SCHEMA_REGISTRY_URL}/subjects" >/dev/null
else
  echo "[health-check] curl не найден, пропускаю HTTP-проверку."
fi

echo "[health-check] OK"


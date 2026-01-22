#!/usr/bin/env bash
set -euo pipefail

# Удаление топиков через kafka-topics внутри контейнера.

KAFKA_CONTAINER="${KAFKA_CONTAINER:-kafka-broker}"
TOPICS="${TOPICS:-subscriber-events}"

echo "[delete-topics] Контейнер Kafka: ${KAFKA_CONTAINER}"
echo "[delete-topics] Топики: ${TOPICS}"

for t in ${TOPICS}; do
  echo "[delete-topics] Удаляю '${t}'..."
  docker exec "${KAFKA_CONTAINER}" /opt/bitnami/kafka/bin/kafka-topics.sh \
    --bootstrap-server localhost:9092 \
    --delete \
    --topic "${t}" || true
done

echo "[delete-topics] Готово."


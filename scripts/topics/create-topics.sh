#!/usr/bin/env bash
set -euo pipefail

# Создание топиков через kafka-topics внутри контейнера.

KAFKA_CONTAINER="${KAFKA_CONTAINER:-kafka-broker}"

# Список топиков (можно переопределить переменной окружения TOPICS="a b c")
TOPICS="${TOPICS:-subscriber-events}"

# Параметры по умолчанию
PARTITIONS="${PARTITIONS:-3}"
REPLICATION_FACTOR="${REPLICATION_FACTOR:-1}"

echo "[create-topics] Контейнер Kafka: ${KAFKA_CONTAINER}"
echo "[create-topics] Топики: ${TOPICS}"

for t in ${TOPICS}; do
  echo "[create-topics] Создаю '${t}'..."
  docker exec "${KAFKA_CONTAINER}" /opt/bitnami/kafka/bin/kafka-topics.sh \
    --bootstrap-server localhost:9092 \
    --create \
    --if-not-exists \
    --topic "${t}" \
    --partitions "${PARTITIONS}" \
    --replication-factor "${REPLICATION_FACTOR}"
done

echo "[create-topics] Готово."


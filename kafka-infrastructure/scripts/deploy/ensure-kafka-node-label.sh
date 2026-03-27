#!/usr/bin/env bash
# Fail-fast: в Swarm должна быть хотя бы одна нода с label kafka=true (как в docker-stack.yml).
# Пропуск: SKIP_KAFKA_NODE_LABEL_CHECK=1

set -euo pipefail

if [[ "${SKIP_KAFKA_NODE_LABEL_CHECK:-0}" == "1" ]]; then
  echo "[kafka-label] проверка пропущена (SKIP_KAFKA_NODE_LABEL_CHECK=1)"
  exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "[kafka-label] docker не найден" >&2
  exit 1
fi

found=0
for id in $(docker node ls -q 2>/dev/null); do
  [[ -z "$id" ]] && continue
  lab="$(docker node inspect "$id" --format '{{index .Spec.Labels "kafka"}}' 2>/dev/null || true)"
  if [[ "$lab" == "true" ]]; then
    echo "[kafka-label] нода ${id}: label kafka=true"
    found=1
    break
  fi
done

if [[ "$found" -ne 1 ]]; then
  echo "[kafka-label] нет ни одной ноды Swarm с label kafka=true" >&2
  echo "[kafka-label] Выполните: docker node update --label-add kafka=true <node-id|имя>" >&2
  exit 1
fi

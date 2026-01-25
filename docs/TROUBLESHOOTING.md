# Troubleshooting

## Kafka не стартует

- Проверьте логи: `./scripts/utils/logs.sh`
- Проверьте, что порт `9092` не занят.

## Не подключается клиент

- Проверьте `KAFKA_ADVERTISED_HOST` и `KAFKA_PORT` в `.env`.
- Если клиент не на той же машине, укажите публичный DNS/IP в `KAFKA_ADVERTISED_HOST`.

## Schema Registry недоступен

- Проверьте `http://localhost:8081/subjects`
- Убедитесь, что Kafka healthy в compose.


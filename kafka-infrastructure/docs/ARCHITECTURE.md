# Архитектура

## Компоненты

- **Kafka**: брокер сообщений (1 нода в шаблоне)
- **KRaft (встроенный контроллер)**: координация и метаданные внутри Kafka (без ZooKeeper)
- **Schema Registry**: хранение и выдача схем (HTTP API)

## Потоки

- Producer отправляет события в топик `subscriber-events`.
- Consumer читает из этого топика в составе consumer group.

## Конфигурация

- `docker/docker-compose.yml`: локальный запуск
- `docker/docker-stack.yml`: деплой в Swarm
- `configs/*`: справочные `*.properties` (образы Confluent настраиваются через env в compose/stack; файлы в контейнер не монтируются)
- `docker/kafka-ui/docker-compose.yml`: опциональный Kafka UI (внешняя сеть `kafka-infra` после `docker compose up` основного файла)


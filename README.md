# kafka-template

Репозиторий с инфраструктурой Kafka (KRaft) и Schema Registry.

## Где всё лежит

**Каноническая копия** шаблона — каталог [`kafka-infrastructure/`](kafka-infrastructure/README.md): Docker Compose, Swarm stack, скрипты, документация, схемы.

- **GitLab CI** (`.gitlab-ci.yml`): валидация compose и ручной деплой Swarm с runner’а на хосте — см. [kafka-infrastructure/docs/DEPLOYMENT.md](kafka-infrastructure/docs/DEPLOYMENT.md).
- Быстрый старт и структура каталогов — в [kafka-infrastructure/README.md](kafka-infrastructure/README.md).

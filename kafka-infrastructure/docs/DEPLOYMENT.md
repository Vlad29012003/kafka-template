# Деплой

## Локально (dev)

```bash
cp env.example .env
./scripts/deploy/deploy-dev.sh
```

## Swarm (prod)

1) Подготовка сервера:

- Установите Docker + docker compose plugin на manager-ноду.
- Инициализируйте Swarm и настройте firewall.
- Рекомендуется автоматизировать это через Ansible/Terraform или отдельный ops-репозиторий.

2) Деплой:

```bash
cp env.example .env
./scripts/deploy/deploy-prod.sh
```

### Рекомендуемый вариант (физические сервера): Ansible

См. `kafka-ops/README.md` — там есть playbook, который:
- ставит Docker на Debian,
- (опционально) настраивает firewall allowlist,
- копирует `kafka-infrastructure/` на Kafka-host,
- делает `docker stack deploy`.

3) Проверка:

```bash
docker stack services ${STACK_NAME:-kafka}
```


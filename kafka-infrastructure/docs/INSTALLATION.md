# Установка

## Локально (Docker)

1) Установите Docker Desktop.
2) В корне `kafka-infrastructure/` создайте `.env`:

```bash
cp env.example .env
```

3) Поднимите сервисы:

```bash
cd docker
docker compose --env-file ../.env up -d
```

## Сервер (Swarm)

- Подготовка сервера (установка Docker, firewall, инициализация Swarm) вынесена за рамки этого репозитория.
- Рекомендуется делать это через Ansible/Terraform или отдельный ops-репозиторий.
- См. `docs/DEPLOYMENT.md`.


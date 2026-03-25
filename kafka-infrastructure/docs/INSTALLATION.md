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

- Подготовка хоста (Docker, Swarm, firewall) и выкладка через GitLab CI — в `DEPLOYMENT.md`.


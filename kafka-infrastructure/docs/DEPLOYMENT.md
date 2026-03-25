# Деплой

## Локально (dev)

```bash
cp env.example .env
./scripts/deploy/deploy-dev.sh
```

## Swarm (prod)

### Через GitLab CI (основной сценарий)

1) На manager-ноде один раз: Docker, Docker Compose plugin, инициализация Swarm, firewall по политике команды; зарегистрированный **GitLab Runner** с тегом из `.gitlab-ci.yml` (например `kafka_infra`) и доступом к `docker`.

2) В GitLab: **Settings → CI/CD → Variables** — переменные, которые подставляются в job `deploy:swarm_dev` (см. `.gitlab-ci.yml`).

3) Запуск pipeline на ветке `dev` → ручной job **deploy:swarm_dev** выполнит `docker stack deploy` из каталога `kafka-infrastructure/`.

### Вручную на сервере (без CI)

```bash
cp env.example .env
# заполнить .env
./scripts/deploy/deploy-prod.sh
```

### Проверка

```bash
docker stack services ${STACK_NAME:-kafka}
```


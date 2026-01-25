# kafka-ops

Ops-часть для **физических серверов**: подготовка ОС и деплой `kafka-infrastructure/` на Kafka-host.

Идея простая:
- `kafka-infrastructure/` — описывает сервисы (compose/stack), конфиги, доки
- `kafka-ops/` — **настраивает сервер** (Docker, firewall, Swarm, деплой)

## Требования

- На вашей машине (где запускаете Ansible): Ansible 2.15+ и доступ по SSH к серверу Kafka (root или sudo).
- На сервере Kafka: Debian 13.

## Быстрый запуск

1) Заполните инвентарь:

- `kafka-ops/ansible/inventory/hosts.ini`

2) Проверьте переменные:

- `kafka-ops/ansible/group_vars/kafka_hosts.yml`

### Топики

Топики создаются автоматически после деплоя стека.
Список и параметры задаются в `kafka-ops/ansible/group_vars/kafka_hosts.yml` в секции `kafka_topics`:
- `name`: имя топика
- `partitions`: число партиций
- `replication_factor`: RF (для single-node = 1)
- `configs`: любые topic configs (например `retention.ms`)

3) Запуск:

```bash
cd kafka-ops/ansible
ansible-playbook -i inventory/hosts.ini playbooks/kafka_host.yml
```

## Важно про firewall

По умолчанию правила готовятся, но **ufw не включается автоматически**, чтобы случайно не потерять SSH доступ.
Когда будете готовы — выставьте `enable_ufw: true` в `group_vars/kafka_hosts.yml`.


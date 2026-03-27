#!/usr/bin/env bash
# Делает коммит доступным для checkout: fetch --prune, проверка объекта, при необходимости fetch SHA.
# Использование: resolve-rollback-commit.sh <SHA>
# Запускать из корня git-репозитория (или ниже — найдём корень через git rev-parse).

set -euo pipefail

SHA="${1:?укажите SHA коммита}"

if ! REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  echo "[resolve-commit] не git-репозиторий" >&2
  exit 1
fi
cd "$REPO_ROOT"

git fetch origin --prune

if git cat-file -e "${SHA}^{commit}" 2>/dev/null; then
  exit 0
fi

# Одиночный fetch по SHA часто не находит remote ref — тогда подтягиваем всё с origin.
if ! git fetch -q origin "${SHA}" 2>/dev/null; then
  echo "[resolve-commit] git fetch origin ${SHA} недоступен, выполняем полный git fetch origin..." >&2
  git fetch origin
fi

if ! git cat-file -e "${SHA}^{commit}" 2>/dev/null; then
  echo "[resolve-commit] коммит недоступен локально после fetch: ${SHA}" >&2
  exit 1
fi

exit 0

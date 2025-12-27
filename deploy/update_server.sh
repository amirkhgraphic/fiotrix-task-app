#!/usr/bin/env bash
set -euo pipefail

APP_DIR=${APP_DIR:-/opt/tasks-api}
REPO_URL=${REPO_URL:-}

if [ -z "$REPO_URL" ]; then
  echo "REPO_URL is required" >&2
  exit 1
fi

if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR"
git pull --ff-only origin main

docker compose up -d --build

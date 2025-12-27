#!/usr/bin/env bash
set -euo pipefail

APP_DIR=${APP_DIR:-/opt/tasks-api}
REPO_URL=${REPO_URL:-}
SERVICE_NAME=${SERVICE_NAME:-tasks-api}
PYTHON_BIN=${PYTHON_BIN:-python3}

if [ -z "$REPO_URL" ]; then
  echo "REPO_URL is required" >&2
  exit 1
fi

if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR"
git pull --ff-only origin main

if [ ! -d ".venv" ]; then
  $PYTHON_BIN -m venv .venv
fi

.venv/bin/pip install -r requirements.txt

sudo systemctl restart "$SERVICE_NAME"

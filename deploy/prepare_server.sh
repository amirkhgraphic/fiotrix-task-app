#!/usr/bin/env bash
set -euo pipefail

APP_DIR=${APP_DIR:-/opt/tasks-api}
REPO_URL=${REPO_URL:-}
PYTHON_BIN=${PYTHON_BIN:-python3}
DATABASE_URL=${DATABASE_URL:-}
PG_USER=${PG_USER:-task_user}
PG_PASSWORD=${PG_PASSWORD:-strongpassword}
PG_DB=${PG_DB:-tasks_db}

if [ -z "$REPO_URL" ]; then
  echo "REPO_URL is required" >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y "$PYTHON_BIN" python3-venv python3-pip git postgresql postgresql-contrib docker.io docker-compose-plugin
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl enable docker
sudo systemctl start docker

sudo -u postgres psql -v ON_ERROR_STOP=1 <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${PG_USER}') THEN
    CREATE ROLE ${PG_USER} LOGIN PASSWORD '${PG_PASSWORD}';
  ELSE
    ALTER ROLE ${PG_USER} WITH PASSWORD '${PG_PASSWORD}';
  END IF;

  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '${PG_DB}') THEN
    CREATE DATABASE ${PG_DB} OWNER ${PG_USER};
  ELSE
    ALTER DATABASE ${PG_DB} OWNER TO ${PG_USER};
  END IF;
END
\$\$;
SQL

sudo mkdir -p "$APP_DIR"
sudo chown -R "$USER:$USER" "$APP_DIR"

if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR"
if [ -z "$DATABASE_URL" ]; then
  DATABASE_URL="postgresql+psycopg2://${PG_USER}:${PG_PASSWORD}@localhost:5432/${PG_DB}"
fi

cat > .env <<ENV
DATABASE_URL=$DATABASE_URL
ENV

docker compose up -d --build

echo "Done. Containers:"
docker compose ps

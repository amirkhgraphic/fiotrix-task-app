# Tasks API (FastAPI + PostgreSQL)

A simple CRUD API for managing tasks using FastAPI and PostgreSQL.

## Requirements

- Python 3.11+
- PostgreSQL

## Setup

```bash
python -m venv .venv
.venv\Scripts\activate
python -m pip install -r requirements.txt
```

Create a `.env` file (or set env vars directly) with your database URL:

```bash
DATABASE_URL=postgresql+psycopg2://postgres:postgres@localhost:5432/tasks_db
```

Run the app locally:

```bash
uvicorn app.main:app --reload
```

Swagger docs are available at `http://localhost:8000/docs`.

## API Endpoints

- `GET /tasks/` list tasks
- `POST /tasks/` create a task
- `GET /tasks/{task_id}` get task by id
- `PUT /tasks/{task_id}` update a task
- `DELETE /tasks/{task_id}` delete a task

## Production (Linux)

### 1) Prepare the server

```bash
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip git
```

### 2) Clone and install

```bash
git clone https://github.com/<owner>/<repo>.git /opt/tasks-api
cd /opt/tasks-api
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

### 3) Configure environment

Create an environment file or set the env var directly for systemd:

```bash
sudo mkdir -p /etc/tasks-api
sudo tee /etc/tasks-api/tasks-api.env > /dev/null <<'ENV'
DATABASE_URL=postgresql+psycopg2://user:pass@localhost:5432/tasks_db
ENV
```

### 4) Systemd service

Copy the template and adjust `User`, `Group`, and paths if needed:

```bash
sudo cp deploy/tasks-api.service /etc/systemd/system/tasks-api.service
sudo systemctl daemon-reload
sudo systemctl enable tasks-api
sudo systemctl start tasks-api
```

To use the env file, update the service with:

```ini
EnvironmentFile=/etc/tasks-api/tasks-api.env
```

### 5) Verify

```bash
curl http://localhost:8000/tasks/
```

## GitHub Actions (CI/CD)

- CI workflow checks dependency integrity and Python syntax on every push/PR.
- CD workflow uses SSH to pull the latest code on your server and restart the systemd service. Set secrets:
  - `SSH_HOST`, `SSH_USER`, `SSH_KEY`, `APP_DIR`, `SERVICE_NAME`

The CD workflow clones the repo if it does not exist; otherwise it runs `git pull`.

## Server Update Script

Use the helper script on the server to pull and restart:

```bash
export REPO_URL=https://github.com/<owner>/<repo>.git
export APP_DIR=/opt/tasks-api
export SERVICE_NAME=tasks-api
bash deploy/update_server.sh
```

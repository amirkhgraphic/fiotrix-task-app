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

## Production (Docker)

### 1) Prepare the server

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-plugin git
sudo systemctl enable docker
sudo systemctl start docker
```

### 2) Clone the repo

```bash
git clone https://github.com/<owner>/<repo>.git /opt/tasks-api
cd /opt/tasks-api
```

### 3) Configure environment

Create a `.env` file in the repo root:

```bash
cat > .env <<'ENV'
DATABASE_URL=postgresql+psycopg2://task_user:strongpassword@db:5432/tasks_db
ENV
```

### 4) Start containers

```bash
docker compose up -d --build
```

### 5) Verify

```bash
curl http://localhost:8000/tasks/
```

## GitHub Actions (CI/CD)

- CI workflow checks dependency integrity and Python syntax on every push/PR.
- CD workflow uses SSH to pull the latest code on your server and run `docker compose up -d --build`. Set secrets:
  - `SSH_HOST`, `SSH_USER`, `SSH_KEY`, `APP_DIR`

## Server Update Script

Use the helper script on the server to pull and restart:

```bash
export REPO_URL=https://github.com/<owner>/<repo>.git
export APP_DIR=/opt/tasks-api
bash deploy/update_server.sh
```

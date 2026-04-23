# snickr

NYU CS6083 Spring 2026 Database Project — Slack-like collaboration system built with Django + PostgreSQL.

## Quick Start (Docker)

**Prerequisites**: Docker Desktop installed and running.

```bash
# 1. Clone the repo
git clone <repo-url> && cd DBproject

# 2. Create .env file (if not exists)
echo "POSTGRES_DB=snickr
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_HOST=db" > .env

# 3. Build and run
docker compose up --build
```

Done. Open **http://localhost:8000** — you'll see the API test page.

### First Time Setup

1. Open http://localhost:8000
2. Click the **initialize** button to set up the database schema and load test data
3. Login with any test account (see below)

### Stopping / Resetting

```bash
# Stop
docker compose down

# Full reset (wipe database volume)
docker compose down -v
docker compose up --build
```

## Test Accounts

After calling `initialize`, the database has these users:

| Email | Username | Password |
|-------|----------|----------|
| az1234@nyu.edu | alicezhang | `alice123` |
| bs5678@nyu.edu | bobsmith | `bob456` |
| cw9012@nyu.edu | carolwang | `carol789` |
| dj3456@nyu.edu | davejohnson | `dave012` |
| ec7890@nyu.edu | evechen | `eve345` |
| fl2345@nyu.edu | frankli | `frank678` |

## API

All 23 backend functions go through one endpoint: `POST /api/core`. See **[API.md](API.md)** for the complete reference with parameters, examples, and response formats.

## Project Structure

```
├── DBProject/
│   ├── settings.py      # Django settings (DB config via .env)
│   ├── urls.py           # URL routing → views
│   └── views.py          # All backend logic (RPC functions)
├── sqls/
│   ├── initialize.sql    # CREATE TABLE statements
│   ├── insert.sql        # Test data
│   └── query.sql         # Stored procedures & sample queries
├── templates/
│   └── simple/
│       └── test.html     # API test page (placeholder for frontend)
├── api.md                # Complete API documentation
├── docker-compose.yml    # PostgreSQL + Django
├── Dockerfile
├── .env                  # DB credentials (not in git)
├── requirements.txt
└── release.yaml          # Version tag for Docker builds
```

### For Frontend Development

The `templates/` directory is where the frontend goes. Currently `templates/simple/test.html` is a basic API tester. Your frontend should:

1. Live in `templates/` (Django will serve it)
2. Call `POST /api/core` with the same JSON-RPC pattern
3. Include `credentials: "include"` in fetch calls for session auth

## Tech Stack

- **Backend**: Django 5.2, raw SQL (no ORM)
- **Database**: PostgreSQL 15
- **Container**: Docker Compose

## CI/CD

GitHub Actions workflow (`.github/workflows/docker-build.yml`) builds and pushes to Docker Hub on manual trigger. Requires two repository secrets:

- `DOCKERHUB_USERNAME` — Docker Hub username
- `DOCKERHUB_TOKEN` — Docker Hub access token

## Authors

- Christine Wagner (caw561@nyu.edu)
- Hongyi Zeng (hz3866@nyu.edu)

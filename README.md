# snickr

NYU CS6083 Spring 2026 Database Project — a web-based collaboration system (similar to Slack) built with Django and PostgreSQL.

## Overview

snickr lets users create **workspaces**, organize conversations into **public, private, and direct channels**, and exchange **messages** within those channels. Access control is enforced at the application level: a single DBMS account is used, and the app restricts visibility based on workspace/channel membership.

## Database Schema

The database consists of six relations:

| Table | Primary Key | Description |
|-------|-------------|-------------|
| `users` | `uid` (serial) | User accounts; `email` is UNIQUE NOT NULL |
| `workspaces` | `wsid` (serial) | Workspaces that group channels |
| `workspace_members` | `(wsid, uid)` | M:N membership with role and invitation status |
| `channels` | `chid` (serial) | Public, private, or direct channels within a workspace |
| `channel_members` | `(chid, uid)` | M:N membership with role and invitation status |
| `messages` | `msgid` (serial) | Messages posted to a channel by a user |

A surrogate integer `uid` is used as the user primary key (rather than `email`) so that users can change their email without cascading FK updates.

## Project Structure

```
├── DBProject/          # Django project settings
├── sqls/
│   ├── initialize.sql  # Schema creation (CREATE TABLE statements)
│   ├── insert.sql      # Test data (6 users, 2 workspaces, 6 channels, 15 messages)
│   └── query.sql       # Procedures, functions, and queries (7 required operations)
├── docs/
│   └── report.tex      # Project report (LaTeX source)
├── templates/           # Django HTML templates
├── manage.py
└── requirements.txt
```

## Tech Stack

- **Backend**: Django 5.2.13
- **Database**: PostgreSQL (via psycopg)
- **Python**: 3.11.9

## Getting Started

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure database

Update `DBProject/settings.py` with your PostgreSQL credentials.

### 3. Initialize the schema and test data

```bash
psql -U <user> -d <dbname> -f sqls/initialize.sql
psql -U <user> -d <dbname> -f sqls/insert.sql
```

### 4. Run the server

```bash
python manage.py runserver
```

The app will be available at `http://127.0.0.1:8000/`.

## Authors

- Christine Wagner (caw561@nyu.edu)
- Hongyi Zeng (hz3866@nyu.edu)

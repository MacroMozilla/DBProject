# snickr

NYU CS6083 Spring 2026 Database Project — A Slack-like collaboration platform built with **Django (RPC API) + PostgreSQL + React**.

---

## Overview

Snickr is a messaging and collaboration system that supports:

- User authentication (login/register/logout)
- Multiple workspaces per user
- Channel-based messaging (public, private, direct)
- Workspace & channel invitations with inbox management
- Role-based access (creator, admin, member)
- Workspace member management (invite, remove, promote/demote)
- Channel discovery and self-join for public channels
- Channel settings (add members, leave, delete)
- Persistent message history

---

## Quick Start (Docker)

**Prerequisites:** Docker Desktop installed and running.

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
2. Click the **Initialize** button to set up the database schema and load test data
3. Log in with any test account (see below)

### Stopping / Resetting

```bash
# Stop
docker compose down

# Full reset (wipe database volume)
docker compose down -v
docker compose up --build
```

---

## Frontend Setup (React)

The frontend runs separately from Django.

```bash
cd frontend
npm install
npm start
```

Frontend runs at: http://localhost:3000

---

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

---

## API

All backend functions go through one endpoint: `POST /api/core`. See **[API.md](API.md)** for the complete reference.

**Request format:**

```json
{
  "function": "function_name",
  "args": [],
  "kwargs": {}
}
```

**Response format:**

```json
{
  "ok": true,
  "data": {}
}
```

### Available RPC Functions

**Auth:** `register`, `login`, `logout`, `me`

**Workspaces:** `get_workspaces`, `create_workspace`, `delete_workspace`, `get_workspace_members`, `invite_to_workspace`, `respond_workspace_invite`, `update_workspace_member`, `leave_workspace`

**Channels:** `get_channels`, `create_channel`, `delete_channel`, `get_channel_members`, `invite_to_channel`, `respond_channel_invite`, `join_channel`, `leave_channel`, `get_public_channels`

**Messages:** `get_messages`, `send_message`, `search_messages`, `get_user_messages`

**Users:** `search_users`

**Reports:** `get_workspace_admins`, `get_pending_channel_invites`

**Admin:** `initialize`

---

## Project Structure

```
├── DBProject/
│   ├── settings.py       # Django settings (DB config via .env)
│   ├── urls.py           # URL routing → views
│   └── views.py          # All backend logic (RPC functions)
├── sqls/
│   ├── initialize.sql    # CREATE TABLE statements
│   ├── insert.sql        # Test data
│   └── query.sql         # Stored procedures & sample queries
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   │   ├── LoginPage.js
│   │   │   ├── RegisterPage.js
│   │   │   └── ChatPage.js          # Main layout, state, modal wiring
│   │   ├── components/
│   │   │   ├── Inbox.js             # Invite notifications dropdown
│   │   │   ├── WorkspaceList.js     # Workspace sidebar list
│   │   │   ├── ChannelList.js       # Channel sidebar list
│   │   │   ├── ChatWindow.js        # Message display + input
│   │   │   ├── Modal.js             # Base modal wrapper
│   │   │   ├── CreateWorkspaceModal.js
│   │   │   ├── CreateChannelModal.js
│   │   │   ├── WorkspaceMembersModal.js  # Invite, remove, promote, leave, delete
│   │   │   ├── ChannelSettingsModal.js   # Add members, leave, delete channel
│   │   │   └── DiscoverChannelsModal.js  # Browse & join public channels
│   │   ├── services/
│   │   │   └── api.js               # All RPC wrappers
│   │   └── App.js
├── templates/
│   └── simple/
│       └── test.html     # API test page
├── api.md                # Complete API documentation
├── docker-compose.yml    # PostgreSQL + Django
├── Dockerfile
├── .env                  # DB credentials (not in git)
├── requirements.txt
└── release.yaml          # Version tag for Docker builds
```

---

## Tech Stack

- **Backend:** Django 5.2, raw SQL (no ORM)
- **Database:** PostgreSQL 15
- **Frontend:** React (functional components + hooks), Tailwind CSS
- **Container:** Docker Compose

---

## Authentication

- Session-based authentication (Django sessions)
- Frontend includes `credentials: "include"` on all fetch calls
- `me` endpoint validates the active session on page load

---

## Key Features

### Workspaces
- Create workspaces with an optional description
- Invite users by username at creation time or later
- Creators and admins can invite members, remove members, and promote/demote to admin
- Creators can delete the workspace (cascades to all channels and messages)
- Non-creators can leave a workspace

### Channels
- Three channel types: **public** (anyone in workspace can join), **private** (invite only), **direct** (exactly two users)
- Direct channel names autopopulate as `DM - username`
- Any workspace member can create a channel
- Channel creators can add members and delete the channel
- Anyone can leave a channel
- Public channels are discoverable via the Browse button — join with one click

### Messaging
- Messages ordered chronologically per channel
- Session-based authorship — messages show your username

### Inbox
- Pending workspace and channel invites appear in the Inbox dropdown
- Accept or reject each invite individually

---

## Design Decisions

- **RPC over REST** for simplicity
- **Raw SQL only** (course requirement — no ORM)
- **Composite keys** for membership tables
- **`status` field** (`pending`, `accepted`, `rejected`) for invitations
- **Application-level access control** — a single DB user, permissions enforced in Python
- **Cascade deletes** handled manually in SQL (messages → channel members → channels → workspace members → workspace)

---

## CI/CD

GitHub Actions workflow (`.github/workflows/docker-build.yml`) builds and pushes to Docker Hub on manual trigger. Requires two repository secrets:

- `DOCKERHUB_USERNAME` — Docker Hub username
- `DOCKERHUB_TOKEN` — Docker Hub access token

---

## Known Limitations

- No WebSocket real-time updates (polling only — refresh to see new messages)
- No message editing or deleting
- No file/image uploads
- No search UI (backend `search_messages` exists but no frontend page yet)

---

## Authors

- Christine Wagner — caw561@nyu.edu
- Hongyi Zeng — hz3866@nyu.edu

# Snickr Backend API Documentation

## Overview

All backend calls go through **one single endpoint**:

```
POST /api/core
Content-Type: application/json
```

Request body:

```json
{
    "function": "<function_name>",
    "args": [],
    "kwargs": { "param1": "value1", "param2": "value2" }
}
```

- `function` — function name (string, required)
- `args` — positional arguments (array, optional, default `[]`)
- `kwargs` — keyword arguments (object, optional, default `{}`)

Response format:

```json
// success
{ "ok": true, "data": { ... } }

// error
{ "ok": false, "error": "error message" }
```

### Helper Endpoint

```
GET /api/functions
```

Returns all available function names with their parameter lists. Useful for quick reference during development.

### Auth & Session

The backend uses Django session cookies. After `login` or `register`, the session cookie is set automatically. Include `credentials: "include"` in fetch calls so the browser sends the cookie.

```javascript
fetch("/api/core", {
    method: "POST",
    credentials: "include",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ function: "login", kwargs: { email: "...", password: "..." } })
})
```

Most functions require the user to be logged in. If not logged in, they return `{ "error": "not logged in" }` inside `data`.

---

## Functions Reference

### 1. Auth

#### `register`

Create a new user account. Automatically logs in after registration.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | yes | User email (must be unique) |
| username | string | yes | Username |
| nickname | string | yes | Display name |
| password | string | yes | Plain text password (hashed on server) |

```json
{
    "function": "register",
    "kwargs": {
        "email": "jd1234@nyu.edu",
        "username": "johndoe",
        "nickname": "John",
        "password": "mypassword123"
    }
}
```

Response:

```json
{
    "ok": true,
    "data": { "uid": 7, "email": "jd1234@nyu.edu", "username": "johndoe", "nickname": "John" }
}
```

---

#### `login`

Log in with email and password.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| email | string | yes | User email |
| password | string | yes | Password |

```json
{
    "function": "login",
    "kwargs": { "email": "az1234@nyu.edu", "password": "mypassword" }
}
```

Response (success):

```json
{
    "ok": true,
    "data": { "uid": 1, "email": "az1234@nyu.edu", "username": "alicezhang", "nickname": "Alice" }
}
```

Response (failure):

```json
{
    "ok": true,
    "data": { "error": "invalid credentials" }
}
```

---

#### `logout`

Log out the current user. No parameters.

```json
{ "function": "logout" }
```

---

#### `me`

Get the currently logged-in user's info. No parameters.

```json
{ "function": "me" }
```

Response:

```json
{
    "ok": true,
    "data": { "uid": 1, "email": "az1234@nyu.edu", "username": "alicezhang", "nickname": "Alice" }
}
```

---

### 2. Workspaces

#### `get_workspaces`

List all workspaces the current user belongs to. No parameters.

```json
{ "function": "get_workspaces" }
```

Response:

```json
{
    "ok": true,
    "data": [
        { "wsid": 1, "wsname": "CS Department", "wsdescription": "...", "role": "creator", "status": "accepted" },
        { "wsid": 2, "wsname": "Robotics Club", "wsdescription": "...", "role": "member", "status": "pending" }
    ]
}
```

---

#### `create_workspace`

Create a new workspace. The current user becomes the creator.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsname | string | yes | Workspace name |
| wsdescription | string | no | Description (default `""`) |

```json
{
    "function": "create_workspace",
    "kwargs": { "wsname": "My New Workspace", "wsdescription": "A cool workspace" }
}
```

Response:

```json
{ "ok": true, "data": { "wsid": 3, "wsname": "My New Workspace" } }
```

---

#### `get_workspace_members`

List all members of a workspace.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |

```json
{
    "function": "get_workspace_members",
    "kwargs": { "wsid": 1 }
}
```

Response:

```json
{
    "ok": true,
    "data": [
        { "uid": 1, "email": "az1234@nyu.edu", "username": "alicezhang", "nickname": "Alice", "role": "creator", "status": "accepted" },
        { "uid": 2, "email": "bs5678@nyu.edu", "username": "bobsmith", "nickname": "Bob", "role": "admin", "status": "accepted" }
    ]
}
```

---

#### `invite_to_workspace`

Invite a user to a workspace. Only creator/admin can invite.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |
| invitee_uid | int | yes | User ID to invite |

```json
{
    "function": "invite_to_workspace",
    "kwargs": { "wsid": 1, "invitee_uid": 6 }
}
```

---

#### `respond_workspace_invite`

Accept or reject a workspace invitation.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |
| accept | bool | yes | `true` = accept, `false` = reject |

```json
{
    "function": "respond_workspace_invite",
    "kwargs": { "wsid": 2, "accept": true }
}
```

---

#### `update_workspace_member`

Change a member's role or remove them. Only creator/admin can do this.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |
| target_uid | int | yes | User ID to modify |
| role | string | no | New role: `"admin"` or `"member"` |
| remove | bool | no | Set `true` to remove the member |

```json
// Promote to admin
{
    "function": "update_workspace_member",
    "kwargs": { "wsid": 1, "target_uid": 3, "role": "admin" }
}

// Remove member
{
    "function": "update_workspace_member",
    "kwargs": { "wsid": 1, "target_uid": 4, "remove": true }
}
```

---

### 3. Channels

#### `get_channels`

List channels in a workspace visible to the current user.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |

```json
{
    "function": "get_channels",
    "kwargs": { "wsid": 1 }
}
```

Response:

```json
{
    "ok": true,
    "data": [
        { "chid": 1, "chname": "general", "chtype": "public" },
        { "chid": 2, "chname": "hiring-committee", "chtype": "private" }
    ]
}
```

---

#### `create_channel`

Create a new channel in a workspace. Must be an accepted workspace member.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |
| chname | string | yes | Channel name |
| chtype | string | no | `"public"` (default), `"private"`, or `"direct"` |

```json
{
    "function": "create_channel",
    "kwargs": { "wsid": 1, "chname": "random", "chtype": "public" }
}
```

Response:

```json
{ "ok": true, "data": { "chid": 7, "chname": "random", "chtype": "public" } }
```

---

#### `invite_to_channel`

Invite a user to a channel.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| chid | int | yes | Channel ID |
| invitee_uid | int | yes | User ID to invite |

```json
{
    "function": "invite_to_channel",
    "kwargs": { "chid": 1, "invitee_uid": 5 }
}
```

---

#### `respond_channel_invite`

Accept or reject a channel invitation.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| chid | int | yes | Channel ID |
| accept | bool | yes | `true` = accept, `false` = reject |

```json
{
    "function": "respond_channel_invite",
    "kwargs": { "chid": 2, "accept": true }
}
```

---

### 4. Invitations

#### `get_invitations`

Get all pending invitations (both workspace and channel) for the current user. No parameters.

```json
{ "function": "get_invitations" }
```

Response:

```json
{
    "ok": true,
    "data": [
        { "type": "workspace", "id": 2, "name": "Robotics Club" },
        { "type": "channel", "id": 5, "name": "competitions" }
    ]
}
```

---

### 5. Messages

#### `get_messages`

Get all messages in a channel, sorted chronologically.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| chid | int | yes | Channel ID |

```json
{
    "function": "get_messages",
    "kwargs": { "chid": 1 }
}
```

Response:

```json
{
    "ok": true,
    "data": [
        { "msgid": 1, "username": "alicezhang", "email": "az1234@nyu.edu", "content": "Welcome!", "postat": "2026-04-01T09:00:00" },
        { "msgid": 2, "username": "bobsmith", "email": "bs5678@nyu.edu", "content": "Thanks!", "postat": "2026-04-01T09:05:00" }
    ]
}
```

---

#### `send_message`

Send a message to a channel.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| chid | int | yes | Channel ID |
| content | string | yes | Message text |

```json
{
    "function": "send_message",
    "kwargs": { "chid": 1, "content": "Hello everyone!" }
}
```

Response:

```json
{ "ok": true, "data": { "msgid": 16, "postat": "2026-04-22T15:30:00" } }
```

---

#### `search_messages`

Search messages the current user has access to by keyword.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| keyword | string | yes | Search keyword (case-insensitive) |

```json
{
    "function": "search_messages",
    "kwargs": { "keyword": "perpendicular" }
}
```

Response:

```json
{
    "ok": true,
    "data": [
        { "msgid": 3, "chname": "general", "author": "carolwang", "content": "Is the new curriculum perpendicular...", "postat": "2026-04-01T09:10:00" }
    ]
}
```

---

#### `get_user_messages`

Get all messages posted by a specific user.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| target_uid | int | yes | User ID |

```json
{
    "function": "get_user_messages",
    "kwargs": { "target_uid": 1 }
}
```

---

### 6. Users

#### `search_users`

Search users by username or email. Useful for the invite UI.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| query | string | yes | Search string (case-insensitive, partial match) |

```json
{
    "function": "search_users",
    "kwargs": { "query": "alice" }
}
```

Response:

```json
{
    "ok": true,
    "data": [
        { "uid": 1, "email": "az1234@nyu.edu", "username": "alicezhang", "nickname": "Alice" }
    ]
}
```

---

### 7. Admin / Report Queries

#### `get_workspace_admins`

List all administrators (creator + admin) of a workspace.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |

```json
{
    "function": "get_workspace_admins",
    "kwargs": { "wsid": 1 }
}
```

---

#### `get_pending_channel_invites`

List public channels with pending invitations older than 5 days.

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| wsid | int | yes | Workspace ID |

```json
{
    "function": "get_pending_channel_invites",
    "kwargs": { "wsid": 1 }
}
```

---

### 8. System

#### `initialize`

Reset the entire database: drops all tables, recreates the schema, and inserts test data. Also clears the current session.

**WARNING**: This destroys all existing data!

```json
{ "function": "initialize" }
```

Response:

```json
{ "ok": true, "data": { "ok": true, "message": "Database reset with test data" } }
```

---

## Quick Reference Table

| # | Function | Params | Auth? | Description |
|---|----------|--------|-------|-------------|
| 1 | `register` | email, username, nickname, password | no | Create account |
| 2 | `login` | email, password | no | Log in |
| 3 | `logout` | — | yes | Log out |
| 4 | `me` | — | yes | Current user info |
| 5 | `get_workspaces` | — | yes | My workspaces |
| 6 | `create_workspace` | wsname, wsdescription? | yes | Create workspace |
| 7 | `get_workspace_members` | wsid | no | List members |
| 8 | `invite_to_workspace` | wsid, invitee_uid | yes | Invite user (creator/admin only) |
| 9 | `respond_workspace_invite` | wsid, accept | yes | Accept/reject invite |
| 10 | `update_workspace_member` | wsid, target_uid, role?, remove? | yes | Change role / remove (creator/admin only) |
| 11 | `get_channels` | wsid | yes | List channels |
| 12 | `create_channel` | wsid, chname, chtype? | yes | Create channel |
| 13 | `invite_to_channel` | chid, invitee_uid | yes | Invite to channel |
| 14 | `respond_channel_invite` | chid, accept | yes | Accept/reject channel invite |
| 15 | `get_invitations` | — | yes | All pending invites |
| 16 | `get_messages` | chid | yes | Channel messages |
| 17 | `send_message` | chid, content | yes | Send message |
| 18 | `search_messages` | keyword | yes | Search messages |
| 19 | `get_user_messages` | target_uid | no | User's messages |
| 20 | `search_users` | query | no | Search users |
| 21 | `get_workspace_admins` | wsid | no | Workspace admins |
| 22 | `get_pending_channel_invites` | wsid | no | Stale pending invites |
| 23 | `initialize` | — | no | Reset DB with test data |

## Test Page

Visit `http://localhost:8000/test/` (or just `http://localhost:8000/`) to open the interactive API tester. Every function has a button with input fields — fill in values and click to call.

## Test Accounts

After calling `initialize` (or on first `docker compose up`), the database has these users:

| Email | Username | Nickname | Password | UID |
|-------|----------|----------|----------|-----|
| az1234@nyu.edu | alicezhang | Alice | `alice123` | 1 |
| bs5678@nyu.edu | bobsmith | Bob | `bob456` | 2 |
| cw9012@nyu.edu | carolwang | Carol | `carol789` | 3 |
| dj3456@nyu.edu | davejohnson | Dave | `dave012` | 4 |
| ec7890@nyu.edu | evechen | Eve | `eve345` | 5 |
| fl2345@nyu.edu | frankli | Frank | `frank678` | 6 |

### Test Data Summary

- **2 workspaces**: CS Department (wsid=1), Tandon Robotics Club (wsid=2)
- **6 channels**: general (1), hiring-committee (2), DM (3), events (4), competitions (5), DM (6)
- **15 messages** across channels
- Alice is creator of workspace 1; Bob is creator of workspace 2
- Eve has a pending invite to workspace 1; Alice has a pending invite to workspace 2

### Quick Test Flow

```
1. Call initialize          → reset DB
2. Call login               → email: az1234@nyu.edu, password: alice123
3. Call get_workspaces      → see Alice's workspaces
4. Call get_channels        → wsid: 1
5. Call get_messages        → chid: 1
6. Call send_message        → chid: 1, content: Hello!
```

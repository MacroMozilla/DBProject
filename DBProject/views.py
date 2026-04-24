"""
snickr backend — single RPC endpoint (Django view)
POST /api/core  { "function": "xxx", "args": [], "kwargs": {} }
"""

import json, hashlib, inspect, os
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db import connection, transaction
from django.shortcuts import render


def _hash(pw):
    return hashlib.sha256(pw.encode()).hexdigest()


def _dictfetchall(cursor):
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]


def _dictfetchone(cursor):
    columns = [col[0] for col in cursor.description]
    row = cursor.fetchone()
    return dict(zip(columns, row)) if row else None


# ── registry ────────────────────────────────────────────────────
FUNCTIONS = {}


def rpc(fn):
    FUNCTIONS[fn.__name__] = fn
    return fn


# ── auth ────────────────────────────────────────────────────────

@rpc
def register(request, email, username, nickname, password):
    with connection.cursor() as c:
        c.execute(
            "INSERT INTO users (email, username, nickname, pwhash) "
            "VALUES (%s, %s, %s, %s) RETURNING uid, email, username, nickname",
            [email, username, nickname, _hash(password)],
        )
        user = _dictfetchone(c)
    request.session["uid"] = user["uid"]
    return user


@rpc
def login(request, username, password):
    with connection.cursor() as c:
        c.execute(
            """
            SELECT uid, email, username, nickname, pwhash
            FROM users
            WHERE username = %s
            """,
            [username],
        )
        user = _dictfetchone(c)

    if not user or user["pwhash"] != _hash(password):
        return {"error": "invalid credentials"}

    request.session["uid"] = user["uid"]

    del user["pwhash"]
    return user

@rpc
def logout(request):
    request.session.flush()
    return {"ok": True}


@rpc
def me(request):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "SELECT uid, email, username, nickname FROM users WHERE uid = %s", [uid]
        )
        return _dictfetchone(c)


# ── workspace ───────────────────────────────────────────────────

@rpc
def get_workspaces(request):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "SELECT w.wsid, w.wsname, w.wsdescription, wm.role, wm.status "
            "FROM workspaces w "
            "JOIN workspace_members wm ON w.wsid = wm.wsid "
            "WHERE wm.uid = %s AND wm.status = 'accepted' ORDER BY w.wsid",
            [uid],
        )
        return _dictfetchall(c)


@rpc
def create_workspace(request, wsname, wsdescription=""):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "INSERT INTO workspaces (wsname, wsdescription) VALUES (%s, %s) RETURNING wsid",
                [wsname, wsdescription],
            )
            wsid = _dictfetchone(c)["wsid"]
            c.execute(
                "INSERT INTO workspace_members (wsid, uid, role, status) "
                "VALUES (%s, %s, 'creator', 'accepted')",
                [wsid, uid],
            )
    return {"wsid": wsid, "wsname": wsname}


@rpc
def get_workspace_members(request, wsid):
    with connection.cursor() as c:
        c.execute(
            "SELECT u.uid, u.email, u.username, u.nickname, wm.role, wm.status "
            "FROM workspace_members wm JOIN users u ON wm.uid = u.uid "
            "WHERE wm.wsid = %s ORDER BY wm.role, u.username",
            [wsid],
        )
        return _dictfetchall(c)


@rpc
def invite_to_workspace(request, wsid, invitee_uid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "SELECT role FROM workspace_members "
                "WHERE wsid=%s AND uid=%s AND status='accepted'",
                [wsid, uid],
            )
            role = _dictfetchone(c)
            if not role or role["role"] not in ("creator", "admin"):
                return {"error": "not authorized"}
            c.execute(
                "INSERT INTO workspace_members (wsid, uid, role, status) "
                "VALUES (%s, %s, 'member', 'pending') "
                "ON CONFLICT (wsid, uid) DO NOTHING",
                [wsid, invitee_uid],
            )
    return {"ok": True}


@rpc
def respond_workspace_invite(request, wsid, accept):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    status = "accepted" if accept else "rejected"
    with connection.cursor() as c:
        c.execute(
            "UPDATE workspace_members SET status=%s, updatedat=CURRENT_TIMESTAMP "
            "WHERE wsid=%s AND uid=%s AND status='pending'",
            [status, wsid, uid],
        )
    return {"ok": True}


@rpc
def update_workspace_member(request, wsid, target_uid, role=None, remove=False):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "SELECT role FROM workspace_members "
                "WHERE wsid=%s AND uid=%s AND status='accepted'",
                [wsid, uid],
            )
            my_role = _dictfetchone(c)
            if not my_role or my_role["role"] not in ("creator", "admin"):
                return {"error": "not authorized"}
            if remove:
                c.execute(
                    "DELETE FROM workspace_members WHERE wsid=%s AND uid=%s",
                    [wsid, target_uid],
                )
            elif role:
                c.execute(
                    "UPDATE workspace_members SET role=%s, updatedat=CURRENT_TIMESTAMP "
                    "WHERE wsid=%s AND uid=%s",
                    [role, wsid, target_uid],
                )
    return {"ok": True}


# ── channel ─────────────────────────────────────────────────────

@rpc
def get_channels(request, wsid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            """
            SELECT c.chid, c.chname, c.chtype,
                   COALESCE((
                       SELECT COUNT(*)
                       FROM messages m
                       WHERE m.chid = c.chid
                         AND (cm.last_read_msgid IS NULL OR m.msgid > cm.last_read_msgid)
                   ), 0) AS unread_count
            FROM channels c
            INNER JOIN channel_members cm ON c.chid = cm.chid AND cm.uid = %s
            WHERE c.wsid = %s
              AND cm.status = 'accepted'
            ORDER BY c.chtype, c.chname
            """,
            [uid, wsid],
        )
        return _dictfetchall(c)


@rpc
def mark_channel_read(request, chid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            """
            UPDATE channel_members
            SET last_read_msgid = (
                SELECT COALESCE(MAX(msgid), 0) FROM messages WHERE chid = %s
            ),
            updatedat = CURRENT_TIMESTAMP
            WHERE chid = %s AND uid = %s
            """,
            [chid, chid, uid],
        )
    return {"ok": True}


@rpc
def mark_channel_read(request, chid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            """
            UPDATE channel_members
            SET last_read_msgid = (
                SELECT COALESCE(MAX(msgid), 0) FROM messages WHERE chid = %s
            ),
            updatedat = CURRENT_TIMESTAMP
            WHERE chid = %s AND uid = %s
            """,
            [chid, chid, uid],
        )
    return {"ok": True}


@rpc
def create_channel(request, wsid, chname, chtype="public"):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "SELECT 1 FROM workspace_members "
                "WHERE wsid=%s AND uid=%s AND status='accepted'",
                [wsid, uid],
            )
            if not c.fetchone():
                return {"error": "not a member of this workspace"}
            c.execute(
                "INSERT INTO channels (wsid, chname, chtype) VALUES (%s, %s, %s) RETURNING chid",
                [wsid, chname, chtype],
            )
            chid = _dictfetchone(c)["chid"]
            c.execute(
                "INSERT INTO channel_members (chid, uid, role, status) "
                "VALUES (%s, %s, 'creator', 'accepted')",
                [chid, uid],
            )
    return {"chid": chid, "chname": chname, "chtype": chtype}


@rpc
def invite_to_channel(request, chid, invitee_uid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "INSERT INTO channel_members (chid, uid, role, status) "
            "VALUES (%s, %s, 'member', 'pending') "
            "ON CONFLICT (chid, uid) DO NOTHING",
            [chid, invitee_uid],
        )
    return {"ok": True}


@rpc
def respond_channel_invite(request, chid, accept):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    status = "accepted" if accept else "rejected"
    with connection.cursor() as c:
        c.execute(
            "UPDATE channel_members SET status=%s, updatedat=CURRENT_TIMESTAMP "
            "WHERE chid=%s AND uid=%s AND status='pending'",
            [status, chid, uid],
        )
    return {"ok": True}


# ── invitations ─────────────────────────────────────────────────

@rpc
def get_invitations(request):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "SELECT 'workspace' AS type, w.wsid AS id, w.wsname AS name "
            "FROM workspace_members wm JOIN workspaces w ON wm.wsid = w.wsid "
            "WHERE wm.uid = %s AND wm.status = 'pending'",
            [uid],
        )
        ws = _dictfetchall(c)
        c.execute(
            "SELECT 'channel' AS type, c.chid AS id, c.chname AS name "
            "FROM channel_members cm JOIN channels c ON cm.chid = c.chid "
            "WHERE cm.uid = %s AND cm.status = 'pending'",
            [uid],
        )
        ch = _dictfetchall(c)
    return ws + ch


# ── messages ────────────────────────────────────────────────────

@rpc
def get_messages(request, chid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "SELECT m.msgid, u.username, u.email, m.content, "
            "       to_char(m.postat, 'YYYY-MM-DD\"T\"HH24:MI:SS') AS postat "
            "FROM messages m JOIN users u ON m.uid = u.uid "
            "WHERE m.chid = %s ORDER BY m.postat ASC",
            [chid],
        )
        return _dictfetchall(c)


@rpc
def send_message(request, chid, content):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "INSERT INTO messages (chid, uid, content) VALUES (%s, %s, %s) "
            "RETURNING msgid, to_char(postat, 'YYYY-MM-DD\"T\"HH24:MI:SS') AS postat",
            [chid, uid, content],
        )
        return _dictfetchone(c)


@rpc
def search_messages(request, keyword):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            """
            SELECT m.msgid, m.chid, c.chname, c.wsid,
                   w.wsname, u.username AS author, m.content,
                   to_char(m.postat, 'YYYY-MM-DD"T"HH24:MI:SS') AS postat
            FROM messages m
            JOIN channels c ON m.chid = c.chid
            JOIN workspaces w ON c.wsid = w.wsid
            JOIN users u ON m.uid = u.uid
            JOIN channel_members cm ON c.chid = cm.chid AND cm.uid = %s
            JOIN workspace_members wm ON c.wsid = wm.wsid AND wm.uid = %s
            WHERE cm.status = 'accepted' AND wm.status = 'accepted'
              AND m.content ILIKE '%%' || %s || '%%'
            ORDER BY m.postat DESC
            LIMIT 50
            """,
            [uid, uid, keyword],
        )
        return _dictfetchall(c)


@rpc
def get_user_messages(request, target_uid):
    with connection.cursor() as c:
        c.execute(
            "SELECT m.msgid, c.chname, m.content, "
            "       to_char(m.postat, 'YYYY-MM-DD\"T\"HH24:MI:SS') AS postat "
            "FROM messages m JOIN channels c ON m.chid = c.chid "
            "WHERE m.uid = %s ORDER BY m.postat DESC",
            [target_uid],
        )
        return _dictfetchall(c)


# ── users ───────────────────────────────────────────────────────

@rpc
def search_users(request, query):
    with connection.cursor() as c:
        c.execute(
            "SELECT uid, email, username, nickname FROM users "
            "WHERE username ILIKE %s OR email ILIKE %s LIMIT 20",
            [f"%{query}%", f"%{query}%"],
        )
        return _dictfetchall(c)


# ── report queries ──────────────────────────────────────────────

@rpc
def get_workspace_admins(request, wsid):
    with connection.cursor() as c:
        c.execute(
            "SELECT u.uid, u.email, u.username, wm.role "
            "FROM workspace_members wm JOIN users u ON wm.uid = u.uid "
            "WHERE wm.wsid = %s AND wm.role IN ('creator','admin') "
            "  AND wm.status = 'accepted' ORDER BY wm.role",
            [wsid],
        )
        return _dictfetchall(c)


@rpc
def get_pending_channel_invites(request, wsid):
    with connection.cursor() as c:
        c.execute(
            "SELECT c.chid, c.chname, COUNT(cm.uid) AS pending_count "
            "FROM channels c "
            "LEFT JOIN channel_members cm ON c.chid = cm.chid "
            "  AND cm.status = 'pending' "
            "  AND cm.createdat < CURRENT_TIMESTAMP - INTERVAL '5 days' "
            "WHERE c.wsid = %s AND c.chtype = 'public' "
            "GROUP BY c.chid, c.chname ORDER BY c.chid",
            [wsid],
        )
        return _dictfetchall(c)


# ── initialize (reset DB) ──────────────────────────────────────

@rpc
def initialize(request):
    sql_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "sqls")
    with transaction.atomic():
        with connection.cursor() as c:
            with open(os.path.join(sql_dir, "initialize.sql")) as f:
                c.execute(f.read())
            with open(os.path.join(sql_dir, "insert.sql")) as f:
                c.execute(f.read())
    request.session.flush()
    return {"ok": True, "message": "Database reset with test data"}


# ── test page ──────────────────────────────────────────────────

def test_page(request):
    fn_list = []
    for name, fn in FUNCTIONS.items():
        sig = inspect.signature(fn)
        params = [p for p in sig.parameters if p != "request"]
        fn_list.append({"name": name, "params": params})
    return render(request, "simple/test.html", {"functions": fn_list})


def react_app(request):
    """Serve the React SPA index.html for all non-API routes."""
    from django.conf import settings
    from django.http import FileResponse
    index = settings.REACT_BUILD_DIR / "index.html"
    if index.exists():
        return FileResponse(open(index, "rb"), content_type="text/html")
    return render(request, "simple/test.html", {"functions": []})


# ── the single RPC endpoint ────────────────────────────────────

@csrf_exempt
def api_core(request):
    if request.method != "POST":
        return JsonResponse({"error": "POST only"}, status=405)

    try:
        data = json.loads(request.body)
    except json.JSONDecodeError:
        return JsonResponse({"error": "invalid JSON"}, status=400)

    fn_name = data.get("function")
    args = data.get("args", [])
    kwargs = data.get("kwargs", {})

    if fn_name not in FUNCTIONS:
        return JsonResponse({"error": f"unknown function: {fn_name}"}, status=400)

    try:
        result = FUNCTIONS[fn_name](request, *args, **kwargs)
        return JsonResponse({"ok": True, "data": result})
    except Exception as e:
        return JsonResponse({"ok": False, "error": str(e)}, status=500)


def api_functions(request):
    out = {}
    for name, fn in FUNCTIONS.items():
        sig = inspect.signature(fn)
        out[name] = [p for p in sig.parameters if p != "request"]
    return JsonResponse(out)


# ── new functions added for project part 2 ──────────────────────

@rpc
def delete_channel(request, chid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "SELECT role FROM channel_members WHERE chid=%s AND uid=%s AND status='accepted'",
                [chid, uid],
            )
            row = _dictfetchone(c)
            if not row or row["role"] != "creator":
                return {"error": "only the channel creator can delete this channel"}
            c.execute("DELETE FROM messages WHERE chid=%s", [chid])
            c.execute("DELETE FROM channel_members WHERE chid=%s", [chid])
            c.execute("DELETE FROM channels WHERE chid=%s", [chid])
    return {"ok": True}


@rpc
def join_channel(request, chid):
    """Self-join a public channel."""
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute("SELECT chtype FROM channels WHERE chid=%s", [chid])
        row = _dictfetchone(c)
        if not row:
            return {"error": "channel not found"}
        if row["chtype"] != "public":
            return {"error": "can only self-join public channels"}
        c.execute(
            "INSERT INTO channel_members (chid, uid, role, status) "
            "VALUES (%s, %s, 'member', 'accepted') "
            "ON CONFLICT (chid, uid) DO UPDATE SET status='accepted'",
            [chid, uid],
        )
    return {"ok": True}


@rpc
def leave_channel(request, chid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "DELETE FROM channel_members WHERE chid=%s AND uid=%s",
            [chid, uid],
        )
    return {"ok": True}


@rpc
def leave_workspace(request, wsid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            "SELECT role FROM workspace_members WHERE wsid=%s AND uid=%s",
            [wsid, uid],
        )
        row = _dictfetchone(c)
        if row and row["role"] == "creator":
            return {"error": "workspace creator cannot leave — delete the workspace instead"}
        c.execute(
            "DELETE FROM workspace_members WHERE wsid=%s AND uid=%s",
            [wsid, uid],
        )
    return {"ok": True}


@rpc
def get_public_channels(request, wsid):
    """Return public channels in a workspace the current user has NOT yet joined."""
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with connection.cursor() as c:
        c.execute(
            """
            SELECT c.chid, c.chname, c.chtype,
                   COUNT(cm2.uid) AS member_count
            FROM channels c
            LEFT JOIN channel_members cm2
                   ON c.chid = cm2.chid AND cm2.status = 'accepted'
            WHERE c.wsid = %s
              AND c.chtype = 'public'
              AND c.chid NOT IN (
                  SELECT chid FROM channel_members
                  WHERE uid = %s AND status = 'accepted'
              )
            GROUP BY c.chid, c.chname, c.chtype
            ORDER BY c.chname
            """,
            [wsid, uid],
        )
        return _dictfetchall(c)


@rpc
def get_channel_members(request, chid):
    with connection.cursor() as c:
        c.execute(
            "SELECT u.uid, u.username, u.nickname, cm.role, cm.status "
            "FROM channel_members cm JOIN users u ON cm.uid = u.uid "
            "WHERE cm.chid = %s ORDER BY cm.role, u.username",
            [chid],
        )
        return _dictfetchall(c)


@rpc
def delete_workspace(request, wsid):
    uid = request.session.get("uid")
    if not uid:
        return {"error": "not logged in"}
    with transaction.atomic():
        with connection.cursor() as c:
            c.execute(
                "SELECT role FROM workspace_members WHERE wsid=%s AND uid=%s",
                [wsid, uid],
            )
            row = _dictfetchone(c)
            if not row or row["role"] != "creator":
                return {"error": "only the workspace creator can delete it"}
            # Cascade: messages → channel_members → channels → workspace_members → workspace
            c.execute("DELETE FROM messages WHERE chid IN (SELECT chid FROM channels WHERE wsid=%s)", [wsid])
            c.execute("DELETE FROM channel_members WHERE chid IN (SELECT chid FROM channels WHERE wsid=%s)", [wsid])
            c.execute("DELETE FROM channels WHERE wsid=%s", [wsid])
            c.execute("DELETE FROM workspace_members WHERE wsid=%s", [wsid])
            c.execute("DELETE FROM workspaces WHERE wsid=%s", [wsid])
    return {"ok": True}

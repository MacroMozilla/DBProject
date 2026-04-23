import json
from django.shortcuts import render
from django.http import JsonResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def send_message(request):
    body = json.loads(request.body)

    with connection.cursor() as cursor:
        cursor.execute("""
            INSERT INTO messages (chid, uid, content)
            VALUES (%s, %s, %s)
        """, [body["chid"], body["uid"], body["content"]])

    return JsonResponse({"status": "ok"})

def get_messages(request):
    chid = request.GET.get("chid")

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT m.msgid, u.username, m.content, m.postat
            FROM messages m
            JOIN users u ON m.uid = u.uid
            WHERE m.chid = %s
            ORDER BY m.postat ASC
        """, [chid])

        rows = cursor.fetchall()

    data = [
        {
            "msgid": r[0],
            "username": r[1],
            "content": r[2],
            "postat": str(r[3])
        }
        for r in rows
    ]

    return JsonResponse(data, safe=False)

def get_channels(request):
    wsid = request.GET.get("wsid")

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT chid, chname
            FROM channels
            WHERE wsid = %s
        """, [wsid])

        rows = cursor.fetchall()

    data = [
        {"chid": r[0], "chname": r[1] or "DM"}
        for r in rows
    ]

    return JsonResponse(data, safe=False)

def get_workspaces(request):
    uid = request.GET.get("uid")

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT w.wsid, w.wsname
            FROM workspaces w
            JOIN workspace_members wm ON w.wsid = wm.wsid
            WHERE wm.uid = %s AND wm.status = 'accepted'
        """, [uid])

        rows = cursor.fetchall()

    data = [
        {"wsid": r[0], "wsname": r[1]}
        for r in rows
    ]

    return JsonResponse(data, safe=False)

def get_invites(request):
    uid = request.GET.get("uid")

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT w.wsname, wm.wsid
            FROM workspace_members wm
            JOIN workspaces w ON wm.wsid = w.wsid
            WHERE wm.uid = %s AND wm.status = 'pending'
        """, [uid])

        rows = cursor.fetchall()

    data = [
        {"wsid": r[1], "wsname": r[0]}
        for r in rows
    ]

    return JsonResponse(data, safe=False)

@csrf_exempt
def accept_invite(request):
    body = json.loads(request.body)

    with connection.cursor() as cursor:
        cursor.execute("""
            UPDATE workspace_members
            SET status = 'accepted'
            WHERE wsid = %s AND uid = %s
        """, [body["wsid"], body["uid"]])

    return JsonResponse({"status": "accepted"})


@csrf_exempt
def reject_invite(request):
    body = json.loads(request.body)

    with connection.cursor() as cursor:
        cursor.execute("""
            UPDATE workspace_members
            SET status = 'rejected'
            WHERE wsid = %s AND uid = %s
        """, [body["wsid"], body["uid"]])

    return JsonResponse({"status": "rejected"})
-- SQL Queries for DBProject (snickr)
-- Part (c)

-- ============================================================
-- Define procedures and functions first (no result sets)
-- ============================================================

-- (1) Create a new user account, with email, name, nickname, and password.
CREATE OR REPLACE PROCEDURE create_user(
    p_email    VARCHAR,
    p_username VARCHAR,
    p_nickname VARCHAR,
    p_pwhash   VARCHAR
)
LANGUAGE SQL
AS $$
    INSERT INTO users (email, username, nickname, pwhash)
    VALUES (p_email, p_username, p_nickname, p_pwhash);
$$;

-- (2) Create a new public channel inside a workspace by a particular user.
--     (Make sure to check that the user is authorized to do so.)
CREATE OR REPLACE PROCEDURE create_public_channel(
    p_wsid    INT,
    p_uid     INT,
    p_chname  VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_chid INT;
BEGIN
    -- Check if the user is an accepted member of the workspace
    IF NOT EXISTS (
        SELECT 1 FROM workspace_members
        WHERE wsid = p_wsid AND uid = p_uid AND accepted = TRUE
    ) THEN
        RAISE EXCEPTION 'User % is not an accepted member of workspace %', p_uid, p_wsid;
    END IF;

    -- Create the public channel
    INSERT INTO channels (wsid, chname, chtype)
    VALUES (p_wsid, p_chname, 'public')
    RETURNING chid INTO v_chid;

    -- Add the creator as a channel member
    INSERT INTO channel_members (chid, uid, role, accepted)
    VALUES (v_chid, p_uid, 'creator', TRUE);
END;
$$;

-- (5) For a particular channel, list all messages in chronological order.
CREATE OR REPLACE FUNCTION list_channel_messages(p_chid INT)
RETURNS TABLE (
    msgid    INT,
    email    VARCHAR,
    username VARCHAR,
    content  TEXT,
    postat   TIMESTAMP
)
LANGUAGE SQL
AS $$
    SELECT m.msgid, u.email, u.username, m.content, m.postat
    FROM messages m
    JOIN users u ON m.uid = u.uid
    WHERE m.chid = p_chid
    ORDER BY m.postat ASC;
$$;

-- (7) For a particular user, list all messages that are accessible to this user
--     and that contain a given keyword in the body of the message.
CREATE OR REPLACE FUNCTION search_accessible_messages(p_uid INT, p_keyword VARCHAR)
RETURNS TABLE (
    msgid    INT,
    chname   VARCHAR,
    author   VARCHAR,
    content  TEXT,
    postat   TIMESTAMP
)
LANGUAGE SQL
AS $$
    SELECT m.msgid, c.chname, u.email AS author, m.content, m.postat
    FROM messages m
    JOIN channels c ON m.chid = c.chid
    JOIN users u ON m.uid = u.uid
    JOIN channel_members cm ON c.chid = cm.chid AND cm.uid = p_uid
    JOIN workspace_members wm ON c.wsid = wm.wsid AND wm.uid = p_uid
    WHERE cm.accepted = TRUE
      AND wm.accepted = TRUE
      AND m.content ILIKE '%' || p_keyword || '%'
    ORDER BY m.postat DESC;
$$;


-- ============================================================
-- Execute queries 1–7 (each produces one result tab)
-- ============================================================

-- (1) Create a new user account (commented out to avoid duplicate inserts)
-- CALL create_user('gz1234@nyu.edu', 'gracezhu', 'Grace', 'a1b2c3d4e5f6');

-- (2) Create a new public channel (commented out to avoid duplicate inserts)
-- CALL create_public_channel(1, 1, 'announcements');

-- (3) For each workspace, list all current administrators
SELECT w.wsid, w.wsname, u.email, u.username, wm.role
FROM workspaces w
JOIN workspace_members wm ON w.wsid = wm.wsid
JOIN users u ON wm.uid = u.uid
WHERE wm.role IN ('creator', 'admin') AND wm.accepted = TRUE
ORDER BY w.wsid, wm.role;

-- (4) Pending invitations per public channel (>5 days, not yet joined)
SELECT c.chid, c.chname, COUNT(cm.uid) AS pending_count
FROM channels c
LEFT JOIN channel_members cm ON c.chid = cm.chid
    AND cm.accepted = FALSE
    AND cm.createdat < CURRENT_TIMESTAMP - INTERVAL '5 days'
WHERE c.wsid = 1 AND c.chtype = 'public'
GROUP BY c.chid, c.chname
ORDER BY c.chid;

-- (5) List all messages in channel 1 (chronological)
SELECT * FROM list_channel_messages(1);

-- (6) All messages posted by a particular user
SELECT m.msgid, c.chname, m.content, m.postat
FROM messages m
JOIN channels c ON m.chid = c.chid
WHERE m.uid = 1
ORDER BY m.postat DESC;

-- (7) Search accessible messages containing 'perpendicular'
SELECT * FROM search_accessible_messages(1, 'perpendicular');

-- Initialize database schema for DBProject (snickr)
-- PostgreSQL

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS channel_members;
DROP TABLE IF EXISTS channels;
DROP TABLE IF EXISTS workspace_members;
DROP TABLE IF EXISTS workspaces;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    uid         SERIAL       PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    username    VARCHAR(50)  NOT NULL,
    nickname    VARCHAR(50),
    pwhash      VARCHAR(255) NOT NULL,
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workspaces (
    wsid        SERIAL       PRIMARY KEY,
    wsname      VARCHAR(100) NOT NULL,
    wsdescription TEXT,
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workspace_members (
    wsid        INT NOT NULL REFERENCES workspaces(wsid) ON DELETE CASCADE,
    uid         INT NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    role        VARCHAR(10) NOT NULL CHECK (role IN ('creator', 'admin', 'member')),
    status      VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'accepted', 'rejected')) DEFAULT 'pending',
    createdat   TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wsid, uid)
);

CREATE TABLE channels (
    chid        SERIAL       PRIMARY KEY,
    wsid        INT NOT NULL REFERENCES workspaces(wsid) ON DELETE CASCADE,
    chname      VARCHAR(100),  
    chtype      VARCHAR(10) NOT NULL CHECK (chtype IN ('public', 'private', 'direct')),
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE channel_members (
    chid        INT NOT NULL REFERENCES channels(chid) ON DELETE CASCADE,
    uid         INT NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    role        VARCHAR(10) NOT NULL CHECK (role IN ('creator', 'member')),
    status      VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'accepted', 'rejected')) DEFAULT 'pending',
    last_read_msgid INT,
    createdat   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chid, uid)
);

CREATE TABLE messages (
    msgid       SERIAL       PRIMARY KEY,
    chid        INT NOT NULL REFERENCES channels(chid) ON DELETE CASCADE,
    uid         INT NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    content     TEXT         NOT NULL,
    postat      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
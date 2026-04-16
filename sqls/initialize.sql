-- Initialize database schema for DBProject (snickr)
-- PostgreSQL

CREATE TABLE users (
    email       VARCHAR(255) PRIMARY KEY,
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
    wsid        INT          NOT NULL REFERENCES workspaces(wsid),
    email       VARCHAR(255) NOT NULL REFERENCES users(email),
    role        VARCHAR(10)  NOT NULL CHECK (role IN ('creator', 'admin', 'member')),
    accepted    BOOLEAN      NOT NULL DEFAULT FALSE,
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wsid, email)
);

CREATE TABLE channels (
    chid        SERIAL       PRIMARY KEY,
    wsid        INT          NOT NULL REFERENCES workspaces(wsid),
    chname      VARCHAR(100),
    chtype      VARCHAR(10)  NOT NULL CHECK (chtype IN ('public', 'private', 'direct')),
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE channel_members (
    chid        INT          NOT NULL REFERENCES channels(chid),
    email       VARCHAR(255) NOT NULL REFERENCES users(email),
    role        VARCHAR(10)  NOT NULL CHECK (role IN ('creator', 'member')),
    accepted    BOOLEAN      NOT NULL DEFAULT FALSE,
    createdat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedat   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chid, email)
);

CREATE TABLE messages (
    msgid       SERIAL       PRIMARY KEY,
    chid        INT          NOT NULL REFERENCES channels(chid),
    email       VARCHAR(255) NOT NULL REFERENCES users(email),
    content     TEXT         NOT NULL,
    postat      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

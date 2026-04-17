-- Test data for DBProject (snickr)
-- Fake NYU-style data

-- ============================================================
-- Users (uid auto-assigned: alice=1, bob=2, carol=3, dave=4, eve=5, frank=6)
-- ============================================================
INSERT INTO users (email, username, nickname, pwhash) VALUES
('az1234@nyu.edu',  'alicezhang',   'Alice',   'hash_alice_123'),
('bs5678@nyu.edu',  'bobsmith',     'Bob',     'hash_bob_456'),
('cw9012@nyu.edu',  'carolwang',    'Carol',   'hash_carol_789'),
('dj3456@nyu.edu',  'davejohnson',  'Dave',    'hash_dave_012'),
('ec7890@nyu.edu',  'evechen',      'Eve',     'hash_eve_345'),
('fl2345@nyu.edu',  'frankli',      'Frank',   'hash_frank_678');

-- ============================================================
-- Workspaces
-- ============================================================
INSERT INTO workspaces (wsname, wsdescription) VALUES
('CS Department',  'NYU Computer Science faculty workspace'),
('Tandon Robotics Club', 'Student robotics club at NYU Tandon');

-- ============================================================
-- Workspace Members
-- ============================================================
-- CS Department (wsid=1): alice=creator, bob=admin, carol/dave=member, eve=invited not joined
INSERT INTO workspace_members (wsid, uid, role, accepted) VALUES
(1, 1, 'creator', TRUE),
(1, 2, 'admin',   TRUE),
(1, 3, 'member',  TRUE),
(1, 4, 'member',  TRUE),
(1, 5, 'member',  FALSE);

-- Tandon Robotics Club (wsid=2): bob=creator, carol=admin, dave/frank=member, alice=invited not joined
INSERT INTO workspace_members (wsid, uid, role, accepted) VALUES
(2, 2, 'creator', TRUE),
(2, 3, 'admin',   TRUE),
(2, 4, 'member',  TRUE),
(2, 6, 'member',  TRUE),
(2, 1, 'member',  FALSE);

-- ============================================================
-- Channels
-- ============================================================
-- CS Department channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(1, 'general',          'public'),
(1, 'hiring-committee', 'private'),
(1, 'direct',           'direct');

-- Tandon Robotics Club channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(2, 'events',       'public'),
(2, 'competitions', 'public'),
(2, 'direct',       'direct');

-- ============================================================
-- Channel Members
-- ============================================================
-- #general (chid=1): alice=creator, bob/carol joined, dave invited 6 days ago not joined
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(1, 1, 'creator', TRUE),
(1, 2, 'member',  TRUE),
(1, 3, 'member',  TRUE);
INSERT INTO channel_members (chid, uid, role, accepted, createdat) VALUES
(1, 4, 'member',  FALSE, CURRENT_TIMESTAMP - INTERVAL '6 days');

-- #hiring-committee (chid=2): alice=creator, bob joined
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(2, 1, 'creator', TRUE),
(2, 2, 'member',  TRUE);

-- alice-bob DM (chid=3): alice=creator, bob=member
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(3, 1, 'creator', TRUE),
(3, 2, 'member',  TRUE);

-- #events (chid=4): bob=creator, carol/dave joined, frank invited 7 days ago not joined
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(4, 2, 'creator', TRUE),
(4, 3, 'member',  TRUE),
(4, 4, 'member',  TRUE);
INSERT INTO channel_members (chid, uid, role, accepted, createdat) VALUES
(4, 6, 'member',  FALSE, CURRENT_TIMESTAMP - INTERVAL '7 days');

-- #competitions (chid=5): bob=creator, carol joined
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(5, 2, 'creator', TRUE),
(5, 3, 'member',  TRUE);

-- bob-carol DM (chid=6): bob=creator, carol=member
INSERT INTO channel_members (chid, uid, role, accepted) VALUES
(6, 2, 'creator', TRUE),
(6, 3, 'member',  TRUE);

-- ============================================================
-- Messages
-- ============================================================
-- #general (chid=1)
INSERT INTO messages (chid, uid, content, postat) VALUES
(1, 1, 'Welcome to the CS Department workspace!',            '2026-04-01 09:00:00'),
(1, 2, 'Thanks Alice! Excited to be here.',                  '2026-04-01 09:05:00'),
(1, 3, 'Is the new curriculum perpendicular to the old one?', '2026-04-01 09:10:00'),
(1, 1, 'Not exactly perpendicular, but quite different.',     '2026-04-01 09:15:00');

-- #hiring-committee (chid=2)
INSERT INTO messages (chid, uid, content, postat) VALUES
(2, 1, 'We need to review the new candidates.',     '2026-04-02 10:00:00'),
(2, 2, 'I will prepare the shortlist by Friday.',   '2026-04-02 10:30:00');

-- alice-bob DM (chid=3)
INSERT INTO messages (chid, uid, content, postat) VALUES
(3, 1, 'Bob, can you handle the seminar logistics?', '2026-04-03 14:00:00'),
(3, 2, 'Sure, I will book the room.',                '2026-04-03 14:05:00');

-- #events (chid=4)
INSERT INTO messages (chid, uid, content, postat) VALUES
(4, 2, 'Robotics demo day is coming up!',                     '2026-04-05 11:00:00'),
(4, 3, 'We should set up a perpendicular track for the bots.', '2026-04-05 11:15:00'),
(4, 4, 'I can bring the sensors and motors.',                  '2026-04-05 11:30:00');

-- #competitions (chid=5)
INSERT INTO messages (chid, uid, content, postat) VALUES
(5, 2, 'Registration for RoboNYU 2026 is open.',  '2026-04-06 08:00:00'),
(5, 3, 'Let us form a team of four.',             '2026-04-06 08:20:00');

-- bob-carol DM (chid=6)
INSERT INTO messages (chid, uid, content, postat) VALUES
(6, 2, 'Carol, are you free for a meeting tomorrow?', '2026-04-07 16:00:00'),
(6, 3, 'Yes, afternoon works for me.',                '2026-04-07 16:10:00');

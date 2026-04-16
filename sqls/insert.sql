-- Test data for DBProject (snickr)
-- Fake NYU-style data

-- ============================================================
-- Users
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
INSERT INTO workspace_members (wsid, email, role, accepted) VALUES
(1, 'az1234@nyu.edu', 'creator', TRUE),
(1, 'bs5678@nyu.edu', 'admin',   TRUE),
(1, 'cw9012@nyu.edu', 'member',  TRUE),
(1, 'dj3456@nyu.edu', 'member',  TRUE),
(1, 'ec7890@nyu.edu', 'member',  FALSE);

-- Tandon Robotics Club (wsid=2): bob=creator, carol=admin, dave/frank=member, alice=invited not joined
INSERT INTO workspace_members (wsid, email, role, accepted) VALUES
(2, 'bs5678@nyu.edu', 'creator', TRUE),
(2, 'cw9012@nyu.edu', 'admin',   TRUE),
(2, 'dj3456@nyu.edu', 'member',  TRUE),
(2, 'fl2345@nyu.edu', 'member',  TRUE),
(2, 'az1234@nyu.edu', 'member',  FALSE);

-- ============================================================
-- Channels
-- ============================================================
-- CS Department channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(1, 'general',          'public'),
(1, 'hiring-committee', 'private'),
(1, NULL,               'direct');

-- Tandon Robotics Club channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(2, 'events',       'public'),
(2, 'competitions', 'public'),
(2, NULL,           'direct');

-- ============================================================
-- Channel Members
-- ============================================================
-- #general (chid=1): alice=creator, bob/carol joined, dave invited 6 days ago not joined
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(1, 'az1234@nyu.edu', 'creator', TRUE),
(1, 'bs5678@nyu.edu', 'member',  TRUE),
(1, 'cw9012@nyu.edu', 'member',  TRUE);
INSERT INTO channel_members (chid, email, role, accepted, createdat) VALUES
(1, 'dj3456@nyu.edu', 'member',  FALSE, CURRENT_TIMESTAMP - INTERVAL '6 days');

-- #hiring-committee (chid=2): alice=creator, bob joined
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(2, 'az1234@nyu.edu', 'creator', TRUE),
(2, 'bs5678@nyu.edu', 'member',  TRUE);

-- alice-bob DM (chid=3): alice=creator, bob=member
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(3, 'az1234@nyu.edu', 'creator', TRUE),
(3, 'bs5678@nyu.edu', 'member',  TRUE);

-- #events (chid=4): bob=creator, carol/dave joined, frank invited 7 days ago not joined
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(4, 'bs5678@nyu.edu', 'creator', TRUE),
(4, 'cw9012@nyu.edu', 'member',  TRUE),
(4, 'dj3456@nyu.edu', 'member',  TRUE);
INSERT INTO channel_members (chid, email, role, accepted, createdat) VALUES
(4, 'fl2345@nyu.edu', 'member',  FALSE, CURRENT_TIMESTAMP - INTERVAL '7 days');

-- #competitions (chid=5): bob=creator, carol joined
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(5, 'bs5678@nyu.edu', 'creator', TRUE),
(5, 'cw9012@nyu.edu', 'member',  TRUE);

-- bob-carol DM (chid=6): bob=creator, carol=member
INSERT INTO channel_members (chid, email, role, accepted) VALUES
(6, 'bs5678@nyu.edu', 'creator', TRUE),
(6, 'cw9012@nyu.edu', 'member',  TRUE);

-- ============================================================
-- Messages
-- ============================================================
-- #general (chid=1)
INSERT INTO messages (chid, email, content, postat) VALUES
(1, 'az1234@nyu.edu', 'Welcome to the CS Department workspace!',            '2026-04-01 09:00:00'),
(1, 'bs5678@nyu.edu', 'Thanks Alice! Excited to be here.',                  '2026-04-01 09:05:00'),
(1, 'cw9012@nyu.edu', 'Is the new curriculum perpendicular to the old one?', '2026-04-01 09:10:00'),
(1, 'az1234@nyu.edu', 'Not exactly perpendicular, but quite different.',     '2026-04-01 09:15:00');

-- #hiring-committee (chid=2)
INSERT INTO messages (chid, email, content, postat) VALUES
(2, 'az1234@nyu.edu', 'We need to review the new candidates.',     '2026-04-02 10:00:00'),
(2, 'bs5678@nyu.edu', 'I will prepare the shortlist by Friday.',   '2026-04-02 10:30:00');

-- alice-bob DM (chid=3)
INSERT INTO messages (chid, email, content, postat) VALUES
(3, 'az1234@nyu.edu', 'Bob, can you handle the seminar logistics?', '2026-04-03 14:00:00'),
(3, 'bs5678@nyu.edu', 'Sure, I will book the room.',                '2026-04-03 14:05:00');

-- #events (chid=4)
INSERT INTO messages (chid, email, content, postat) VALUES
(4, 'bs5678@nyu.edu', 'Robotics demo day is coming up!',                     '2026-04-05 11:00:00'),
(4, 'cw9012@nyu.edu', 'We should set up a perpendicular track for the bots.', '2026-04-05 11:15:00'),
(4, 'dj3456@nyu.edu', 'I can bring the sensors and motors.',                  '2026-04-05 11:30:00');

-- #competitions (chid=5)
INSERT INTO messages (chid, email, content, postat) VALUES
(5, 'bs5678@nyu.edu', 'Registration for RoboNYU 2026 is open.',  '2026-04-06 08:00:00'),
(5, 'cw9012@nyu.edu', 'Let us form a team of four.',             '2026-04-06 08:20:00');

-- bob-carol DM (chid=6)
INSERT INTO messages (chid, email, content, postat) VALUES
(6, 'bs5678@nyu.edu', 'Carol, are you free for a meeting tomorrow?', '2026-04-07 16:00:00'),
(6, 'cw9012@nyu.edu', 'Yes, afternoon works for me.',                '2026-04-07 16:10:00');

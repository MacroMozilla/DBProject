-- Test data for DBProject (snickr)
-- Fake NYU-style data
-- Passwords are SHA-256 hashes of the plaintext shown in comments

-- ============================================================
-- Users (see docs/api.md for login credentials)
-- ============================================================
INSERT INTO users (email, username, nickname, pwhash) VALUES
('az1234@nyu.edu',  'alicezhang',   'Alice',   '4e40e8ffe0ee32fa53e139147ed559229a5930f89c2204706fc174beb36210b3'),  -- alice123
('bs5678@nyu.edu',  'bobsmith',     'Bob',     'ed4d9437294706c60027d39427f6f5850870625544bb77722aac19f97495b2b7'),  -- bob456
('cw9012@nyu.edu',  'carolwang',    'Carol',   'dae1889176856be72020e4f0e100d4baa7fbbc95c513b585fb30b99e56fd98d5'),  -- carol789
('dj3456@nyu.edu',  'davejohnson',  'Dave',    '66afe08203fcede78a06d84384306a995bb5c6313d56b6537248a31d025f7c53'),  -- dave012
('ec7890@nyu.edu',  'evechen',      'Eve',     '3c6ac0e335056e146d422e2d774cde5880763728cd9cdbed5a6f06e80ba70ae3'),  -- eve345
('fl2345@nyu.edu',  'frankli',      'Frank',   '1699a1f4e31831a0f531a18a829f41999d2c17df7e062ab5615d862bca488664');  -- frank678

-- ============================================================
-- Workspaces
-- ============================================================
INSERT INTO workspaces (wsname, wsdescription) VALUES
('CS Department',  'NYU Computer Science faculty workspace'),
('Tandon Robotics Club', 'Student robotics club at NYU Tandon');

-- ============================================================
-- Workspace Members
-- ============================================================
INSERT INTO workspace_members (wsid, uid, role, status) VALUES
(1, 1, 'creator', 'accepted'),
(1, 2, 'admin',   'accepted'),
(1, 3, 'member',  'accepted'),
(1, 4, 'member',  'accepted'),
(1, 5, 'member',  'pending');

INSERT INTO workspace_members (wsid, uid, role, status) VALUES
(2, 2, 'creator', 'accepted'),
(2, 3, 'admin',   'accepted'),
(2, 4, 'member',  'accepted'),
(2, 6, 'member',  'accepted'),
(2, 1, 'member',  'pending');

-- ============================================================
-- Channels
-- ============================================================
INSERT INTO channels (wsid, chname, chtype) VALUES
(1, 'general',          'public'),
(1, 'hiring-committee', 'private'),
(1, NULL,               'direct');  -- DM

INSERT INTO channels (wsid, chname, chtype) VALUES
(2, 'events',       'public'),
(2, 'competitions', 'public'),
(2, NULL,           'direct');  -- DM

-- ============================================================
-- Channel Members
-- ============================================================
INSERT INTO channel_members (chid, uid, role, status) VALUES
(1, 1, 'creator', 'accepted'),
(1, 2, 'member',  'accepted'),
(1, 3, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status, createdat) VALUES
(1, 4, 'member', 'pending', CURRENT_TIMESTAMP - INTERVAL '6 days');

INSERT INTO channel_members (chid, uid, role, status) VALUES
(2, 1, 'creator', 'accepted'),
(2, 2, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status) VALUES
(3, 1, 'creator', 'accepted'),
(3, 2, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status) VALUES
(4, 2, 'creator', 'accepted'),
(4, 3, 'member',  'accepted'),
(4, 4, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status, createdat) VALUES
(4, 6, 'member', 'pending', CURRENT_TIMESTAMP - INTERVAL '7 days');

INSERT INTO channel_members (chid, uid, role, status) VALUES
(5, 2, 'creator', 'accepted'),
(5, 3, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status) VALUES
(6, 2, 'creator', 'accepted'),
(6, 3, 'member',  'accepted');

-- ============================================================
-- Messages
-- ============================================================
INSERT INTO messages (chid, uid, content, postat) VALUES
(1, 1, 'Welcome to the CS Department workspace!',            '2026-04-01 09:00:00'),
(1, 2, 'Thanks Alice! Excited to be here.',                  '2026-04-01 09:05:00'),
(1, 3, 'Is the new curriculum perpendicular to the old one?', '2026-04-01 09:10:00'),
(1, 1, 'Not exactly perpendicular, but quite different.',     '2026-04-01 09:15:00'),

(2, 1, 'We need to review the new candidates.',     '2026-04-02 10:00:00'),
(2, 2, 'I will prepare the shortlist by Friday.',   '2026-04-02 10:30:00'),

(3, 1, 'Bob, can you handle the seminar logistics?', '2026-04-03 14:00:00'),
(3, 2, 'Sure, I will book the room.',                '2026-04-03 14:05:00'),

(4, 2, 'Robotics demo day is coming up!',                     '2026-04-05 11:00:00'),
(4, 3, 'We should set up a perpendicular track for the bots.', '2026-04-05 11:15:00'),
(4, 4, 'I can bring the sensors and motors.',                  '2026-04-05 11:30:00'),

(5, 2, 'Registration for RoboNYU 2026 is open.',  '2026-04-06 08:00:00'),
(5, 3, 'Let us form a team of four.',             '2026-04-06 08:20:00'),

(6, 2, 'Carol, are you free for a meeting tomorrow?', '2026-04-07 16:00:00'),
(6, 3, 'Yes, afternoon works for me.',                '2026-04-07 16:10:00');

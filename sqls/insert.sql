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
('fl2345@nyu.edu',  'frankli',      'Frank',   '1699a1f4e31831a0f531a18a829f41999d2c17df7e062ab5615d862bca488664'),  -- frank678
('gs6789@nyu.edu',  'gracesun',     'Grace',   'fbc1a9f858ea9e177916964bd88c3d37b91a1e84412765571b64f6313e1d3dd6'),  -- grace901
('hk1234@nyu.edu',  'henrykim',     'Henry',   'f3288b9d00c57b38eed6c15e1afaee0ec1a66c326affc54e24b7ebcf2e8b1fd5');  -- henry234

-- ============================================================
-- Workspaces
-- ============================================================
INSERT INTO workspaces (wsname, wsdescription) VALUES
('CS Department',         'NYU Computer Science faculty workspace'),
('Tandon Robotics Club',  'Student robotics club at NYU Tandon'),
('DB Project Team',       'CS6083 database project collaboration');

-- ============================================================
-- Workspace Members
-- ============================================================
-- WS1: CS Department
INSERT INTO workspace_members (wsid, uid, role, status) VALUES
(1, 1, 'creator', 'accepted'),
(1, 2, 'admin',   'accepted'),
(1, 3, 'member',  'accepted'),
(1, 4, 'member',  'accepted'),
(1, 5, 'member',  'pending'),
(1, 7, 'member',  'accepted');

-- WS2: Tandon Robotics Club
INSERT INTO workspace_members (wsid, uid, role, status) VALUES
(2, 2, 'creator', 'accepted'),
(2, 3, 'admin',   'accepted'),
(2, 4, 'member',  'accepted'),
(2, 6, 'member',  'accepted'),
(2, 1, 'member',  'pending'),
(2, 8, 'member',  'accepted');

-- WS3: DB Project Team
INSERT INTO workspace_members (wsid, uid, role, status) VALUES
(3, 3, 'creator', 'accepted'),
(3, 7, 'admin',   'accepted'),
(3, 8, 'member',  'accepted'),
(3, 1, 'member',  'accepted'),
(3, 4, 'member',  'pending');

-- ============================================================
-- Channels
-- ============================================================
-- WS1 channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(1, 'general',          'public'),    -- chid 1
(1, 'hiring-committee', 'private'),   -- chid 2
(1, NULL,               'direct'),    -- chid 3: Alice-Bob DM
(1, 'research',         'public');    -- chid 4

-- WS2 channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(2, 'events',       'public'),       -- chid 5
(2, 'competitions', 'public'),       -- chid 6
(2, NULL,           'direct'),       -- chid 7: Bob-Carol DM
(2, 'hardware',     'private');      -- chid 8

-- WS3 channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(3, 'general',      'public'),       -- chid 9
(3, 'schema-design','public'),       -- chid 10
(3, NULL,           'direct');       -- chid 11: Carol-Grace DM

-- ============================================================
-- Channel Members
-- ============================================================
-- WS1: #general (chid 1)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(1, 1, 'creator', 'accepted'),
(1, 2, 'member',  'accepted'),
(1, 3, 'member',  'accepted'),
(1, 7, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status, createdat) VALUES
(1, 4, 'member', 'pending', CURRENT_TIMESTAMP - INTERVAL '6 days');

-- WS1: #hiring-committee (chid 2)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(2, 1, 'creator', 'accepted'),
(2, 2, 'member',  'accepted');

-- WS1: DM Alice-Bob (chid 3)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(3, 1, 'creator', 'accepted'),
(3, 2, 'member',  'accepted');

-- WS1: #research (chid 4)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(4, 1, 'creator', 'accepted'),
(4, 3, 'member',  'accepted'),
(4, 7, 'member',  'accepted');

-- WS2: #events (chid 5)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(5, 2, 'creator', 'accepted'),
(5, 3, 'member',  'accepted'),
(5, 4, 'member',  'accepted'),
(5, 8, 'member',  'accepted');

INSERT INTO channel_members (chid, uid, role, status, createdat) VALUES
(5, 6, 'member', 'pending', CURRENT_TIMESTAMP - INTERVAL '7 days');

-- WS2: #competitions (chid 6)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(6, 2, 'creator', 'accepted'),
(6, 3, 'member',  'accepted');

-- WS2: DM Bob-Carol (chid 7)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(7, 2, 'creator', 'accepted'),
(7, 3, 'member',  'accepted');

-- WS2: #hardware (chid 8)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(8, 2, 'creator', 'accepted'),
(8, 4, 'member',  'accepted'),
(8, 6, 'member',  'accepted'),
(8, 8, 'member',  'accepted');

-- WS3: #general (chid 9)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(9, 3, 'creator', 'accepted'),
(9, 7, 'member',  'accepted'),
(9, 8, 'member',  'accepted'),
(9, 1, 'member',  'accepted');

-- WS3: #schema-design (chid 10)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(10, 3, 'creator', 'accepted'),
(10, 7, 'member',  'accepted'),
(10, 8, 'member',  'accepted');

-- WS3: DM Carol-Grace (chid 11)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(11, 3, 'creator', 'accepted'),
(11, 7, 'member',  'accepted');

-- ============================================================
-- Messages
-- ============================================================
-- WS1: #general (chid 1)
INSERT INTO messages (chid, uid, content, postat) VALUES
(1, 1, 'Welcome to the CS Department workspace!',                   '2026-04-01 09:00:00'),
(1, 2, 'Thanks Alice! Excited to be here.',                         '2026-04-01 09:05:00'),
(1, 3, 'Is the new curriculum perpendicular to the old one?',       '2026-04-01 09:10:00'),
(1, 1, 'Not exactly perpendicular, but quite different.',            '2026-04-01 09:15:00'),
(1, 7, 'Hi everyone! Just joined the department.',                  '2026-04-01 09:20:00'),
(1, 2, 'Welcome Grace! Let us know if you need anything.',          '2026-04-01 09:25:00'),
(1, 1, 'Faculty meeting is scheduled for next Monday at 2pm.',      '2026-04-02 08:00:00'),
(1, 3, 'Will the meeting cover the new database curriculum?',       '2026-04-02 08:15:00');

-- WS1: #hiring-committee (chid 2)
INSERT INTO messages (chid, uid, content, postat) VALUES
(2, 1, 'We need to review the new candidates.',                     '2026-04-02 10:00:00'),
(2, 2, 'I will prepare the shortlist by Friday.',                   '2026-04-02 10:30:00'),
(2, 1, 'Great. Focus on candidates with systems experience.',       '2026-04-02 10:45:00'),
(2, 2, 'Should we also consider the ML candidates?',                '2026-04-02 11:00:00'),
(2, 1, 'Yes, but systems is the priority this cycle.',              '2026-04-02 11:15:00');

-- WS1: DM Alice-Bob (chid 3)
INSERT INTO messages (chid, uid, content, postat) VALUES
(3, 1, 'Bob, can you handle the seminar logistics?',                '2026-04-03 14:00:00'),
(3, 2, 'Sure, I will book the room.',                               '2026-04-03 14:05:00'),
(3, 1, 'Room 312 in Warren Weaver Hall would be ideal.',            '2026-04-03 14:10:00'),
(3, 2, 'Got it. I will also set up the projector.',                 '2026-04-03 14:15:00');

-- WS1: #research (chid 4)
INSERT INTO messages (chid, uid, content, postat) VALUES
(4, 1, 'Anyone interested in the new VLDB paper on query optimization?',  '2026-04-04 10:00:00'),
(4, 3, 'Yes! The perpendicular indexing approach looks promising.',       '2026-04-04 10:15:00'),
(4, 7, 'I can present a summary at next week reading group.',            '2026-04-04 10:30:00'),
(4, 1, 'Perfect. Let us schedule it for Wednesday.',                     '2026-04-04 10:45:00');

-- WS2: #events (chid 5)
INSERT INTO messages (chid, uid, content, postat) VALUES
(5, 2, 'Robotics demo day is coming up!',                                '2026-04-05 11:00:00'),
(5, 3, 'We should set up a perpendicular track for the bots.',           '2026-04-05 11:15:00'),
(5, 4, 'I can bring the sensors and motors.',                            '2026-04-05 11:30:00'),
(5, 8, 'I have spare Arduino boards if anyone needs them.',              '2026-04-05 11:45:00'),
(5, 2, 'Great! Let us meet Saturday to do a dry run.',                   '2026-04-05 12:00:00'),
(5, 3, 'Saturday works for me. What time?',                              '2026-04-05 12:10:00'),
(5, 2, '2pm at the Makerspace. Bring your laptops.',                     '2026-04-05 12:15:00');

-- WS2: #competitions (chid 6)
INSERT INTO messages (chid, uid, content, postat) VALUES
(6, 2, 'Registration for RoboNYU 2026 is open.',                        '2026-04-06 08:00:00'),
(6, 3, 'Let us form a team of four.',                                    '2026-04-06 08:20:00'),
(6, 2, 'Dave and Frank said they are interested.',                       '2026-04-06 08:30:00'),
(6, 3, 'Perfect. That makes four with us. What category?',              '2026-04-06 08:45:00'),
(6, 2, 'I think line-follower is best for our first competition.',       '2026-04-06 09:00:00');

-- WS2: DM Bob-Carol (chid 7)
INSERT INTO messages (chid, uid, content, postat) VALUES
(7, 2, 'Carol, are you free for a meeting tomorrow?',                    '2026-04-07 16:00:00'),
(7, 3, 'Yes, afternoon works for me.',                                   '2026-04-07 16:10:00'),
(7, 2, 'Let us discuss the competition strategy.',                       '2026-04-07 16:15:00'),
(7, 3, 'Sounds good. I will bring the budget proposal too.',             '2026-04-07 16:20:00');

-- WS2: #hardware (chid 8)
INSERT INTO messages (chid, uid, content, postat) VALUES
(8, 2, 'We just received the new Raspberry Pi 5 units.',                '2026-04-08 09:00:00'),
(8, 4, 'Nice! How many did we get?',                                    '2026-04-08 09:10:00'),
(8, 2, 'Ten units. Plus five camera modules.',                          '2026-04-08 09:15:00'),
(8, 6, 'Can I borrow one for my autonomous navigation project?',        '2026-04-08 09:30:00'),
(8, 8, 'I need one for the drone controller prototype.',                '2026-04-08 09:45:00'),
(8, 2, 'Sure, just log it in the equipment sheet.',                     '2026-04-08 10:00:00');

-- WS3: #general (chid 9)
INSERT INTO messages (chid, uid, content, postat) VALUES
(9, 3, 'Welcome to the DB project workspace! Let us get started.',       '2026-04-10 10:00:00'),
(9, 7, 'Excited to work on this. What is our topic?',                   '2026-04-10 10:05:00'),
(9, 3, 'We are building snickr - a Slack-like collaboration system.',   '2026-04-10 10:10:00'),
(9, 8, 'Cool! I can work on the frontend.',                             '2026-04-10 10:15:00'),
(9, 1, 'I have experience with Django, happy to help with backend.',    '2026-04-10 10:20:00'),
(9, 3, 'Great team. The project is due around May 8.',                  '2026-04-10 10:25:00'),
(9, 7, 'Should we use PostgreSQL or MySQL?',                            '2026-04-10 10:30:00'),
(9, 3, 'PostgreSQL. Better support for advanced SQL features.',         '2026-04-10 10:35:00');

-- WS3: #schema-design (chid 10)
INSERT INTO messages (chid, uid, content, postat) VALUES
(10, 3, 'Let us discuss the ER diagram here.',                          '2026-04-11 14:00:00'),
(10, 7, 'I think we need six tables: users, workspaces, channels, messages, plus two junction tables.', '2026-04-11 14:10:00'),
(10, 8, 'Should channel members have a status field for invitations?',  '2026-04-11 14:20:00'),
(10, 3, 'Yes, status IN (pending, accepted, rejected). Good catch.',    '2026-04-11 14:30:00'),
(10, 7, 'What about the perpendicular relationship between workspaces and channels?', '2026-04-11 14:40:00'),
(10, 3, 'It is a one-to-many: each channel belongs to exactly one workspace.', '2026-04-11 14:50:00'),
(10, 8, 'Makes sense. I will start drafting the CREATE TABLE statements.', '2026-04-11 15:00:00');

-- WS3: DM Carol-Grace (chid 11)
INSERT INTO messages (chid, uid, content, postat) VALUES
(11, 3, 'Grace, can you review the schema before we submit?',           '2026-04-12 09:00:00'),
(11, 7, 'Sure! I will look at it tonight.',                             '2026-04-12 09:05:00'),
(11, 3, 'Focus on the foreign key constraints and index choices.',      '2026-04-12 09:10:00');

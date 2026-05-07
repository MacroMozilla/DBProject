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
(1, 3, 'Quick question - has anyone seen the updated syllabus for the intro CS course?', '2026-04-01 09:10:00'),
(1, 1, 'Not yet, but I heard they are adding more Python and less Java this semester.',  '2026-04-01 09:15:00'),
(1, 7, 'Hi everyone! Just joined the department. Looking forward to collaborating!',     '2026-04-01 09:20:00'),
(1, 2, 'Welcome Grace! Let us know if you need anything. Office hours are pinned in #research.', '2026-04-01 09:25:00'),
(1, 1, 'Faculty meeting is scheduled for next Monday at 2pm in WWH 312.',               '2026-04-02 08:00:00'),
(1, 3, 'Will the meeting cover the new database curriculum?',                            '2026-04-02 08:15:00'),
(1, 1, 'Yes, plus budget allocations for the new lab equipment.',                        '2026-04-02 08:30:00'),
(1, 2, 'Can we also discuss TA assignments? We are short-staffed for the OS course.',    '2026-04-02 08:45:00'),
(1, 7, 'I can TA for OS! I did my thesis on kernel scheduling.',                         '2026-04-02 09:00:00'),
(1, 2, 'That would be amazing Grace, I will add you to the list.',                       '2026-04-02 09:10:00'),
(1, 3, 'Reminder: the SIGMOD paper deadline is April 15. Anyone submitting?',            '2026-04-03 10:00:00'),
(1, 1, 'Bob and I are submitting our work on distributed query optimization.',            '2026-04-03 10:15:00'),
(1, 2, 'Almost done with the evaluation section. Running final benchmarks tonight.',      '2026-04-03 10:20:00'),
(1, 7, 'Good luck! I would love to read a draft if you need reviewers.',                 '2026-04-03 10:30:00');

-- WS1: #hiring-committee (chid 2)
INSERT INTO messages (chid, uid, content, postat) VALUES
(2, 1, 'We need to review the new faculty candidates. HR sent over 23 applications.',  '2026-04-02 10:00:00'),
(2, 2, 'I will prepare the shortlist by Friday. Any must-have criteria?',               '2026-04-02 10:30:00'),
(2, 1, 'Focus on candidates with systems experience - we lost two systems profs last year.', '2026-04-02 10:45:00'),
(2, 2, 'Should we also consider the ML candidates? There is a strong one from Stanford.', '2026-04-02 11:00:00'),
(2, 1, 'Yes, but systems is the priority this cycle. Maybe one ML hire if budget allows.', '2026-04-02 11:15:00'),
(2, 2, 'Got it. I have narrowed it down to 8 systems and 3 ML candidates.',              '2026-04-03 14:00:00'),
(2, 1, 'Nice work. Let us schedule campus visits for the top 5 in May.',                  '2026-04-03 14:15:00'),
(2, 2, 'The Stanford ML candidate has 4 top-tier publications this year alone.',          '2026-04-03 14:30:00'),
(2, 1, 'Impressive. Put them on the shortlist. We can do a joint offer if the dean approves.', '2026-04-03 14:45:00');

-- WS1: DM Alice-Bob (chid 3)
INSERT INTO messages (chid, uid, content, postat) VALUES
(3, 1, 'Bob, can you handle the seminar logistics for Dr. Patel visit?',  '2026-04-03 14:00:00'),
(3, 2, 'Sure, I will book the room. WWH 312 right?',                      '2026-04-03 14:05:00'),
(3, 1, 'Yes, and we need AV setup for a live demo. She is presenting a distributed DB system.', '2026-04-03 14:10:00'),
(3, 2, 'Got it. I will also set up the projector and test the HDMI.',     '2026-04-03 14:15:00'),
(3, 1, 'One more thing - can you order lunch? About 30 people expected.',  '2026-04-03 14:20:00'),
(3, 2, 'Pizza or sandwiches?',                                            '2026-04-03 14:22:00'),
(3, 1, 'Sandwiches. Last time half the pizza went cold. Also get a veggie platter.', '2026-04-03 14:25:00'),
(3, 2, 'On it. Budget limit?',                                            '2026-04-03 14:27:00'),
(3, 1, '$500 from the department seminar fund. Receipt goes to Maria in admin.', '2026-04-03 14:30:00'),
(3, 2, 'Perfect. Everything is booked. See you Monday!',                   '2026-04-03 14:35:00');

-- WS1: #research (chid 4)
INSERT INTO messages (chid, uid, content, postat) VALUES
(4, 1, 'Anyone interested in the new VLDB paper on learned query optimization?',        '2026-04-04 10:00:00'),
(4, 3, 'Yes! The adaptive indexing approach looks promising. Way better than traditional cost models.', '2026-04-04 10:15:00'),
(4, 7, 'I can present a summary at next week reading group.',                            '2026-04-04 10:30:00'),
(4, 1, 'Perfect. Let us schedule it for Wednesday 3pm.',                                 '2026-04-04 10:45:00'),
(4, 3, 'Also found this interesting paper on vector databases for RAG systems.',         '2026-04-05 11:00:00'),
(4, 1, 'The pgvector extension for PostgreSQL is getting a lot of traction.',            '2026-04-05 11:10:00'),
(4, 7, 'I have been experimenting with it. The HNSW index makes a huge difference for ANN queries.', '2026-04-05 11:20:00'),
(4, 3, 'Could be a great topic for a joint paper. Who wants to collaborate?',            '2026-04-05 11:30:00'),
(4, 1, 'I am in. Let us draft an outline by end of month.',                              '2026-04-05 11:45:00'),
(4, 7, 'Count me in too. I have access to the benchmark datasets we would need.',        '2026-04-05 12:00:00');

-- WS2: #events (chid 5)
INSERT INTO messages (chid, uid, content, postat) VALUES
(5, 2, 'Robotics demo day is April 20! We need to start preparing.',     '2026-04-05 11:00:00'),
(5, 3, 'We should set up an obstacle course and a line-following track.','2026-04-05 11:15:00'),
(5, 4, 'I can bring the ultrasonic sensors and spare servo motors.',     '2026-04-05 11:30:00'),
(5, 8, 'I have 5 spare Arduino Mega boards if anyone needs them.',       '2026-04-05 11:45:00'),
(5, 2, 'Great! Let us meet Saturday to do a dry run.',                   '2026-04-05 12:00:00'),
(5, 3, 'Saturday works for me. What time?',                              '2026-04-05 12:10:00'),
(5, 2, '2pm at the Makerspace in MakerSpace@Tandon. Bring your laptops.', '2026-04-05 12:15:00'),
(5, 4, 'Should we invite prospective members? Good recruiting opportunity.', '2026-04-05 12:30:00'),
(5, 2, 'Definitely. I will post flyers around the Tandon commons.',      '2026-04-05 12:35:00'),
(5, 8, 'I can make a short video reel from last year demos for social media.', '2026-04-05 12:40:00'),
(5, 3, 'Love that idea Henry. Our Instagram needs content badly.',       '2026-04-05 12:50:00'),
(5, 2, 'Update: the Makerspace confirmed we can use both rooms. Plenty of space!', '2026-04-06 09:00:00'),
(5, 4, 'I just tested our line-follower bot. It completes the track in 12 seconds.', '2026-04-06 15:00:00'),
(5, 3, 'Nice! That is way faster than last semester. What did you change?', '2026-04-06 15:05:00'),
(5, 4, 'Switched from bang-bang control to PID. Smoother turns.',        '2026-04-06 15:10:00');

-- WS2: #competitions (chid 6)
INSERT INTO messages (chid, uid, content, postat) VALUES
(6, 2, 'Registration for RoboNYU 2026 is open! Deadline is April 25.',  '2026-04-06 08:00:00'),
(6, 3, 'Let us form a team of four. Who is in?',                         '2026-04-06 08:20:00'),
(6, 2, 'Dave and Frank said they are interested.',                       '2026-04-06 08:30:00'),
(6, 3, 'Perfect. That makes four with us. What category should we enter?', '2026-04-06 08:45:00'),
(6, 2, 'I think line-follower is best for our first competition.',       '2026-04-06 09:00:00'),
(6, 3, 'Agreed. We already have a working prototype from the club.',     '2026-04-06 09:15:00'),
(6, 2, 'I looked at last year winners. Top team completed in 8.3 seconds.', '2026-04-07 10:00:00'),
(6, 3, 'Our current time is 12 seconds. We need to shave off 4 seconds.', '2026-04-07 10:10:00'),
(6, 2, 'Dave suggested using reflectance sensors instead of IR. Better accuracy on curves.', '2026-04-07 10:20:00'),
(6, 3, 'Good idea. Also we should tune the PID constants. I wrote a simulator in Python.', '2026-04-07 10:30:00'),
(6, 2, 'Can you share the repo? I want to run some experiments tonight.', '2026-04-07 10:35:00'),
(6, 3, 'Just pushed it to our GitHub org. Check tandon-robotics/pid-sim.', '2026-04-07 10:40:00');

-- WS2: DM Bob-Carol (chid 7)
INSERT INTO messages (chid, uid, content, postat) VALUES
(7, 2, 'Carol, are you free for a meeting tomorrow?',                    '2026-04-07 16:00:00'),
(7, 3, 'Yes, afternoon works. 3pm at Dunkin?',                          '2026-04-07 16:10:00'),
(7, 2, 'Let us discuss the competition strategy and club budget.',       '2026-04-07 16:15:00'),
(7, 3, 'Sounds good. I will bring the budget spreadsheet.',              '2026-04-07 16:20:00'),
(7, 2, 'Also wanted to talk about next year leadership. You should run for president.', '2026-04-07 16:25:00'),
(7, 3, 'Really? I have only been in the club for a year though.',        '2026-04-07 16:30:00'),
(7, 2, 'You organized the entire demo day basically by yourself. Everyone noticed.', '2026-04-07 16:35:00'),
(7, 3, 'That means a lot Bob. Let me think about it.',                   '2026-04-07 16:40:00'),
(7, 2, 'No pressure. Just know you have my full support.',               '2026-04-07 16:45:00');

-- WS2: #hardware (chid 8)
INSERT INTO messages (chid, uid, content, postat) VALUES
(8, 2, 'We just received the new Raspberry Pi 5 units from the Tandon budget!', '2026-04-08 09:00:00'),
(8, 4, 'Nice! How many did we get?',                                    '2026-04-08 09:10:00'),
(8, 2, 'Ten units. Plus five camera modules and a bunch of GPIO cables.', '2026-04-08 09:15:00'),
(8, 6, 'Can I borrow one for my autonomous navigation project?',        '2026-04-08 09:30:00'),
(8, 8, 'I need one for the drone controller prototype.',                '2026-04-08 09:45:00'),
(8, 2, 'Sure, just log it in the equipment Google Sheet. Link is pinned.', '2026-04-08 10:00:00'),
(8, 4, 'Has anyone tried the Pi 5 with ROS2? Wondering about performance.', '2026-04-09 13:00:00'),
(8, 6, 'I ran ROS2 Humble on it yesterday. Handles SLAM pretty well actually.', '2026-04-09 13:15:00'),
(8, 8, 'What about real-time control loops? The Pi 4 struggled with anything under 10ms.', '2026-04-09 13:20:00'),
(8, 6, 'Pi 5 is way better. I got stable 5ms loops with the new kernel patches.', '2026-04-09 13:30:00'),
(8, 4, 'That is great news for the competition bot. We can run PID and vision on one board.', '2026-04-09 13:35:00'),
(8, 2, 'FYI I also ordered 3 LiDAR modules. Should arrive next week.',  '2026-04-09 14:00:00'),
(8, 8, 'Oh nice. RPLiDAR A1 or the new A2?',                           '2026-04-09 14:05:00'),
(8, 2, 'A2. Better range and faster scan rate. Worth the extra $30.',    '2026-04-09 14:10:00');

-- WS3: #general (chid 9)
INSERT INTO messages (chid, uid, content, postat) VALUES
(9, 3, 'Welcome to the DB project workspace! Let us get started.',       '2026-04-10 10:00:00'),
(9, 7, 'Excited to work on this. What is our topic?',                   '2026-04-10 10:05:00'),
(9, 3, 'We are building snickr - a Slack-like collaboration system.',   '2026-04-10 10:10:00'),
(9, 8, 'Cool! I can work on the frontend. I have been learning React.', '2026-04-10 10:15:00'),
(9, 1, 'I have experience with Django and Flask. Happy to do backend.', '2026-04-10 10:20:00'),
(9, 3, 'Great team. The project report 1 is due around May 8.',         '2026-04-10 10:25:00'),
(9, 7, 'Should we use PostgreSQL or MySQL?',                            '2026-04-10 10:30:00'),
(9, 3, 'PostgreSQL. Better support for advanced SQL features and Prof mentioned it in lecture.', '2026-04-10 10:35:00'),
(9, 8, 'I set up a Docker Compose with Postgres and a Flask backend. Want me to push it?', '2026-04-10 14:00:00'),
(9, 3, 'Yes please! That saves us a ton of setup time.',                '2026-04-10 14:05:00'),
(9, 1, 'Nice. I will write the API endpoints once the schema is ready.','2026-04-10 14:10:00'),
(9, 7, 'I can handle the SQL queries and stored procedures.',           '2026-04-10 14:15:00'),
(9, 3, 'Perfect. Let us divide and conquer. I will coordinate the report.', '2026-04-10 14:20:00'),
(9, 8, 'Pushed to main branch. Clone and run docker compose up.',       '2026-04-10 16:00:00'),
(9, 1, 'Works on my machine. The hot reload is really nice.',           '2026-04-10 16:30:00'),
(9, 3, 'Reminder: we need at least 5 interesting SQL queries for the report. Start thinking about what to demo.', '2026-04-12 09:00:00'),
(9, 7, 'I was thinking: unread message counts, channel activity stats, user engagement metrics.', '2026-04-12 09:15:00'),
(9, 1, 'We should also do a keyword search across messages. That is always impressive in demos.', '2026-04-12 09:20:00'),
(9, 3, 'Love those ideas. Let us also add a "most active users" leaderboard query.', '2026-04-12 09:30:00'),
(9, 8, 'I finished the login and channel switching UI. Screenshots in #schema-design.', '2026-04-13 20:00:00');

-- WS3: #schema-design (chid 10)
INSERT INTO messages (chid, uid, content, postat) VALUES
(10, 3, 'Let us discuss the ER diagram here. I drew a first draft on paper.', '2026-04-11 14:00:00'),
(10, 7, 'I think we need six tables: users, workspaces, channels, messages, plus two junction tables for memberships.', '2026-04-11 14:10:00'),
(10, 8, 'Should channel_members have a status field for invitations?',  '2026-04-11 14:20:00'),
(10, 3, 'Yes, status CHECK IN (pending, accepted, rejected). Good catch Henry.', '2026-04-11 14:30:00'),
(10, 7, 'What about the relationship between workspaces and channels?', '2026-04-11 14:40:00'),
(10, 3, 'One-to-many: each channel belongs to exactly one workspace. Foreign key on channels.', '2026-04-11 14:50:00'),
(10, 8, 'Makes sense. I will start drafting the CREATE TABLE statements.', '2026-04-11 15:00:00'),
(10, 7, 'Should we add ON DELETE CASCADE to the foreign keys?',         '2026-04-11 15:10:00'),
(10, 3, 'Yes. If a workspace is deleted, its channels and memberships should go too.', '2026-04-11 15:15:00'),
(10, 8, 'What about direct messages? They do not really have a channel name.', '2026-04-11 15:20:00'),
(10, 3, 'Good point. We can use chtype = direct and allow NULL for chname in that case.', '2026-04-11 15:25:00'),
(10, 7, 'I added a CHECK constraint: chtype IN (public, private, direct). Looks clean.', '2026-04-11 15:30:00'),
(10, 3, 'Nice. Also thinking about adding a last_read_msgid to channel_members for tracking unread messages.', '2026-04-11 15:40:00'),
(10, 8, 'That is clever. The frontend can compare last_read_msgid with the latest msgid to show unread count.', '2026-04-11 15:45:00'),
(10, 7, 'Schema is looking solid. I will write the initialize.sql file tonight.', '2026-04-11 16:00:00'),
(10, 3, 'Great work team. This is coming together really well.',        '2026-04-11 16:05:00');

-- WS3: DM Carol-Grace (chid 11)
INSERT INTO messages (chid, uid, content, postat) VALUES
(11, 3, 'Grace, can you review the schema before we submit?',           '2026-04-12 09:00:00'),
(11, 7, 'Sure! I will look at it tonight.',                             '2026-04-12 09:05:00'),
(11, 3, 'Focus on the foreign key constraints and index choices.',      '2026-04-12 09:10:00'),
(11, 7, 'Reviewed it. Looks great overall. Two suggestions:',          '2026-04-12 22:00:00'),
(11, 7, '1. Add an index on messages(chid, postat) for faster channel message loading.', '2026-04-12 22:01:00'),
(11, 7, '2. The email column should have a UNIQUE constraint. Currently it does not.', '2026-04-12 22:02:00'),
(11, 3, 'Good catches! The email one is critical - we do not want duplicate accounts.', '2026-04-12 22:15:00'),
(11, 7, 'Already fixed both and pushed. Also added NOT NULL where it was missing.', '2026-04-12 22:20:00'),
(11, 3, 'You are a lifesaver Grace. Coffee is on me tomorrow.',        '2026-04-12 22:25:00'),
(11, 7, 'Haha deal. Also I am a bit worried about the report. Have you started writing?', '2026-04-12 22:30:00'),
(11, 3, 'I have the outline done. Need to add the ER diagram and query explanations.', '2026-04-12 22:35:00'),
(11, 7, 'I can write the normalization analysis section. 3NF and BCNF proofs.', '2026-04-12 22:40:00'),
(11, 3, 'Perfect. Let us aim to have a full draft by this weekend.',   '2026-04-12 22:45:00');

-- ============================================================
-- Additional Channels
-- ============================================================
-- WS1: additional channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(1, 'announcements',   'public'),   -- chid 12
(1, 'ta-coordination', 'private');  -- chid 13

-- WS2: additional channel
INSERT INTO channels (wsid, chname, chtype) VALUES
(2, 'software', 'public');          -- chid 14

-- WS3: additional channels
INSERT INTO channels (wsid, chname, chtype) VALUES
(3, 'frontend', 'public'),          -- chid 15
(3, 'queries',  'public');          -- chid 16

-- ============================================================
-- Additional Channel Members
-- ============================================================
-- WS1: #announcements (chid 12)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(12, 1, 'creator', 'accepted'),
(12, 2, 'member',  'accepted'),
(12, 3, 'member',  'accepted'),
(12, 7, 'member',  'accepted');

-- WS1: #ta-coordination (chid 13)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(13, 1, 'creator', 'accepted'),
(13, 2, 'member',  'accepted'),
(13, 7, 'member',  'accepted');

-- WS2: #software (chid 14)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(14, 2, 'creator', 'accepted'),
(14, 3, 'member',  'accepted'),
(14, 4, 'member',  'accepted'),
(14, 8, 'member',  'accepted');

-- WS3: #frontend (chid 15)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(15, 3, 'creator', 'accepted'),
(15, 8, 'member',  'accepted'),
(15, 1, 'member',  'accepted');

-- WS3: #queries (chid 16)
INSERT INTO channel_members (chid, uid, role, status) VALUES
(16, 3, 'creator', 'accepted'),
(16, 7, 'member',  'accepted'),
(16, 8, 'member',  'accepted'),
(16, 1, 'member',  'accepted');

-- ============================================================
-- Additional Messages -- late April / May 2026
-- ============================================================

-- WS1: #general continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(1, 1, 'End of semester reminders: grade submissions due May 16. Please log in to Albert early.', '2026-04-20 09:00:00'),
(1, 2, 'Quick reminder that the department colloquium is this Friday at 3pm. Dr. Lin from CMU is presenting on federated learning.', '2026-04-20 09:30:00'),
(1, 3, 'Is the talk in person or hybrid?', '2026-04-20 09:35:00'),
(1, 1, 'Hybrid. Zoom link is on the department calendar.', '2026-04-20 09:40:00'),
(1, 7, 'The abstract looks great. Her work on privacy-preserving ML is really relevant right now.', '2026-04-20 10:00:00'),
(1, 2, 'Also - anyone else having issues with the new Albert grade submission portal? It keeps timing out.', '2026-04-21 08:45:00'),
(1, 3, 'Yes! I submitted twice by accident. IT said it is a known bug and they are working on it.', '2026-04-21 09:00:00'),
(1, 1, 'Thanks for the heads up. I will send an email to the department.', '2026-04-21 09:10:00'),
(1, 7, 'Reminder that the CS award nominations close April 30. Please nominate deserving students.', '2026-04-28 11:00:00'),
(1, 2, 'Nominated three students from my algorithms class. Incredible work this semester.', '2026-04-28 11:30:00'),
(1, 1, 'Faculty meeting notes from Monday are in the shared drive under Admin/Meetings.', '2026-05-01 10:00:00'),
(1, 3, 'Thanks Alice. Did they finalize the new course rotations for fall?', '2026-05-01 10:15:00'),
(1, 1, 'Yes. DB systems will run both semesters next year. High demand after the snickr project got attention.', '2026-05-01 10:20:00'),
(1, 7, 'Ha, we made an impact already!', '2026-05-01 10:25:00'),
(1, 2, 'Does anyone have office hours coverage for next week? I will be at ICDE.', '2026-05-05 14:00:00'),
(1, 7, 'I can cover Monday and Wednesday.', '2026-05-05 14:10:00'),
(1, 3, 'I have Tuesday and Thursday.', '2026-05-05 14:15:00'),
(1, 2, 'Perfect, thank you both!', '2026-05-05 14:20:00');

-- WS1: #hiring-committee continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(2, 1, 'Campus visit schedule is confirmed for the week of May 12. We have 5 candidates coming in.', '2026-04-25 10:00:00'),
(2, 2, 'I will coordinate the faculty lunch slots. Each candidate gets a 30-minute slot with the committee.', '2026-04-25 10:15:00'),
(2, 1, 'The Stanford ML candidate confirmed. She is flying in from San Francisco on May 13.', '2026-04-25 10:30:00'),
(2, 2, 'Should we set up a research talk for her? Her recent NeurIPS paper would be a great fit.', '2026-04-25 10:45:00'),
(2, 1, 'Yes, book WWH 317 for a 45-minute talk at 2pm. I will send the invite to the full department.', '2026-04-25 11:00:00'),
(2, 2, 'Done. Also the two systems candidates both have strong industry connections. Google and Meta respectively.', '2026-04-28 09:00:00'),
(2, 1, 'Good. The dean mentioned industry connections are a big plus for grant funding.', '2026-04-28 09:20:00'),
(2, 2, 'Post-visit debrief meeting scheduled for May 16 at 4pm. Please block your calendar.', '2026-05-05 15:00:00');

-- WS1: DM Alice-Bob continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(3, 1, 'Bob, how did the seminar go?', '2026-04-07 10:00:00'),
(3, 2, 'It was great! Dr. Patel got a lot of good questions. The AV setup worked perfectly.', '2026-04-07 10:05:00'),
(3, 1, 'Wonderful. The food was a hit too - several people mentioned the veggie platter.', '2026-04-07 10:08:00'),
(3, 2, 'Ha! Good call on the sandwiches. I will remember that for next time.', '2026-04-07 10:10:00'),
(3, 1, 'One more thing - can you be on the hiring committee interview panel on May 13?', '2026-04-28 14:00:00'),
(3, 2, 'Yes, happy to help. What time?', '2026-04-28 14:05:00'),
(3, 1, 'The ML candidate is at 2pm, systems candidates in the morning starting at 9am.', '2026-04-28 14:10:00'),
(3, 2, 'I will block the whole day. Want me to prepare any evaluation rubrics?', '2026-04-28 14:15:00'),
(3, 1, 'That would be very helpful. Focus on research vision and teaching fit.', '2026-04-28 14:20:00'),
(3, 2, 'Will have a draft rubric to you by end of week.', '2026-04-28 14:25:00');

-- WS1: #research continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(4, 7, 'Reading group summary from Wednesday is posted in the shared drive.', '2026-04-16 10:00:00'),
(4, 1, 'Great summary Grace. The discussion on learned indexes was really productive.', '2026-04-16 10:30:00'),
(4, 3, 'For next week I want to discuss the new paper on quantum database systems. Anyone read it?', '2026-04-16 11:00:00'),
(4, 7, 'I skimmed it. The complexity results are interesting but I am skeptical about near-term applications.', '2026-04-16 11:15:00'),
(4, 1, 'Still worth discussing. The theoretical bounds alone are worth 30 minutes.', '2026-04-16 11:20:00'),
(4, 3, 'Draft of our pgvector paper outline is ready. Shared it in the drive under Research/2026-papers.', '2026-04-30 15:00:00'),
(4, 1, 'Read it last night. The motivation section is strong. The experimental section needs more detail.', '2026-04-30 15:30:00'),
(4, 7, 'Agreed. I will add the benchmark methodology subsection this weekend.', '2026-04-30 15:45:00'),
(4, 3, 'Target venue: VLDB 2027. Deadline is March 1 so we have time to do this properly.', '2026-04-30 16:00:00'),
(4, 1, 'Good call. I would rather submit once with a polished paper than rush.', '2026-04-30 16:10:00');

-- WS1: #announcements
INSERT INTO messages (chid, uid, content, postat) VALUES
(12, 1, 'Welcome to #announcements. This channel is for department-wide updates only.', '2026-04-01 08:00:00'),
(12, 1, 'Reminder: final exam schedule is now posted on the registrar website. Please review your assigned rooms.', '2026-04-15 09:00:00'),
(12, 1, 'The department picnic is scheduled for May 10, 12-3pm on the Gould Plaza lawn. Families welcome!', '2026-04-22 10:00:00'),
(12, 2, 'Reminder that NSF grant proposals for summer funding are due April 30. See Maria in admin for the internal routing form.', '2026-04-25 09:00:00'),
(12, 1, 'Congratulations to @gracesun whose paper was accepted to SIGMOD 2026!', '2026-04-29 11:00:00'),
(12, 7, 'Thank you everyone! Really excited about this one.', '2026-04-29 11:15:00'),
(12, 1, 'Campus is closed May 26 for Memorial Day. Please plan accordingly.', '2026-05-01 09:00:00'),
(12, 2, 'Hiring committee: please submit your candidate evaluations by May 18.', '2026-05-06 10:00:00');

-- WS1: #ta-coordination
INSERT INTO messages (chid, uid, content, postat) VALUES
(13, 1, 'This channel is for coordinating TA assignments and grading logistics.', '2026-04-01 09:00:00'),
(13, 2, 'DB course has three TAs this semester. Office hours schedule is in the shared doc.', '2026-04-01 09:10:00'),
(13, 7, 'I will hold DB office hours Tuesdays 4-6pm in WWH 412.', '2026-04-01 09:20:00'),
(13, 1, 'Perfect. Bob can you set up Gradescope for the final project submissions?', '2026-04-01 09:25:00'),
(13, 2, 'Done. Students can submit through Gradescope starting April 28.', '2026-04-02 10:00:00'),
(13, 7, 'Getting a lot of questions about the project requirements. Can we post a FAQ?', '2026-04-14 15:00:00'),
(13, 1, 'Good idea. I will draft one tonight and share here before posting to Ed.', '2026-04-14 15:10:00'),
(13, 2, 'Grading rubric for Part 1 is ready. Sending to both of you now.', '2026-04-20 11:00:00'),
(13, 7, 'Received. Looks comprehensive. One question - how many points for the ER diagram?', '2026-04-20 11:10:00'),
(13, 2, '20 points out of 100. Correctness counts for 15, notation for 5.', '2026-04-20 11:15:00'),
(13, 1, 'Part 1 submissions closed. 24 out of 26 groups submitted. Starting grading now.', '2026-04-29 17:00:00'),
(13, 7, 'I will take groups 1-12, @bobsmith can you do 13-24?', '2026-04-29 17:05:00'),
(13, 2, 'On it. Should have grades done by May 5.', '2026-04-29 17:10:00');

-- WS2: #events continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(5, 2, 'Demo day was a huge success! Over 80 people came through.', '2026-04-21 18:00:00'),
(5, 3, 'The line-follower bot was definitely the crowd favorite.', '2026-04-21 18:10:00'),
(5, 4, 'Three prospective members already filled out the interest form.', '2026-04-21 18:15:00'),
(5, 8, 'The video reel got 400 views on Instagram overnight!', '2026-04-21 18:30:00'),
(5, 2, 'Amazing work everyone. Next event: end of year showcase on May 15.', '2026-04-22 09:00:00'),
(5, 3, 'For the showcase I think we should add the drone demo if it is ready.', '2026-04-22 09:15:00'),
(5, 8, 'Drone prototype is 80% done. Should be flight-ready by May 10.', '2026-04-22 09:20:00'),
(5, 2, 'Exciting! Let us plan a test flight in the gym the week before.', '2026-04-22 09:30:00'),
(5, 4, 'I can reserve the gym for May 8 evening if that works.', '2026-04-22 09:35:00'),
(5, 2, 'Perfect. Book it.', '2026-04-22 09:36:00');

-- WS2: #competitions continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(6, 2, 'Update: we shaved our time down to 9.8 seconds with the new PID constants.', '2026-04-15 19:00:00'),
(6, 3, 'Getting close! We need to hit sub-9 to have a shot at winning.', '2026-04-15 19:10:00'),
(6, 2, 'The reflectance sensors Dave suggested made a huge difference on curves.', '2026-04-15 19:15:00'),
(6, 3, 'I ran overnight simulations. Optimal PID values are Kp=1.2, Ki=0.05, Kd=0.8.', '2026-04-16 08:00:00'),
(6, 2, 'Testing those now. Fingers crossed.', '2026-04-16 08:05:00'),
(6, 3, 'NEW RECORD: 8.7 seconds! We are competitive now.', '2026-04-16 14:00:00'),
(6, 2, 'LETS GO! Competition is April 25. Final prep meeting April 23 at 6pm.', '2026-04-16 14:05:00'),
(6, 3, 'We placed second at RoboNYU! Lost to MIT by 0.4 seconds but it was incredibly close.', '2026-04-25 20:00:00'),
(6, 2, 'Second place at our first competition is something to be proud of. Incredible team effort.', '2026-04-25 20:10:00'),
(6, 3, 'Already thinking about next year. We know exactly what to improve.', '2026-04-25 20:15:00');

-- WS2: DM Bob-Carol continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(7, 3, 'Bob I thought about what you said. I think I will run for president.', '2026-04-15 10:00:00'),
(7, 2, 'That is great news! You have my full support. Election is May 1.', '2026-04-15 10:05:00'),
(7, 3, 'Do I need to prepare a speech?', '2026-04-15 10:08:00'),
(7, 2, 'Yes, 5 minutes at the general meeting. Just talk about your vision for the club.', '2026-04-15 10:10:00'),
(7, 3, 'Okay. I am thinking focus on industry partnerships and expanding the workshop series.', '2026-04-15 10:15:00'),
(7, 2, 'Perfect platform. Members have been asking about workshops since last year.', '2026-04-15 10:18:00'),
(7, 3, 'I won! 18-4 vote. Thank you for encouraging me.', '2026-05-01 19:30:00'),
(7, 2, 'Congratulations President Carol! First order of business?', '2026-05-01 19:35:00'),
(7, 3, 'Reach out to two companies about sponsorship this week.', '2026-05-01 19:38:00'),
(7, 2, 'Already on it. I know someone at Boston Dynamics.', '2026-05-01 19:40:00');

-- WS2: #software
INSERT INTO messages (chid, uid, content, postat) VALUES
(14, 2, 'Starting this channel for software and firmware discussion separate from hardware.', '2026-04-10 10:00:00'),
(14, 3, 'Good idea. First topic: should we switch from Arduino IDE to PlatformIO?', '2026-04-10 10:10:00'),
(14, 4, 'PlatformIO is much better for version control and library management. Strongly recommend.', '2026-04-10 10:20:00'),
(14, 8, 'Agreed. It also integrates nicely with VS Code which most of us already use.', '2026-04-10 10:25:00'),
(14, 2, 'Okay, let us make the switch. I will write a migration guide for the wiki.', '2026-04-10 10:30:00'),
(14, 3, 'Also we should start using GitHub Actions for CI on the firmware repo.', '2026-04-14 15:00:00'),
(14, 8, 'I set up a basic workflow that compiles and lints on every push. Check the pull request.', '2026-04-15 09:00:00'),
(14, 4, 'Looks great Henry. Approved and merged.', '2026-04-15 09:30:00'),
(14, 2, 'For the competition bot, all firmware should go through code review before the final run.', '2026-04-20 11:00:00'),
(14, 3, 'Agreed. No last-minute untested changes at the venue.', '2026-04-20 11:05:00'),
(14, 8, 'I also started writing unit tests for the PID controller. Caught two edge case bugs already.', '2026-04-22 14:00:00'),
(14, 4, 'Nice. Testing embedded code is underrated. Good habit to build.', '2026-04-22 14:10:00');

-- WS3: #general continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(9, 3, 'Part 1 submitted! Good work everyone. Now on to Part 2.', '2026-04-29 17:00:00'),
(9, 8, 'What are the main requirements for Part 2?', '2026-04-29 17:10:00'),
(9, 3, 'Full working app with at least 5 interesting SQL queries and a live demo.', '2026-04-29 17:15:00'),
(9, 1, 'We basically already have the app. We should focus on polishing and the query writeups.', '2026-04-29 17:20:00'),
(9, 7, 'I will write up the normalization proofs and query explanations. Leave that section to me.', '2026-04-29 17:25:00'),
(9, 3, 'Perfect division of labor. @henrykim can you add screenshots of the UI to the report?', '2026-04-30 10:00:00'),
(9, 8, 'Yes, will do it once we finalize the styling.', '2026-04-30 10:05:00'),
(9, 1, 'The LaTeX rendering in chat is a nice touch. Might be worth highlighting in the demo.', '2026-04-30 10:10:00'),
(9, 3, 'Good idea. We can show $E = mc^2$ and a full matrix equation in the demo.', '2026-04-30 10:15:00'),
(9, 8, 'Also the unread message badge and DM system look really polished now.', '2026-05-01 09:00:00'),
(9, 3, 'Demo is tomorrow. Everyone please review the demo script in #frontend.', '2026-05-06 20:00:00'),
(9, 1, 'Reviewed. Looks solid. I think we are ready.', '2026-05-06 20:30:00'),
(9, 7, 'Same. Let us get some sleep. We have this.', '2026-05-06 20:45:00'),
(9, 8, 'See everyone tomorrow. Good luck team!', '2026-05-06 21:00:00');

-- WS3: #schema-design continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(10, 3, 'Final schema is locked in. No more changes before the demo.', '2026-04-25 14:00:00'),
(10, 7, 'Agreed. The indexes are solid and all constraints are in place.', '2026-04-25 14:10:00'),
(10, 8, 'Should we add any views or stored procedures for the demo queries?', '2026-04-25 14:20:00'),
(10, 7, 'I was thinking a view for unread counts per channel would look impressive.', '2026-04-25 14:30:00'),
(10, 3, 'Do it. Views are worth extra credit according to the rubric.', '2026-04-25 14:35:00'),
(10, 7, 'Created the view. Also added an index on messages(chid, postat DESC) for performance.', '2026-04-26 10:00:00'),
(10, 8, 'The query times dropped significantly. Good call on that index.', '2026-04-26 10:15:00'),
(10, 3, 'For normalization: our schema is in BCNF. Every non-trivial FD has a superkey on the left.', '2026-04-26 11:00:00'),
(10, 7, 'I verified this for all six tables. The workspace_members and channel_members tables have composite primary keys which makes it clean.', '2026-04-26 11:15:00'),
(10, 3, 'Perfect. That section of the report basically writes itself.', '2026-04-26 11:20:00');

-- WS3: DM Carol-Grace continued
INSERT INTO messages (chid, uid, content, postat) VALUES
(11, 7, 'Carol the report draft looks really good. I added the normalization section.', '2026-04-20 21:00:00'),
(11, 3, 'Just read it. The BCNF proofs are really clear. Professor will love this.', '2026-04-20 21:15:00'),
(11, 7, 'I am a little nervous about the live demo. What if something breaks?', '2026-04-20 21:20:00'),
(11, 3, 'We have been running it for weeks. It will be fine. Plus we have seed data.', '2026-04-20 21:25:00'),
(11, 7, 'True. I just want to make sure the LaTeX rendering works live.', '2026-04-20 21:28:00'),
(11, 3, 'Test it in the morning before class. Type $\nabla^2 \phi = \rho / \varepsilon_0$ and see what happens.', '2026-04-20 21:30:00'),
(11, 7, 'Ha okay will do. Also can we go over the query explanations one more time tomorrow?', '2026-04-20 21:35:00'),
(11, 3, 'Sure. Meet at the library at 9am?', '2026-04-20 21:37:00'),
(11, 7, 'Perfect. See you then.', '2026-04-20 21:38:00'),
(11, 3, 'Report is submitted! 11:58pm. That was close.', '2026-05-03 23:58:00'),
(11, 7, 'I saw! Great work. Now just the demo.', '2026-05-04 00:01:00'),
(11, 3, 'We are going to crush it.', '2026-05-04 00:03:00');

-- WS3: #frontend
INSERT INTO messages (chid, uid, content, postat) VALUES
(15, 8, 'Kicking off this channel for frontend-specific discussion.', '2026-04-14 10:00:00'),
(15, 3, 'Good idea. Current status: login, workspaces, channels, and messaging all work.', '2026-04-14 10:05:00'),
(15, 1, 'What is left to polish before the demo?', '2026-04-14 10:10:00'),
(15, 8, 'Unread badges, DM display names, and the timestamp formatting.', '2026-04-14 10:15:00'),
(15, 3, 'Also want to add channel search and LaTeX rendering if we have time.', '2026-04-14 10:20:00'),
(15, 8, 'LaTeX is done! Using react-markdown with remark-math and rehype-katex.', '2026-04-18 15:00:00'),
(15, 1, 'Tested it. Renders beautifully. Try $$\\int_{-\\infty}^{\\infty} e^{-x^2} dx = \\sqrt{\\pi}$$', '2026-04-18 15:10:00'),
(15, 8, 'Channel search also works now. Click the magnifying glass in the header.', '2026-04-22 11:00:00'),
(15, 3, 'Nice! The DM section is now separate from channels in the sidebar. Looks much cleaner.', '2026-04-22 11:15:00'),
(15, 8, 'Unread counts clear when you click a channel. Timestamps are 12-hour format.', '2026-04-25 14:00:00'),
(15, 1, 'This is looking really professional. Good work everyone.', '2026-04-25 14:30:00'),
(15, 3, 'Demo script: log in as alicezhang, show workspaces, send a LaTeX message, check DMs, search a keyword.', '2026-05-06 19:00:00'),
(15, 8, 'Got it. I will drive the demo since I know the UI best.', '2026-05-06 19:05:00'),
(15, 1, 'Sounds good. Keep it under 5 minutes for the walkthrough.', '2026-05-06 19:10:00');

-- WS3: #queries
INSERT INTO messages (chid, uid, content, postat) VALUES
(16, 7, 'This channel is for discussing our demo SQL queries.', '2026-04-20 10:00:00'),
(16, 3, 'Query 1: unread messages per channel for a given user. Uses last_read_msgid.', '2026-04-20 10:05:00'),
(16, 8, 'Query 2: most active users by message count. Simple aggregate but looks good on screen.', '2026-04-20 10:10:00'),
(16, 7, 'Query 3: keyword search across all messages in a workspace. Uses ILIKE.', '2026-04-20 10:15:00'),
(16, 1, 'Query 4: channels with the most unread messages. Useful for admin dashboards.', '2026-04-20 10:20:00'),
(16, 3, 'Query 5: user engagement - how many channels each user is active in.', '2026-04-20 10:25:00'),
(16, 7, 'I wrote all five with sample output. Check query.sql in the repo.', '2026-04-21 09:00:00'),
(16, 8, 'These look great. The unread messages one especially - it shows off the last_read_msgid design.', '2026-04-21 09:15:00'),
(16, 3, 'Exactly. That was a deliberate schema decision and it pays off here.', '2026-04-21 09:20:00'),
(16, 7, 'Should we also prepare a query that the TA might ask on the spot? Like top 3 channels by activity this week?', '2026-04-28 14:00:00'),
(16, 1, 'Good thinking. I added a few ad-hoc friendly queries at the bottom of query.sql.', '2026-04-28 14:30:00'),
(16, 3, 'Perfect. We should be able to answer any reasonable SQL question about this schema.', '2026-04-28 14:35:00');

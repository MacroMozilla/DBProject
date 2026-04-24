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

----------------------------------------------------------------
----------------------------- DATA -----------------------------
----------------------------------------------------------------

-- For non-compliance
INSERT INTO Departments VALUES 
(0, 'Deparment A'),
(1, 'Deparment B');

INSERT INTO Employees VALUES 
(0, 'A', 'A', 'A', NULL, 0),
(1, 'B', 'B', 'B', NULL, 0),
(2, 'C', 'C', 'C', NULL, 0),
(3, 'D', 'D', 'D', NULL, 0),
(4, 'E', 'E', 'E', NULL, 1);

INSERT INTO HealthDeclaration VALUES
(0, '2021-10-01', 36.1, B'0'),
(2, '2021-10-01', 36.1, B'0'),
(3, '2021-10-01', 36.1, B'0'),
(0, '2021-10-02', 36.1, B'0'),
(3, '2021-10-02', 36.1, B'0'),
(0, '2021-10-03', 36.1, B'0'),
(3, '2021-10-03', 36.1, B'0'),
(0, '2021-10-04', 36.1, B'0'),
(2, '2021-10-04', 36.1, B'0');

INSERT INTO Junior VALUES (2), (3);

INSERT INTO Booker VALUES (0), (1);

INSERT INTO Manager VALUES (0);

INSERT INTO MeetingRooms VALUES 
(0, 0, 'MR_A', 0),
(1, 1, 'MR_B', 0),
(2, 2, 'MR_B', 1);

INSERT INTO Sessions VALUES 
(0, 0, '00:00:00', '2020-10-01', 0, 1),
(1, 1, '01:01:01', '2020-10-01', NULL, 1),
(1, 1, '02:02:02', '2020-10-02', 0, 0),
(0, 0, '03:03:03', '2020-10-02', NULL, 1),
(2, 2, '04:04:04', '2020-10-03', NULL, 4);

INSERT INTO Joins VALUES
(0, 0, 0, '00:00:00', '2020-10-01'),
(2, 0, 0, '00:00:00', '2020-10-01'),
(3, 0, 0, '00:00:00', '2020-10-01'),
(0, 1, 1, '01:01:01', '2020-10-01'),
(3, 1, 1, '01:01:01', '2020-10-01'),
(0, 1, 1, '02:02:02', '2020-10-02'),
(3, 1, 1, '02:02:02', '2020-10-02'),
(0, 0, 0, '03:03:03', '2020-10-02'),
(2, 0, 0, '03:03:03', '2020-10-02'),
(0, 2, 2, '04:04:04', '2020-10-03'),
(4, 2, 2, '04:04:04', '2020-10-03');

----------------------------------------------------------------
---------------------------- OTHERS ----------------------------
----------------------------------------------------------------

SELECT * FROM non_compliance ('2021-10-01', '2021-10-04');

WITH dates (date) AS (
  SELECT *
    FROM generate_series('2021-10-01', '2021-10-04', '1 day'::interval)
)
SELECT e.eid, COUNT(*)
FROM Employees e, dates d
WHERE NOT EXISTS (
  SELECT 1
  FROM HealthDeclaration hd
  WHERE hd.eid = e.eid
    AND hd.date = d.date
)
GROUP BY e.eid;


SELECT * FROM view_booking_report('2020-10-01', 1);

SELECT floor, room, date, time, CASE
  WHEN s.meid IS NULL THEN TRUE
  ELSE FALSE END
FROM Sessions s
WHERE s.beid = 1
  AND date >= '2020-10-01'
ORDER BY date ASC, time ASC;

SELECT * FROM view_future_meeting('2020-08-01', 3);

SELECT j.floor, j.room, j.date, j.time
FROM Joins j JOIN Sessions s ON (
  j.floor = s.floor AND j.room = s.room AND j.time = s.time AND j.date = s.date
)
WHERE j.eid = 0
ORDER BY j.date ASC, j.time ASC;

SELECT * FROM view_manager_report('2020-10-01', 4);

SELECT s.floor, s.room, s.date, s.time, s.beid
FROM Sessions s JOINS MeetingRooms mr ON (
  s.floor = mr.floor AND s.room = mr.room
)
WHERE s.eid IS NULL
  AND mr.did = 0
  AND s.date >= '2020-10-02';

-- Trying to add room in future
CALL add_room(1203, 1123, 'lmao', 10, 1, 3, '2025-01-01');

-- Trying to change capacity in future
CALL change_capacity(5, 8, 3, 10, '2025-01-01');
























----------------------------------------------------------------
----------------------------- DATA -----------------------------
----------------------------------------------------------------

-- For non-compliance
INSERT INTO Departments VALUES (0, 'Deparment A');

INSERT INTO Employees VALUES 
(0, 'A', 'A', 'A', NULL, 0),
(1, 'B', 'B', 'B', NULL, 0),
(2, 'C', 'C', 'C', NULL, 0),
(3, 'D', 'D', 'D', NULL, 0);

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

INSERT INTO Booker VALUES (0), (1);

INSERT INTO Manager VALUES (0);

INSERT INTO MeetingRooms VALUES 
(0, 0, 'MR_A', 0),
(1, 1, 'MR_B', 0);

INSERT INTO Sessions VALUES 
(0, 0, '00:00:00', '2020-10-01', 0, 1),
(1, 1, '01:01:01', '2020-10-01', NULL, 1),
(1, 1, '02:02:02', '2020-10-02', 0, 1),
(0, 0, '03:03:03', '2020-10-01', NULL, 1),
(0, 0, '04:04:04', '2020-10-02', 0, 0);

----------------------------------------------------------------
---------------------------- OTHERS ----------------------------
----------------------------------------------------------------

SELECT non_compliance ('2021-10-01', '2021-10-04');

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


SELECT view_booking_report('2020-10-01', 1);

SELECT floor, room, date, time, CASE
  WHEN s.meid IS NULL THEN TRUE
  ELSE FALSE END
FROM Sessions s
WHERE s.beid = 1
  AND date >= '2020-10-01'
ORDER BY date ASC, time ASC;


































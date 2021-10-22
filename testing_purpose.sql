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

SELECT non_compliance ('2021-10-01', '2021-10-04');

SELECT DISTINCT hd.eid, COUNT(*)
FROM HealthDeclaration hd
GROUP BY hd.eid
HAVING NOT EXISTS (
  SELECT 1
  FROM HealthDeclaration hd2
  WHERE hd.eid = hd2.eid
    AND hd2.date >= '2021-10-01'
    AND hd2.date <= '2021-10-04'
);

SELECT DISTINCT hd.eid, COUNT(*)
FROM HealthDeclaration hd
GROUP BY hd.eid
HAVING hd.eid NOT IN (
  SELECT hd2.eid
  FROM HealthDeclaration hd2
  WHERE hd.eid = hd2.eid
    AND hd2.date >= '2021-10-01'
    AND hd2.date <= '2021-10-04'
);

-- Cross join employees with list of dates
SELECT e.eid
FROM Employees e LEFT OUTER JOIN HealthDeclaration hd ON e.eid = hd.eid
WHERE NOT EXISTS (
  SELECT 1
  FROM HealthDeclaration hd
  WHERE hd.eid = e.eid 
    AND hd.date >= '2021-10-01'
    AND hd.date <= '2021-10-04'
);


WITH dates (date) AS (
  SELECT DISTINCT date
  FROM HealthDeclaration
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



WITH dates (date) AS (
  SELECT date
  FROM 
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







































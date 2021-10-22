----------------------------------------------------------------
--------------------------- FUNCTIONS --------------------------
----------------------------------------------------------------

-----------
-- Admin --
-----------

---- Non Compliance ----
CREATE OR REPLACE FUNCTION non_compliance 
  (IN start_date DATE, IN end_date DATE)
RETURNS TABLE
  (employee_id INTEGER, number_of_days BIGINT) AS $$
BEGIN
  RETURN QUERY
    WITH dates (date) AS (
      SELECT *
        FROM generate_series(start_date, end_date, '1 day'::interval)
    )
    SELECT e.eid, COUNT(*) AS days
    FROM Employees e, dates d
    WHERE NOT EXISTS (
      SELECT 1
      FROM HealthDeclaration hd
      WHERE hd.eid = e.eid
        AND hd.date = d.date
    )
    GROUP BY e.eid
    ORDER BY days DESC;
END;
$$ LANGUAGE plpgsql;

---- View Booking Report ----
CREATE OR REPLACE FUNCTION view_booking_report
  (IN start_date DATE, IN employee_id INTEGER)
RETURNS TABLE
  (floor_number INTEGER, room_number INTEGER, date DATE, start_hour TIME, is_approved BIT) AS $$
BEGIN
  RETURN QUERY
    SELECT s.floor, s.room, s.date, s.time, CASE
      WHEN s.meid IS NOT NULL THEN B'1'
      ELSE B'0' END
    FROM Sessions s
    WHERE s.beid = employee_id
      AND s.date >= start_date
    ORDER BY s.date ASC, s.time ASC;
END;
$$ LANGUAGE plpgsql;

---- View Future Meetings ----
CREATE OR REPLACE FUNCTION view_future_meeting
  (IN start_date DATE, IN employee_id INTEGER)
RETURNS TABLE
  (floor_number INTEGER, room_number INTEGER, date DATE, start_hour TIME) AS $$
BEGIN
  RETURN QUERY
    SELECT j.floor, j.room, j.date, j.time
    FROM Joins j JOIN Sessions s ON (
      j.floor = s.floor AND j.room = s.room AND j.time = s.time AND j.date = s.date
    )
    WHERE j.eid = employee_id
      AND j.date >= start_date
      AND s.meid IS NOT NULL
    ORDER BY j.date ASC, j.time ASC;
RETURN;
END;
$$ LANGUAGE plpgsql;

---- View Manager Report ----
CREATE OR REPLACE FUNCTION view_manager_report
  (IN start_date DATE, IN m_employee_id INTEGER)
RETURNS TABLE
  (floor_number INTEGER, room_number INTEGER, date DATE, start_hour TIME, b_employee_id INTEGER) AS $$
DECLARE
  department_id INTEGER;
BEGIN
  SELECT did INTO department_id FROM Employees WHERE eid = m_employee_id;

  RETURN QUERY
    SELECT s.floor, s.room, s.date, s.time, s.beid
    FROM Sessions s JOIN MeetingRooms mr ON (
      s.floor = mr.floor AND s.room = mr.room
    )
    WHERE s.meid IS NULL
      AND mr.did = department_id
      AND s.date >= start_date
      AND m_employee_id IN (
        SELECT eid FROM Manager
      );
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
--------------------------- TRIGGERS ---------------------------
----------------------------------------------------------------



























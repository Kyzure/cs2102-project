----------------------------------------------------------------
--------------------------- FUNCTIONS --------------------------
----------------------------------------------------------------

-----------
-- Admin --
-----------

---- Non Compliance ----
CREATE OR REPLACE FUNCTION non_compliance 
  (IN start_date DATE, IN end_date DATE)
RETURNS TABLE(employee_id INTEGER, number_of_days BIGINT) AS $$
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
    WHERE s.beid = 1
      AND s.date >= '2020-10-01'
    ORDER BY s.date ASC, s.time ASC;
END;
$$ LANGUAGE plpgsql;

---- View Future Meetings ----
CREATE OR REPLACE FUNCTION view_future_meeting
RETURNS <type> AS $$
DECLARE
  temp INT := 0;
BEGIN

RETURN;
END;
$$ LANGUAGE plpgsql;

---- View Manager Report ----
CREATE OR REPLACE FUNCTION view_manager_report
RETURNS <type> AS $$
DECLARE
  temp INT := 0;
BEGIN

RETURN;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
--------------------------- TRIGGERS ---------------------------
----------------------------------------------------------------

-----------
-- Admin --
-----------


























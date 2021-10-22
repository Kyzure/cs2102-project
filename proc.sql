----------------------------------------------------------------
--------------------------- FUNCTIONS --------------------------
----------------------------------------------------------------

-----------
-- Admin --
-----------

---- Non Compliance ----
CREATE OR REPLACE FUNCTION non_compliance 
  (IN start_date DATE, IN end_DATE date)
RETURNS TABLE(eid INTEGER, days INTEGER) AS $$
BEGIN
  SELECT DISTINCT e.eid, COUNT(*) INTO eid, days
  FROM Employees e
  GROUP BY e.eid
  HAVING NOT EXISTS (
    SELECT 1
    FROM HealthDeclaration hd
    WHERE hd.eid = e.eid 
      AND hd.date >= start_date
      AND hd.date <= end_date
  );
  RETURN QUERY SELECT eid, days;
END;
$$ LANGUAGE plpgsql;


---- View Booking Report ----
CREATE OR REPLACE FUNCTION view_booking_report
RETURNS <type> AS $$
DECLARE
  temp INT := 0;
BEGIN

RETURN;
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


























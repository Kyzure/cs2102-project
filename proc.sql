----------------------------------------------------------------
--------------------------- FUNCTIONS --------------------------
----------------------------------------------------------------

-----------
-- Basic --
-----------

---- Add Department ----
CREATE OR REPLACE PROCEDURE add_department
  (did INTEGER, dname TEXT)
AS $$
BEGIN
  INSERT INTO Departments VALUES (did, dname);
END
$$ LANGUAGE plpgsql;

---- Remove Department ----
CREATE OR REPLACE PROCEDURE remove_department
  (selected_did INTEGER)
AS $$
BEGIN
  DELETE FROM Departments WHERE did = selected_did;
END
$$ LANGUAGE plpgsql;

---- Add Room ----
CREATE OR REPLACE PROCEDURE add_room
  (floor INTEGER, room INTEGER, rname TEXT, capacity INTEGER, did INTEGER, eid INTEGER, added_date DATE)
AS $$
BEGIN
  INSERT INTO MeetingRooms VALUES (room, floor, rname, did);
  INSERT INTO Updates VALUES (room, floor, eid, added_date, capacity);
END
$$ LANGUAGE plpgsql;

---- Change Capacity ----
CREATE OR REPLACE PROCEDURE change_capacity
  (floor INTEGER, room INTEGER, eid INTEGER, capacity INTEGER, date DATE)
AS $$
BEGIN
  INSERT INTO Updates VALUES (room, floor, eid, date, capacity);
END
$$ LANGUAGE plpgsql;

---- Add Employee ----
CREATE OR REPLACE PROCEDURE add_employee
  (ename TEXT, primary_contact TEXT, secondary_contact TEXT, kind TEXT, did INTEGER)
AS $$
DECLARE
  new_eid INTEGER;
  new_email TEXT;
BEGIN
  SELECT COALESCE(MAX(eid), 0) + 1 INTO new_eid FROM Employees;
  SELECT CONCAT(ename, new_eid, '@gmail.com') INTO new_email;
  INSERT INTO Employees VALUES (new_eid, ename, new_email, primary_contact, secondary_contact, null, did);
  CASE
    WHEN kind = 'junior' OR kind = 'Junior' THEN
      INSERT INTO Junior VALUES (new_eid);
    WHEN kind = 'senior' OR kind = 'Senior' THEN
      INSERT INTO Booker VALUES (new_eid);
      INSERT INTO Senior VALUES (new_eid);
    WHEN kind = 'manager' OR kind = 'Manager' THEN
      INSERT INTO Booker VALUES (new_eid);
      INSERT INTO Manager VALUES (new_eid);
  END CASE;
END
$$ LANGUAGE plpgsql;

---- Remove Employee ----
CREATE OR REPLACE PROCEDURE remove_employee
  (selected_eid INTEGER, resignation_date DATE)
AS $$
BEGIN
  Update Employees
  SET resigned_date = resignation_date
  WHERE eid = selected_eid;
END
$$ LANGUAGE plpgsql;

-----------
-- Core --
-----------

---- search_room ----
CREATE OR REPLACE FUNCTION search_room
  (IN capacity INTEGER, IN date DATE, IN startTime TIME, IN endTime TIME)
RETURNS TABLE(floor INTEGER, room INTEGER, did INTEGER, room_capcity INTEGER) AS $$
BEGIN
  RETURN QUERY (
    SELECT mr.floor, mr.room, mr.did, up.new_cap
    FROM MeetingRooms mr 
    JOIN (
      SELECT * FROM Updates
      WHERE new_cap >= capacity
    ) up
    ON mr.floor = up.floor
    AND mr.room = up.room
    WHERE NOT EXISTS (
      SELECT s.floor, s.room
      FROM Sessions s
      WHERE time >= startTime
      AND time < endTime
    )
  );
END
$$ LANGUAGE plpgsql;

---- book_room ----
CREATE OR REPLACE PROCEDURE book_room
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM sessions S
    WHERE s.floor = floor_number 
      AND s.room = room_number
      AND s.date = meet_date
      AND s.time >= startTime
      AND s.time < endTime
  ) THEN
    WITH RECURSIVE insertSession AS (
    SELECT startTime AS time
    UNION ALL
    SELECT time + interval '1 hour'
    FROM insertSession
    WHERE time + interval '1 hour'< endTime
  )
    INSERT INTO sessions (room, floor, time , date, beid)
    SELECT room_number, floor_number, time, meet_date, id
    FROM insertSession;
  END IF;
END
$$ LANGUAGE plpgsql;

---- unbook_room ----
CREATE OR REPLACE PROCEDURE unbook_room
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN
  DELETE FROM Sessions s
  WHERE s.floor = floor_number 
    AND s.room = room_number
    AND s.date = meet_date
    AND s.time >= startTime
    AND s.time < endTime
    and beid = id;
END
$$ LANGUAGE plpgsql;

---- join_meeting ----
CREATE OR REPLACE PROCEDURE join_meeting
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN
 WITH RECURSIVE insertMember AS (
   SELECT startTime AS time
   UNION ALL
   SELECT time + interval '1 hour'
   FROM insertMember
   WHERE time + interval '1 hour'< endTime
 )
 INSERT INTO Joins(eid, room, floor, time, date)
 SELECT id, room_number, floor_number, time, meet_date 
 FROM insertMember;
END
$$ LANGUAGE plpgsql;

---- leave_meeting ----
CREATE OR REPLACE PROCEDURE leave_meeting
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN

END
$$ LANGUAGE plpsql;
---- approve_meeting ----
CREATE OR REPLACE PROCEDURE approve_meeting
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN

END
$$ LANGUAGE plpsql;

------------
-- Health --
------------

-- Replaced to a PROCEDURE for data usage. --
-- Needs to overwrite current temperatures --
CREATE OR REPLACE PROCEDURE declare_health
  (IN new_eid INT, IN new_date DATE, IN new_temperature NUMERIC)
AS $$
DECLARE
    fever BIT := '0';
BEGIN
    DELETE FROM healthdeclaration
    WHERE eid = new_eid AND date = new_date;
    IF new_temperature > 37.5
        THEN fever := '1';
    END IF;
    INSERT INTO healthdeclaration VALUES (new_eid, new_date, new_temperature, fever);
END;
$$ LANGUAGE plpgsql;

/*
-- Replaced to a PROCEDURE for data usage. --
CREATE OR REPLACE FUNCTION declare_health
  (IN eid INT, IN date DATE, IN temp NUMERIC) 
RETURNS VOID AS $$
    DECLARE 
        fever BIT := '0';
    BEGIN
        IF temp > 37.5
            THEN fever := '1';
        END IF;
        INSERT INTO healthdeclaration
        VALUES (eid, date, temp, fever);
    END;
$$ LANGUAGE plpgsql;

*/

CREATE OR REPLACE FUNCTION contact_tracing
  (IN e_id INT)
RETURNS TABLE (eid INT) AS $$
    BEGIN
    SELECT v.eid
        FROM joins u, joins v, healthdeclaration h
        WHERE h.eid = e_id
            AND h.fever = '1'
            AND u.eid = e_id
            AND v.eid <> e_id
            AND u.room = v.room
            AND u.floor = v.floor
            AND u.time = v.time
            AND u.date = v.date
            AND v.date >= D - interval '3 day';
    END;
$$ LANGUAGE plpgsql;

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

-----------
-- Basic --
-----------
/*
CREATE OR REPLACE FUNCTION is_department_empty()
RETURNS TRIGGER AS $$
DECLARE
  employee_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO employee_count
  FROM Employees E, Department D
  WHERE E.did = D.did;

  IF employee_count = 0 THEN
    RETURN NEW;
  ELSE
    RAISE NOTICE '% Department is not empty.', D.dname;
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_department_empty
BEFORE DELETE ON Departments
FOR EACH ROW EXECUTE FUNCTION is_department_empty();
*/





----------------------------------------------------------------
--------------------------- FUNCTIONS --------------------------
----------------------------------------------------------------

-- Drops --
DROP PROCEDURE IF EXISTS add_department, remove_department, add_room, change_capacity, add_employee, remove_employee, book_room, unbook_room, join_meeting, leave_meeting, approve_meeting, declare_health CASCADE;

DROP FUNCTION IF EXISTS search_room, check_joining, check_approval, check_booking, add_booker, contact_tracing, remove_close_contacts, remove_booked_meetings, check_health_validity, non_compliance, view_booking_report, view_future_meeting, view_manager_report, is_booker_or_manager_retired, is_employee_retired CASCADE;

DROP TRIGGER IF EXISTS check_retired_Updates ON Updates;
DROP TRIGGER IF EXISTS check_retired_Joins ON Joins;
DROP TRIGGER IF EXISTS check_retired_Health_Declaration ON HealthDeclaration;
DROP TRIGGER IF EXISTS check_MeetingRooms_same_department_as_Manager ON Updates;
DROP TRIGGER IF EXISTS check_retired_Sessions ON Sessions;
DROP TRIGGER IF EXISTS trace_contacts ON healthdeclaration;
DROP TRIGGER IF EXISTS remove_bookings ON healthdeclaration;
DROP TRIGGER IF EXISTS check_health_declared ON healthdeclaration;
DROP TRIGGER IF EXISTS is_booker_or_manager_retired ON Sessions;
DROP TRIGGER IF EXISTS is_employee_retired ON Sessions;
DROP TRIGGER IF EXISTS is_employee_retired ON HealthDeclaration;
DROP TRIGGER IF EXISTS is_employee_retired ON Updates;
DROP TRIGGER IF EXISTS is_employee_retired ON Joins;

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
  IF added_date < CURRENT_DATE
    THEN
      RAISE NOTICE '% is not a current or future date', added_date;      
  ELSE
    INSERT INTO MeetingRooms VALUES (room, floor, rname, did);
    INSERT INTO Updates VALUES (room, floor, eid, added_date, capacity);
  END IF;
END
$$ LANGUAGE plpgsql;

---- Change Capacity ----
CREATE OR REPLACE PROCEDURE change_capacity
  (_floor INTEGER, _room INTEGER, _eid INTEGER, _capacity INTEGER, _date DATE)
AS $$
BEGIN
  IF _date < CURRENT_DATE
    THEN
      RAISE NOTICE '% is not a current or future date', _date;
  ELSEIF _eid NOT IN (SELECT * FROM Manager)
    THEN
      RAISE NOTICE '% is not a manager', _eid;
  ELSEIF NOT EXISTS (
    SELECT *
    FROM MeetingRooms MR JOIN Employees E ON MR.did = E.did
    WHERE _floor = MR.floor AND _room = MR.room AND _eid = E.eid
  ) THEN
    RAISE NOTICE 'MeetingRoom belongs to different department from %', _eid;
  ELSE
    INSERT INTO Updates VALUES (_room, _floor, _eid, _date, _capacity);
  END IF;
END
$$ LANGUAGE plpgsql;

---- Add Employee ----
CREATE OR REPLACE PROCEDURE add_employee
  (ename TEXT, primary_contact TEXT, secondary_contact TEXT, kind TEXT, did INTEGER)
AS $$
DECLARE
  temp_name TEXT;
  new_eid INTEGER;
  new_email TEXT;
BEGIN
  SELECT COALESCE(MAX(eid), 0) + 1 INTO new_eid FROM Employees;
  SELECT REPLACE(ename, ' ', '_') INTO temp_name;
  SELECT CONCAT(temp_name, new_eid, '@gmail.com') INTO new_email;
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
  (IN capacity INTEGER, IN dates DATE, IN startTime TIME, IN endTime TIME)
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
      AND s.date = dates
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
  DELETE FROM Joins j
  WHERE j.floor = floor_number
  AND j.room = room_number
  AND j.date = meet_date
  AND j.time >= startTime
  AND j.time < endTime
  AND j.eid = id;
END
$$ LANGUAGE plpgsql;

---- approve_meeting ----
CREATE OR REPLACE PROCEDURE approve_meeting
  (floor_number INTEGER, room_number INTEGER, meet_date DATE, 
  startTime TIME, endTime TIME, id INTEGER)
AS $$
BEGIN
  IF (now() < meet_date)
  THEN 
    UPDATE Sessions s
    SET meid = id
    WHERE s.floor = floor_number 
      AND s.room = room_number
      AND s.date = meet_date
      AND s.time >= startTime
      AND s.time < endTime
      AND s.meid IS NULL
      AND EXISTS  (
        SELECT 1
        FROM MeetingRooms mr
        WHERE mr.floor = floor_number
        AND mr.room = room_number
        AND mr.did IN (
          SELECT e2.did
          FROM Employees e2 
          JOIN Manager m
          ON e2.eid = m.eid
          WHERE e2.eid = id
        )
      );
    END IF;
END
$$ LANGUAGE plpgsql;

---------------------------
---- trigger functions ----
---------------------------
---- check_joining ----
CREATE OR REPLACE FUNCTION check_joining()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM Sessions s
    WHERE s.floor = NEW.floor
    AND s.room = NEW.room
    AND s.date = NEW.date
    AND s.time = NEW.time
    AND s.meid IS NULL
  ) THEN
      RETURN OLD;
  ELSEIF EXISTS (
    SELECT 1 
    FROM healthDeclaration h
    WHERE h.eid = NEW.eid
    AND h.fever = '1'
    AND h.date >= now() - interval '7 day'
    AND h.date <= now()
  ) THEN
      RETURN OLD;
  ELSEIF (
    now() >= NEW.date
  ) THEN
  ELSEIF (
    (SELECT COUNT (*)
    FROM joins j
    WHERE j.room = NEW.room
    AND j.floor = NEW.floor
    AND j.time = NEW.time
    AND j.date = NEW.date) >=
    (SELECT u.new_cap
     FROM Updates u
     WHERE u.room = NEW.room
     AND u.floor = NEW.floor
     AND u.date <= NEW.date
     ORDER BY u.date DESC
     LIMIT 1
    )
  ) THEN
      return OLD;
  ELSEIF EXISTS (
    SELECT 1
      FROM joins u, joins v
      WHERE u.eid = NEW.eid
          AND v.eid <> NEW.eid
          AND u.room = v.room
          AND u.floor = v.floor
          AND u.time = v.time
          AND u.date = v.date
          AND v.date <= now()
          AND v.date >= now() - interval '3 day'
          AND v.eid IN (
            SELECT h.eid FROM healthdeclaration h
            WHERE fever = '1'
            AND h.date <= now()
            AND h.date >= now() - interval '3 day'
          )
  ) THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END
$$ LANGUAGE plpgsql;

---- check_approval ----
CREATE OR REPLACE FUNCTION check_approval()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM Sessions s
    WHERE s.floor = NEW.floor
    AND s.room = NEW.room
    AND s.date = NEW.date
    AND s.time = NEW.time
    AND s.meid IS NOT NULL
  ) THEN
    RETURN NEW;
  ELSEIF (
    now() >= NEW.date
  ) THEN
    RETURN NEW;
  ELSE
    RETURN OLD;
  END IF;
END
$$ LANGUAGE plpgsql;

---- check_booking ----
CREATE OR REPLACE FUNCTION check_booking()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM healthDeclaration h
    WHERE h.eid = NEW.beid
    AND h.fever = '1'
    AND h.date >= now() - interval '7 day'
    AND h.date <= now()
  ) THEN
    RETURN OLD;
  ELSEIF EXISTS (
    SELECT 1
    FROM Junior j
    WHERE j.eid = NEW.beid
  ) THEN
      RETURN OLD;
  ELSEIF (
    now() >= NEW.date
  ) THEN
      RETURN OLD;
  ELSEIF EXISTS (
    SELECT 1
      FROM joins u, joins v
      WHERE u.eid = NEW.beid
          AND v.eid <> NEW.beid
          AND u.room = v.room
          AND u.floor = v.floor
          AND u.time = v.time
          AND u.date = v.date
          AND v.date <= now()
          AND v.date >= now() - interval '3 day'
          AND v.eid IN (
            SELECT h.eid FROM healthdeclaration h
            WHERE fever = '1'
            AND h.date <= now()
            AND h.date >= now() - interval '3 day'
          )
  ) THEN
    RETURN OLD;
  ELSE 
    RETURN NEW;
  END IF;
END
$$ LANGUAGE plpgsql;

---- add_booker ----
CREATE OR REPLACE FUNCTION add_booker()
RETURNS TRIGGER AS $$
BEGIN
  CALL join_meeting(
    NEW.floor, NEW.room, NEW.date, NEW.time, 
    NEW.time + interval '1 hour', NEW.beid);
  RETURN NEW;
END
$$ LANGUAGE plpgsql;

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
    INSERT INTO healthdeclaration
    VALUES (new_eid, new_date, new_temperature, fever);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contact_tracing(IN e_id INT)
RETURNS TABLE (eid INT) AS $$
    DECLARE
        D Date ;
    BEGIN
    select MAX(DATE) INTO D 
            from healthdeclaration h
            where fever = '1'
                AND h.eid = e_id
            group by h.eid;
    RETURN QUERY SELECT v.eid
        FROM joins u, joins v
        WHERE u.eid = e_id
            AND v.eid <> e_id
            AND u.room = v.room
            AND u.floor = v.floor
            AND u.time = v.time
            AND u.date = v.date
            AND v.date <= D
            AND v.date >= D - interval '3 day';
    END;
$$ Language plpgsql;

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
      )
    ORDER BY s.date ASC, s.time ASC;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
--------------------------- TRIGGERS ---------------------------
----------------------------------------------------------------

-----------
-- Basic --
-----------
CREATE OR REPLACE FUNCTION is_employee_retired()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT *
      FROM Employees E
      WHERE E.eid = NEW.eid AND E.resigned_date <= NEW.date
    ) THEN
      RAISE NOTICE 'Employee % has retired', NEW.eid;
      RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_booker_or_manager_retired()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT *
      FROM Employees E
      WHERE E.eid = NEW.beid AND E.resigned_date <= NEW.date
    ) THEN
      RAISE NOTICE 'Booker % has retired', NEW.beid;
      RETURN NULL;
  ELSEIF EXISTS (SELECT *
    FROM Employees E
    WHERE E.eid = NEW.meid AND E.resigned_date <= NEW.date
  ) THEN
      RAISE NOTICE 'Manager % has retired', NEW.meid;
      RETURN NULL;
  ELSE
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_retired_Health_Declaration
BEFORE INSERT ON HealthDeclaration
FOR EACH ROW EXECUTE FUNCTION is_employee_retired();

CREATE TRIGGER check_retired_Updates
BEFORE INSERT ON Updates
FOR EACH ROW EXECUTE FUNCTION is_employee_retired();

CREATE TRIGGER check_retired_Sessions
BEFORE INSERT OR UPDATE ON Sessions
FOR EACH ROW EXECUTE FUNCTION is_Booker_or_Manager_retired();

CREATE TRIGGER check_retired_Joins
BEFORE INSERT ON Joins
FOR EACH ROW EXECUTE FUNCTION is_employee_retired();

-----------
-- Core --
-----------

---- check_join ----
CREATE TRIGGER check_join
BEFORE INSERT ON Joins
FOR EACH ROW EXECUTE FUNCTION
  check_joining();

---- check_approve ----
CREATE TRIGGER check_approve
BEFORE DELETE ON Joins
FOR EACH ROW EXECUTE FUNCTION
  check_approval();

---- check_book ----
CREATE TRIGGER check_book
BEFORE INSERT ON Sessions
FOR EACH ROW EXECUTE FUNCTION
  check_booking();

---- add_book ----
CREATE TRIGGER add_book
AFTER INSERT ON Sessions
FOR EACH ROW EXECUTE FUNCTION
  add_booker();

---------------------
-- Contact Tracing --
---------------------
---- remove_close_contacts ----
CREATE OR REPLACE FUNCTION remove_close_contacts()
RETURNS TRIGGER AS $$
DECLARE
        D Date ;
BEGIN
    select MAX(DATE) INTO D 
            from healthdeclaration h
            where fever = '1'
                AND h.eid = NEW.eid
            group by h.eid;

    DELETE FROM joins j
    WHERE j.eid in (SELECT * 
                    FROM contact_tracing(NEW.eid))
        AND j.date >= D
        AND j.date <= D + interval '7 day';
    
    RETURN NULL;
END;
$$ Language plpgsql;

CREATE TRIGGER trace_contacts
AFTER INSERT ON healthdeclaration
FOR EACH ROW WHEN (NEW.fever = '1')
EXECUTE FUNCTION remove_close_contacts();

---- remove_booked_meetings ----
CREATE OR REPLACE FUNCTION remove_booked_meetings()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM SESSIONS s
    WHERE beid = NEW.eid;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER remove_bookings
AFTER INSERT ON healthdeclaration
FOR EACH ROW WHEN (NEW.fever = '1')
EXECUTE FUNCTION remove_booked_meetings();

-------------------------------------
---- Check Validity of healthdec ----
-------------------------------------

CREATE OR REPLACE FUNCTION check_health_validity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date > CURRENT_DATE THEN 
        RAISE NOTICE 'You cannot declare health for a future date.';
        RETURN NULL;
    ELSEIF NEW.temp > 43.0 THEN 
        RAISE NOTICE 'Temperature declared is too high.';
        RETURN NULL;
    ELSEIF NEW.temp < 34.0 THEN 
        RAISE NOTICE 'Temperature declared is too low.';
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_health_declared
BEFORE INSERT ON healthdeclaration
FOR EACH ROW EXECUTE FUNCTION check_health_validity();





----------------------------------------------------------------
-- SCHEMA ------------------------------------------------------
----------------------------------------------------------------

CREATE TABLE Emplyoees (
  eid INTEGER PRIMARY KEY,
  ename TEXT,
  email TEXT UNIQUE,
  contact TEXT,
  resigned_date DATE
);

CREATE TABLE Departments (
  did INTEGER PRIMARY KEY
  dname TEXT
);

CREATE TABLE MeetingRooms (
  room INTEGER
  floor INTEGER
  rname
  PRIMARY KEY (room, floor)
);

CREATE TABLE Booker (

);

CREATE TABLE Senior (

);

CREATE TABLE Manager (

);













































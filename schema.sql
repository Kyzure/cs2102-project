----------------------------------------------------------------
---------------------------- SCHEMA ----------------------------
----------------------------------------------------------------

DROP TABLE IF EXISTS Departments, Employees, MeetingRooms, Junior, Booker, Senior, Manager, HealthDeclaration, Updates, Sessions, Joins;

CREATE TABLE Departments (
  did INTEGER,
  dname TEXT,
  PRIMARY KEY (did)
);

CREATE TABLE Employees (
  eid INTEGER,
  ename TEXT,
  email TEXT,
  contact TEXT,
  resigned_date DATE,
  did INTEGER NOT NULL,
  PRIMARY KEY (eid),
  UNIQUE (email),
  FOREIGN KEY (did) REFERENCES Departments (did)
);

CREATE TABLE MeetingRooms (
  room INTEGER,
  floor INTEGER,
  rname TEXT,
  did INTEGER NOT NULL,
  PRIMARY KEY (room, floor),
  FOREIGN KEY (did) REFERENCES Departments (did)
);

CREATE TABLE Junior (
  eid INTEGER,
  PRIMARY KEY (eid),
  FOREIGN KEY (eid) REFERENCES Employees (eid) ON DELETE CASCADE
);

CREATE TABLE Booker (
  eid INTEGER,
  PRIMARY KEY (eid),
  FOREIGN KEY (eid) REFERENCES Employees (eid) ON DELETE CASCADE
);

CREATE TABLE Senior (
  eid INTEGER,
  PRIMARY KEY (eid),
  FOREIGN KEY (eid) REFERENCES Booker (eid) ON DELETE CASCADE
);

CREATE TABLE Manager (
  eid INTEGER,
  PRIMARY KEY (eid),
  FOREIGN KEY (eid) REFERENCES Booker (eid) ON DELETE CASCADE
);

CREATE TABLE HealthDeclaration (
  eid INTEGER,
  date DATE,
  temp NUMERIC,
  fever BIT,
  PRIMARY KEY (eid, date),
  FOREIGN KEY (eid) REFERENCES Employees(eid)
);

CREATE TABLE Updates (
  room INTEGER,
  floor INTEGER,
  eid INTEGER,
  date DATE,
  new_cap INTEGER NOT NULL,
  PRIMARY KEY (room, floor, date),
  FOREIGN KEY (room, floor) REFERENCES MeetingRooms (room, floor),
  FOREIGN KEY (eid) REFERENCES Manager (eid)
);

CREATE TABLE Sessions (
  room INTEGER,
  floor INTEGER,
  time TIME,
  date DATE,
  meid INTEGER,
  beid INTEGER NOT NULL,
  PRIMARY KEY (room, floor, time, date),
  FOREIGN KEY (meid) REFERENCES Manager (eid),
  FOREIGN KEY (beid) REFERENCES Booker (eid),
  FOREIGN KEY (room, floor) REFERENCES MeetingRooms (room, floor)
);

CREATE TABLE Joins (
  eid INTEGER,
  room INTEGER,
  floor INTEGER,
  time TIME,
  date DATE,
  PRIMARY KEY (eid, room, floor, time, date),
  FOREIGN KEY (eid) REFERENCES Employees (eid),
  FOREIGN KEY (room, floor, time, date) REFERENCES Sessions (room, floor, time, date)
);

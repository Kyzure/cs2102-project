#### Imports ####
import random

#### Classes ####
class Session: 
  def __init__(self, room, floor, time, date, meid, beid): 
    self.room = room
    self.floor = floor
    self.time = time
    self.date = date
    self.meid = meid
    self.beid = beid

class Join: 
  def __init__(self, eid, room, floor, time, date): 
    self.eid = eid
    self.room = room
    self.floor = floor
    self.time = time
    self.date = date

class MeetingRoom:
  def __init__(self, room, floor, did): 
    self.room = room
    self.floor = floor
    self.did = did

class Manager:
  def __init__(self, eid, did): 
    self.eid = eid
    self.did = did

#### Data ####

# Final String
sqlString = ""

# Bookers
booker_list = [2, 3, 5, 9, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 25, 28, 29, 31, 36, 37, 39, 41, 44, 45, 47, 48, 49, 52, 54, 56, 58, 60, 62, 63, 64, 66, 67, 68, 70, 71, 74, 75, 78, 81, 82, 83, 84, 85, 86, 87, 88, 89, 91, 93, 96]

# Managers
manager_list = []

manager_list.append(None)
manager_list.append(None)
manager_list.append(None)
manager_list.append(None)
manager_list.append(None)
manager_list.append(Manager(  3,  1))
manager_list.append(Manager(  5,  1))
manager_list.append(Manager( 12,  1))
manager_list.append(Manager( 13,  1))
manager_list.append(Manager( 23,  2))
manager_list.append(Manager( 24,  2))
manager_list.append(Manager( 25,  2))
manager_list.append(Manager( 31,  3))
manager_list.append(Manager( 39,  4))
manager_list.append(Manager( 45,  5))
manager_list.append(Manager( 47,  5))
manager_list.append(Manager( 56,  5))
manager_list.append(Manager( 64,  6))
manager_list.append(Manager( 70,  6))
manager_list.append(Manager( 81,  8))
manager_list.append(Manager( 82,  8))
manager_list.append(Manager( 85,  8))
manager_list.append(Manager( 91,  9))
manager_list.append(Manager( 96, 10))

room_floor = []
room_floor.append(MeetingRoom( 8,  5, 10))
room_floor.append(MeetingRoom(36, 12,  8))
room_floor.append(MeetingRoom(50, 14,  2))
room_floor.append(MeetingRoom( 8,  7,  4))
room_floor.append(MeetingRoom(35,  4,  2))
room_floor.append(MeetingRoom(32, 15,  6))
room_floor.append(MeetingRoom(19,  1,  1))
room_floor.append(MeetingRoom(35,  2,  5))
room_floor.append(MeetingRoom(48, 11,  7))
room_floor.append(MeetingRoom(40,  9,  3))
room_floor.append(MeetingRoom(44,  5,  3))
room_floor.append(MeetingRoom(11,  4,  9))
room_floor.append(MeetingRoom(44,  4,  3))
room_floor.append(MeetingRoom(10, 11,  7))
room_floor.append(MeetingRoom(42,  6,  3))
room_floor.append(MeetingRoom(10, 13,  5))
room_floor.append(MeetingRoom(27,  5,  8))
room_floor.append(MeetingRoom(29,  9, 10))
room_floor.append(MeetingRoom( 2,  1,  6))
room_floor.append(MeetingRoom(27,  9,  5))
room_floor.append(MeetingRoom(11, 15,  7))
room_floor.append(MeetingRoom(27,  8,  5))
room_floor.append(MeetingRoom(13, 15,  5))
room_floor.append(MeetingRoom( 2,  8,  8))
room_floor.append(MeetingRoom(28,  3,  2))
room_floor.append(MeetingRoom(37, 13,  6))
room_floor.append(MeetingRoom(37,  6,  8))
room_floor.append(MeetingRoom(48, 13, 10))
room_floor.append(MeetingRoom(35, 14,  7))
room_floor.append(MeetingRoom(35,  3,  9))
room_floor.append(MeetingRoom(12,  1,  3))
room_floor.append(MeetingRoom( 4, 13,  7))
room_floor.append(MeetingRoom(26,  8,  5))
room_floor.append(MeetingRoom( 1, 10,  6))
room_floor.append(MeetingRoom(47, 15,  1))
room_floor.append(MeetingRoom(32,  2,  2))
room_floor.append(MeetingRoom(26, 13,  3))
room_floor.append(MeetingRoom(21, 13,  1))
room_floor.append(MeetingRoom(46,  6,  8))
room_floor.append(MeetingRoom(28,  2,  8))
room_floor.append(MeetingRoom(11, 13,  5))
room_floor.append(MeetingRoom(34,  1,  1))
room_floor.append(MeetingRoom(31, 14,  3))
room_floor.append(MeetingRoom(18, 13,  7))
room_floor.append(MeetingRoom( 8,  8,  8))
room_floor.append(MeetingRoom(21,  5,  1))
room_floor.append(MeetingRoom(31,  1,  8))
room_floor.append(MeetingRoom(36, 15,  5))
room_floor.append(MeetingRoom(31,  3,  1))
room_floor.append(MeetingRoom(19,  8, 10))

# Populate time of day
time_of_day = []
for i in range(24):
  hour = i
  if (hour <= 9):
    hour = "0" + str(hour)
  else:
    hour = str(hour)
  time_of_day.append("'" + hour + ":00:00'")

# Populate booking date
booking_dates = []
for i in range(1, 29):
  day = i
  if (day <= 9):
    day = "0" + str(day)
  else:
    day = str(day)
  booking_dates.append("'2021-02-" + day + "'")

## Data post randomzie ##
sessions = []

joins = []

## Randomizing Sessions ##
for num in range(200):
  randRoom = random.randrange(0, len(room_floor))
  randTime = random.randrange(0, len(time_of_day))
  randDate = random.randrange(0, len(booking_dates))
  randManager = random.randrange(0, len(manager_list))
  randBooker = random.randrange(0, len(booker_list))

  room = room_floor[randRoom]

  manager = None
  for i in range(20):
    manager = manager_list[randManager]
    if manager != None and manager.did == room.did:
      break
    randManager = randManager = random.randrange(0, len(manager_list))


  if (manager == None or manager.did != room.did):
    manager = "null"
  else:
    manager = str(manager.eid)

  obj = Session(
    str(room_floor[randRoom].room),
    str(room_floor[randRoom].floor),
    str(time_of_day[randTime]),
    str(booking_dates[randDate]),
    manager,
    str(booker_list[randBooker]))

  line = "INSERT INTO Sessions VALUES ("
  line += obj.room + ", " + obj.floor + ", " + obj.time + ", "
  line += obj.date + ", " + obj.meid + ", " + obj.beid + ");\n"
  sqlString += line
  sessions.append(obj)

# Spacing
sqlString += "\n"


## Randomizing Joins ##
for num in range(2000):
  randSession = random.randrange(0, len(sessions))
  sess = sessions[randSession]
  employee = random.randrange(1, 100)

  if(sess == None):
    continue

  obj = Join(
    str(employee),
    str(sess.room),
    str(sess.floor),
    str(sess.time),
    str(sess.date))

  for j in joins:
    if obj.eid == j.eid and obj.room == j.room and obj.floor == j.floor and obj.time == j.time and obj.date == j.date:
      continue
  
  line = "INSERT INTO Joins VALUES ("
  line += obj.eid + ", " + obj.room + ", " + obj.floor + ", " + obj.time + ", " + obj.date
  line += ");\n"
  sqlString += line
  joins.append(obj)

# Spacing
sqlString += "\n"


#### Write ####
f = open("data.txt", "w")
f.write(sqlString)
f.close()



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

#### Data ####

# Final String
sqlString = ""

room_floor = [(8, 5), (36, 12), (50, 14), (8, 7), (35, 4), (32, 15), (19, 1), (35, 2), (48, 11), (40, 9), (44, 5), (11, 4), (44, 4), (10, 11), (42, 6), (10, 13), (27, 5), (29, 9), (2, 1), (27, 9), (11, 15), (27, 8), (13, 15), (2, 8), (28, 3), (37, 13), (37, 6), (48, 13), (35, 14), (35, 3), (12, 1), (4, 13), (26, 8), (1, 10), (47, 15), (32, 2), (26, 13), (21, 13), (46, 6), (28, 2), (11, 13), (34, 1), (31, 14), (18, 13), (8, 8), (21, 5), (31, 1), (36, 15), (31, 3), (19, 8)]

# Managers
manager_list = [3, 5, 12, 13, 23, 24, 25, 31, 39, 45, 47, 56, 64, 70, 81, 82, 85, 91, 96]

# Bookers
booker_list = [2, 3, 5, 9, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 25, 28, 29, 31, 36, 37, 39, 41, 44, 45, 47, 48, 49, 52, 54, 56, 58, 60, 62, 63, 64, 66, 67, 68, 70, 71, 74, 75, 78, 81, 82, 83, 84, 85, 86, 87, 88, 89, 91, 93, 96]

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

## Randomizing Sessions ##
for num in range(100):
  randRoom = random.randrange(0, len(room_floor))
  randTime = random.randrange(0, len(time_of_day))
  randDate = random.randrange(0, len(booking_dates))
  randManager = random.randrange(0, len(manager_list))
  randBooker = random.randrange(0, len(booker_list))

  obj = Session(
    str(room_floor[randRoom][0]),
    str(room_floor[randRoom][1]),
    str(time_of_day[randTime]),
    str(booking_dates[randDate]),
    str(manager_list[randManager]),
    str(booker_list[randBooker]))

  line = "INSERT INTO Sessions VALUES ("
  line += obj.room + ", " + obj.floor + ", " + obj.time + ", "
  line += obj.date + ", " + obj.meid + ", " + obj.beid + ");\n"
  sqlString += line
  sessions.append(obj)

# Spacing
sqlString += "\n"


## Randomizing Joins ##
for num in range(1000):
  randSession = random.randrange(0, len(sessions))
  sess = sessions[randSession]
  employee = random.randrange(1, 100)

  obj = Join(
    str(employee),
    sess.room,
    sess.floor,
    sess.time,
    sess.date)
  
  line = "INSERT INTO Joins VALUES ("
  line += obj.eid + ", " + obj.room + ", " + obj.floor + ", " + obj.time + ", " + obj.date
  line += ");\n"
  sqlString += line

# Spacing
sqlString += "\n"


#### Write ####
f = open("data.txt", "w")
f.write(sqlString)
f.close()



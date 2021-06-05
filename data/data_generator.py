#################
#### Imports ####
#################
import random

#################
#### Classes ####
#################
class BookRoom: 
  def __init__(self, floor, room, date, startTime, endTime, eid): 
    self.floor = floor
    self.room = room
    self.date = date
    self.startTime = startTime
    self.endTime = endTime
    self.eid = eid

class ApproveMeeting:
  def __init__(self, floor, room, date, startTime, endTime, eid): 
    self.floor = floor
    self.room = room
    self.date = date
    self.startTime = startTime
    self.endTime = endTime
    self.eid = eid  

class JoinMeeting: 
  def __init__(self, floor, room, date, startTime, endTime, eid): 
    self.floor = floor
    self.room = room
    self.date = date
    self.startTime = startTime
    self.endTime = endTime
    self.eid = eid  

class Manager:
  def __init__(self, eid, did): 
    self.eid = eid
    self.did = did

class Updates:
  def __init__(self, floor, room, eid, capacity, date): 
    self.floor = floor
    self.room = room
    self.eid = eid
    self.capacity = capacity
    self.date = date

class HealthDeclaration:
  def __init__(self, eid, date, temp): 
    self.eid = eid
    self.date = date
    self.temp = temp

class AddRooms:
  def __init__(self, floor, room, rname, capacity, did, eid, date): 
    self.floor = floor
    self.room = room
    self.rname = rname
    self.capacity = capacity
    self.did = did
    self.eid = eid
    self.date = date

##############
#### Data ####
##############
# Final String
sqlString = ""

# Front data
room_floor = []
book_room = []
join_meeting = []
approve_meeting = []

# randomRoomNames
randomRoomNames = ["Flexidy", "Solaris", "YSolowarm", "Trippledex", "Keylex", "Treeflex", "Fintone", "Transcof", "Andalax", "Stringtough", "Gembucket", "Flexidy", "Otcom", "Flexidy", "Biodex", "Cookley", "Flexidy", "Tres-Zap", "Gembucket", "Zaam-Dox", "Voyatouch", "Prodder", "Keylex", "Viva", "Mat Lam Tam", "Holdlamis", "Voltsillam", "Daltfresh", "Tin", "Home Ing", "Tresom", "Zathin", "Cardify", "Matsoft", "TresZap", "Duobam", "Zathin", "Fixflex", "Opela", "Ventosanzap", "Trippledex", "Quo Lux", "Lotstring", "Namfix", "Bitwolf", "Cookley", "Alpha", "Sonsing", "Lotlux", "Keylex", "Greenlam", "Temp", "Job", "Voyatouch", "Cookley", "Home Ing", "Wrapsafe", "Ronstring", "Duobam", "Tres-Zap", "Holdlamis", "Bytecard", "Zathin", "Tresom", "Fintone", "Vagram", "Andalax", "Ventosanzap", "Voyatouch", "Biodex", "Bigtax", "Transcof", "Bamity", "Sonsing", "Viva", "YSolowarm", "Biodex", "Bigtax", "Bitchip", "Tampflex", "Span", "Tempsoft", "Job", "Kanlam", "Zamit", "Lotstring", "Konklux", "Stim", "Tempsoft", "Tres-Zap", "Duobam", "Alphazap", "Lotstring", "Namfix", "Subin", "Fix San", "Matsoft", "Asoka", "Cardguard", "Toughjoyfax"]

# Bookers
booker_list = [2, 3, 5, 9, 10, 11, 12, 13, 19, 20, 21, 22, 23, 24, 25, 28, 29, 31, 36, 37, 39, 41, 44, 45, 47, 48, 49, 52, 54, 56, 58, 60, 62, 63, 64, 66, 67, 68, 70, 71, 74, 75, 78, 81, 82, 83, 84, 85, 86, 87, 88, 89, 91, 93, 96]

# Managers
manager_list = []

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
manager_list.append(Manager( 77,  7))
manager_list.append(Manager( 81,  8))
manager_list.append(Manager( 82,  8))
manager_list.append(Manager( 85,  8))
manager_list.append(Manager( 91,  9))
manager_list.append(Manager( 96, 10))

# Populate time of day
time_of_day = []
for i in range(24):
  hour = i
  if (hour <= 9):
    hour = "0" + str(hour)
  else:
    hour = str(hour)
  time_of_day.append("'" + hour + ":00:00'")

## Populate booking date ##
booking_dates = []
declaration_dates = []
for i in range(1, 32):
  day = i
  if (day <= 9):
    day = "0" + str(day)
  else:
    day = str(day)
  booking_dates.append("'2021-10-" + day + "'")
  declaration_dates.append("'2021-10-" + day + "'")
for i in range(1, 31):
  day = i
  tempo = i
  if (day <= 9):
    day = "0" + str(day)
  else:
    day = str(day)
  booking_dates.append("'2021-11-" + day + "'")
  if tempo <= 11:
    declaration_dates.append("'2021-11-" + day + "'")
for i in range(1, 32):
  day = i
  if (day <= 9):
    day = "0" + str(day)
  else:
    day = str(day)
  booking_dates.append("'2021-12-" + day + "'")

#####################
#### Randomizing ####
#####################

# Note: We let them repeat, so we let SQL take care of repeated value
# through brute force.

#### HealthDeclaration ####
for num in range(4000):
  randEmployee = random.randrange(0, 100)
  randDate = random.randrange(0, len(declaration_dates))
  randTemp =  random.randrange(35, 40)
  randTempFloat = random.randrange(1, 10)

  obj = HealthDeclaration(
    str(randEmployee),
    str(declaration_dates[randDate]),
    (str(randTemp) + "." + str(randTempFloat)))

  line = "CALL declare_health ("
  line += obj.eid + ", " + obj.date + ", " + obj.temp + ");\n"
  sqlString += line

# Spacing
sqlString += "\n"

#### Rooms ####
for num in range(250):
  randFloor = random.randrange(1, 100)
  randRoom = random.randrange(1, 100)
  randName = random.randrange(0, len(randomRoomNames))
  randCapacity = random.randrange(1, 100)
  randDid = random.randrange(1, 11)
  randManager = random.randrange(0, len(manager_list))  
  date = "'2021-10-01'"

  obj = AddRooms(
    str(randFloor),
    str(randRoom),
    str(randomRoomNames[randName]),
    str(randCapacity),
    str(randDid),
    str(manager_list[randManager].eid),
    str(date))

  line = "CALL add_room ("
  line += obj.floor + ", " + obj.room + ", '" + obj.rname + "', "
  line += obj.capacity + ", " + obj.did + ", " + obj.eid + ", " + obj.date + ");\n"
  sqlString += line
  room_floor.append(obj)

# Spacing
sqlString += "\n"

#### ChangeCapcity ####
for num in range(400):
  randRoom = random.randrange(0, len(room_floor))
  randCapcity =  random.randrange(2, 100)
  randDate = random.randrange(0, len(booking_dates))
  temp_list = []

  for m in manager_list:
    if str(m.did) == str(room_floor[randRoom].did):
      temp_list.append(m)
  randManager = random.randrange(0, len(temp_list))
  manager = temp_list[randManager]

  obj = Updates(
    str(room_floor[randRoom].floor),
    str(room_floor[randRoom].room),
    str(manager.eid),
    str(randCapcity),
    str(booking_dates[randDate]))

  line = "CALL change_capacity ("
  line += obj.floor + ", " + obj.room + ", " + obj.eid + ", "
  line += obj.capacity + ", " + obj.date + ");\n"
  sqlString += line

# Spacing
sqlString += "\n"

#### book_room ####
for num in range(300):
  randRoom = random.randrange(0, len(room_floor))
  randDate = random.randrange(0, len(booking_dates))
  randStartTime = random.randrange(0, len(time_of_day))
  randEndTime = random.randrange(0, len(time_of_day))
  randBooker = random.randrange(0, len(booker_list))
  
  if randStartTime > randEndTime:
    tempz = randStartTime
    randStartTime = randEndTime
    randEndTime = tempz
  elif randStartTime == randEndTime:
      if randStartTime == 0:
        randEndTime += 1
      elif randEndTime == 24:
        randStartTime -= 1
      else:
        randStartTime -= 1
        randEndTime -= 1

  obj = BookRoom(
    str(room_floor[randRoom].floor),
    str(room_floor[randRoom].room),
    str(booking_dates[randDate]),
    str(time_of_day[randStartTime]),
    str(time_of_day[randEndTime]),
    str(booker_list[randBooker]))

  line = "CALL book_room ("
  line += obj.floor + ", " + obj.room + ", " + obj.date + ", "
  line += obj.startTime + ", " + obj.endTime + ", " + obj.eid + ");\n"
  sqlString += line
  book_room.append(obj)

# Spacing
sqlString += "\n"

#### join_meeting ####
for num in range(2000):
  randBooking = random.randrange(0, len(book_room))
  randEmployee = random.randrange(1, 101)
  
  booking = book_room[randBooking]

  obj = JoinMeeting(
    str(booking.floor),
    str(booking.room),
    str(booking.date),
    str(booking.startTime),
    str(booking.endTime),
    str(randEmployee))

  line = "CALL join_meeting ("
  line += obj.floor + ", " + obj.room + ", " + obj.date + ", "
  line += obj.startTime + ", " + obj.endTime + ", " + obj.eid + ");\n"
  sqlString += line
  join_meeting.append(obj)

# Spacing
sqlString += "\n"

#### approve_meeting ####
new_book_room = book_room 
for num in range(295):
  randBooking = random.randrange(0, len(new_book_room))
  randManager = random.randrange(1, len(manager_list))

  booking = new_book_room[randBooking]
  new_book_room.pop(randBooking)

  obj = ApproveMeeting(
    str(booking.floor),
    str(booking.room),
    str(booking.date),
    str(booking.startTime),
    str(booking.endTime),
    str(manager_list[randManager].eid))

  line = "CALL approve_meeting ("
  line += obj.floor + ", " + obj.room + ", " + obj.date + ", "
  line += obj.startTime + ", " + obj.endTime + ", " + obj.eid + ");\n"
  sqlString += line

# Spacing
sqlString += "\n"

#### Write ####
f = open("data.txt", "w")
f.write(sqlString)
f.close()



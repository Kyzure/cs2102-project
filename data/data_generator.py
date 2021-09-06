#################
#### Imports ####
#################
import random

#################
#### Classes ####
#################

class Department:
  def __init__(self, did, dname): 
    self.did = did
    self.dname = dname

class Employee:
  def __init__(self, eid, name, did, phone_1, phone_2, kind): 
    self.eid = eid
    self.name = name
    self.did = did
    self.phone_1 = phone_1
    self.phone_2 = phone_2
    self.kind = kind

class Manager:
  def __init__(self, eid, did): 
    self.eid = eid
    self.did = did

class Booker:
  def __init__(self, eid, did): 
    self.eid = eid
    self.did = did

class BookRoom: 
  def __init__(self, floor, room, date, startTime, endTime, eid, did): 
    self.floor = floor
    self.room = room
    self.date = date
    self.startTime = startTime
    self.endTime = endTime
    self.eid = eid
    self.did = did

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
manager_list = []
booker_list = []
employee_list = []
department_list = []

# Populated names
randomRoomNames = ["Flexidy", "Solaris", "YSolowarm", "Trippledex", "Keylex", "Treeflex", "Fintone", "Transcof", "Andalax", "Stringtough", "Gembucket", "Flexidy", "Otcom", "Flexidy", "Biodex", "Cookley", "Flexidy", "Tres-Zap", "Gembucket", "Zaam-Dox", "Voyatouch", "Prodder", "Keylex", "Viva", "Mat Lam Tam", "Holdlamis", "Voltsillam", "Daltfresh", "Tin", "Home Ing", "Tresom", "Zathin", "Cardify", "Matsoft", "TresZap", "Duobam", "Zathin", "Fixflex", "Opela", "Ventosanzap", "Trippledex", "Quo Lux", "Lotstring", "Namfix", "Bitwolf", "Cookley", "Alpha", "Sonsing", "Lotlux", "Keylex", "Greenlam", "Temp", "Job", "Voyatouch", "Cookley", "Home Ing", "Wrapsafe", "Ronstring", "Duobam", "Tres-Zap", "Holdlamis", "Bytecard", "Zathin", "Tresom", "Fintone", "Vagram", "Andalax", "Ventosanzap", "Voyatouch", "Biodex", "Bigtax", "Transcof", "Bamity", "Sonsing", "Viva", "YSolowarm", "Biodex", "Bigtax", "Bitchip", "Tampflex", "Span", "Tempsoft", "Job", "Kanlam", "Zamit", "Lotstring", "Konklux", "Stim", "Tempsoft", "Tres-Zap", "Duobam", "Alphazap", "Lotstring", "Namfix", "Subin", "Fix San", "Matsoft", "Asoka", "Cardguard", "Toughjoyfax"]

department_names = ["Human Resources", "Services", "Product Management", "Human Resources", "Legal", "Engineering", "Accounting", "Accounting", "Engineering", "Research and Development", "Training", "Product Management", "Training", "Engineering", "Accounting", "Human Resources", "Support", "Engineering", "Human Resources", "Human Resources", "Product Management", "Sales", "Accounting", "Research and Development", "Engineering", "Support", "Services", "Human Resources", "Support", "Accounting", "Research and Development", "Engineering", "Legal", "Legal", "Human Resources", "Accounting", "Support", "Marketing", "Training", "Services", "Services", "Product Management", "Sales", "Human Resources", "Product Management", "Support", "Research and Development", "Marketing", "Legal", "Marketing", "Product Management", "Support", "Engineering", "Product Management", "Engineering", "Training", "Research and Development", "Training", "Product Management", "Business Development", "Training", "Sales", "Support", "Accounting", "Services", "Accounting", "Training", "Training", "Training", "Research and Development", "Research and Development", "Sales", "Legal", "Legal", "Product Management", "Support", "Human Resources", "Services", "Engineering", "Product Management", "Business Development", "Marketing", "Business Development", "Support", "Support", "Services", "Sales", "Product Management", "Human Resources", "Support", "Research and Development", "Human Resources", "Human Resources", "Business Development", "Sales", "Research and Development", "Legal", "Support", "Legal", "Sales"
]

employee_names = ["Ashlen Meegin", "Piper Rother", "Lisetta Petrelli", "Foss Studd", "Babbie Coyle", "Leonore Connell", "Horton Ickovicz", "Eloise Rembrandt", "Kent Cleatherow", "Maura Longbothom", "Carleen Goodsell", "Marijn McJerrow", "Sandi Ashforth", "Edna Penman", "Harman Hoolahan", "Chrisy Tipperton", "Rutter Gregon", "Bellanca Dullaghan", "Rudolfo Saundercock", "Aubrey Durand", "Percival Newport", "Goddard Gillooly", "Ardella McQuin", "Robers Greeve", "Corliss Lathey", "Nevin Grouer", "Morley Plett", "Brandtr Howton", "Nilson Perocci", "Elbert Cashell", "Jonathon MacAnulty", "Serena Banbrick", "Kessia Ameer-Beg", "Felix Van Velde", "Felicdad Huggett", "Fayre Killshaw", "Carver Starsmore", "Bari Duthy", "Mischa Rodder", "Reade Corteney", "Abagael Ashness", "Meade Brithman", "Calida McKinnon", "Basilio Wabe", "Sherwynd Kohen", "Ray Broomer", "Gerianne Bexon", "Titus Tregien", "Marlo Laurentin", "Rhoda Riall", "Nolana Flemming", "Gerta Mossdale", "Fabe Snoddin", "Moreen Carsey", "Gilles Adamo", "Patrizia Linning", "Carlynne Baudet", "Dex Viner", "Garret Housby", "Farrel Lethebridge", "Kimbell Olpin", "Gill Cornbell", "Axe Dalgetty", "Aharon Dasent", "Mildred Verrall", "Eugene Cumming", "Tatum Baudon", "Theadora Chagg", "Kirstin Conaboy", "Cornell MacKissack", "Nerte Mellings", "Beth Vern", "Brannon Swanston", "Galvan Halbeard", "Sheree Sighard", "Lynette Kerry", "Marj Axten", "Mitch Bleythin", "Shannah Besemer", "Thorpe Ipsgrave", "Cynthea Fegan", "Jourdan Warfield", "Brnaby Swalwel", "Leone Slainey", "Marchelle Ianizzi", "Elena Wyer", "Isabelita Waleran", "Jenifer Shapcott", "Thelma Cosson", "Davide MacMenamin", "Vin Ainsby", "Zia Simms", "Lennard Kaliszewski", "Nelie Pettingall", "Adrien Deth", "Caryl MacCrosson", "Ofella MacCartair", "Kristel Wetheril", "Dennison Kertess", "Emeline Affron", "Renaud Clifforth", "Maddi Inglese", "Reginauld Hentzer", "Gaynor Plett", "Alaster Syms", "Constancia Jovicevic", "Melinde Caudle", "Tadeas Reddy", "Andre Ricardet", "Jessie Renshaw", "Lisetta Skelhorn", "Collie Dumke", "Cesar Kubiczek", "Cornie Ramsey", "Urbain Klaff", "Amil Westpfel", "Francyne Farmloe", "Luther Alty", "Maure Rendall", "Veda Rodenborch", "Farrell Witch", "Pebrook Cousens", "Emmanuel Tulip", "Karlen Rontsch", "Lydon Lowsely", "Rena Foucher", "Eustace Moulster", "Max Tibalt", "Margarita Bartolomeazzi", "Wileen Afield", "Lew Cockley", "Griffith Kesterton", "Grannie Schermick", "Willis Beazleigh", "Didi Linke", "Elyssa Bartzen", "Sallyanne Wharby", "Rosette Grady", "Morry Yellowlea", "Farr Allchorn", "Kalindi Kaes", "Gay Rickardes", "Vivyan Pembry", "Flory Bembrick", "Greggory Felgat", "Edin Cuthbertson", "Karin Pollok", "Keriann Peach", "Adrian Lethieulier", "Phaidra Juschke", "Dewain Jarnell", "Ralph Huxtable", "Frants Duffill", "Alena Bruntjen", "Ardyce Targett", "Nerti Risbrough", "Gilli Dmytryk", "Lurline Duguid", "Philbert Abeles", "Kristoffer Saltsberger", "Vania Merman", "Edythe Growy", "Abdul Dreher", "Chip Limmer", "Moore Bettleson", "Gilberte Rubinowicz", "Abbye Semaine", "Tandie Di Francesco", "Susanna Thelwll", "Hetty Burberye", "Joelynn Hampson", "Jazmin Mockford", "Kip Hassur", "Chastity Titt", "Burch Pardie", "Jakie Volant", "Nowell Niset", "Percival Bracher", "Cindra Vanyatin", "Debi Filippyev", "Dwain Simenot", "Teddi Bunch", "Isidore Cluelow", "Douglas Jarrette", "Sig Winchester", "Jerald Orta", "Lesley Babington", "Helyn Alban", "Turner Falloon", "Gerard Lord", "Cornie Stegell", "Magnum Foynes", "Vanya Webley", "Serena Gouldstraw", "Lem Rossetti", "Lurlene Boler", "Zechariah Arro", "Don Joriot", "Timmie Conti", "Timothea Truswell", "Griff McFadden", "Urbano Pannett", "Odo Cardenas", "Gayle Pond-Jones", "Harrison Ugolotti", "Dell Aymer", "Paxton Mogg", "Tobin Pointer", "Perri Slite", "Aurora De Roeck", "Vallie Kellart", "Hamlin Peace", "Zarla Garaway", "Cathryn Dolohunty", "Aluino Fadian", "Tome Harsant", "Jeno Linnard", "Karolina Braunlein", "Celina Orrocks", "Adelle Whithalgh", "Blinni Boughtflower", "Annie Bowton", "Wesley Camm", "Nikolia Ladlow", "Thurston Cutress", "Irvin Craythorne", "Elinor Sholem", "Nikolia Fawley", "Cassaundra Yakebovich", "Aimil Gillanders", "Alphard Foston", "Rina Basilio", "Lois Langer", "Delainey Cowling", "Vick Landsberg", "Janka McConnachie", "Janos McDugal", "Nancey Kobpac", "Antonin Gideon", "Rodrique Cordelle", "Vaughn Reisenberg", "Lucila Chaman", "Jacklin Beckhouse", "Carena Galiford", "Mahalia Goldberg", "Fern Shwenn", "Jana Pellissier", "Garv Orable", "Dante Frissell", "Claudina Abrahamowitcz", "Dorise Birkby", "Helsa Lomas", "Beret Aire", "Eldon Lieb", "Walton Stoney", "Chantalle Cohani", "Dwight Halling", "Adan Makeswell", "Consuelo Matveichev", "Gerianne Bonnefin", "Ximenez Gregorace", "Freddie Godball", "Farlie Lilburn", "Garnette Wooles", "Adrea McKeighen", "Rozamond Sporrij", "Ashlie Lomaz", "Ileana Infantino", "Elisabeth Larkings", "Pippa Maplethorp", "Aeriela Barrim", "Erena Bergstram", "Courtnay Walsh", "Fax Mosson", "Tate Enrich", "Cristin Pine", "Harper Worledge", "Ariel Zanetello", "Arri Haigh", "Isidora Chaperlin", "Valeda Johansson", "Luz Eustes", "Amalia Isoldi", "Hugo Gerb", "Thorndike Penning", "Chick Boorer", "Audre Jedryka", "Derron Tottem", "Modesty Vizor", "Sid Keattch", "Eleonore Cours", "Mano Bloyes", "Phelia Izac", "Morgun Mankor", "Marice Cowp", "Brana McOwen", "Esta Greiswood", "Isahella Delouch", "Karole Barrowcliffe", "Jake Mackrill", "Van McAleese", "Keene Shakelade", "Dawn Henery", "Brent McKee", "Ronni Basson", "Merle Trood", "Boris Leimster", "Melisenda Feake", "Donalt Evett", "Aurora Walsom", "Cassy Reedman", "Bartie Cranstone", "Ludvig Stavers", "Crista Vanezis", "Vidovik Boatman", "Emalee Spinks", "Sibylla Dudhill", "Seward Keir", "Gerard Burfoot", "Deborah Thripp", "Francine Gaymer", "Kain Beckley", "Raye Velareal", "Spence Idell", "Devina Clowney", "Noach Di Roberto", "Al Casella", "Jocko Turfes", "Des Acres", "Birch Diffley", "Cliff Coppard", "Evy Ferrar", "Golda Pearcy", "Helsa Rizzello", "Wiatt Goodrick", "Susannah Twizell", "Doralia Cowdery", "Glenna Dewberry", "Wyatan Pennigar", "Konstantin Barnshaw", "Catharina Verrell", "Bar McGilleghole", "Korney Deboo", "Rhonda Hector", "Javier Castaner", "Bertie Reaney", "Marco Levecque", "Doris Burless", "Adi Deackes", "Keslie Schonfeld", "Bradney Whimp", "Creigh Snaith", "Sybilla Seiler", "Jayne Geator", "Barnebas Tosney", "Brian Fetters", "Salomo Thouless", "Dreddy Berndtsson", "Morse Kynge", "Trent Barnbrook", "Bonnie Gifford", "Ed Schaffel", "Ulrike Bartolommeo", "Helen Hiddy", "Bartie Rickman", "Fraze Pelcheur", "Stesha Edmead", "Renata Faherty", "Rene Mityashev", "Rowan Brittoner", "Dael Atty", "Myrta Scollick", "Gael Tume", "Juan Duke", "Zena Locard", "Wiley Ouldcott", "Shelba Leckenby", "Kellie Thyer", "Francois Joselevitz", "Gloriana Viger", "Lyda Robbeke", "Lisle Harfoot", "Klemens Lobbe", "Sam Rouchy", "Adan Severns", "Dean Rault", "Staford Salan", "Herby Heeley", "Roxane Henningham", "Norry Ruel", "Giselbert Spackman", "Rosabelle Smidmor", "Kellsie Killerby", "Marillin Hassett", "Tally Cicutto", "Harley Lunam", "Rodney Nolder", "Tome Nutley", "Marion Winchcombe", "Ferdinande Heindrick", "Gabbie Gergolet", "Ronny Bruhke", "Saunder Thurlow", "Judy Fidelus", "Clemente Timms", "Stefano Molines", "Thibaut Merrien", "Corbie Benez", "Averil Wainwright", "Gaye Bulstrode", "Daron Goady", "Wyatt Courtier", "Frayda Chomiszewski", "Franz Shawe", "Russ Bryant", "Austen Cerie", "Rahel Nilges", "Carlotta Jurkiewicz", "Guglielmo Scurr", "Salome Thurlby", "Carlie Phinn", "Victor Matessian", "Nora Rogier", "Carlo Guppie", "Anna-diane Regglar", "Obadias Aukland", "Alys Whistlecraft", "Corine Haughian", "Pavla Coetzee", "Jerry Bentjens", "Findley Croster", "Hart Leworthy", "Rickard Kaser", "Sigfried Banck", "Paten Brezlaw", "Adah Keers", "Bondie Tremayne", "Anders Choulerton", "Jillane Gething", "Melva Hoyle", "Blisse Treble", "Marchall Simco", "Cody Swinnerton", "Anastasia Camillo", "Tisha Sidry", "Quinn Ingrey", "Sheryl Redish", "Anabel Coveney", "Georgia Prout", "Allis Linggood", "Beatrix Sedgwick", "Mireille Reide", "Freddie Zucker", "Anjanette Luty", "Magda Cristofaro", "Aguistin Bakster", "Robb Barnett", "Joe Neeve", "Odille Macon", "Adoree Bigby", "Arlinda McGairl", "Frank Di Nisco", "Luke Klink", "Laurella Impy", "Ilysa Learmount", "Hartley Adcock", "Hynda Giampietro", "Nev Egre", "Cesar Wenham", "Enrika Gladyer", "Celine MacCarroll", "Riobard Goodyer", "Marie-ann Nicol", "Sher Skellorne", "Candi Elsby", "Ruttger Frankish", "Marjorie Boosey", "Ralf Bartzen", "Jodie Skewes", "Hamnet Troughton", "Joelle Petrolli", "Harli Hadlee", "Dale Alforde", "Gwennie Whight", "Michal Bricklebank", "Bran Hundall", "Brett Linthead", "Peggy Amys", "Zia Whittlesea", "Teena Ashpital", "Cullin Bradd", "Joycelin Nickols", "Walliw Romayne", "Neda Sharpe", "Fidole Dunlap", "Zaneta McVitty", "Osgood Janiszewski", "Lisabeth Waiton", "Agneta Butterley", "Shawn Geard", "Mia Warrack", "Brita Gergler", "Dilan Scoggans", "Spencer Tumpane", "Denni Blampey", "Lilllie Ungerecht", "Ailis Bum", "Verina Alabone", "Ingram Dawtrey", "Fiona Wansbury", "Dasha Corns", "Hew Troughton", "Phillipp Poyner", "Edita Klawi", "Yancy Ferdinand", "Birgitta Anderl", "Emlyn Greenroyd", "Bo Marconi", "Kial Hallward", "Kai Conroy", "Jenna Pappin", "Olva Skettles", "Alejoa Dugmore", "Leela Norkutt", "Lawry Goskar", "Morton Haworth", "Nealon Rens", "Virgie Boc", "Elsey MacCleay", "Jyoti Letch", "Gwenora Prandini", "Johannes MacKenney", "Marilee Garling", "Raine Colicot", "Adela Sander", "Elisabet Grellier", "Athene Antonelli", "Ardyth Leonardi", "Galvan Crass", "Sherri Kitchaside", "Vinni Danieli", "Netti Pyrton", "Eleanora Borles", "Towney Coggin", "Brander Guinery", "Conni Honniebal", "Livia Ottewell", "Mart Gommery", "Patton Borris", "Linea Hillen", "Adolph Jaszczak", "Elfie Dodson", "June McKinnon", "Alexandr Sheeres", "Laural Packwood", "Roby Obin", "Brittney Cadle", "Moise Beggs", "Lynda Chidgey", "Deeanne Christescu", "Ester Vokes", "Obidiah Jochen", "Orelle Pawlicki", "Clem Blaxland", "Vale Bachellier", "Lorilyn Barszczewski", "Cherise Jedrzejewicz", "Demetria Orrocks", "Deidre Sieur", "Irwin Potteril", "Sutton Banane", "Dion Kenworth", "Saxon Hawford", "Elmira Mossop", "Ola Savoury", "Evelina Beton", "Cy Grolle", "Angelia Kobu", "Ignazio Lacroix", "Griffy Valder", "Carson Kleehuhler", "Gordy Jelphs", "Rena Cisco", "Nealson Kenealy", "Christyna Jizhaki", "Billi Jessope", "Antonina Bysh", "Daryl Allicock", "Coralie Bulch", "Nikos Yukhov", "Elana Dawney", "Kris Harnor", "Huntington Grute", "Marita Tarbath", "Sullivan Ceschelli", "Michelle Bes", "Myrtie Tranckle", "Raffaello Langridge", "Romy Ilyinski", "Moll Pelosi", "Florrie Luxford", "Junie Gostling", "Meggy Clabburn", "Mady Lawey", "Lorettalorna Glennard", "Gay Proudlock", "Jelene Moggie", "Caresse Hardin", "Reinhard Shegog", "Bridget Blankau", "Mala Littlemore", "Fairleigh Mosen", "Nancee Sankey", "Jandy Johnston", "Bonnee Chazotte", "Willie Naseby", "Audie Jachimczak", "Rosie Eynon", "Kelsey Reeme", "Abbi Skase", "Gretta Badgers", "Munroe Huie", "Emmit Martina", "Kevyn Wickman", "Carena Witter", "Jessi Tomblin", "Joseito Lautie", "Essie Stallworthy", "Thurston Klulisek", "Patrice Whall", "Corey Badham", "Briant McQuirk", "Bryn Lawther", "Livvyy Wyeth", "Donica Chancelier", "Dev Meenehan", "Tera Revett", "Sydelle Hammersley", "Earlie Skellen", "Xena Jakes", "Hilliard Rembrandt", "Lucien Cleverly", "Collin Hammerton", "Katee Grishinov", "Victoria Downey", "Robbie McColm", "Jamie Ruggiero", "Emmanuel Gadesby", "Harrietta Readett", "Anderea Rominov", "Odille Goudie", "Danni Spykings", "Vera Maffia", "Mead Playfair", "Ree Petrillo", "Emmott Tomaskov", "Wandie McGrill", "Scottie Queree", "Stanislas Rigate", "Rodolfo Seamer", "Bradford Palfery", "Ab Kanzler", "Griz Whiteford", "James Bruckshaw", "Auberta Hartas", "Carlynne Arnoll", "Errick Penke", "Smith Tremoulet", "Madelina Plaister", "Margy Grigoire", "Christophe Brogan", "Horten Tofanelli", "Rikki Condict", "Bev Partkya", "Scotty Kellough", "Raimundo Kasher", "Beatriz Gianulli", "Noam Gunby", "Charita Kunzel", "Nikkie Sabban", "Carroll Salkild", "Mack Pole", "Malachi Davis", "Thurston Landman", "Iseabal Francklyn", "Annabella Hryniewicz", "Fania Seyffert", "Lauraine Angus", "Bendite Halm", "Aron Halstead", "Jammie Ollander", "Dixie Hek", "Elijah Greydon", "Bartel Eicheler", "Dean Duckels", "Goddard Faro", "Belia Bartels-Ellis", "Berkley Scarbarrow", "Franny Gentiry", "Jacquelyn Ollington", "Mychal Bangle", "Lewes Bearne", "Waylen Bucky", "Saxon DAlesco", "Klarika Matushenko", "Rubin Raft", "Cati Guys", "Eddy Le Noury", "Tomasina Yannikov", "Devinne Saxton", "Demetra McGreal", "Harriett Caldicot", "Decca Ort", "Beale DOyly", "Archy Payler", "Paule Cleeton", "Freddie Backes", "Dori Bloxholm", "Barny Roblin", "Buddie Readhead", "Beulah Shieldon", "Pamela MacKibbon", "Trudey Hathaway", "Ange Danaher", "Rob Lougheed", "Darby Tatham", "Gwenneth Bellison", "Hettie Dohmer", "Orin Dell", "Brucie Stores", "Waylon Seifenmacher", "Norah Borlease", "Adriano Malsher", "Che Winchester", "Eldon McKinn", "Yovonnda Marney", "Kahlil McKibben", "Amalee Bruinemann", "Torrie Renoden", "Barri Haire", "Mathilda Whellans", "Bonnibelle McLay", "Cybil Letrange", "Sharon Morit", "Jehanna Bewicke", "Trueman McClure", "Vanny Palfrie", "Serene Gounel", "Geordie Hutcheons", "Uriah Soden", "Annelise Artz", "Olvan Meegan", "Cindelyn Lively", "Manon Zohrer", "Jessalin Johanning", "Estel Sobey", "Lilian Simonazzi", "Ulrich Mainds", "Brig McQuode", "Jessey Labba", "Gabi Rubinovitsch", "Hillard Thebe", "Cesya Croan", "Mechelle Braghini", "Alley Peracco", "Sandi Shepard", "Doralin Rennebach", "Forster Mussettini", "Flinn Narracott", "Anthia Miner", "Cory Blagden", "Leland Morrel", "Carolyne Nibley", "Iolanthe Assender", "Marv Box", "Shelli McKeevers", "Onfre Lasty", "Ariana Beacroft", "Lutero Castanie", "Kellie Kardos", "Fidelity Emett", "Moria Snalum", "Oralle Gautrey", "Ogdon Mattingley", "Meier Klammt", "Stacee Boschmann", "Charo Scholefield", "Freddy Purkiss", "Hanny Ambrosch", "Karl Hamstead", "Carline Moorwood", "Glenine McPhee", "Louella Pert", "Dory Antognetti", "Tamas Stabbins", "Stefanie Rosenstengel", "Hurlee Stawell", "Kara Chirrie", "Phylis Pre", "Lorna Hardi", "Phillip Forgie", "Ronalda Veeler", "Orbadiah Slemmonds", "Mommy Ledster", "Glyn Poley", "Coralie Cornuau", "Justina Seamen", "Gunar Lumm", "Katina Bunce", "Noell Downgate", "Zsa zsa Libermore", "Elia Bolliver", "Heywood Phant", "Eileen Eglise", "Ernaline Anthoney", "Marlee Collishaw", "Sabina McGray", "Sabra Titterington", "Damian Patman", "Josepha Spilsburie", "Noell Charon", "Inga Mariyushkin", "Robinett Shillum", "Rainer Klimczak", "Eugenia Dirand", "Otto Edensor", "Katalin Kleinstub", "Herc Ivic", "Garnette Spadazzi", "Marice Bennington", "Adelice Hardey", "Carolynn Woffinden", "Brannon Gravenall", "Andi Presslee", "Deck Andrieu", "Maxie Banks", "Vittorio MacChaell", "Amandie Jandak", "Jacki Rossey", "Neile Kelbie", "Junina Loggie", "Vonnie Guntrip", "Chuck Ivatt", "Bennett Durrand", "Alaine Farlambe", "Nicki Elion", "Cinnamon Fordyce", "Glendon Skechley", "Darbee Speirs", "Charla Hambelton", "Efren Iggo", "Corena Good", "Crissie Brattell", "Matthiew Rainsden", "Truda Cureton", "Dita Calder", "Rollo Chetwind", "Margarethe Plum", "Derrik Pridie", "Daisie Deniskevich", "Guillaume Emmerson", "Shell McCawley", "Dorette Berkelay", "Odessa Domeny", "Fidela Castellani", "Parke Puller", "Binnie Laddle", "Adelheid Tyne", "Neils Moylan", "Tamara Shimoni", "Dorri Havock", "Karel Kittredge", "Crin Menel", "Illa Smitten", "Cart Tribell", "Camey Nickless", "Izabel Coughlan", "Onfre Cossum", "Taite Oaten", "Harlene Nern", "Lemuel Dibbin", "Marilin Jerwood", "Stearn Southgate", "Leland Pursey", "Benedikta McQuilliam", "Alyda MacBarron", "Sigismond Glazer", "Regine Tomich", "Abby Reddings", "Smitty Tregidga", "Noella Matiasek", "Liam Negus", "Say Dauber", "Borg Hannent", "Guthrey Hindrich", "Barbee Eslemont", "Raquela Freund", "Bride Nutkin", "Alys Turone", "Ruddie Salling", "Ofilia Sly", "Angie Ballintyne", "Crawford Glasscoo", "Fairlie Rash", "Florette Baggallay", "Tani Whiten", "Pamela Finessy", "Aldous Largent", "Pietra Sein", "Jacquelyn Tomaszynski", "Denys Doerffer", "Marabel Redford", "Cornelle Stonier", "Danica McRuvie", "Binni Collison", "Lyndel Mussettini", "Elli Ohone", "Sebastiano Jobbins", "Gabrila Licari", "Edee Newarte", "Indira Chishull", "Darryl Smithers", "Heriberto Caze", "Marcille Shieber", "Dorris Eede", "Lauraine Beeze", "Maxy Husby", "Hershel Pick", "Elvina Koppeck", "Lind Twells", "Anneliese Springthorp", "Robers Lonergan", "Craggie Othen", "Clotilda Ronald", "Renie Aust", "Kelley Hessle", "Eryn Worge", "Candis Welldrake", "Orly Poynzer", "Sauncho Wikey", "Kort Robatham", "Aurilia Goodwill", "Nissa Kruger", "Jamill McLorinan", "Barnie Shawell", "Hadrian Zorzenoni", "Norma Ternott", "Park Roiz", "Judah Thomesson", "Sherill Pie", "Carmelina Bunney", "Dorothea Wombwell", "Margarete Morfett", "Kameko Didball", "Brandyn Canny", "Michel Thorald", "Charlton MacGiffin", "Katine Load", "Gwenore Aronowitz", "Wald Kyme", "Steffie Pales", "Beniamino Astill", "Rebe Wilderspoon", "Alissa Kirman", "Demetris Dake", "Monti Bartunek", "Vania Margerrison", "Falkner Iliff", "Ddene De Mitris", "Patsy Gordon-Giles", "Lucille Orchard", "Tami Dorn", "Dyan Pendered", "Shelia Hearl", "Dorelle Ayars", "Flory Warratt", "Donnajean Norwood", "Melisa Orta", "Chad Tyas", "Elizabet Davidwitz", "Magdalena Buckbee", "Melony Wringe", "Moe Oultram", "Lorine Anderer", "Dov Walrond", "Staford Ketch", "Nedda Lantaff", "Berkly Holdron", "Allissa Zecchetti", "Albertine Macro", "Davine Balaisot", "Caryl Hemeret", "Onfroi Barry", "Wilhelm Ceaser", "Joey Jandak", "Mariejeanne Coupe", "Artur Tinmouth", "Kendrick Burnel", "Felicia Minocchi", "Antone Dober"
]


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

#### Departments ####
for num in range(1, 31):
  randName = random.randrange(0, len(department_names))

  obj = Department(
    str(num),
    str(department_names[randName]))

  line = "CALL add_department ("
  line += obj.did + ", '" + obj.dname + "');\n"
  sqlString += line
  department_list.append(obj)

# Spacing
sqlString += "\n"

#### Employees ####
managerDid = 1
for num in range(1, 501):
  randName = random.randrange(0, len(employee_names))
  randType = random.randrange(0, 10)
  randDid = random.randrange(1, len(department_list) + 1)
  randPhone_1 = random.randrange(80000000, 99999999)
  randPhone_2 = random.randrange(80000000, 99999999)
  isPhoneEmpty_1 = random.randrange(0, 8) == 0
  isPhoneEmpty_2 = random.randrange(0, 3) == 0

  if isPhoneEmpty_1:
    randPhone_1 = 'null'
  if isPhoneEmpty_2:
    randPhone_2 = 'null'

  if randType <= 3:
    randType = "Junior"
  else:
    if randType <= 6:
      randType = "Senior"
    elif randType <= 9:
      manager = Manager(
        str(num),
        str(managerDid)
      )
      manager_list.append(manager)
      randType = "Manager"
      randDid = managerDid
      managerDid = (managerDid % len(department_list)) + 1

    booker = Booker(
      str(num),
      str(randDid)
    )
    booker_list.append(booker)
      
  obj = Employee(
    str(num),
    str(employee_names[randName]),
    str(randDid),
    str(randPhone_1),
    str(randPhone_2),
    str(randType))

  line = "CALL add_employee ("
  line += "'" + obj.name + "', '" + obj.phone_1 + "', '" + obj.phone_2 + "', '"
  line += obj.kind + "', " + obj.did 
  sqlString += (line + ");\n")
  employee_list.append(obj)

# Spacing
sqlString += "\n"

#### Retired Employees ####
for num in range(50):
  randEmployee = random.randrange(1, len(employee_list))
  randDate = random.randrange(0, len(booking_dates))

  line = "CALL remove_employee ("
  line += str(randEmployee) + ", " + str(booking_dates[randDate]) + ");\n"
  sqlString += line

# Spacing
sqlString += "\n"  

#### HealthDeclaration ####
for num in range(3000):
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
  randCapacity = random.randrange(2, 100)
  randDid = random.randrange(1, len(department_list))
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
for num in range(400):
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
    str(booker_list[randBooker].eid),
    str(room_floor[randRoom].did))

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
for num in range(350):
  randBooking = random.randrange(0, len(book_room))
  temp_list = []

  booking = book_room.pop(randBooking)

  for m in manager_list:
    if str(m.did) == str(booking.did):
      temp_list.append(m)
  
  randManager = random.randrange(0, len(temp_list))
  manager = temp_list[randManager]

  obj = ApproveMeeting(
    str(booking.floor),
    str(booking.room),
    str(booking.date),
    str(booking.startTime),
    str(booking.endTime),
    str(manager.eid))

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


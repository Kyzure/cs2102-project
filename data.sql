----------------------------------------------------------------
----------------------------- DATA -----------------------------
----------------------------------------------------------------

---- Add Departments (did, dname) ----
CALL add_department (1, 'Services');
CALL add_department (2, 'Human Resources');
CALL add_department (3, 'Support');
CALL add_department (4, 'Human Resources');
CALL add_department (5, 'Services');
CALL add_department (6, 'Engineering');
CALL add_department (7, 'Research and Development');
CALL add_department (8, 'Product Management');
CALL add_department (9, 'Business Development');
CALL add_department (10, 'Legal');

---- Add Employees (email, primary_contact, secondary_contact, kind, did) ----
CALL add_employee ('Aiam Repeated', '9841052003', '0398996323', 'Junior', 1);
CALL add_employee ('Gasper Daulton', '0083702138', '0408398308', 'Junior', 1);
CALL add_employee ('Zorana Thireau', '0194694806', '9211549280', 'Junior', 1);
CALL add_employee ('Shannen Beney', '0588448419', '0259281828', 'Junior', 1);
CALL add_employee ('Vanni Vigors', '0246418164', '9957179884', 'Junior', 1);
CALL add_employee ('Yancy Trainor', '0476875786', '9726295000', 'Junior', 1);
CALL add_employee ('Lawrence Blanche', '0336376340', '0709362205', 'Junior', 1);
CALL add_employee ('Jule Looker', '9095385855', null, 'Junior', 1);
CALL add_employee ('Aiam Repeated', null, null, 'Senior', 1);
CALL add_employee ('Rufe Volett', '0885033358', null, 'Senior', 1);
CALL add_employee ('Katinka Toner', '9202762332', '0386826843', 'Senior', 1);
CALL add_employee ('Torry Showell', '0988722530', '0801218544', 'Manager', 1);
CALL add_employee ('Hort Roomes', '0686706899', '0048389509', 'Manager', 1);
CALL add_employee ('Jackquelin Galego', '0082183787', '0654531767', 'Junior', 2);
CALL add_employee ('Zeb Westney', '0906948204', '0232128894', 'Junior', 2);
CALL add_employee ('Amata Tregunnah', '0291802971', null, 'Junior', 2);
CALL add_employee ('Maribel Vanne', '0817326339', '0122431134', 'Junior', 2);
CALL add_employee ('Sauncho Petrolli', '0858083866', '0921274692', 'Junior', 2);
CALL add_employee ('Nels Jordon', '0872042019', '9382023587', 'Junior', 2);
CALL add_employee ('Lek Pattesall', '0177335286', '0446428760', 'Junior', 2);
CALL add_employee ('Dannye Pidcock', '0045991235', '0217000206', 'Junior', 2);
CALL add_employee ('Alvis Spackman', '0565899380', '0359614239', 'Junior', 2);
CALL add_employee ('Tabbitha Whiscard', '0506398537', '0781434647', 'Junior', 2);
CALL add_employee ('Latisha Kaasmann', '0032886447', '0651408558', 'Junior', 2);
CALL add_employee ('Berri Bailie', '0209187746', null, 'Junior', 2);
CALL add_employee ('Sadella Fearnill', '0902738836', '0391219889', 'Junior', 2);
CALL add_employee ('Ethan McCart', '0883797021', '0634107141', 'Junior', 3);
CALL add_employee ('Gun Farbrother', '0792510072', null, 'Junior', 3);
CALL add_employee ('Ave Parmenter', '0459382444', '0048952973', 'Junior', 3);
CALL add_employee ('Enrica Filer', '0936130261', '0368447822', 'Junior', 3);
CALL add_employee ('Rodolfo Edgworth', '0564075894', '0803372843', 'Junior', 3);
CALL add_employee ('Lauritz Gebhardt', '0165058295', '0863954093', 'Junior', 3);
CALL add_employee ('Rusty Mewhirter', '0056279570', '0029530977', 'Junior', 3);
CALL add_employee ('Jermaine Bowne', '0002210610', '0172905276', 'Junior', 3);
CALL add_employee ('Fern Rowswell', null, null, 'Junior', 3);
CALL add_employee ('Arnaldo Gosforth', '0494301804', null, 'Junior', 3);
CALL add_employee ('Buddy Reggio', null, '0955070630', 'Junior', 3);
CALL add_employee ('Denys Yeabsley', '0304925799', null, 'Junior', 4);
CALL add_employee ('Em Karpmann', '0241060215', '0763212008', 'Junior', 4);
CALL add_employee ('Mac Alexsandrev', '0264271195', null, 'Junior', 4);
CALL add_employee ('Webster Ganing', '0799056609', '9303458594', 'Junior', 4);
CALL add_employee ('Tonya Froome', '0051337085', null, 'Junior', 4);
CALL add_employee ('Eryn Tollemache', '0839249636', null, 'Junior', 4);
CALL add_employee ('Dunn Pinock', '0928608387', '0387612182', 'Junior', 4);
CALL add_employee ('Aiam Repeated', '0094423475', '0737773324', 'Junior', 5);
CALL add_employee ('Rickie Gordon', null, null, 'Junior', 5);
CALL add_employee ('Aubrey Scotchmor', '0172385830', '0611972990', 'Junior', 5);
CALL add_employee ('Leeanne Vequaud', '0736830037', '0829482195', 'Junior', 5);
CALL add_employee ('Kellyann Battaille', '9058957629', '0094289245', 'Junior', 5);
CALL add_employee ('Jared Esselin', '0417501222', null, 'Junior', 5);
CALL add_employee ('Leupold McCory', '0671061069', '0651871686', 'Junior', 5);
CALL add_employee ('Ertha Noury', '9153255819', '0812982305', 'Junior', 5);
CALL add_employee ('Margo Cranmer', '0561555316', '0615632662', 'Junior', 5);
CALL add_employee ('Orion Maestrini', '0051787026', '0761920179', 'Junior', 5);
CALL add_employee ('Pat Ourry', '0724037992', '0586143383', 'Junior', 5);
CALL add_employee ('Aiam Repeated', '0271626172', '9261559542', 'Junior', 5);
CALL add_employee ('Caril Donald', '9677334008', null, 'Junior', 6);
CALL add_employee ('Quent Gresch', '0228988456', '0823454079', 'Junior', 6);
CALL add_employee ('Boone Bowdrey', '0156493708', null, 'Junior', 6);
CALL add_employee ('Chas Wickens', '0081510099', '0824100111', 'Junior', 6);
CALL add_employee ('Ellery Coale', '9882104058', null, 'Junior', 6);
CALL add_employee ('Ham Carwardine', null, null, 'Junior', 6);
CALL add_employee ('Tiphanie Rylstone', '9677919095', '0482346997', 'Junior', 6);
CALL add_employee ('Edward Chelley', '0487376874', '0579676052', 'Junior', 6);
CALL add_employee ('Shaylah Bartle', '0056575708', null, 'Junior', 6);
CALL add_employee ('Bale Pilmer', '0132393203', '0237144240', 'Junior', 6);
CALL add_employee ('Mozelle Cornner', '0829739963', '0369450147', 'Junior', 6);
CALL add_employee ('Alix Battman', '0302037015', '0163512049', 'Junior', 6);
CALL add_employee ('Pinchas McGeady', null, null, 'Junior', 6);
CALL add_employee ('Sidnee Hierro', '9944683585', '0639852736', 'Junior', 6);
CALL add_employee ('Jillana Farreil', '0491962885', '0315708878', 'Junior', 7);
CALL add_employee ('Cherish Reeveley', '0222411429', '9894136366', 'Junior', 7);
CALL add_employee ('Chrotoem Starmont', '0367890820', '0324483321', 'Junior', 7);
CALL add_employee ('Nicky Wain', '0363544477', null, 'Junior', 7);
CALL add_employee ('Sharyl Dalyiel', '0783874034', '0427925721', 'Junior', 7);
CALL add_employee ('Bryce Stennes', '0554030919', '0821409001', 'Junior', 7);
CALL add_employee ('Morna Raeburn', '9817244257', '0785443971', 'Junior', 7);
CALL add_employee ('Merry Hengoed', '0695059316', null, 'Junior', 7);
CALL add_employee ('Kristofer Reuben', '0886123310', null, 'Junior', 7);
CALL add_employee ('Ruperto Dubbin', '0367228826', null, 'Junior', 8);
CALL add_employee ('Elena Karlicek', '0561365263', '0473759370', 'Junior', 8);
CALL add_employee ('Maryl Trematick', '0643464422', null, 'Junior', 8);
CALL add_employee ('Ariadne Masser', '9723471939', '0078480376', 'Junior', 8);
CALL add_employee ('Darrick Guyonnet', '0374341870', '0211164202', 'Junior', 8);
CALL add_employee ('Bell Jurisch', '0542845525', '9969872855', 'Junior', 8);
CALL add_employee ('Nike Collocott', '0885510139', '0869103553', 'Junior', 8);
CALL add_employee ('Port Silbert', '0118857898', '0127003351', 'Junior', 9);
CALL add_employee ('Sonnnie Jeffry', '0126112769', '0204267905', 'Junior', 9);
CALL add_employee ('Suzanna Maton', '0868037999', '0381820940', 'Junior', 9);
CALL add_employee ('Lita Sennett', '0186373867', '0582729260', 'Junior', 9);
CALL add_employee ('Rossy Peret', null, '0109390668', 'Junior', 9);
CALL add_employee ('Wilton Jiras', null, null, 'Junior', 9);
CALL add_employee ('Cristobal Kellock', '0376831605', null, 'Junior', 9);
CALL add_employee ('Dacey Brient', '0999176942', '0577165502', 'Junior', 9);
CALL add_employee ('Emelia Maplestone', null, null, 'Junior', 9);
CALL add_employee ('Sandye Brownlie', '0684808795', '0267686938', 'Junior', 10);
CALL add_employee ('Gerri Bygraves', '0744050643', '0315594117', 'Junior', 10);
CALL add_employee ('Ginnifer Cissell', '0082285725', '0032175033', 'Junior', 10);
CALL add_employee ('Gram Cyson', '0732634966', '0846636856', 'Junior', 10);
CALL add_employee ('King Curness', '0151359672', null, 'Junior', 10);





























-----------------------------------------------------------------

-- Insertion into Users

--INSERT INTO Users (NTID, Password, FirstName, MiddleName, LastName, Email, Address, PhoneNum, SSN)
--VALUES
--    ('JDSmith01',	'Password123',	'John',		'D',	'Smith',	'john.smith@email.com',		 '123 Main St, New York, NY, 10001',	'123-456-7890', '123-45-6789'),
--    ('ALSimpson02', 'P@ssw0rd456',	'Alice',	'L',	'Simpson',	'alice.simpson@email.com',	 '456 Elm St, Los Angeles, CA, 90001',	'456-789-0123', '234-56-7890'),
--    ('MPPatel03',	'Secret789',	'Michael',	'P',	'Patel',	'michael.patel@email.com',	 '789 Oak St, Chicago, IL, 60601',		'789-012-3456', '345-67-8901'),
--    ('KJohnson04',	'KPass123',		'Karen',	NULL ,	'Johnson',	'karen.johnson@email.com',	 '456 Pine St, CityD, StateW, 45678',	'567-890-1234', NULL),
--    ('RWilliams05', 'RWill789',		'Robert',	NULL ,	'Williams', 'robert.williams@email.com', '678 Cedar St, CityE, StateV, 56789',	'678-901-2345',	NULL),
--    ('ESmith06',	'EPassword123', 'Emily',	NULL ,	'Smith',	'emily.smith@email.com',	 '890 Birch St, CityF, StateU, 67890',	'789-012-3456',	NULL),
--    ('ABrown07',	'P@ss1234',		'Anna',		'M',	'Brown',	'anna.brown@email.com',		 '123 Elm St, New York, NY, 10001',		'123-456-7891', NULL),
--    ('JSharpe08',	'J0hnD0e',		'James',	'R',	'Sharpe',	'james.sharpe@email.com',	 '456 Oak St, Los Angeles, CA, 90001',	'456-789-0124', NULL),
--    ('LSanchez09',	'Pa$$w0rd',		'Laura',	'A',	'Sanchez',	'laura.sanchez@email.com',	 '123 Pine St, Chicago, IL, 60601',		'789-012-3457', '345-67-8903'),
--    ('TJohnson10',	'T3stUser',		'Tommy',	'J',	'Johnson',	'tommmy.johnson@email.com',  '678 Cedar St, Houston, TX, 77001',	'678-901-2346', '567-89-0123');
--SELECT * FROM cchen64.Users

-----------------------------------------------------------------


-- Insertion into College

--INSERT INTO College (CollegeName)
--VALUES
--    ('College of Architecture'),
--    ('College of Sciences and Engineering'),
--    ('College of Arts and Humanities'),
--    ('College of Business and Economics'),
--    ('College of Health Sciences'),
--    ('College of Education');
--SELECT * FROM College

-----------------------------------------------------------------

--Insertion into CollegeDepartment

--INSERT INTO CollegeDepartments (DepartmentName, CollegeID)
--VALUES
--    ('Department of Chemistry', 2),
--    ('Department of History', 3),
--    ('Department of Finance', 4),
--    ('Department of Nursing', 5), 
--    ('Department of Education', 6),
--    ('Department of Bursar', NULL); 

--SELECT * FROM CollegeDepartments

-----------------------------------------------------------------

-- Insertion into majors

--INSERT INTO Majors (MajorName, CollegeID)
--VALUES
--    ('Computer Science', 2), -- Belongs to College of Sciences and Engineering
--    ('Psychology', 3), -- Belongs to College of Arts and Humanities
--    ('Business Administration', 4), -- Belongs to College of Business and Economics
--    ('Nursing', 5), -- Belongs to College of Health Sciences
--    ('Education', 6), -- Belongs to College of Education
--    ('Physics', 2), -- Belongs to College of Sciences and Engineering
--	('Chemistry', 2), -- belongs to college of sciences and engineering
--	('Political Science', 3); -- Belongs to College of Arts and Humanities
--SELECT * FROM Majors


-----------------------------------------------------------------

-- Insertion into Minors

--INSERT INTO Minors (MinorName, CollegeID)
--VALUES
--    ('Mathematics', 2), -- Belongs to College of Sciences and Engineering
--    ('Art History', 3), -- Belongs to College of Arts and Humanities
--    ('Marketing', 4), -- Belongs to College of Business and Economics
--    ('Public Health', 5), -- Belongs to College of Health Sciences
--    ('English', 6), -- Belongs to College of Education
--    ('Chemistry', 2); -- Belongs to College of Sciences and Engineering
--SELECT * FROM MINORS

-----------------------------------------------------------------

-- Insertion into StudentType

--INSERT INTO StudentType (TypeName)
--VALUES
--    ('Freshmen'),
--    ('Continuing'),
--    ('Transfer'),
--    ('Re-admitted'),
--    ('New Graduate'),
--    ('Continuing Graduate');
--SELECT * FROM StudentType

-----------------------------------------------------------------

-- Insertion into StudentLevel

--INSERT INTO StudentLevel (StudentLevel)
--VALUES
--    ('Undergraduate'),
--    ('Graduate');
--SELECT * FROM StudentLevel

-----------------------------------------------------------------

-- Insertion into StudentStatus

--INSERT INTO StudentStatus (StatusName)
--VALUES
--    ('Active'),
--    ('Suspended'),
--    ('Inactive');
--SELECT * FROM StudentStatus

-----------------------------------------------------------------

-- Insertion into Students
--INSERT INTO Students (StudentID, NetID, MajorID, MinorID, StudentTypeID, StudentLevelID, StatusID)
--VALUES
--    (123456789, 'JDSmith01', 8, NULL, 1, 1, 1), -- John Smith, Major in Political Science, Freshman, Undergraduate, Active
--    (234567890, 'ALSimpson02', 3, 2, 2, 1, 1),  -- Alice Simpson, Major in Business Administration, no minor, Continuing, Undergraduate, Active
--    (345678901, 'MPPatel03', 7, NULL, 3, 2, 1),	  -- Michael Patel, Major in Chemistry, no minor, Transfer, Graduate, Active
--    (456789012, 'KJohnson04', 5, NULL, 1, 2, 1),   -- Karen Johnson, Major in Education, no minor, new graduate, Graduate, Active
--    (567890123, 'RWilliams05', 6, NULL, 4, 2, 1),  -- Robert Williams, Major in Physics, no minor, Re-admitted, Graduate, Active
--    (678901234, 'ESmith06', 4, NULL, 5, 1, 3),     -- Emily Smith, Major in Nursing, no minor, Continuing, Undergraduate, Inactive
--    (789012345, 'ABrown07', 1, NULL, 2, 1, 1),     -- Anna Brown, Major in Computer Science, Minor in Art History, Continuing, Undergraduate, Active
--    (890123456, 'LSanchez09', 3, NULL, 6, 2, 1);   -- Laura Sanchez, Major in Business Administration, no minor, Continuing Graduate, Graduate, Active

--SELECT * FROM Students

-----------------------------------------------------------------

-- Insertion into insurance table

--INSERT INTO Insurance (InsuranceType, CoverageType, EmployeePremium, EmployerPRemium)
--VALUES
--	('Dental', 'EmployeeOnly',	 108, 492),
--	('Dental', 'EmployeeFamily', 216, 504),
--	('Vision', 'EmployeeOnly',	 33, 147),
--	('Vision', 'EmployeeFamily', 65, 151),
--	('Health', 'EmployeeOnly',	 1422, 6478),
--	('Health', 'EmployeeFamily', 2844, 6636),
--	('D+V', 'EmployeeOnly', 135, 615),
--	('D+V', 'EmployeeFamily', 270, 630),
--	('Comprehensive', 'EmployeeOnly', 1548, 7052),
--	('Comprehensive', 'EmployeeFamily', 3096, 7224);

--SELECT * FROM Insurance

-----------------------------------------------------------------

-- Insertion into JobTypes Table

--INSERT INTO JobTypes (JobType)
--VALUES
--	('Faculty'),
--	('Staff');

--SELECT * FROM JobTypes

-----------------------------------------------------------------

-- Insertion into Jobs table


--INSERT INTO Jobs (JobCode, JobTitle, JobDescription, JobType, MinPay, MaxPay)
--VALUES
--    ('J001', 'Lecturer', 'Teach and mentor students', 2, 55000, 75000),
--    ('J002', 'Assistant Professor', 'Teach, research, and assist students', 1, 65000, 85000),
--    ('J003', 'Associate Professor', 'Teach, research, and mentor students', 1, 75000, 95000),
--    ('J004', 'Full Professor', 'Teach, research, and lead academic programs', 1, 85000, 110000),
--    ('J005', 'Admission Counselor', 'Assist students with admissions', 2, 45000, 60000),
--	('J006', 'Food Handler', 'Preparing food and ensure safety in dining areas', 2, 14400 , 28800),
--    ('J007', 'Librarian', 'Manage library resources and assist patrons', 2, 50000, 65000);


--SELECT * FROM Jobs

-----------------------------------------------------------------

-- Insertion into Employee Table
--INSERT INTO Employee(EmployeeID, NetID, Salary, JobID, InsuranceID)
--VALUES
--	('2010001','JSharpe08', 110000, 4, 10), -- Sharpe is a full professor and making max pay, and is covered under comprehensive family insurance
--	('2015001','TJohnson10', 95000, 3, 9),  -- Johnson is a Associate professor and making max pay, and is covered under comprehensive individual insurance
--	('2020001','ALSimpson02', 15000, 6, 7), -- Simpson is a student food handler making hourly pay, salary is an estimation and she is covered under personal dental and vision plan
--	('2020002','JDSmith01', 16000, 6, 7),   -- Smith is a student food handly making hourly pay, salary is an estimation and he is covered under personal dental and vision plan
--	('2018001','LSanchez09', 50000, 7, 5),  -- Sanchez is a grad student librarian making min pay and is covered under individual health insurance
--	('2018002','MPPatel03', 55000, 1, 5);   -- patel is a grad student lecturer making min pay and is covered under individual health insurance

--SELECT * FROM Employee


-----------------------------------------------------------------

-- Insertion into CourseCode table
--INSERT INTO CourseCode(CourseCode)
--VALUES
--	('CHE'), -- Chemistry, under chem department
--	('CEN'), -- Chemical engineering, under chem department
--	('MES'), -- middle eastern study, under history department
--	('MAX'), -- maxwell, under history department
--	('FIN'), -- Finance, under finance department
--	('BUA'), -- business admin, under finance department
--	('FST'), -- food studies, under nursing department
--	('HCA'), -- healthcare admin, under nursing department
--	('EDU'), -- Education, under education department
--	('EDA'); -- Education admin, under education department

--SELECT * FROM CourseCode

---------------------------------------------------------------

-- Insertion into CourseLevel Table

--INSERT INTO CourseLevel(CourseLevel)
--VALUES
--	('Undergraduate'),
--	('Graduate');


--SELECT * FROM CourseLevel

---------------------------------------------------------------

-- Insertion into Course Table
--INSERT INTO Course(CourseCodeID, CourseNum, CourseTitle, CourseDepartment, CourseDescription, CourseLevelID, Credits, Prereqs)
--VALUES
--	(1, '106', 'General Chemistry Lecture I', 1, 'Fundamental principles and laws underlying chemical action', 1, 3, NULL),
--	(2, '212', 'Experimental Methods in C.E.', 1, 'Statistical analysis and presentation of experimental data', 1, 3, NULL),
--	(3, '165', 'Discovering Islam', 2, 'Understand the origin, beliefs, rituals, and more about Islam', 1, 3, NULL),
--	(4, '123', 'Critical Issues for the US', 2, 'Interdisciplinary focus on critical issues facing America', 1, 3, NULL),
--	(5, '256', 'Principles of Finance', 3, 'Principles and foundations of finance', 1, 3, NULL),
--	(6, '201', 'Business Essentials', 3, 'Business fundamentals taught through the operation of a fictional company', 1, 3, NULL),
--	(7, '303', 'Food Movements', 4, 'Examination of food movements', 1, 3, NULL),
--	(8, '310', 'Electronic Healthcare Systems', 4, 'The course is aimed at exposing students to Electronic Health Record systems', 1, 3, NULL),
--	(9, '522', 'Social Studies and Democracy', 5, 'Relationship of social studies education to US democracy', 2, 3, NULL),
--	(10, '792', 'Legal Basis of Education', 3, 'School law as set forth in various government authorities', 2, 3, NULL)
--	;


--SELECT * FROM Course
---------------------------------------------------------------

-- Insertion into Semester Table


--INSERT INTO Semesters(SemesterType, SemesterStart, SemesterEnd)
--VALUES
--	('Spring', '2010-01-02', '2010-05-15'),
--	('Summer', '2010-05-15', '2010-08-25'),
--	('Fall', '2015-08-01', '2015-12-27'),
--	('Spring', '2016-01-02', '2016-05-15'),
--	('Summer', '2016-05-15', '2016-08-25'), 
--	('Fall', '2018-08-01', '2018-12-27'),
--	('Spring', '2018-01-02', '2018-05-15'),
--	('Summer', '2018-05-15', '2018-08-25'),
--	('Spring', '2020-01-02', '2020-05-15'),
--	('Fall', '2020-08-01', '2020-12-27');
	
--SELECT * FROM Semesters

---------------------------------------------------------------

-- Insertion into buildings table
--INSERT INTO Buildings (BuildingName)
--VALUES
--    ('Scientific Complex'), -- Building for Department of Chemistry
--    ('Nexus of Humanities'), -- Building for Department of History
--    ('Business Building'), -- Building for Department of Finance
--    ('Davidson center for Health Sciences '), -- Building for Department of Nursing
--    ('Sherman center of education'), -- Building for Department of Education
--    ('Office of Bursar Affairs'); -- No specific building for Department of Bursar

--SELECT * FROM Buildings

-----------------------------------------------------------------

-- Insertion into Rooms table
--INSERT INTO Rooms (RoomNum, RoomCapacity, BuildingID)
--VALUES
--    ('SC101', 30, 1), -- Scientific Complex
--    ('SC201', 60, 1), -- Scientific Complex
--    ('NH101', 40, 2), -- Nexus of Humanities
--    ('NH201', 80, 2), -- Nexus of Humanities
--    ('B101', 50, 3), -- Business Building
--    ('B201', 20, 3), -- Fine Arts Center
--    ('DCHS101', 30, 4), -- Davidson Center for Health Sciences
--    ('DCHS201', 100, 4), -- Davidson Center for Health Sciences
--    ('SCE301', 25, 5), -- Sherman Center of Education
--    ('SCE101', 75, 5); -- Sherman Center of Education

--SELECT * FROM Rooms

-----------------------------------------------------------------

-- Insertion into Equipments table
--INSERT INTO Equipments (EquipmentName, EquipmentPrice)
--VALUES
--    ('Projector', 800),
--    ('Microscope', 1500),
--    ('Whiteboard', 200),
--    ('Computer', 800),
--    ('Desk', 150),
--    ('Printer', 600),
--    ('Chair', 75),
--    ('Lab Table', 300),
--    ('Speaker System', 1200),
--    ('Smart Board', 1200);

--SELECT * FROM Equipments

-----------------------------------------------------------------

-- Insertion into RoomEquipment Table
--INSERT INTO RoomEquipment(RoomID, EquipmentID, EquipmentCount)
--VALUES
--	(1, 1, 1),  --Science building, 1 projector
--	(1, 2, 6),  --Science building, 6 microscopes
--	(1, 8, 6),  --Science building, 6 lab desks
--	(1, 9, 1),  --Science building, 1 speaker system
--	(1, 7, 30), --Science building, 30 chairs
--	(1, 10, 1), --Science building, 1 smart board
--	(3, 5, 20), --Nexus of Humanities, 20 desks
--	(3, 7, 40), --Nexus of Humanities, 40 chairs
--	(3, 1, 1),  --Nexus of Humanities, 1 projector
--	(3, 10, 1); --Nexus of Humanities, 1 smart board

--SELECT * FROM RoomEquipment

---------------------------------------------------------------

-- Insertion into CourseSchedule

--INSERT INTO CourseSchedule(CourseID, CRN, SectionNum, EmployeeID, CourseDates, StartTime, EndTime, CourseType, RoomID, SemesterID)
--VALUES
--	(1,  '18389', 1, 2018002, 'MonWed', '08:00:00', '09:20:00', 'OFF', 1, 10),  -- Taught by Patel, lecturer
--	(2,  '16843', 1, 2018002, 'MonWed', '11:00:00', '12:20:00', 'OFF', 2, 10),  -- Taught by Patel, lecturer
--	(3,  '15667', 1, 2015001, 'MonWedFri', '11:00:00', '12:20:00', 'OFF', 3, 10),  -- Taught by johnson, associate professor 
--	(4,  '13489', 1, 2015001, 'MonWedFri', '13:50:00', '15:10:00', 'OFF', 4, 10),  -- Taught by johnson, associate professor
--	(9,  '19589', 1, 2010001, 'TueThu', '09:30:00', '10:50:00', 'OFF', 9, 10),  -- Taught by Sharpe, tenured professor
--	(10, '19689', 1, 2010001, 'TueThu', '11:00:00', '12:20:00', 'OFF', 10, 10); -- Taught by sharpe, tenuerd professor

--SELECT * FROM CourseSchedule

---------------------------------------------------------------

-- Insertion into CourseStatus Table
--INSERT INTO CourseStatus(StatusName)
--VALUES
--	('Enrolled'),
--	('Dropped'),
--	('Audit');

--SELECT * FROM CourseStatus

---------------------------------------------------------------

-- Insertion into CourseEnrollment table

--INSERT INTO CourseEnrollment(ScheduleID, StudentID, CourseStatusID, MidtermGrade, FinalGrade)
--VALUES
--	(1, 789012345, 1, NULL, NULL), -- Anna is currently enrolled in chem 106
--	(1, 234567890, 1, NULL, NULL), -- Alice is currently enrolled in chem 106 
--	(3, 123456789, 1, NULL, NULL), -- John is currently enrolled in M.E. 
--	(4, 123456789, 1, NULL, NULL), -- John is currently enrolled in US studies
--	(5, 456789012, 1, NULL, NULL), -- Karen is currently enrolled in SS and democracy
--	(6, 456789012, 1, NULL, NULL); -- Karent is currently enrolled in Legal basis in ed
--SELECT * FROM CourseEnrollment

---------------------------------------------------------------

-- Insertion into EnrollmentCount Table	
--INSERT INTO EnrollmentCount
--VALUES
--	(1,2),
--	(3,1),
--	(4,1),
--	(5,1),
--	(6,1),
--	(2,0);

--SELECT * FROM EnrollmentCount
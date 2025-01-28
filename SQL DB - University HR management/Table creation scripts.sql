CREATE TABLE Users(
	NTID		VARCHAR(20)  PRIMARY KEY,
	Password	VARCHAR(50)  NOT NULL,
	FirstName	VARCHAR(50)  NOT NULL,
	MiddleName	VARCHAR(1),
	LastName	VARCHAR(50)  NOT NULL,
	Email		VARCHAR(100) NOT NULL,
	Address		VARCHAR(100) NOT NULL,
	PhoneNum	VARCHAR(20)  NOT NULL,
	SSN			VARCHAR(11)
);

CREATE TABLE College(
	CollegeID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	CollegeName		VARCHAR(100)	NOT NULL
);

CREATE TABLE CollegeDepartments(
	DepartmentID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	DepartmentName	VARCHAR(100)	NOT NULL,
	CollegeID		INT				REFERENCES College(CollegeID)
);

CREATE TABLE Majors(
	MajorID			INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	MajorName		VARCHAR(100)	NOT NULL,
	CollegeID		INT				NOT NULL REFERENCES College(CollegeID)
);

CREATE TABLE Minors(
	MinorID			INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	MinorName		VARCHAR(100)	NOT NULL,
	CollegeID		INT				NOT NULL REFERENCES College(CollegeID)
);

CREATE TABLE StudentType(
	StudentTypeID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	TypeName		VARCHAR(50)		NOT NULL
);

CREATE TABLE StudentLevel(
	StudentLevelID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	StudentLevel	VARCHAR(20)		NOT NULL
);

CREATE TABLE StudentStatus(
	StudentStatusID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	StatusName		VARCHAR(50)		NOT NULL
);

CREATE TABLE Students(
	StudentID		INT				NOT NULL PRIMARY KEY,
	NetID			VARCHAR(20)		NOT NULL REFERENCES Users(NTID),
	MajorID			INT				REFERENCES	Majors(MajorID),
	MinorID			INT				REFERENCES	Minors(MinorID),
	StudentTypeID	INT				NOT NULL REFERENCES StudentType(StudentTypeID),
	StudentLevelID	INT				NOT NULL REFERENCES StudentLevel(StudentLevelID),
	StatusID		INT				NOT NULL REFERENCES StudentStatus(StudentStatusID)
);

-- Renamed the following column
--	EXEC sp_rename 'Insurance.EmployerPRemium', 'EmployerPremium', 'COLUMN';

CREATE TABLE Insurance(
	InsuranceID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	InsuranceType	VARCHAR(30)		NOT NULL,
	CoverageType	VARCHAR(30)		NOT NULL,
	EmployeePremium	INT				NOT NULL,
	--edited the following coulm and made R after P lowercase
	--EmployerPRemium	INT				NOT NULL
	EmployerPremium	INT				NOT NULL
);

CREATE TABLE JobTypes(
	JTypeID			INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	JobType			VARCHAR(10)		NOT NULL
);


CREATE TABLE Jobs(
	JobID			INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	JobCode			VARCHAR(10)		NOT NULL,
	JobTitle		VARCHAR(50)		NOT NULL,
	JobDescription	VARCHAR(100)	,
	JobType			INT				NOT NULL REFERENCES JobTypes(JTypeID),
	MinPay			INT				NOT NULL,
	MaxPay			INT				NOT NULL
);

CREATE TABLE Employee(
	EmployeeID		INT				NOT NULL PRIMARY KEY,
	NetID			VARCHAR(20)		NOT NULL REFERENCES Users(NTID),
	Salary			INT				NOT NULL,
	JobID			INT				NOT NULL REFERENCES Jobs(JobID),
	InsuranceID		INT				NOT NULL REFERENCES Insurance(InsuranceID)
);

CREATE TABLE CourseCode(
	CourseCodeID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	CourseCode		VARCHAR(3)		NOT NULL				
);

CREATE TABLE CourseLevel(
	CourseLevelID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	CourseLevel		VARCHAR(15)		NOT NULL
);

CREATE TABLE Course(
	CourseID		  INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	CourseCodeID	  INT				NOT NULL REFERENCES CourseCode(CourseCodeID),
	CourseNum		  VARCHAR(3)		NOT NULL,
	CourseTitle		  VARCHAR(50)		NOT NULL,
	CourseDepartment  INT				NOT NULL REFERENCES CollegeDepartments(DepartmentID),
	CourseDescription VARCHAR(200)		NOT NULL,
	CourseLevelID	  INT				NOT NULL REFERENCES CourseLevel(CourseLevelID),
	Credits			  INT				NOT NULL,
	Prereqs			  VARCHAR(200)		
);

CREATE TABLE Buildings(
	BuildingID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	BuildingName	VARCHAR(50)		NOT NULL
);

CREATE TABLE Rooms(
	RoomID			INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	RoomNum			VARCHAR(10)		NOT NULL,
	RoomCapacity	INT				NOT NULL,
	BuildingID		INT				NOT NULL REFERENCES Buildings(BuildingID)
);

CREATE TABLE Equipments(
	EquipmentID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	EquipmentName	VARCHAR(50)		NOT NULL,
	EquipmentPrice	INT				NOT NULL
);

CREATE TABLE RoomEquipment(
	RoomEquipmentID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	RoomID			INT				NOT NULL REFERENCES Rooms(RoomID),
	EquipmentID		INT				NOT NULL REFERENCES Equipments(EquipmentID),
  EquipmentCount	INT				NOT NULL
);

CREATE TABLE Semesters(
	SemesterID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	SemesterType	VARCHAR(50)		NOT NULL,
	SemesterStart	DATE			NOT NULL,
	SemesterEnd		DATE			NOT NULL
);

CREATE TABLE CourseSchedule(
	ScheduleID		INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	CourseID		INT				NOT NULL REFERENCES Course(CourseID),
	CRN				VARCHAR(10)		NOT NULL,
	SectionNum		INT				,
	EmployeeID		INT				NOT NULL REFERENCES Employee(EmployeeID),
	CourseDates		VARCHAR(10)		NOT NULL,
	StartTime		TIME			NOT NULL,
	EndTime			TIME			NOT NULL,
	CourseType		VARCHAR(3)		,
	RoomID			INT				REFERENCES Rooms(RoomID),
	SemesterID		INT				NOT NULL REFERENCES Semesters(SemesterID)
);

CREATE TABLE CourseStatus(
	CourseStatusID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	StatusName		VARCHAR(30)		
);

CREATE TABLE CourseEnrollment(
	EnrollmentID	INT				NOT NULL PRIMARY KEY IDENTITY(1,1),
	ScheduleID		INT				NOT NULL REFERENCES CourseSchedule(ScheduleID),
	StudentID		INT				NOT NULL REFERENCES Students(StudentID),
	CourseStatusID	INT				NOT NULL REFERENCES CourseStatus(CourseStatusID),
	MidtermGrade	VARCHAR(10)		,
	FinalGrade		VARCHAR(10)
);


CREATE TABLE EnrollmentCount(
	EnrollmentID	INT				NOT NULL PRIMARY KEY REFERENCES CourseSchedule(ScheduleID),
	StudentCount	INT				NOT NULL
);
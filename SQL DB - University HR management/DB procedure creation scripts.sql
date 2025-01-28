
/* The following procedure lists all students that's current enrolled in a major on-record using a cursor
*/
CREATE PROCEDURE ListStudentsInMajor
    @MajorID INT
AS
BEGIN
    DECLARE @StudentID INT;
    DECLARE @FirstName VARCHAR(50);
    DECLARE @LastName VARCHAR(50);
    DECLARE @MajorName VARCHAR(100);

    -- Declare cursor
    DECLARE StudentCursor CURSOR FOR 
        SELECT s.StudentID, u.FirstName, u.LastName, m.MajorName 
        FROM Students s
        INNER JOIN Users u ON s.NetID = u.NTID
        INNER JOIN Majors m ON s.MajorID = m.MajorID
        WHERE s.MajorID = @MajorID;

    -- Open cursor and fetch from it
    OPEN StudentCursor;
    FETCH NEXT FROM StudentCursor INTO @StudentID, @FirstName, @LastName, @MajorName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'Student ID: ' + CAST(@StudentID AS VARCHAR) + ', Name: ' + @FirstName + ' ' + @LastName + ', Major: ' + @MajorName;
        FETCH NEXT FROM StudentCursor INTO @StudentID, @FirstName, @LastName, @MajorName;
    END;

    -- Close and deallocate cursor
    CLOSE StudentCursor;
    DEALLOCATE StudentCursor;
END;

DROP PROCEDURE ListStudentsInMajor

--SELECT * FROM Majors
/*	Here are all the majors currently on-record
*	
*	MajorID	   |  		MajorName		 |	CollegeID
*		1	   |	 Computer Science	 |		2
*		2	   |	 Psychology			 |		3
*		3	   | Business Administration |		4
*		4	   |		Nursing			 |		5
*		5	   |		Education		 |		6
*		6	   |		Physics			 |		2
*		7	   |		Chemistry		 |		2
*		8	   |	Political Science	 |		3
*/

-- The following will invoke procedure ListStudentsInMajor and print out students that's in a major
EXEC ListStudentsInMajor 1;
EXEC ListStudentsInMajor 2;
EXEC ListStudentsInMajor 3;
EXEC ListStudentsInMajor 4;
EXEC ListStudentsInMajor 5;
EXEC ListStudentsInMajor 6;
EXEC ListStudentsInMajor 7;
EXEC ListStudentsInMajor 8;

--example of procedure invoked with invalid input due to wrong datatype
EXEC ListStudentsInMajor 'Computer Science';

--------------------------------------------------------------------------------------
/* The following procedure updates a student's major based on a few condition
*	1. If student doesn't exist, operation should fail and produce error
*	2. If major is not supported (not on-record), operation should fail and produce error
*	3. Graduate student can't change their major
*	4. If the student is not active, you can't change major
*	Otherwise, change student major
*/
CREATE PROCEDURE UpdateStudentMajor
    @StudentID INT,
    @NewMajorID INT
AS
BEGIN
    -- Check if the student exists
    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
    BEGIN
        PRINT 'Error: The specified student ID does not exist.';
        RETURN;
    END

    -- Check if the major ID exists
    IF NOT EXISTS (SELECT 1 FROM Majors WHERE MajorID = @NewMajorID)
    BEGIN
        PRINT 'Error: The specified major ID is not available.';
        RETURN;
    END

    -- Check if the student is a graduate student
    IF EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID AND StudentLevelID = 2)
    BEGIN
        PRINT 'Error: Graduate students cannot change their major.';
        RETURN;
    END

    -- Check if the student is active
    IF EXISTS (SELECT 1 FROM Students s
               INNER JOIN StudentStatus ss ON s.StatusID = ss.StudentStatusID
               WHERE s.StudentID = @StudentID AND ss.StatusName = 'Active')
    BEGIN
        -- Student exists, is active, not a graduate student, and major exists, update the major
        UPDATE Students
        SET MajorID = @NewMajorID
        WHERE StudentID = @StudentID;
    END
    ELSE
    BEGIN
        -- Student is not active, print an error message
        PRINT 'Error: Only active students can change their major.';
    END
END;


DROP PROCEDURE UpdateStudentMajor

--SELECT * FROM Majors
/*	Here are all the majors currently on-record
*	
*	MajorID	   |  		MajorName		 |	CollegeID
*		1	   |	 Computer Science	 |		2
*		2	   |	 Psychology			 |		3
*		3	   | Business Administration |		4
*		4	   |		Nursing			 |		5
*		5	   |		Education		 |		6
*		6	   |		Physics			 |		2
*		7	   |		Chemistry		 |		2
*		8	   |	Political Science	 |		3
*/

--SELECT * FROM Students
/*
*	StudentID	|	NetID	|	MajorID	| MinorID |	StudentTypeID |	StudentLevelID | StatusID
*	123456789	| JDSmith01	|     8		|	NULL  |    	  1	      |        1	   |	1
*	234567890	|ALSimpson02|     3     |  	 2    |       2       |        1	   |    1
*	345678901	|MPPatel03	|	  7		|   NULL  |		  3	      |		   2	   |	1
*	456789012	|KJohnson04	|	  5		|   NULL  |		  5	      |		   2	   |	1
*	567890123	|RWilliams05|	  6		|   NULL  |		  4	      |		   2	   |	1
*	678901234	|ESmith06	| 	  4		|   NULL  |		  2	      |		   1	   |	3
*	789012345	|ABrown07	|	  1		|   NULL  |		  2		  |		   1	   |	1
*	890123456	|LSanchez09	|	  3		|   NULL  |		  6	      |		   2	   |	1
*/

SELECT * FROM Students
-- after the following EXEC, student John D. Smith will now be majored in Computer Science, not political science
EXEC UpdateStudentMajor 123456789, 2;
SELECT * FROM Students

-- the following produces: Error: The specified major ID is not available.
EXEC UpdateStudentMajor @StudentID = 123456789, @NewMajorID = 999;
-- the folowing produces: Error: Graduate students cannot change their major.
EXEC UpdateStudentMajor @StudentID = 345678901, @NewMajorID = 1;
-- the following produces: Error: Only active students can change their major.
EXEC UpdateStudentMajor @StudentID = 678901234, @NewMajorID = 1;

--------------------------------------------------------------------------------------
/*
* The following procedure checks whether or not a course can be deleted, a course can't be deleted based on the 3 following criteria:
*	1. CourseID not in DB
*	2. Course is currently scheduled for the newest semester
*
*	Otherwise a course may be deleted
*/
CREATE PROCEDURE DeleteCourse
    @CourseID INT
AS
BEGIN
    -- Check if the course exists
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        PRINT 'Error: The specified course ID does not exist.';
        RETURN;
    END

    -- Check if the course is scheduled in the latest semester
    IF EXISTS (
        SELECT 1 FROM CourseSchedule cs
        INNER JOIN Semesters s ON cs.SemesterID = s.SemesterID
        WHERE cs.CourseID = @CourseID AND s.SemesterEnd = (
            SELECT MAX(SemesterEnd) FROM Semesters
        )
    )
    BEGIN
        PRINT 'Error: The course is scheduled in the latest semester and cannot be deleted.';
        RETURN;
    END

    -- If checks pass, delete the course
    DELETE FROM Course WHERE CourseID = @CourseID;
END;

--SELECT * FROM Course
/*
*	CourseID	|	CourseCodeID	|	CourseNum	|	CourseTitle						|	CourseDepartment	|	CourseDescription															|	CourseLevelID	|	Credits	|	Prereqs
*	1			|	1				|	106			|	General Chemistry Lecture I		|	1					|	Fundamental principles and laws underlying chemical action					|	1				|	3		|	NULL
*	2			|	2				|	212			|	Experimental Methods in C.E.	|	1					|	Statistical analysis and presentation of experimental data					|	1				|	3		|	NULL
*	3			|	3				|	165			|	Discovering Islam				|	2					|	Understand the origin, beliefs, rituals, and more about Islam				|	1				|	3		|	NULL
*	4			|	4				|	123			|	Critical Issues for the US		|	2					|	Interdisciplinary focus on critical issues facing America					|	1				|	3		|	NULL
*	5			|	5				|	256			|	Principles of Finance			|	3					|	Principles and foundations of finance										|	1				|	3		|	NULL
*	6			|	6				|	201			|	Business Essentials				|	3					|	Business fundamentals taught through the operation of a fictional company	|	1				|	3		|	NULL
*	7			|	7				|	303			|	Food Movements					|	4					|	Examination of food movements												|	1				|	3		|	NULL
*	8			|	8				|	310			|	Electronic Healthcare Systems	|	4					|	The course is aimed at exposing students to Electronic Health Record systems|	1				|	3		|	NULL
*	9			|	9				|	522			|	Social Studies and Democracy	|	5					|	Relationship of social studies education to US democracy					|	2				|	3		|	NULL
*	10			|	10				|	792			|	Legal Basis of Education		|	5					|	School law as set forth in various government authorities					|	2				|	3		|	NULL
*/

-- Ignore the following insert for testing
--INSERT INTO Course(CourseCodeID, CourseNum, CourseTitle, CourseDepartment, CourseDescription, CourseLevelID, Credits, Prereqs)
--VALUES
--(5, '256', 'Principles of Finance', 3, 'Principles and foundations of finance', 1, 3, NULL)


SELECT * FROM Course
-- the following would succeed and delete the course 'principles of finance' from Course table
EXEC DeleteCourse 5
SELECT * FROM Course
-- the following produces: Error: The course is scheduled in the latest semester and cannot be deleted.
EXEC DeleteCourse @CourseID = 1;
-- the following produces: Error: The specified course ID does not exist.
EXEC DeleteCourse @CourseID = 999;

--------------------------------------------------------------------------------------
/* The following script creates procedure which will enroll a student a student in a class
*	if:
*		1. The student level (undergrad or grad) matches class level (undergrad or grad)
*		2. The student is not already scheduled in said class
*	Otherwise, student may not be enrolled in said class
*/

CREATE PROCEDURE EnrollStudentInCourse
    @StudentID INT,
    @ScheduleID INT
AS
BEGIN
    DECLARE @CourseStatusID INT = 1;  -- Default status ID for new enrollments

    -- Check if the course and student levels match
    IF NOT EXISTS (
        SELECT 1 FROM Students s
        INNER JOIN StudentLevel sl ON s.StudentLevelID = sl.StudentLevelID
        INNER JOIN CourseSchedule cs ON cs.ScheduleID = @ScheduleID
        INNER JOIN Course c ON cs.CourseID = c.CourseID
        INNER JOIN CourseLevel cl ON c.CourseLevelID = cl.CourseLevelID
        WHERE s.StudentID = @StudentID AND sl.StudentLevel = cl.CourseLevel
    )
    BEGIN
        PRINT 'Error: Enrollment requirement not met';
        RETURN;
    END

    -- Check if the student is already enrolled in the course
    IF EXISTS (SELECT * FROM CourseEnrollment WHERE StudentID = @StudentID AND ScheduleID = @ScheduleID)
    BEGIN
        PRINT 'Error: Student is already enrolled in this course.';
        RETURN;
    END

    -- Insert the enrollment record if all checks pass
    INSERT INTO CourseEnrollment (ScheduleID, StudentID, CourseStatusID)
    VALUES (@ScheduleID, @StudentID, @CourseStatusID);
END;


DROP PROCEDURE EnrollStudentInCourse

SELECT * FROM CourseSchedule
/*
* ScheduleID | CourseID |  CRN  | SectionNum | EmployeeID | CourseDates | StartTime | EndTime | CourseType | RoomID | SemesterID
*	 1			  1		  18389		  1			2018002		  MonWed	  08:00:00	  09:20:00	   OFF			1		10
*	 2			  2		  16843		  1			2018002		  MonWed	  11:00:00	  12:20:00	   OFF			2		10
*	 3			  3		  15667		  1			2015001		  MonWedFri	  11:00:00	  12:20:00	   OFF			3		10
*	 4			  4		  13489		  1			2015001		  MonWedFri	  13:50:00	  15:10:00	   OFF			4		10
*	 5			  9		  19589		  1			2010001		  TueThu	  09:30:00	  10:50:00	   OFF			9		10
*	 6			 10		  19689		  1			2010001		  TueThu	  11:00:00	  12:20:00	   OFF			10		10
*/

SELECT * FROM CourseEnrollment
-- The following enrolls student of ID 789012345 to Discovering Islam
EXEC EnrollStudentInCourse 789012345, 3;
SELECT * FROM CourseEnrollment

-- The following will produce: Error: Enrollment requirement not met
EXEC EnrollStudentInCourse 789012345, 9;
-- The following will produce: Error: Student is already enrolled in this course.
EXEC EnrollStudentInCourse 789012345, 1;	


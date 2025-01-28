-- the following should return a table with no entries, as no other classes are registered in spring 2010
SELECT * FROM GetCoursesByDepartment(1, 1)
-- the following should return a table with 2 entries
SELECT * FROM GetCoursesByDepartment(1, 10)


-- To use the function, consider the available data available below


--SELECT * FROM Semesters
/*	Currently my DB contains 10 semesters, and their ID for the above function are as follows:
*	
*	SemesterID	|	SemesterType	|	SemesterStart	|	SemesterEnd
*		1				Spring				2010				2010
*		2				Summer				2010				2010
*		3				Fall				2015				2015
*		4				Spring				2016				2016
*		5				Summer				2016				2016
*		6				Fall				2018				2018
*		7				Spring				2018				2018
*		8				Summer				2018				2018
*		9				Spring				2020				2020
*		10				Fall				2020				2020
*/

--SELECT * FROM CollegeDepartments
/*	Currently on-record college departments
*	
* DepartmentID |      DepartmentName     |  CollegeID
*       1      | Department Of Chemistry |      2
*       2      | Department Of History   |      3
*       3      | Department Of Finance   |      4
*       4      | Department Of Nursing   |      5
*       5      | Department Of Education |      6
*       6      | Department Of Bursar    |     NULL
*/
-----------------------------------------------------------------------------------------
-- How to select the view as described by the project document:

SELECT * FROM Benefits

-----------------------------------------------------------------------------------------
-- How to execute procedure 1

-- Consider the following available data before trying the function
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

-----------------------------------------------------------------------------------------
-- How to execute procedure 2
-- Consider the following available data before trying the function

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
*	123456789	| JDSmith01	|     2		|	NULL  |    	  1	      |        1	   |	1
*	234567890	|ALSimpson02|     3     |  	 2    |       2       |        1	   |    1
*	345678901	|MPPatel03	|	  7		|   NULL  |		  3	      |		   2	   |	1
*	456789012	|KJohnson04	|	  5		|   NULL  |		  5	      |		   2	   |	1
*	567890123	|RWilliams05|	  6		|   NULL  |		  4	      |		   2	   |	1
*	678901234	|ESmith06	| 	  4		|   NULL  |		  2	      |		   1	   |	3
*	789012345	|ABrown07	|	  1		|   NULL  |		  2		  |		   1	   |	1
*	890123456	|LSanchez09	|	  3		|   NULL  |		  6	      |		   2	   |	1
*/

SELECT * FROM Students
-- after the following EXEC, student John D. Smith will now be majored in Business Administration, not Computer Science
EXEC UpdateStudentMajor 123456789, 3;
SELECT * FROM Students

-- the following produces: Error: The specified major ID is not available.
EXEC UpdateStudentMajor @StudentID = 123456789, @NewMajorID = 999;
-- the folowing produces: Error: Graduate students cannot change their major.
EXEC UpdateStudentMajor @StudentID = 345678901, @NewMajorID = 1;
-- the following produces: Error: Only active students can change their major.
EXEC UpdateStudentMajor @StudentID = 678901234, @NewMajorID = 1;


-----------------------------------------------------------------------------------------
-- How to execute procedure 3
-- Consider the following available data before trying the function

--SELECT * FROM Course
/*
*	CourseID	|	CourseCodeID	|	CourseNum	|	CourseTitle						|	CourseDepartment	|	CourseDescription															|	CourseLevelID	|	Credits	|	Prereqs
*	1			|	1				|	106			|	General Chemistry Lecture I		|	1					|	Fundamental principles and laws underlying chemical action					|	1				|	3		|	NULL
*	2			|	2				|	212			|	Experimental Methods in C.E.	|	1					|	Statistical analysis and presentation of experimental data					|	1				|	3		|	NULL
*	3			|	3				|	165			|	Discovering Islam				|	2					|	Understand the origin, beliefs, rituals, and more about Islam				|	1				|	3		|	NULL
*	4			|	4				|	123			|	Critical Issues for the US		|	2					|	Interdisciplinary focus on critical issues facing America					|	1				|	3		|	NULL										|	1				|	3		|	NULL
*	6			|	6				|	201			|	Business Essentials				|	3					|	Business fundamentals taught through the operation of a fictional company	|	1				|	3		|	NULL
*	7			|	7				|	303			|	Food Movements					|	4					|	Examination of food movements												|	1				|	3		|	NULL
*	8			|	8				|	310			|	Electronic Healthcare Systems	|	4					|	The course is aimed at exposing students to Electronic Health Record systems|	1				|	3		|	NULL
*	9			|	9				|	522			|	Social Studies and Democracy	|	5					|	Relationship of social studies education to US democracy					|	2				|	3		|	NULL
*	10			|	10				|	792			|	Legal Basis of Education		|	5					|	School law as set forth in various government authorities					|	2				|	3		|	NULL
*/


SELECT * FROM Course
-- the following would succeed and delete the course 'critical issues for the us' from Course table
EXEC DeleteCourse 4
SELECT * FROM Course
-- the following produces: Error: The course is scheduled in the latest semester and cannot be deleted.
EXEC DeleteCourse @CourseID = 1;
-- the following produces: Error: The specified course ID does not exist.
EXEC DeleteCourse @CourseID = 999;
-----------------------------------------------------------------------------------------
-- How to execute procedure 4
--Consider the following available data before trying the function

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
-- The following enrolls student of ID 789012345 to Experimental Methods in C.E.
EXEC EnrollStudentInCourse 789012345, 2;
SELECT * FROM CourseEnrollment

-- The following will produce: Error: Enrollment requirement not met
EXEC EnrollStudentInCourse 789012345, 9;
-- The following will produce: Error: Student is already enrolled in this course.
EXEC EnrollStudentInCourse 789012345, 1;	
-----------------------------------------------------------------------------------------
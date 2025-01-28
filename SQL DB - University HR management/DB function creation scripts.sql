-- To see results, uncomment respective query statements 

CREATE FUNCTION GetCoursesByDepartment (@DepartmentID INT, @SemesterID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT c.CourseID, cc.CourseCode, c.CourseNum, c.CourseTitle, c.CourseDescription, cl.CourseLevel, cs.SectionNum, s.SemesterType, YEAR(s.SemesterStart)[Semester Year] ,cs.StartTime, cs.EndTime
    FROM Course c
				INNER JOIN CollegeDepartments cd ON c.CourseDepartment = cd.DepartmentID
				INNER JOIN CourseSchedule cs ON c.CourseID = cs.CourseID
				INNER JOIN CourseLevel cl ON c.CourseLevelID = cl.CourseLevelID
				INNER JOIN CourseCode cc ON c.CourseCodeID=cc.CourseCodeID
				INNER JOIN Semesters s ON cs.SemesterID=s.SemesterID
    WHERE cd.DepartmentID = @DepartmentID AND cs.SemesterID = @SemesterID
);

--DROP FUNCTION GetCoursesByDepartment


-- How to use function GetCourseByDepartment

-- should return a table with no entries, as no other classes are registered in spring 2010
SELECT * FROM GetCoursesByDepartment(1, 1)
-- should return a table with 2 entries, namely
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
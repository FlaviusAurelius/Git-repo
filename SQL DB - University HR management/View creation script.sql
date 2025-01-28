GRANT SELECT ON SCHEMA::cchen64 TO Graders

 --The following script creates a view named benefits which can be viewed by "Graders"
 -- that shows every employee's name, ID, benefit's type, coverage, and premium
 -- excluding job title and salary

CREATE VIEW [Benefits]
	AS	SELECT (u.FirstName+' '+u.MiddleName+'. '+u.LastName)[Employee Name],
				E.EmployeeID, ins.InsuranceType, ins.CoverageType, ins.EmployeePremium, ins.EmployerPremium
				FROM Users[u] INNER JOIN Employee[E] ON u.NTID=E.NetID
							  INNER JOIN Insurance[ins] ON E.InsuranceID=ins.InsuranceID

SELECT * FROM Benefits
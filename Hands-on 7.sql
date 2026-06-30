WITH Source_Count AS (SELECT COUNT(*) AS total_source FROM Employee_Source),
 Target_Count AS (SELECT COUNT(*) AS total_target FROM Employee_Target)
 SELECT total_source, total_target FROM Source_Count, Target_Count;


WITH Missing_Records AS (SELECT s.Emp_ID FROM Employee_Source s LEFT JOIN Employee_Target t 
 ON s.Emp_ID = t.Emp_ID WHERE t.Emp_ID IS NULL) SELECT * FROM Missing_Records;


WITH Extra_Records AS (SELECT t.Emp_ID FROM Employee_Target t LEFT JOIN Employee_Source s
 ON t.Emp_ID = s.Emp_ID WHERE s.Emp_ID IS NULL) SELECT * FROM Extra_Records;


WITH Salary_Check AS (SELECT s.Emp_ID, s.Salary AS Source_Salary, t.Salary AS Target_Salary
 FROM Employee_Source s JOIN Employee_Target t ON s.Emp_ID = t.Emp_ID)
 SELECT * FROM Salary_Check WHERE Source_Salary <> Target_Salary;
 
 
 WITH Source_Total AS 
 (SELECT Emp_ID, SUM(Salary) AS Source_Sum FROM Employee_Source GROUP BY Emp_ID),
Target_Total AS 
 (SELECT Emp_ID, SUM(Salary) AS Target_Sum FROM Employee_Target GROUP BY Emp_ID)
 SELECT s.Emp_ID, s.Source_Sum, t.Target_Sum FROM Source_Total s JOIN 
 Target_Total t ON s.Emp_ID = t.Emp_ID WHERE s.Source_Sum <> t.Target_Sum;
 
 WITH Source_Status AS 
 (SELECT Status, COUNT(*) AS Source_Count FROM Employee_Source GROUP BY Status),
Target_Status AS 
 (SELECT Status, COUNT(*) AS Target_Count FROM Employee_Target GROUP BY Status)
 SELECT s.Status, s.Source_Count, t.Target_Count FROM Source_Status s JOIN 
 Target_Status t ON s.Status = t.Status;
 
 
CREATE TABLE Employee_Source
(
 Emp_ID INT,
 Full_Name VARCHAR(100),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Status VARCHAR(20),
 Join_Date DATE
);

INSERT INTO Employee_Source VALUES
(101,'John Smith','IT',50000,'Active','2022-01-10'),
(102,'Mary Jones','HR',40000,'Active','2021-06-15'),
(103,'David Lee','Finance',60000,'Inactive','2020-03-20'),
(104,'Nancy Roy','IT',55000,'Active','2023-02-01'),
(105,'Sam Kumar','HR',45000,'Active','2022-08-12');

select * from employee_source ;

CREATE TABLE Project_Source
(
 Project_ID INT,
 Emp_ID INT,
 Project_Name VARCHAR(100),
 Project_Cost DECIMAL(10,2)
);

INSERT INTO Project_Source VALUES
(201,101,'ERP',100000),
(202,102,'CRM',80000),
(203,104,'Cloud',120000),
(204,105,'Payroll',90000);

select * from project_source;

CREATE TABLE Employee_Target
(
 Emp_Key INT PRIMARY KEY,
 Emp_ID INT UNIQUE NOT NULL,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Bonus DECIMAL(10,2),
 Status CHAR(1),
 Join_Date DATE,
 Created_Date DATE
);

CREATE TABLE Project_Target
(
 Project_Key INT PRIMARY KEY,
 Project_ID INT UNIQUE,
 Emp_Key INT,
 Project_Name VARCHAR(100),
 Project_Cost DECIMAL(10,2),
 Total_Cost DECIMAL(10,2),
 FOREIGN KEY (Emp_Key) REFERENCES Employee_Target(Emp_Key)
);

INSERT INTO Employee_Target
SELECT
ROW_NUMBER() OVER(ORDER BY Emp_ID),
Emp_ID,
SUBSTRING_INDEX(Full_Name,' ',1),
SUBSTRING_INDEX(Full_Name,' ',-1),
Department,
Salary,
Salary*0.10,
CASE
WHEN Status='Active' THEN 'A'
WHEN Status='Inactive' THEN 'I'
END,
Join_Date,
CURRENT_DATE
FROM Employee_Source;

select * from employee_target ;

INSERT INTO Project_Target
SELECT
ROW_NUMBER() OVER(ORDER BY p.Project_ID),
p.Project_ID,
e.Emp_Key,
p.Project_Name,
p.Project_Cost,
p.Project_Cost + e.Bonus
FROM Project_Source p
JOIN Employee_Target e
ON p.Emp_ID = e.Emp_ID;

select * from project_target;


SELECT 
 (SELECT COUNT(*) FROM Employee_Source where Status = 'Active') AS Source_Count,
 (SELECT COUNT(*) FROM Employee_Target) AS Target_Count;


SELECT s.Department, s.Source_Employee_Count, t.Target_Employee_Count
 FROM (SELECT Department, COUNT(*) AS Source_Employee_Count FROM Employee_Source
 WHERE Status = 'Active' GROUP BY Department) s
 JOIN (SELECT Department, COUNT(*) AS Target_Employee_Count FROM Employee_Target
 GROUP BY Department) t
 ON s.Department = t.Department;


SELECT s.Total_Source_Salary, t.Total_Target_Salary FROM
 (SELECT SUM(Salary) AS Total_Source_Salary FROM Employee_Source WHERE Status = 'Active') s,
 (SELECT SUM(Salary) AS Total_Target_Salary FROM Employee_Target) t;
 
 
 SELECT s.Department, s.Total_Source_Salary, t.Total_Target_Salary
 FROM (SELECT Department, SUM(Salary) AS Total_Source_Salary FROM Employee_Source
 WHERE Status = 'Active' GROUP BY Department) s
 JOIN (SELECT Department, SUM(Salary) AS Total_Target_Salary FROM Employee_Target
 GROUP BY Department) t
 ON s.Department = t.Department;
 
 SELECT s.Avg_Source_Salary, t.Avg_Target_Salary FROM
 (SELECT AVG(Salary) AS Avg_Source_Salary FROM Employee_Source WHERE Status = 'Active') s,
 (SELECT AVG(Salary) AS Avg_Target_Salary FROM Employee_Target) t;
 
 
 SELECT s.Min_Source_Salary, t.Min_Target_Salary FROM
 (SELECT MIN(Salary) AS Min_Source_Salary FROM Employee_Source WHERE Status = 'Active') s,
 (SELECT MIN(Salary) AS Min_Target_Salary FROM Employee_Target) t;
 
SELECT s.Max_Source_Salary, t.Max_Target_Salary FROM
 (SELECT MAX(Salary) AS Max_Source_Salary FROM Employee_Source WHERE Status = 'Active') s,
 (SELECT MAX(Salary) AS Max_Target_Salary FROM Employee_Target) t;

SELECT Emp_ID, COUNT(*) FROM Employee_Target GROUP BY Emp_ID HAVING COUNT(*) > 1;

SELECT s.Total_Source_Status, t.Total_Target_Status FROM
 (SELECT Status, COUNT(*) AS Total_Source_Status FROM Employee_Source WHERE Status = 'Active'
 GROUP BY Status) s,
 (SELECT Status, COUNT(*) AS Total_Target_Status FROM Employee_Target
 GROUP BY Status) t ;
 
 

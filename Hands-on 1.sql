/*HANDS-ON - 1*/

CREATE TABLE Employee_Source (
Emp_ID INT,
Emp_Name VARCHAR(100),
Gender VARCHAR(10),
Department VARCHAR(50),
Salary DECIMAL(10,2),
Manager_ID INT,
Join_Date DATE
);


INSERT INTO Employee_Source VALUES
(101,'John Smith','Male','IT',50000,201,'2018-01-10'),
(102,'Mary Jones','Female','HR',45000,202,'2019-05-12'),
(103,'David Lee','Male','Finance',60000,203,'2020-03-15'),
(104,'Nancy Roy',NULL,'IT',55000,201,'2021-07-10'),
(105,'Sam Kumar','Male','IT',70000,NULL,'2022-01-20');


select* from employee_source ;


CREATE TABLE Employee_Target (
Employee_Key INT,
Emp_ID INT,
Full_Name VARCHAR(100),
Gender VARCHAR(1),
Department VARCHAR(50),
Salary DECIMAL(10,2),
Manager_ID INT,
Join_Date DATE
);


INSERT INTO Employee_Target
(
Employee_Key,
Emp_ID,
Full_Name,
Gender,
Department,
Salary,
Manager_ID,
Join_Date
)
SELECT ROW_NUMBER() OVER (ORDER BY Emp_ID) AS Employee_Key,
Emp_ID, Emp_Name AS Full_Name,
CASE
WHEN Gender = 'Male' THEN 'M'
WHEN Gender = 'Female' THEN 'F'
ELSE NULL
END AS Gender, Department, Salary, Manager_ID, Join_Date FROM Employee_Source ;


CREATE TABLE Department_Master (
Department_Name VARCHAR(50)
);
INSERT INTO Department_Master VALUES
('IT'),
('HR'),
('Finance');


SELECT COUNT(*) FROM Employee_Source;
SELECT COUNT(*) FROM Employee_Target;

SELECT s.Emp_ID FROM Employee_Source s LEFT JOIN Employee_Target t
ON s.Emp_ID=t.Emp_ID WHERE t.Emp_ID IS NULL;


SELECT s.Emp_ID FROM Employee_Source s LEFT JOIN Employee_Target t
ON s.Emp_ID=t.Emp_ID WHERE t.Gender IS NULL;
SELECT s.Emp_ID FROM Employee_Source s LEFT JOIN Employee_Target t
ON s.Emp_ID=t.Emp_ID WHERE t.Emp_ID IS NULL or t.Gender IS NULL;


SELECT s.Emp_ID, s.Gender, t.Gender FROM Employee_Source s JOIN Employee_Target t
ON s.Emp_ID=t.Emp_ID WHERE (s.Gender='Male' AND t.Gender<>'M')
OR (s.Gender='Female' AND t.Gender<>'F');

SELECT * FROM Employee_Target WHERE Salary IS NULL; 
SELECT * FROM Employee_Target WHERE Gender IS NULL; 


SELECT t.Department FROM Employee_Target t LEFT JOIN Department_Master d
ON t.Department=d.Department_Name WHERE d.Department_Name IS NULL;

SELECT Emp_ID, COUNT(*) FROM Employee_Target
GROUP BY Emp_ID HAVING COUNT(*)>1;


SELECT * FROM Employee_Target WHERE Salary<0;

SELECT Employee_Key, COUNT(*) FROM Employee_Target
GROUP BY Employee_Key HAVING COUNT(*)>1;


SELECT SUM(Salary) Source_Salary FROM Employee_Source;
SELECT SUM(Salary) Target_Salary FROM Employee_Target;


SELECT MD5(CONCAT(Emp_ID, Emp_Name, Department, Salary)) FROM Employee_Source;
SELECT MD5(CONCAT(Emp_ID, Full_Name, Department, Salary)) FROM Employee_Target;


UPDATE Employee_Target SET Gender='X' WHERE Emp_ID=101;

SELECT * FROM Employee_Target
WHERE Gender NOT IN ('M', 'F') OR Gender IS NULL;

DELETE FROM Employee_Target WHERE Emp_ID=103;

SELECT (SELECT COUNT(*) FROM Employee_Source) AS Source_Count,
(SELECT COUNT(*) FROM Employee_Target) AS Target_Count;

SELECT s.* FROM Employee_Source s LEFT JOIN Employee_Target t
ON s.Emp_ID = t.Emp_ID WHERE t.Emp_ID IS NULL;

SELECT * FROM Employee_Source s
WHERE NOT EXISTS (SELECT * FROM Employee_Target t WHERE t.Emp_ID = s.Emp_ID);


INSERT INTO Employee_Target SELECT * FROM Employee_Target WHERE Emp_ID=102;

SELECT Emp_ID, COUNT(*) AS Record_Count FROM Employee_Target
GROUP BY Emp_ID HAVING COUNT(*) > 1;

SELECT * FROM Employee_Target WHERE Emp_ID IN
(SELECT Emp_ID FROM Employee_Target GROUP BY Emp_ID HAVING COUNT(*) > 1);


UPDATE Employee_Target SET Salary=99999 WHERE Emp_ID=104;

SELECT s.Emp_ID, s.Salary AS Source_Salary, t.Salary AS Target_Salary FROM
Employee_Source s
JOIN Employee_Target t ON s.Emp_ID = t.Emp_ID WHERE s.Salary <> t.Salary;

SELECT s.Emp_ID, s.Emp_Name, s.Salary AS Source_Salary, t.Salary AS Target_Salary
FROM Employee_Source s JOIN Employee_Target t
ON s.Emp_ID = t.Emp_ID WHERE IFNULL(s.Salary,0) <> IFNULL(t.Salary,0);


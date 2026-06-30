CREATE TABLE Employee_Source
( Emp_ID INT,
 Emp_Name VARCHAR(100),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Gender CHAR(1),
 Join_Date DATE,
 Status VARCHAR(20));
 
INSERT INTO Employee_Source VALUES
(101,'John', 'IT', 50000,'M','2023-01-15','Active'),
(102,'Mary', 'HR', 45000,'F','2022-06-10','Active'),
(103,'David','Finance', 60000,'M','2021-09-20','Inactive'),
(104,'Nancy','IT', 55000,'F','2023-03-01','Active'),
(105,'Sam', 'Admin', 35000,'M','2020-12-11','Active');


CREATE TABLE Employee_Target
( Employee_Key INT PRIMARY KEY,
 Emp_ID INT UNIQUE NOT NULL,
 Full_Name VARCHAR(100),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Gender CHAR(1),
 Join_Date DATE,
 Status CHAR(1));

INSERT INTO Employee_Target ( Employee_Key, Emp_ID, Full_Name, Department, Salary, Gender, 
Join_Date, Status ) SELECT ROW_NUMBER() OVER(ORDER BY Emp_ID), Emp_ID, Emp_Name,
Department, Salary, Gender, Join_Date, CASE WHEN Status='Active' THEN 'A' ELSE 'I' END FROM 
Employee_Source;

select * from employee_source ;

select * from employee_target ;
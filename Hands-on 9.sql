CREATE TABLE Source_Employee (
 Emp_ID INT PRIMARY KEY,
 Emp_Name VARCHAR(100),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Join_Date DATE
);

INSERT INTO Source_Employee VALUES
(101,'John','IT',50000,'2022-01-10'),
(102,'Alice','HR',40000,'2021-06-15'),
(103,'Bob','Finance',60000,'2020-03-20'),
(104,'David','IT',55000,'2023-02-11');

select * from source_employee;

CREATE TABLE Target_Employee (
 Emp_ID INT PRIMARY KEY,
 Emp_Name VARCHAR(100),
 Department VARCHAR(50),
 Salary DECIMAL(10,2),
 Join_Date DATE
);

INSERT INTO Target_Employee VALUES
(101,'John','IT',50000,'2022-01-10'),
(102,'Alice','HR',45000,'2021-06-15'),
(103,'Bob','Finance',60000,'2020-03-20');

select * from target_employee;

CREATE VIEW Employee_Validation AS
SELECT s.Emp_ID, s.Emp_Name,s.Salary AS Source_Salary, t.Salary AS Target_Salary,
s.Department As Source_Department, t.Department as Target_Department
FROM Source_Employee s LEFT JOIN Target_Employee t ON s.Emp_ID = t.Emp_ID;

SELECT * FROM Employee_Validation;

SELECT * FROM Employee_Validation WHERE Source_Salary <> Target_Salary OR Target_Salary IS NULL;

SELECT * FROM Employee_Validation WHERE Source_Department <> 
Target_Department;


DELIMITER $$
CREATE FUNCTION fn_SalaryDiff(src_salary DECIMAL(10,2), tgt_salary 
DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
 RETURN ABS(src_salary - tgt_salary);
END 
$$ DELIMITER ;


SELECT Emp_ID, fn_SalaryDiff(Source_Salary, Target_Salary) AS Salary_Diff
FROM Employee_Validation;


CREATE TABLE Migration_Audit (
 Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
 Emp_ID INT NOT NULL,
 Action_Type VARCHAR(20) NOT NULL,
 Action_Time DATETIME NOT NULL
);

DELIMITER $$
CREATE TRIGGER trg_Target_Insert
AFTER INSERT ON Target_Employee
FOR EACH ROW
BEGIN
 INSERT INTO Migration_Audit (Emp_ID, Action_Type, Action_Time)
 VALUES (NEW.Emp_ID, 'INSERT', NOW());
END
$$ DELIMITER ;

INSERT INTO Target_Employee VALUES (104,'David','IT',55000,'2023-02-11');
SELECT * FROM Migration_Audit; 
SELECT * FROM Migration_Audit ORDER BY Action_Time DESC;

DELIMITER $$
CREATE PROCEDURE ValidateMigration()
BEGIN
 -- Check missing records --
 SELECT 'Missing Records' AS Validation_Type, s.Emp_ID FROM Source_Employee s
 LEFT JOIN Target_Employee t ON s.Emp_ID = t.Emp_ID WHERE t.Emp_ID IS NULL;
 -- Check salary mismatches --
 SELECT 'Salary Mismatch' AS Validation_Type, s.Emp_ID, s.Salary AS 
Source_Salary,
 t.Salary AS Target_Salary FROM Source_Employee s INNER JOIN Target_Employee 
t
 ON s.Emp_ID = t.Emp_ID WHERE s.Salary <> t.Salary;
END
$$ DELIMITER ;

CALL ValidateMigration();



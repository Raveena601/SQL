CREATE TABLE Customer_Master (
 Cust_ID INT PRIMARY KEY,
 Full_Name VARCHAR(100),
 DOB DATE,
 City VARCHAR(50)
);

INSERT INTO Customer_Master VALUES
(101,'Ravi Kumar','1990-05-10','Chennai'),
(102,'Priya Sharma','1988-07-20','Bangalore'),
(103,'John Mathew','1995-01-15','Mumbai'),
(104,'Anu Raj','1992-11-25','Delhi'),
(105,'Kiran Das','1993-09-12','Chennai');

select * from customer_master;

CREATE TABLE Subscription_Details (
 Cust_ID INT,
 Plan_Code VARCHAR(20),
 Monthly_Fee DECIMAL(10,2),
 Start_Date DATE
);

INSERT INTO Subscription_Details VALUES
(101,'P100',500,'2025-01-01'),
(102,'P200',700,'2025-02-15'),
(103,'P100',500,'2025-03-01'),
(104,'P300',900,'2025-01-20'),
(105,'P100',500,'2025-04-10');

select * from subscription_details;


CREATE TABLE Payment_History (
 Cust_ID INT,
 Total_Paid DECIMAL(12,2),
 Last_Payment_Date DATE
);

INSERT INTO Payment_History VALUES
(101,3000,'2026-05-01'),
(102,4200,'2026-05-15'),
(103,2500,'2026-05-10'),
(104,5400,'2026-04-25'),
(105,1000,'2026-05-05');

select * from payment_history;


CREATE TABLE Customer_Subscription_Target (
 Customer_ID INT PRIMARY KEY,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50),
 Age INT CHECK (Age >= 18),
 City VARCHAR(50),
 Plan_Code VARCHAR(20),
 Monthly_Fee DECIMAL(10,2),
 Total_Paid DECIMAL(12,2),
 Payment_Status VARCHAR(20),
 Subscription_Status VARCHAR(20)
);

INSERT INTO Customer_Subscription_Target VALUES
(101,'Ravi','Kumar',36,'Chennai','P100',500,3000,'PAID','STANDARD'),
(102,'Priya','Sharma',38,'Bangalore','P200',700,4200,'PAID','STANDARD'),
(103,'John','Mathew',31,'Mumbai','P100',500,2500,'PENDING','STANDARD'),
(104,'Anu','Raj',34,'Delhi','P300',950,5400,'PAID','PREMIUM'),
(106,'Extra','Customer',28,'Hyderabad','P400',1200,6000,'PAID','PREMIUM');

select * from customer_subscription_target;

 SELECT s.Source_Count, t.Target_Count FROM 
 (SELECT COUNT(*) AS Source_Count FROM Customer_Master) s JOIN
 (SELECT COUNT(*) AS Target_Count FROM Customer_Subscription_Target) t ON 1=1;

 SELECT 
 (SELECT COUNT(*) FROM Customer_Master) AS Source_Count,
 (SELECT COUNT(*) FROM Customer_Subscription_Target) AS Target_Count;
 
 
SELECT Cust_ID FROM Customer_Master WHERE Cust_ID NOT IN 
 (SELECT Customer_ID FROM Customer_Subscription_Target);
 
 SELECT s.Cust_ID FROM Customer_Master s LEFT JOIN Customer_Subscription_Target t
 ON s.Cust_ID = t.Customer_ID WHERE t.Customer_ID IS NULL;


SELECT t.Customer_ID FROM Customer_Master s RIGHT JOIN Customer_Subscription_Target t
 ON s.Cust_ID = t.Customer_ID WHERE s.Cust_ID IS NULL;


 SELECT t.Customer_ID FROM Customer_Subscription_Target t WHERE NOT EXISTS 
 (SELECT * FROM Customer_Master s WHERE s.Cust_ID = t.Customer_ID);
 
 SELECT s.Full_Name, CONCAT(t.First_Name,' ',t.Last_Name) AS Target_Name
 FROM Customer_Master s JOIN Customer_Subscription_Target t ON s.Cust_ID=t.Customer_ID
 WHERE s.Full_Name <> CONCAT(t.First_Name,' ',t.Last_Name);
 
 SELECT s.Full_Name, (SELECT CONCAT(t.First_Name,' ',t.Last_Name) FROM Customer_Subscription_Target t
 WHERE s.Cust_ID = t.Customer_ID) AS Target_Name FROM Customer_Master s WHERE s.Full_Name <> 
 (SELECT CONCAT(t.First_Name,' ',t.Last_Name) FROM Customer_Subscription_Target t
 WHERE s.Cust_ID = t.Customer_ID);


SELECT s.Cust_ID, TIMESTAMPDIFF(YEAR,s.DOB,CURDATE()) AS Expected_Age,
 t.Age FROM Customer_Master s JOIN Customer_Subscription_Target t ON s.Cust_ID=t.Customer_ID
 WHERE TIMESTAMPDIFF(YEAR,s.DOB,CURDATE()) <> t.Age;

 SELECT s.Cust_ID, TIMESTAMPDIFF(YEAR, s.DOB, CURDATE()) AS Expected_Age,
 (SELECT t.Age FROM Customer_Subscription_Target t WHERE s.Cust_ID = t.Customer_ID) AS Target_Age
 FROM Customer_Master s WHERE TIMESTAMPDIFF(YEAR, s.DOB, CURDATE()) <> 
 (SELECT t.Age FROM Customer_Subscription_Target t WHERE s.Cust_ID = t.Customer_ID
);


SELECT t.Customer_ID, t.Total_Paid, t.Payment_Status FROM Customer_Subscription_Target t
 JOIN (SELECT Customer_ID FROM Customer_Subscription_Target WHERE
 (Total_Paid > 2000 AND Payment_Status <> 'PAID') OR
 (Total_Paid <= 2000 AND Payment_Status <> 'PENDING')) v ON t.Customer_ID = v.Customer_ID;
 
 SELECT Customer_ID, Total_Paid, Payment_Status FROM Customer_Subscription_Target WHERE
 Customer_ID IN (SELECT Customer_ID FROM Customer_Subscription_Target WHERE
 (Total_Paid > 2000 AND Payment_Status <> 'PAID') OR
 (Total_Paid <= 2000 AND Payment_Status <> 'PENDING'));
 
 
 SELECT t.* FROM Customer_Subscription_Target t JOIN 
 (SELECT Customer_ID FROM Customer_Subscription_Target WHERE
 (Monthly_Fee > 800 AND Subscription_Status <> 'PREMIUM') OR
 (Monthly_Fee <= 800 AND Subscription_Status <> 'STANDARD')) v
 ON t.Customer_ID = v.Customer_ID;
 
 SELECT * FROM Customer_Subscription_Target WHERE Customer_ID IN (
 SELECT Customer_ID FROM Customer_Subscription_Target WHERE
 (Monthly_Fee > 800 AND Subscription_Status <> 'PREMIUM') OR
 (Monthly_Fee <= 800 AND Subscription_Status <> 'STANDARD'));
 
 
 SELECT SUM(p.Total_Paid) AS Source_Total, SUM(t.Total_Paid) AS Target_Total FROM Payment_History p
 JOIN Customer_Subscription_Target t ON p.Cust_ID=t.Customer_ID;
 
 SELECT s.Plan_Code, SUM(s.Monthly_Fee) AS Source_Revenue, SUM(t.Monthly_Fee) AS Target_Revenue
 FROM Subscription_Details s JOIN Customer_Subscription_Target t
 ON s.Cust_ID=t.Customer_ID GROUP BY s.Plan_Code;

SELECT a.Customer_ID, b.Customer_ID FROM Customer_Subscription_Target a JOIN 
Customer_Subscription_Target b ON a.Customer_ID=b.Customer_ID AND a.Customer_ID<>b.Customer_ID;

SELECT Customer_ID FROM Customer_Subscription_Target WHERE Customer_ID IN 
 (SELECT Customer_ID FROM Customer_Subscription_Target GROUP BY Customer_ID
 HAVING COUNT(*) > 1);
 
 SELECT t.Customer_ID FROM Customer_Subscription_Target t LEFT JOIN Customer_Master s
 ON t.Customer_ID = s.Cust_ID WHERE s.Cust_ID IS NULL;
 
 SELECT t.Customer_ID FROM Customer_Subscription_Target t
 WHERE t.Customer_ID NOT IN (SELECT Cust_ID FROM Customer_Master);
 
 SELECT t.Customer_ID FROM Customer_Subscription_Target t
 WHERE NOT EXISTS (SELECT * FROM Customer_Master s WHERE s.Cust_ID = t.Customer_ID);

SELECT * FROM Customer_Subscription_Target WHERE First_Name IS NULL
OR Last_Name IS NULL OR Plan_Code IS NULL;


SELECT * FROM Customer_Subscription_Target WHERE Age < 18;
CREATE TABLE Customer_Source
(
Customer_ID INT,
Customer_Name VARCHAR(100),
Email VARCHAR(100),
City VARCHAR(50),
Status VARCHAR(20)
);
INSERT INTO Customer_Source VALUES
(101,'John Smith','john@gmail.com','Chennai','Active'),
(102,'Mary Jones','mary@gmail.com','Bangalore','Inactive'),
(103,'David Lee','david@gmail.com','Hyderabad','Active'),
(104,'Nancy Roy',NULL,'Chennai','Active'),
(105,'Sam Kumar','sam@gmail.com','Pune','Active');


CREATE TABLE Orders_Source
(
Order_ID INT,
Customer_ID INT,
Order_Date DATE,
Order_Amount DECIMAL(10,2)
);


INSERT INTO Orders_Source VALUES
(1001,101,'2024-01-10',2500),
(1002,102,'2024-02-15',5000),
(1003,103,'2024-03-12',3500),
(1004,101,'2024-04-01',4000),
(1005,105,'2024-05-10',6000);


CREATE TABLE Customer_Target
(
Customer_Key INT PRIMARY KEY,
Customer_ID INT UNIQUE NOT NULL,
Full_Name VARCHAR(100) NOT NULL,
Email VARCHAR(100),
City VARCHAR(50),
Status CHAR(1) CHECK(Status IN ('A','I'))
);


CREATE TABLE Orders_Target
(
Order_Key INT PRIMARY KEY,
Order_ID INT UNIQUE NOT NULL,
Customer_Key INT NOT NULL,
Order_Date DATE,
Order_Amount DECIMAL(10,2) CHECK(Order_Amount > 0),
FOREIGN KEY(Customer_Key)
REFERENCES Customer_Target(Customer_Key)
);


INSERT INTO Customer_Target
(
Customer_Key,
Customer_ID,
Full_Name,
Email,
City,
Status
)
SELECT
ROW_NUMBER() OVER(ORDER BY Customer_ID),
Customer_ID,
Customer_Name,
Email,
City,
CASE
WHEN Status='Active' THEN 'A'
WHEN Status='Inactive' THEN 'I'
END
FROM Customer_Source;

INSERT INTO Orders_Target
(
Order_Key,
Order_ID,
Customer_Key,
Order_Date,
Order_Amount
)
SELECT
ROW_NUMBER() OVER(ORDER BY o.Order_ID),
o.Order_ID,
c.Customer_Key,
o.Order_Date,
o.Order_Amount
FROM Orders_Source o
JOIN Customer_Target c
ON o.Customer_ID=c.Customer_ID;

select * from customer_source ;

select * from orders_source;

select * from customer_target;

select * from orders_target;

SELECT Email,COUNT(*) FROM Customer_Target GROUP BY Email HAVING COUNT(*) > 1;

SELECT Email, COUNT(*) AS Email_Count,
CASE WHEN COUNT(*) > 1 THEN 'Duplicate' ELSE 'Unique' END AS Validation_Result
FROM Customer_Target GROUP BY Email;

/*Total_Amount DECIMAL(10,2)
SELECT * FROM Orders_Target WHERE Total_Amount <> ROUND(Order_Amount+Tax_Amount,2); */


SELECT *,
CASE WHEN Total_Amount = ROUND(Order_Amount + Tax_Amount, 2)
THEN 'PASS' ELSE 'FAIL' END AS Validation_Result
FROM Orders_Target;

SELECT * FROM Customer_Target WHERE Join_Date > Created_Date;
SELECT *,
CASE WHEN Join_Date > Created_Date THEN 'FAIL' ELSE 'PASS'
END AS Validation_Result FROM Customer_Target;


SELECT * FROM Orders_Target o LEFT JOIN Customer_Target c
ON o.Customer_Key=c.Customer_Key WHERE c.Customer_Key IS NULL;

SELECT o.Order_ID, o.Customer_Key,
CASE
WHEN c.Customer_Key IS NULL THEN 'FAIL Customer Not Found'
ELSE 'PASS Customer Exists' END AS Validation_Result
FROM Orders_Target o LEFT JOIN Customer_Target c
ON o.Customer_Key = c.Customer_Key;

SELECT * FROM Customer_Target WHERE City IS NULL OR Status IS NULL OR Customer_ID IS NULL;

SELECT *,
CASE WHEN City IS NULL OR Status IS NULL OR Customer_ID IS NULL
THEN 'FAIL' ELSE 'PASS' END AS Validation_Result FROM Customer_Target;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders_Target' AND COLUMN_NAME = 'Order_Date';

SELECT CASE WHEN DATA_TYPE = 'date'
THEN 'PASS' ELSE 'FAIL' END AS Validation_Result
FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = 'Orders_Target' AND COLUMN_NAME = 'Order_Date';

SELECT Customer_ID, Full_Name, Email FROM Customer_Target WHERE Email NOT LIKE '%@%.%';

SELECT Customer_ID, Full_Name, Email,
CASE WHEN Email LIKE '%@%.%' THEN 'PASS' ELSE 'FAIL'
END AS Validation_Result FROM Customer_Target;

INSERT INTO Customer_Target SELECT * FROM Customer_Target WHERE Customer_ID=102;

UPDATE Orders_Target SET Customer_Key=999 WHERE Order_ID=1003;

UPDATE Customer_Target SET Email = 'john.doe#gmail.com' WHERE Customer_ID = 101;

UPDATE Orders_Target SET Order_Amount=99999 WHERE Order_ID=1004;

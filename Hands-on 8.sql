
CREATE TABLE Customer_Source (
 Customer_ID INT PRIMARY KEY,
 Email VARCHAR(100),
 Phone VARCHAR(15),
 Country VARCHAR(50),
 Status VARCHAR(20),
 Created_Date DATE,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50)
);

INSERT INTO Customer_Source VALUES
(101, 'john@gmail.com', '9876543210', 'India', 'ACTIVE', '2026-01-10', 'John', 'David'),
(102, 'alice@gmail.com', '9876543211', 'USA', 'ACTIVE', '2026-02-15', 'Alice', 'Smith'),
(103, 'bob@gmail.com', '9876543212', 'UK', 'INACTIVE', '2026-03-20', 'Bob', 'Roy'),
(104, 'mike@gmail.com', '9876543213', 'India', 'ACTIVE', '2026-04-05', 'Mike', 'Jordan'),
(105, 'emma@gmail.com', '9876543214', 'Canada','ACTIVE', '2026-05-25', 'Emma', 'Watson');

select * from customer_source ;

CREATE TABLE Customer_Target (
 Customer_ID INT PRIMARY KEY,
 Email VARCHAR(100),
 Phone VARCHAR(15),
 Country VARCHAR(50),
 Status VARCHAR(20),
 Created_Date DATE,
 First_Name VARCHAR(50),
 Last_Name VARCHAR(50)
);

INSERT INTO Customer_Target VALUES
(101, 'john@gmail.com', '9876543210', 'India', 'ACTIVE', '2026-01-10', 'John', 'David'),
(102, 'alice@gmail.com', '9876543211', 'USA', 'ACTIVE', '2026-02-15', 'Alice', 'Smith'),
(103, 'bob_new@gmail.com','9876543212', 'UK', 'INACTIVE', '2026-03-20', 'Bob', 'Roy'),
(104, 'mike@gmail.com', '9876543213', 'India', 'ACTIVE', '2026-04-05', 'Mike', 'Jordan'),
(106, 'harry@gmail.com', '9876543215', 'India', 'ACTIVE', '2026-06-01', 'Harry', 'Potter');

select * from customer_target ;

CREATE UNIQUE INDEX idx_email ON Customer_Target(Email);

CREATE INDEX idx_name_phone ON Customer_Target(First_Name, Last_Name, Phone);

CREATE CLUSTERED INDEX idx_date ON Customer_Target(Created_Date);

CREATE INDEX idx_country ON Customer_Target(Country);

SELECT COUNT(*) FROM Customer_Source;
SELECT COUNT(*) FROM Customer_Target;

SELECT s.* FROM Customer_Source s LEFT JOIN Customer_Target t
ON s.Customer_ID = t.Customer_ID WHERE t.Customer_ID IS NULL;

SELECT t.* FROM Customer_Target t LEFT JOIN Customer_Source s
ON t.Customer_ID = s.Customer_ID WHERE s.Customer_ID IS NULL;

SELECT Email FROM Customer_Target GROUP BY Email HAVING COUNT(*) > 1;

SELECT s.Customer_ID, s.Email AS Source_Email, t.Email AS Target_Email
FROM Customer_Source s JOIN Customer_Target t
ON s.Customer_ID = t.Customer_ID WHERE s.Email <> t.Email;

SELECT s.* FROM Customer_Source s JOIN Customer_Target t
ON s.First_Name=t.First_Name AND s.Last_Name=t.Last_Name AND s.Phone=t.Phone;

SELECT * FROM Customer_Target WHERE Created_Date >= '2026-06-01';

SELECT * FROM Orders_Target o LEFT JOIN Customer_Target c
ON o.Customer_ID=c.Customer_ID WHERE c.Customer_ID IS NULL;

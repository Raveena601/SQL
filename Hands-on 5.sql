CREATE TABLE Orders_Source (
Order_ID INT PRIMARY KEY,
Customer_ID INT,
Order_Date DATE,
Amount DECIMAL(10,2),
Status VARCHAR(20)
);

INSERT INTO Orders_Source VALUES
(1001,201,'2026-06-01',1500,'Completed'),
(1002,202,'2026-06-02',2200,'Pending'),
(1003,203,'2026-06-03',1800,'Completed'),
(1004,204,'2026-06-04',2500,'Cancelled'),
(1005,205,'2026-06-05',3000,'Completed');

select * from orders_source ;

CREATE TABLE Orders_Target (
Order_ID INT PRIMARY KEY,
Customer_ID INT,
Order_Date DATE,
Amount DECIMAL(10,2),
Status VARCHAR(20)
);

INSERT INTO Orders_Target VALUES
(1001,201,'2026-06-01',1500,'Completed'),
(1002,202,'2026-06-02',2300,'Pending'),
(1003,203,'2026-06-03',1800,'Completed'),
(1004,204,'2026-06-04',2500,'Cancelled'),
(1006,206,'2026-06-06',3500,'Completed');

select * from orders_target ;

SELECT s.Order_ID, s.Amount AS Source_Amount, t.Amount AS Target_Amount
FROM Orders_Source s INNER JOIN Orders_Target t ON s.Order_ID = t.Order_ID;

SELECT s.* FROM Orders_Source s LEFT JOIN Orders_Target t
ON s.Order_ID = t.Order_ID WHERE t.Order_ID IS NULL;


SELECT t.* FROM Orders_Source s RIGHT JOIN Orders_Target t ON
s.Order_ID = t.Order_ID WHERE s.Order_ID IS NULL;

SELECT s.Order_ID, s.Amount, t.Amount FROM Orders_Source s LEFT JOIN Orders_Target t
ON s.Order_ID = t.Order_ID UNION SELECT s.Order_ID, s.Amount, t.Amount
FROM Orders_Source s RIGHT JOIN Orders_Target t ON s.Order_ID = t.Order_ID;

SELECT s.Order_ID, t.Status FROM Orders_Source s CROSS JOIN Orders_Target t;


SELECT a.Customer_ID, a.Order_ID, b.Order_ID FROM Orders_Target a JOIN Orders_Target b
ON a.Customer_ID = b.Customer_ID AND a.Order_ID <> b.Order_ID;

SELECT s.Order_ID, s.Amount AS Source_Amount, t.Amount AS Target_Amount FROM Orders_Source s
JOIN Orders_Target t ON s.Order_ID = t.Order_ID WHERE s.Amount <> t.Amount;

SELECT s.Status, SUM(s.Amount) AS Source_Total, SUM(t.Amount) AS Target_Total
FROM Orders_Source s JOIN Orders_Target t ON s.Order_ID = t.Order_ID
GROUP BY s.Status;
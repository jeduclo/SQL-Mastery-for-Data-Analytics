CREATE DATABASE Workshop1;
USE DATABASE Workshop1;
--1. Create Tables
-- Creating the 'Products' table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    Price DECIMAL(10, 2)
);

-- Creating the 'Customers' table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    ZipCode VARCHAR(10)
);

-- Creating the 'Orders' table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    PaymentType VARCHAR(50),
    TotalPrice DECIMAL(10, 2),
    State VARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creating the 'OrderLines' table
CREATE TABLE OrderLines (
    OrderLineID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    NumUnits INT,
    PricePerUnit DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

--2. Insert Sample Data
-- Inserting data into 'Products'
INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.99),
(3, 'Keyboard', 45.50),
(4, 'Monitor', 150.00),
(5, 'USB Cable', 10.00);

-- Inserting data into 'Customers'
INSERT INTO Customers (CustomerID, CustomerName, City, State, ZipCode) VALUES
(1, 'John Doe', 'New York', 'NY', '10001'),
(2, 'Jane Smith', 'Los Angeles', 'CA', '90001'),
(3, 'William Johnson', 'Chicago', 'IL', '60601'),
(4, 'Emma Brown', 'Houston', 'TX', '77001');

-- Inserting data into 'Orders'
INSERT INTO Orders (OrderID, CustomerID, OrderDate, PaymentType, TotalPrice, State) VALUES
(1, 1, '2023-01-01', 'Credit Card', 1275.99, 'NY'),
(2, 2, '2023-01-05', 'PayPal', 170.49, 'CA'),
(3, 3, '2023-01-10', 'Debit', 45.50, 'IL'),
(4, 4, '2023-01-15', 'Credit Card', 1260.00, 'TX');

-- Inserting data into 'OrderLines'
INSERT INTO OrderLines (OrderLineID, OrderID, ProductID, NumUnits, PricePerUnit) VALUES
(1, 1, 1, 1, 1200.00),
(2, 1, 2, 1, 25.99),
(3, 2, 3, 1, 45.50),
(4, 2, 4, 1, 150.00),
(5, 3, 3, 1, 45.50),
(6, 4, 1, 1, 1200.00),
(7, 4, 5, 2, 10.00);

--3. Example Queries to Teach SQL Concepts
--Basic SQL Syntax:
SELECT * FROM Products;

--WHERE Clause and Filtering:
SELECT * FROM Orders WHERE PaymentType = 'Credit Card';

--Functions and Aggregates:
SELECT COUNT(*) AS NumberOfOrders FROM Orders;

--GROUP BY and Aggregates:
SELECT State, COUNT(*) AS NumberOfOrders FROM Orders GROUP BY State;

--ORDER BY Clause:
SELECT ProductName, Price FROM Products ORDER BY Price DESC;

--JOIN Operations:
SELECT Orders.OrderID, Customers.CustomerName, Orders.TotalPrice
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--Subqueries and CTEs:
WITH CustomerOrders AS (
    SELECT CustomerID, COUNT(*) AS NumOrders
    FROM Orders
    GROUP BY CustomerID
)
SELECT Customers.CustomerName, CustomerOrders.NumOrders
FROM Customers
JOIN CustomerOrders ON Customers.CustomerID = CustomerOrders.CustomerID;

--#########################################################################
--Lab 1: SQL Basics and Querying Data

--Exercise 1: Basic Data Retrieval
-- Select all columns from the Products table
SELECT * FROM Products;

-- Select only the ProductName and Price columns from the Products table
SELECT ProductName, Price FROM Products;


--Exercise 2: Filtering and Sorting
-- Find all orders with a TotalPrice greater than 100
SELECT * FROM Orders WHERE TotalPrice > 100;

-- Sort the results by OrderDate in descending order
SELECT * FROM Orders WHERE TotalPrice > 100 ORDER BY OrderDate DESC;


--Exercise 3: Aggregations and Grouping
-- Count the total number of orders
SELECT COUNT(*) AS NumberOfOrders FROM Orders;

-- Find the average TotalPrice of orders, grouped by PaymentType
SELECT PaymentType, AVG(TotalPrice) AS AveragePrice FROM Orders GROUP BY PaymentType;


--Exercise 4: Using Aliases
-- Select customers' names and states with aliases
SELECT CustomerName AS Name, State FROM Customers;


--Lab 2: Advanced SQL Concepts

--Exercise 1: Conditional Logic and Pattern Matching
-- Categorize orders into 'High Value' and 'Low Value'
SELECT OrderID, TotalPrice,
       CASE WHEN TotalPrice > 500 THEN 'High Value' ELSE 'Low Value' END AS ValueCategory
FROM Orders;

-- Find all products whose names start with 'M'
SELECT * FROM Products WHERE ProductName LIKE 'M%';


--Exercise 2: Subqueries and Joins
-- Subquery to find customers who have placed more than 1 order
SELECT * FROM Customers WHERE CustomerID IN (
    SELECT CustomerID FROM Orders GROUP BY CustomerID HAVING COUNT(OrderID) > 1
);

-- Inner join between Orders and OrderLines to find the total number of units ordered for each order
SELECT Orders.OrderID, SUM(OrderLines.NumUnits) AS TotalUnits
FROM Orders
JOIN OrderLines ON Orders.OrderID = OrderLines.OrderID
GROUP BY Orders.OrderID;


--Exercise 3: Advanced Aggregation and Window Functions
-- Count the number of orders for each PaymentType with TotalPrice > 200
SELECT PaymentType, SUM(CASE WHEN TotalPrice > 200 THEN 1 ELSE 0 END) AS HighValueOrderCount
FROM Orders
GROUP BY PaymentType;

-- Cumulative sum of orders' total prices, ordered by OrderDate
SELECT OrderID, OrderDate, TotalPrice,
       SUM(TotalPrice) OVER (ORDER BY OrderDate) AS CumulativeTotalPrice
FROM Orders;


--Exercise 4: Working with Dates and String Functions
-- Extract year and month from OrderDate and count orders for each month and year
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, COUNT(*) AS OrderCount
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate);

-- Transform CustomerName into uppercase and select customers whose names start with 'J'
SELECT * FROM Customers WHERE UPPER(CustomerName) LIKE 'J%';



--Lab 3: Data Transformation and Advanced Filtering

--Exercise 1: Advanced WHERE Clauses
-- Find orders made in the last quarter of any year (October to December)
SELECT * FROM Orders WHERE MONTH(OrderDate) BETWEEN 10 AND 12;


--Exercise 2: Aggregations with Conditional Logic
-- Calculate the total, average, minimum, and maximum prices for products, categorizing them into 'Expensive' and 'Affordable' based on their price
SELECT 
    CASE 
        WHEN Price >= 100 THEN 'Expensive' 
        ELSE 'Affordable' 
    END AS PriceCategory,
    COUNT(*) AS ProductCount,
    AVG(Price) AS AveragePrice,
    MIN(Price) AS MinPrice,
    MAX(Price) AS MaxPrice
FROM Products
GROUP BY 
    CASE 
        WHEN Price >= 100 THEN 'Expensive' 
        ELSE 'Affordable' 
    END;


--Exercise 3: CASE in SELECT Statements
-- Use a CASE statement to add a 'CustomerSegment' column categorizing customers based on the state they are from
SELECT 
    CustomerName, 
    State,
    CASE 
        WHEN State IN ('NY', 'CA', 'IL') THEN 'Major Market' 
        ELSE 'Other' 
    END AS CustomerSegment
FROM Customers;


--Exercise 4: Complex JOINs with Aggregates
-- Join Orders and Customers tables to find the total number of orders and total spending by state
SELECT 
    Customers.State, 
    COUNT(Orders.OrderID) AS NumberOfOrders, 
    SUM(Orders.TotalPrice) AS TotalSpending
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.State;


--Lab 4: Analytical Functions and Data Insights

--Exercise 1: Window Functions
-- Use ROW_NUMBER() to assign a rank to orders within each PaymentType by OrderDate
SELECT 
    OrderID, 
    PaymentType, 
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY PaymentType ORDER BY OrderDate) AS Rank
FROM Orders;


--Exercise 2: Conditional Aggregates with CASE
-- Count the number of 'High Value' and 'Low Value' orders by PaymentType
SELECT 
    PaymentType,
    SUM(CASE WHEN TotalPrice > 500 THEN 1 ELSE 0 END) AS HighValueOrders,
    SUM(CASE WHEN TotalPrice <= 500 THEN 1 ELSE 0 END) AS LowValueOrders
FROM Orders
GROUP BY PaymentType;


--Exercise 3: Using CASE with JOINs
-- Categorize each order line as 'Above Average' or 'Below Average' based on its price compared to the average price of its product
SELECT 
    OrderLines.OrderID, 
    OrderLines.ProductID, 
    OrderLines.PricePerUnit,
    CASE 
        WHEN OrderLines.PricePerUnit > Products.Price THEN 'Above Average' 
        ELSE 'Below Average' 
    END AS PriceComparison
FROM OrderLines
JOIN Products ON OrderLines.ProductID = Products.ProductID;


--Exercise 4: Pattern Matching for Customer Insights
-- Identify customers whose names contain 'John' or 'Jane' and categorize their location as 'Urban' if they are from 'NY' or 'CA', or 'Non-Urban' otherwise
SELECT 
    CustomerName, 
    State,
    CASE 
        WHEN State IN ('NY', 'CA') THEN 'Urban' 
        ELSE 'Non-Urban' 
    END AS LocationCategory
FROM Customers
WHERE CustomerName LIKE '%John%' OR CustomerName LIKE '%Jane%';





--Analyse de Types de Paiement
-- Sélectionnez le type de paiement et comptez le nombre total de commandes pour chaque type
SELECT PaymentType, COUNT(*) as cnt
FROM Orders o
GROUP BY PaymentType
ORDER BY PaymentType;

--Question d'affaire: Combien de commandes ont été effectuées avec chaque type de paiement?
--Importance pour un gestionnaire: Cette information aide à comprendre les préférences de paiement des clients, permettant d'optimiser les options de paiement.

--Analyse des Tranches de Prix des Commandes
-- Calculez le nombre de commandes dans différentes tranches de prix pour chaque type de paiement
SELECT PaymentType,
       SUM(CASE WHEN 0 <= TotalPrice AND TotalPrice < 10 THEN 1 ELSE 0 END) as cnt_0_10,
       SUM(CASE WHEN 10 <= TotalPrice AND TotalPrice < 100 THEN 1 ELSE 0 END) as cnt_10_100,
       SUM(CASE WHEN 100 <= TotalPrice AND TotalPrice < 1000 THEN 1 ELSE 0 END) as cnt_100_1000,
       SUM(CASE WHEN TotalPrice >= 1000 THEN 1 ELSE 0 END) as cnt_1000,
       COUNT(*) as cnt, SUM(TotalPrice) as revenue
FROM Orders
GROUP BY PaymentType
ORDER BY PaymentType;


--Question d'affaire: Quelle est la répartition des commandes par tranche de prix pour chaque type de paiement?
--Importance pour un gestionnaire: Comprendre la distribution des montants des commandes peut aider à cibler des promotions ou ajuster les stratégies de prix.


--Analyse des Commandes par Mois
-- Pour chaque type de paiement, calculez le nombre de commandes par mois pour l'année 2015
SELECT PaymentType,
       SUM(CASE WHEN MONTH(OrderDate) = 1 THEN 1 ELSE 0 END) as Jan,
       SUM(CASE WHEN MONTH(OrderDate) = 12 THEN 1 ELSE 0 END) as Dec
FROM Orders o
WHERE YEAR(OrderDate) = 2015
GROUP BY PaymentType
ORDER BY PaymentType;


--Question d'affaire: Combien de commandes de chaque type de paiement ont été effectuées chaque mois en 2015?
--Importance pour un gestionnaire: Identifier les tendances saisonnières des types de paiement peut informer sur la planification des ressources et des campagnes marketing.

--Moyenne des Prix des Commandes par Mois
-- Calculez le prix moyen des commandes pour chaque type de paiement par mois pour l'année 2015
SELECT PaymentType,
       AVG(CASE WHEN MONTH(OrderDate) = 1 THEN TotalPrice END) as Jan,
       ...
       AVG(CASE WHEN MONTH(OrderDate) = 12 THEN TotalPrice END) as Dec
FROM Orders o
WHERE YEAR(OrderDate) = 2015
GROUP BY PaymentType
ORDER BY PaymentType;



SELECT
    OrderDetail.OrderID,
    OrderDetail.CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OrderDetail.Products, ',', n.n), ',', -1)) AS Product
FROM
    OrderDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5
) n
WHERE
    LENGTH(OrderDetail.Products) - LENGTH(REPLACE(OrderDetail.Products, ',', '')) >= n - 1
ORDER BY
    OrderDetail.OrderID;

Question 2

-- Create a new table for Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(255)
);

-- Insert distinct customer names into the Customers table
INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName
FROM OrderDetails;

-- Create a new table for Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert order information into the Orders table
INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT od.OrderID, c.CustomerID
FROM OrderDetails od
JOIN Customers c ON od.CustomerName = c.CustomerName;

-- Create a new table for OrderItems
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert order item details into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Final result (showing the transformed tables and data):

-- Customers Table
SELECT * FROM Customers;

-- Orders Table
SELECT * FROM Orders;

-- OrderItems Table
SELECT * FROM OrderItems;

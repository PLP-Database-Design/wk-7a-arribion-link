-- answers.sql

-- (Optional) Create and populate a representation of the *original* non-1NF table (for demonstration):
DROP TABLE IF EXISTS ProductDetail_Non1NF;
CREATE TABLE ProductDetail_Non1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255) -- Stores comma-separated values
);

INSERT INTO ProductDetail_Non1NF (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Create the 1NF table structure
DROP TABLE IF EXISTS ProductDetail_1NF;
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100), -- Each row now holds a single product
    -- Optionally define a primary key, e.g., PRIMARY KEY (OrderID, Product)
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Question 2: Achieving 2NF (Second Normal Form)
-- SQL Query to represent the tables in 2NF:
-- First, create and populate the original 1NF table (for demonstration).
DROP TABLE IF EXISTS OrderDetails_1NF;
CREATE TABLE OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product) -- Define the composite key
);

INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create the first 2NF table: Orders (removes partial dependency of CustomerName)
DROP TABLE IF EXISTS Orders_2NF;
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY, -- Primary key
    CustomerName VARCHAR(100)  -- Depends only on OrderID
);

-- Populate the Orders_2NF table using distinct values from the original table
INSERT INTO Orders_2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails_1NF;

-- Create the second 2NF table: OrderItems
DROP TABLE IF EXISTS OrderItems_2NF;
CREATE TABLE OrderItems_2NF (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product), -- Composite primary key
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID) -- Foreign key linking back to Orders
);

-- Populate the OrderItems_2NF table with data fully dependent on the composite key
INSERT INTO OrderItems_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails_1NF;


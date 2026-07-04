-- ====================================================================
-- E-COMMERCE DATABASE SCHEMA & SAMPLE DATA
-- MySQL 8.0 Compliant
-- ====================================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS EcommerceDB;
USE EcommerceDB;

-- --------------------------------------------------------------------
-- 1. DDL: Table Definitions
-- --------------------------------------------------------------------

-- Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    ParentCategoryID INT NULL,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID) ON DELETE SET NULL
);

-- Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID INT NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- OrderItems Table (Junction Table)
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- --------------------------------------------------------------------
-- 2. DML: Sample Data Injection
-- --------------------------------------------------------------------

-- Insert Users
INSERT INTO Users (FirstName, LastName, Email) VALUES
('Alice', 'Smith', 'alice@example.com'),
('Bob', 'Johnson', 'bob@example.com'),
('Charlie', 'Brown', 'charlie@example.com'),
('Diana', 'Prince', 'diana@example.com');

-- Insert Categories
INSERT INTO Categories (CategoryName, ParentCategoryID) VALUES
('Electronics', NULL),       -- 1
('Computers', 1),            -- 2
('Smartphones', 1),          -- 3
('Home Appliances', NULL),   -- 4
('Kitchen', 4);              -- 5

-- Insert Products
INSERT INTO Products (CategoryID, ProductName, Price, StockQuantity) VALUES
(2, 'MacBook Pro 16', 2499.99, 10),
(2, 'Dell XPS 15', 1899.50, 15),
(3, 'iPhone 15 Pro', 1099.00, 50),
(3, 'Samsung Galaxy S24', 999.00, 40),
(5, 'Vitamix Blender', 349.00, 20),
(5, 'Air Fryer', 129.99, 100);

-- Insert Orders
INSERT INTO Orders (UserID, OrderDate, TotalAmount, Status) VALUES
(1, '2023-10-01 10:00:00', 1099.00, 'Delivered'),
(2, '2023-10-05 14:30:00', 2629.98, 'Shipped'),
(1, '2023-10-10 09:15:00', 349.00, 'Pending'),
(3, '2023-10-12 16:45:00', 999.00, 'Delivered');

-- Insert OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 3, 1, 1099.00),                 -- Alice bought an iPhone
(2, 1, 1, 2499.99),                 -- Bob bought a MacBook
(2, 6, 1, 129.99),                  -- Bob also bought an Air Fryer
(3, 5, 1, 349.00),                  -- Alice bought a Blender
(4, 4, 1, 999.00);                  -- Charlie bought a Samsung

-- Insert Reviews
INSERT INTO Reviews (ProductID, UserID, Rating, Comment) VALUES
(3, 1, 5, 'Amazing phone, battery life is great!'),
(1, 2, 4, 'Very powerful, but gets a bit hot.'),
(5, 1, 5, 'Best blender I have ever owned.');

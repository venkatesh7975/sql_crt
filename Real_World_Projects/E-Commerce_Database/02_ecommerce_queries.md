# E-Commerce Database: Real-World Reporting Queries

This document contains 10 realistic business intelligence (BI) queries commonly requested by Product Managers and Data Analysts for an E-Commerce platform.

---

### 1. Total Revenue Generated
**Scenario:** The executive team wants to know the total amount of money the platform has successfully generated from 'Delivered' orders.
```sql
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders
WHERE Status = 'Delivered';
```

### 2. Top 5 Best-Selling Products by Quantity
**Scenario:** The inventory manager needs to know which products move off the shelves the fastest.
```sql
SELECT 
    p.ProductName, 
    SUM(oi.Quantity) AS TotalUnitsSold
FROM Products p
INNER JOIN OrderItems oi ON p.ProductID = oi.ProductID
INNER JOIN Orders o ON oi.OrderID = o.OrderID
WHERE o.Status IN ('Shipped', 'Delivered')
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalUnitsSold DESC
LIMIT 5;
```

### 3. High-Value Customers (Customer Lifetime Value - LTV)
**Scenario:** Marketing wants to send a "VIP" discount code to the users who have spent the most money historically.
```sql
SELECT 
    u.UserID,
    CONCAT(u.FirstName, ' ', u.LastName) AS CustomerName,
    SUM(o.TotalAmount) AS LifetimeValue,
    COUNT(o.OrderID) AS TotalOrdersPlaced
FROM Users u
INNER JOIN Orders o ON u.UserID = o.UserID
WHERE o.Status != 'Cancelled'
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY LifetimeValue DESC;
```

### 4. Products with Low Stock (Reorder Alert)
**Scenario:** An automated CRON job runs daily to alert warehouse managers of products dipping below 15 units.
```sql
SELECT 
    ProductID, 
    ProductName, 
    StockQuantity 
FROM Products
WHERE StockQuantity < 15
ORDER BY StockQuantity ASC;
```

### 5. Average Product Rating per Category
**Scenario:** The catalog team wants to know which categories have the highest user satisfaction.
```sql
SELECT 
    c.CategoryName,
    ROUND(AVG(r.Rating), 1) AS AverageRating,
    COUNT(r.ReviewID) AS TotalReviews
FROM Categories c
INNER JOIN Products p ON c.CategoryID = p.CategoryID
INNER JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY AverageRating DESC;
```

### 6. Cart Abandonment vs Completed Orders
**Scenario:** Assuming 'Pending' status means payment hasn't cleared or the item is just sitting, compare it against completed statuses.
```sql
SELECT 
    Status,
    COUNT(OrderID) AS OrderCount,
    SUM(TotalAmount) AS FinancialValue
FROM Orders
GROUP BY Status
ORDER BY FinancialValue DESC;
```

### 7. Monthly Sales Trend (Time-Series)
**Scenario:** The finance team needs a breakdown of sales month-over-month.
```sql
SELECT 
    DATE_FORMAT(OrderDate, '%Y-%m') AS SalesMonth,
    SUM(TotalAmount) AS TotalSales,
    COUNT(OrderID) AS NumberOfOrders
FROM Orders
WHERE Status != 'Cancelled'
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY SalesMonth ASC;
```

### 8. Find Customers Who Ordered Specific Categories (Cross-Selling)
**Scenario:** Marketing wants the emails of everyone who bought 'Smartphones' so they can email them ads for phone cases.
```sql
SELECT DISTINCT u.Email
FROM Users u
INNER JOIN Orders o ON u.UserID = o.UserID
INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
INNER JOIN Products p ON oi.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Smartphones';
```

### 9. Identify Unsold Products (Dead Stock)
**Scenario:** Find products that have *never* been ordered so we can put them on clearance.
```sql
SELECT p.ProductName, p.Price
FROM Products p
LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
WHERE oi.OrderItemID IS NULL;
```

### 10. Complex: Moving Average / Rolling Revenue
**Scenario:** Calculate the cumulative revenue generated over time using Window Functions.
```sql
SELECT 
    DATE(OrderDate) AS OrderDay,
    SUM(TotalAmount) AS DailyRevenue,
    SUM(SUM(TotalAmount)) OVER (ORDER BY DATE(OrderDate)) AS CumulativeRevenue
FROM Orders
WHERE Status != 'Cancelled'
GROUP BY DATE(OrderDate)
ORDER BY OrderDay;
```

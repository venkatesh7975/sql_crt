-- =================================================================================
-- MySQL JOINS Explained with Examples
-- =================================================================================
-- A JOIN is used to combine rows from two or more tables based on a related column.

-- ---------------------------------------------------------------------------------
-- 0. SETUP: Sample Tables
-- ---------------------------------------------------------------------------------

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50)
);

INSERT INTO orders (order_id, customer_id, product) VALUES
(101, 1, 'Laptop'),
(102, 1, 'Mouse'),
(103, 2, 'Keyboard'),
(104, 5, 'Mobile');

-- Notice:
-- * Alice has 2 orders
-- * Bob has 1 order
-- * Charlie and David have no orders
-- * Order 104 belongs to customer 5, who doesn't exist in the customers table.

-- ---------------------------------------------------------------------------------
-- 1. INNER JOIN
-- ---------------------------------------------------------------------------------
-- Returns only the matching records from both tables.

SELECT c.customer_name, o.product
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

-- Explanation:
-- Charlie → No order ❌
-- David → No order ❌
-- Order 104 → No matching customer ❌
-- Only matching rows are returned.

-- ---------------------------------------------------------------------------------
-- 2. LEFT JOIN
-- ---------------------------------------------------------------------------------
-- Returns all rows from the left table and matching rows from the right table.
-- If no match exists, the right-side columns become NULL.

SELECT c.customer_name, o.product
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Explanation:
-- Every customer is shown.
-- Customers without orders get NULL.

-- ---------------------------------------------------------------------------------
-- 3. RIGHT JOIN
-- ---------------------------------------------------------------------------------
-- Returns all rows from the right table and matching rows from the left table.

SELECT c.customer_name, o.product
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- Explanation:
-- Order 104 belongs to customer_id 5.
-- Since customer 5 doesn't exist, Customer becomes NULL.

-- ---------------------------------------------------------------------------------
-- 4. FULL OUTER JOIN
-- ---------------------------------------------------------------------------------
-- MySQL does NOT support FULL OUTER JOIN directly.
-- We simulate it using UNION.

SELECT c.customer_name, o.product
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
UNION
SELECT c.customer_name, o.product
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- Explanation:
-- Returns everything from both tables.

-- ---------------------------------------------------------------------------------
-- 5. CROSS JOIN
-- ---------------------------------------------------------------------------------
-- Returns the Cartesian Product.
-- Every row in table A joins with every row in table B.

SELECT customer_name, product
FROM customers
CROSS JOIN orders;

-- Output: 4 customers × 4 orders = 16 rows

-- ---------------------------------------------------------------------------------
-- 6. SELF JOIN
-- ---------------------------------------------------------------------------------
-- A table joins with itself.
-- Useful for: Employee → Manager, Parent → Child, Friend Relationships

-- Employee Table Setup
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

INSERT INTO employees (emp_id, name, manager_id) VALUES
(1, 'John', NULL),
(2, 'Alice', 1),
(3, 'Bob', 1),
(4, 'David', 2);

-- Query
SELECT e.name AS Employee, m.name AS Manager
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id;

-- =================================================================================
-- INTERVIEW QUESTIONS
-- =================================================================================
-- 1. What is a JOIN?
-- 2. Difference between INNER JOIN and LEFT JOIN?
-- 3. Difference between LEFT JOIN and RIGHT JOIN?
-- 4. Does MySQL support FULL OUTER JOIN?
-- 5. How do you simulate a FULL OUTER JOIN in MySQL?
-- 6. What is a CROSS JOIN, and when would you use it?
-- 7. What is a SELF JOIN? Give a real-world example.
-- 8. What happens if there are duplicate values in the join column?
-- 9. What is the difference between ON and WHERE in JOINs?
-- 10. How do indexes on join columns improve JOIN performance?

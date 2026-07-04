# MySQL 8.0 Comprehensive Cheat Sheet

---

## Data Definition Language (DDL)

```sql
-- Create Database
CREATE DATABASE IF NOT EXISTS app_db;
USE app_db;

-- Create Table with Constraints
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10, 2) DEFAULT 0.00,
    department_id INT,
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

-- Alter Table
ALTER TABLE employees ADD COLUMN status VARCHAR(20) DEFAULT 'active';
ALTER TABLE employees DROP COLUMN status;
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12, 2);

-- Drop/Truncate
DROP TABLE employees;
TRUNCATE TABLE employees; -- Fast, deletes all rows, resets AUTO_INCREMENT
```

---

## Data Manipulation Language (DML)

```sql
-- Insert
INSERT INTO employees (first_name, last_name, email, salary) 
VALUES ('John', 'Doe', 'john@test.com', 80000);

-- Update
UPDATE employees 
SET salary = salary * 1.10 
WHERE department_id = 1;

-- Delete
DELETE FROM employees WHERE hire_date < '2020-01-01';
```

---

## Queries (DQL)

```sql
-- The Order of Execution
SELECT           -- 5. Projection / Aliasing
FROM             -- 1. Table Selection & Joins
WHERE            -- 2. Row Filtering
GROUP BY         -- 3. Aggregation (Bucketing)
HAVING           -- 4. Aggregate Filtering
ORDER BY         -- 6. Sorting
LIMIT / OFFSET;  -- 7. Pagination
```

### Filtering & Sorting
```sql
SELECT * FROM users 
WHERE age BETWEEN 18 AND 35
  AND last_name LIKE 'S%' -- Starts with S (SARGable)
  AND email IS NOT NULL
ORDER BY age DESC, last_name ASC
LIMIT 10 OFFSET 20; -- Page 3
```

### Joins
```sql
SELECT u.name, o.total 
FROM users u
INNER JOIN orders o ON u.id = o.user_id; -- Match only

LEFT JOIN orders o ON u.id = o.user_id; -- Keep all users
RIGHT JOIN orders o ON u.id = o.user_id; -- Keep all orders
-- For FULL OUTER, UNION a LEFT and a RIGHT join.
```

### Aggregation & Grouping
```sql
SELECT 
    department, 
    COUNT(*) AS head_count,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
WHERE status = 'active'
GROUP BY department
HAVING COUNT(*) > 5;
```

---

## Advanced Functions

### CASE Statement (Conditional Aggregation)
```sql
SELECT 
    department,
    SUM(CASE WHEN role = 'Manager' THEN salary ELSE 0 END) AS manager_payroll,
    SUM(CASE WHEN role = 'Dev' THEN salary ELSE 0 END) AS dev_payroll
FROM employees
GROUP BY department;
```

### Common Table Expressions (CTEs)
```sql
WITH HighEarners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT department, COUNT(*) FROM HighEarners GROUP BY department;
```

### Window Functions
```sql
SELECT 
    name, 
    department, 
    salary,
    -- Ranking
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank_in_dept,
    -- Running Total
    SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) AS running_payroll,
    -- Lags/Leads
    LAG(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS prev_hire_salary
FROM employees;
```

---

## Operations & Optimization

### Set Operations
```sql
SELECT email FROM table_a
UNION ALL    -- Keep duplicates (Fast)
UNION        -- Remove duplicates (Slow)
INTERSECT    -- Overlap only (MySQL 8.0+)
EXCEPT       -- Table A minus Table B (MySQL 8.0+)
SELECT email FROM table_b;
```

### Indexing
```sql
CREATE INDEX idx_email ON users(email);
EXPLAIN SELECT * FROM users WHERE email = 'test@test.com'; 
-- Look for 'type: ref' instead of 'type: ALL'
```

### Transactions
```sql
BEGIN;
UPDATE accounts SET bal = bal - 100 WHERE id = 1;
UPDATE accounts SET bal = bal + 100 WHERE id = 2;
COMMIT; -- Or ROLLBACK; if error
```

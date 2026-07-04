# Core Syntax Cheat Sheet (DDL, DML, DQL)

---

## 1. Data Definition Language (DDL)
Commands used to define or modify the structure of database objects (tables, databases, views).
*Note: In MySQL, DDL statements automatically commit and cannot be rolled back.*

### Database Operations
```sql
CREATE DATABASE company_db;
DROP DATABASE IF EXISTS company_db;
USE company_db;
```

### Table Operations
```sql
-- Creating a table with standard constraints
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

-- Modifying a table
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);
ALTER TABLE employees DROP COLUMN phone;
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12, 2);

-- Dropping and Truncating
DROP TABLE employees;       -- Completely deletes table and data
TRUNCATE TABLE employees;   -- Fast delete of all rows, resets AUTO_INCREMENT, keeps structure
```

---

## 2. Data Manipulation Language (DML)
Commands used to manipulate the data *inside* the tables.
*Note: DML statements can be rolled back in a transaction.*

### Insert
```sql
-- Insert a single row
INSERT INTO employees (first_name, last_name, email) 
VALUES ('John', 'Doe', 'john@test.com');

-- Insert multiple rows
INSERT INTO employees (first_name, last_name, email) 
VALUES 
  ('Alice', 'Smith', 'alice@test.com'),
  ('Bob', 'Jones', 'bob@test.com');
```

### Update
```sql
-- Give a 10% raise to everyone in the IT department
UPDATE employees 
SET salary = salary * 1.10 
WHERE department_id = 1; 
-- DANGER: Forgetting the WHERE clause updates every row in the table!
```

### Delete
```sql
-- Delete specific rows
DELETE FROM employees 
WHERE hire_date < '2020-01-01';
-- DANGER: Forgetting the WHERE clause deletes all rows in the table!
```

---

## 3. Data Query Language (DQL)
The command used to retrieve data.

### The Order of Execution (Must Memorize)
When you write a query, you write it like this, but the database executes it in the numbered order below:
```sql
SELECT           -- 5. Projection / Aliasing
FROM             -- 1. Table Selection & Joins
WHERE            -- 2. Row Filtering
GROUP BY         -- 3. Aggregation (Bucketing)
HAVING           -- 4. Aggregate Filtering
ORDER BY         -- 6. Sorting
LIMIT / OFFSET;  -- 7. Pagination
```

### Basic Filtering (WHERE)
```sql
SELECT first_name, last_name, salary
FROM employees
WHERE salary >= 50000 
  AND salary <= 100000
  -- OR: WHERE salary BETWEEN 50000 AND 100000
  AND department_id IN (1, 2, 3)
  AND last_name LIKE 'S%'     -- SARGable: Starts with 'S'
  AND email IS NOT NULL;      -- You MUST use IS NOT NULL, you cannot use != NULL
```

### Basic Sorting and Pagination
```sql
SELECT first_name, salary
FROM employees
ORDER BY salary DESC, first_name ASC
LIMIT 10 OFFSET 20; -- Skips the first 20 rows, returns the next 10 (Page 3)
```

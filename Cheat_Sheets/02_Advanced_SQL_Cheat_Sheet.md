# Advanced SQL Cheat Sheet

---

## 1. Joins (Combining Data)

Always use table aliases (`users u`, `orders o`) when joining tables.

```sql
-- INNER JOIN (Default): Returns only rows with a match in BOTH tables
SELECT u.name, o.order_total 
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- LEFT JOIN: Returns ALL rows from the Left table (users). Missing matches on the right are NULL.
SELECT u.name, o.order_total 
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- FIND ORPHANED RECORDS: Uses a LEFT JOIN to find missing data
SELECT u.name 
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL; -- The user has no orders

-- SELF JOIN: Joining a table to itself (Requires two different aliases)
SELECT worker.name AS worker_name, boss.name AS boss_name
FROM employees worker
LEFT JOIN employees boss ON worker.manager_id = boss.id;
```

---

## 2. Aggregation & Grouping

**The Golden Rule:** Any column in the `SELECT` clause that is not wrapped in an aggregate function MUST be included in the `GROUP BY` clause.

```sql
SELECT 
    department, 
    COUNT(*) AS total_employees,           -- Counts all rows (including NULLs)
    COUNT(phone_number) AS total_phones,   -- Counts rows where phone is NOT NULL
    ROUND(AVG(salary), 2) AS avg_salary,
    MAX(hire_date) AS newest_employee
FROM employees
WHERE status = 'active'                    -- Filters rows BEFORE grouping
GROUP BY department
HAVING COUNT(*) > 5;                       -- Filters groups AFTER grouping
```

---

## 3. Conditional Aggregation (CASE Statements)

Useful for creating Pivot Tables or counting distinct categories within a single row.

```sql
SELECT 
    department,
    -- Simple CASE for categorizing
    CASE 
        WHEN AVG(salary) > 100000 THEN 'High Paying'
        ELSE 'Normal'
    END AS dept_tier,
    
    -- Conditional SUM (Pivoting)
    SUM(CASE WHEN role = 'Manager' THEN salary ELSE 0 END) AS manager_payroll,
    SUM(CASE WHEN role = 'Dev' THEN salary ELSE 0 END) AS dev_payroll,
    
    -- Conditional COUNT (Use ELSE NULL, not ELSE 0)
    COUNT(CASE WHEN role = 'Intern' THEN id ELSE NULL END) AS total_interns
FROM employees
GROUP BY department;
```

---

## 4. Window Functions

Window functions perform calculations across related rows *without collapsing* the result set like `GROUP BY` does.

```sql
SELECT 
    name, 
    department, 
    salary,
    
    -- 1. Rankings
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS strict_rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank_with_ties,
    
    -- 2. Aggregations (Keeps all individual rows!)
    SUM(salary) OVER(PARTITION BY department) AS total_dept_salary,
    (salary / SUM(salary) OVER(PARTITION BY department)) * 100 AS pct_of_dept_payroll,
    
    -- 3. Running Totals (Cumulative Sum)
    SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) AS running_payroll,
    
    -- 4. Value Functions (Lags/Leads)
    LAG(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS prev_hire_salary,
    LEAD(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS next_hire_salary
    
FROM employees;
```

---

## 5. Common Table Expressions (CTEs)

Use CTEs instead of deeply nested subqueries to improve readability. They act as temporary views for the duration of the query.

```sql
WITH HighEarners AS (
    SELECT id, department, salary 
    FROM employees 
    WHERE salary > 100000
),
DeptTotals AS (
    SELECT department, COUNT(*) AS total_high_earners
    FROM HighEarners  -- CTEs can query CTEs defined above them!
    GROUP BY department
)
SELECT * FROM DeptTotals WHERE total_high_earners > 5;
```

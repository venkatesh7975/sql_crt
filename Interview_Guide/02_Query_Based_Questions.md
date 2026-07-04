# Query-Based Interview Questions

---

## 1. Find the Nth Highest Salary
**Question:** Write a query to find the 2nd highest salary in the `employees` table. If there is no 2nd highest salary, return NULL.

**The LIMIT approach (Easy):**
```sql
SELECT (
    SELECT DISTINCT salary 
    FROM employees 
    ORDER BY salary DESC 
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```

**The DENSE_RANK approach (Professional / Per Category):**
```sql
WITH RankedSalaries AS (
    SELECT 
        salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) as rnk
    FROM employees
)
SELECT salary FROM RankedSalaries WHERE rnk = 2 LIMIT 1;
```

---

## 2. Find Orphaned Records
**Question:** We have a `customers` table and an `orders` table. Find all customers who have NEVER placed an order.

**The LEFT JOIN approach:**
```sql
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;
```

**The NOT EXISTS approach:**
```sql
SELECT customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.id
);
```

---

## 3. The Pivot Table (Rows to Columns)
**Question:** We have a `sales` table with `department` and `month`. Write a query to return one row per department, with columns for Jan_Revenue, Feb_Revenue, and Mar_Revenue.

**The Conditional Aggregation approach:**
```sql
SELECT 
    department,
    SUM(CASE WHEN month = 'Jan' THEN revenue ELSE 0 END) AS Jan_Revenue,
    SUM(CASE WHEN month = 'Feb' THEN revenue ELSE 0 END) AS Feb_Revenue,
    SUM(CASE WHEN month = 'Mar' THEN revenue ELSE 0 END) AS Mar_Revenue
FROM sales
GROUP BY department;
```

---

## 4. Calculating Year-Over-Year Growth
**Question:** Calculate the YoY percentage revenue growth for each year.

**The LAG() approach:**
```sql
WITH YearlyData AS (
    SELECT 
        sales_year,
        SUM(revenue) AS current_rev
    FROM sales
    GROUP BY sales_year
)
SELECT 
    sales_year,
    current_rev,
    LAG(current_rev, 1) OVER(ORDER BY sales_year) AS prev_rev,
    ROUND(((current_rev - LAG(current_rev, 1) OVER(ORDER BY sales_year)) / 
            LAG(current_rev, 1) OVER(ORDER BY sales_year)) * 100, 2) AS yoy_growth_pct
FROM YearlyData;
```

---

## 5. Identifying Duplicates
**Question:** Find all duplicate email addresses in the `users` table.

**The HAVING approach:**
```sql
SELECT email, COUNT(*)
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

**Question:** Now, *delete* all duplicate emails, keeping only the one with the lowest `id`.

**The Self-Join DELETE approach (MySQL specific):**
```sql
DELETE u1 FROM users u1
JOIN users u2 
  ON u1.email = u2.email 
  AND u1.id > u2.id;
```

---

## 6. The Rolling Average
**Question:** Calculate a 7-day rolling average for daily sales.

**The Window Frame approach:**
```sql
SELECT 
    sales_date,
    revenue,
    AVG(revenue) OVER(
        ORDER BY sales_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS 7_day_moving_avg
FROM daily_sales;
```

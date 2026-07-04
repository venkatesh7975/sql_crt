# Subqueries in SELECT, FROM, and WHERE

---

## 1. Where can you put a Subquery?

We have already seen subqueries in the `WHERE` clause. But they are incredibly versatile and can be placed in almost any major clause of a SQL statement.

---

## 2. Subqueries in the WHERE Clause

This is the most common placement. It is used for dynamic filtering.

```sql
SELECT name FROM products 
WHERE price = (SELECT MAX(price) FROM products);
```

---

## 3. Subqueries in the SELECT Clause (Projection)

You can place a Scalar Subquery directly in the `SELECT` clause to act as a virtual column.
This is almost always a **Correlated Subquery**, because you usually want to calculate a value related to the current row.

### Example: Comparing individual salary to company max
```sql
SELECT 
    first_name,
    salary,
    (SELECT MAX(salary) FROM employees) AS company_max_salary,
    ((salary / (SELECT MAX(salary) FROM employees)) * 100) AS pct_of_max
FROM employees;
```

### Example: Counting related records
```sql
SELECT 
    c.customer_name,
    (
        SELECT COUNT(*) 
        FROM orders o 
        WHERE o.customer_id = c.id
    ) AS total_orders_placed
FROM customers c;
```
*(Warning: Placing Correlated Subqueries in the SELECT clause is a notorious performance killer on large tables, as it executes per-row. A `LEFT JOIN` with a `GROUP BY` is vastly superior for this).*

---

## 4. Subqueries in the FROM Clause (Derived Tables)

This is one of the most powerful concepts in advanced SQL. 
When you put a subquery in the `FROM` clause, you are essentially generating a temporary, on-the-fly table (called a **Derived Table**) that only exists for the duration of the query.

You can then query this temporary table exactly as if it were a real table in the database!

### The Golden Rule of Derived Tables
**In MySQL, every single subquery in a `FROM` clause MUST be given an Alias.** If you forget the alias, the query will crash.

### Example: Aggregating an Aggregation
Imagine you want to find the "Average of the Totals". You can't write `AVG(SUM(revenue))` in SQL; nested aggregates are illegal. 

You must use a Derived Table!
1. Calculate the sums in the inner query.
2. Calculate the average of those sums in the outer query.

```sql
SELECT AVG(daily_total) AS average_daily_revenue
FROM (
    -- This inner query generates a temporary table of daily sums
    SELECT order_date, SUM(order_total) AS daily_total
    FROM orders
    GROUP BY order_date
) AS daily_sales_table; -- THIS ALIAS IS MANDATORY!
```

---

## 5. Interview Tips
*   **Nested Aggregates:** If an interviewer asks you to "find the average number of orders placed per user", you cannot write `AVG(COUNT(orders))`. You must immediately write a Derived Table in the `FROM` clause. The inner query does the `COUNT` per user, the outer query does the `AVG` on the resulting temporary table.
*   **The Mandatory Alias:** Forgetting the alias on a `FROM` clause subquery is the easiest way to fail a live coding interview. Always write `) AS temp_table` immediately after closing the parentheses!

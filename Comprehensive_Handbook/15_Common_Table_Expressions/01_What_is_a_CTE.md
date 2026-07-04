# What is a CTE?

---

## 1. The Problem with Subqueries

In the previous chapter, we learned how to put subqueries inside the `FROM` clause to create Derived Tables. 
While powerful, this creates two massive problems:

1.  **Readability (The "Inception" Problem):** Deeply nested subqueries are famously difficult to read. Because the inner query executes first, you have to read the SQL code from the inside-out, starting in the middle of the code block.
2.  **Reusability:** If you need to use that exact same Derived Table three different times in your query (e.g., joining it to itself), you have to copy/paste the entire subquery block three times, bloating your code.

---

## 2. Enter the Common Table Expression (CTE)

A **CTE** (Common Table Expression) is a named temporary result set that exists only for the duration of the query. 
It solves both problems of Derived Tables by moving the subquery to the very top of the script using the **`WITH`** clause.

CTEs make your code read cleanly from top to bottom.

---

## 3. Basic Syntax

You define a CTE using the `WITH` keyword, give it a name, and put the query inside parentheses using `AS`.
Then, you write your main `SELECT` query below it, treating the CTE exactly like a real table.

```sql
WITH daily_sales AS (
    SELECT order_date, SUM(order_total) AS daily_total
    FROM orders
    GROUP BY order_date
)
-- Now we query the CTE we just defined!
SELECT AVG(daily_total) AS avg_daily_revenue
FROM daily_sales;
```
*(Notice how much easier this is to read than a nested `FROM` subquery!)*

---

## 4. Multiple CTEs

You can define as many CTEs as you want at the top of your script. You only type the word `WITH` once, and separate the CTEs with commas.
Even better, **CTEs can query other CTEs defined above them!**

```sql
WITH regional_sales AS (
    SELECT region, SUM(revenue) as total_rev
    FROM sales
    GROUP BY region
),
top_regions AS (
    -- This CTE queries the CTE defined right above it!
    SELECT region 
    FROM regional_sales 
    WHERE total_rev > 1000000
)
-- Main Query
SELECT * 
FROM employees e
JOIN top_regions t ON e.region = t.region;
```

---

## 5. CTEs vs Subqueries (Performance)

In modern database engines (like MySQL 8.0+ and PostgreSQL), there is generally **no performance difference** between a CTE and a Subquery. The database optimizer breaks them both down into the exact same execution plan.

Therefore, you should almost **always prefer CTEs over Subqueries** purely for readability and maintainability.

---

## 6. Interview Tips
*   **Code Organization:** If an interviewer asks you to write a complex query on a whiteboard or in an IDE, start by writing a CTE. It shows that you write modern, maintainable, enterprise-grade SQL. Subqueries are considered "old school" for complex data transformation.
*   **The Scope:** "How long does a CTE live?"
    *   **Answer:** "A CTE only exists for the duration of the single execution of the query. As soon as the final semicolon `;` is reached, the CTE vanishes from memory. It is not a permanent View."

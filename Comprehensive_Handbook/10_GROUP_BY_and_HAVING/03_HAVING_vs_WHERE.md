# HAVING vs WHERE

---

## 1. The Filtering Dilemma

We know that the `WHERE` clause is used to filter rows.
But what if we want to filter rows based on the result of an Aggregate Function?

**Scenario:** We have a `sales` table. We want to find the total revenue per department, **BUT we only want to see departments that made more than $100,000.**

**The Intuitive (But Wrong) Approach:**
```sql
-- THIS WILL CRASH!
SELECT department, SUM(revenue)
FROM sales
WHERE SUM(revenue) > 100000
GROUP BY department;
```

### Why does WHERE fail here?
Because of the SQL Execution Order. 
The database runs the `WHERE` clause **BEFORE** it runs the `GROUP BY` clause. 
When the database is executing the `WHERE` clause, it is evaluating rows one-by-one. It hasn't created the department buckets yet, so it has absolutely no idea what the `SUM(revenue)` for the department is!

---

## 2. Enter the HAVING Clause

To solve this problem, SQL introduced the `HAVING` clause. 

The `HAVING` clause is exactly like the `WHERE` clause, but it executes **AFTER** the `GROUP BY` clause. Because it runs after the buckets are created and the math is done, it is allowed to filter based on Aggregate Functions.

**The Correct Approach:**
```sql
SELECT department, SUM(revenue)
FROM sales
GROUP BY department
HAVING SUM(revenue) > 100000;
```

---

## 3. Combining WHERE and HAVING

You can absolutely use both `WHERE` and `HAVING` in the exact same query. They serve two different purposes:
1.  **WHERE:** Filters the raw data *before* it gets put into buckets.
2.  **HAVING:** Filters the buckets *after* the math is done.

**Scenario:** We want to find the total revenue per department, **excluding refunds**, and we only want to see departments that made **more than $100,000**.

```sql
SELECT department, SUM(revenue) AS total_revenue
FROM sales
WHERE status != 'refunded'       -- 1. Filter raw rows first
GROUP BY department              -- 2. Create the buckets
HAVING SUM(revenue) > 100000;    -- 3. Filter the aggregated buckets
```

*(Note: While some databases allow you to use aliases in the HAVING clause like `HAVING total_revenue > 100000`, it is safer and more universally standard to repeat the aggregate function: `HAVING SUM(revenue) > 100000`).*

---

## 4. Interview Tips
*   **The Most Common Question:** "What is the difference between WHERE and HAVING?" This is asked in almost every single junior/mid-level SQL interview.
    *   **The Perfect Answer:** "`WHERE` filters individual rows *before* aggregation occurs. `HAVING` filters the grouped results *after* aggregation occurs. You cannot use aggregate functions like `SUM()` or `COUNT()` in a `WHERE` clause; you must use `HAVING`."
*   **Performance Optimization:** Could you put all your filtering in the `HAVING` clause? Yes, technically `HAVING status != 'refunded'` would work in some dialects. But it's a terrible idea. You should always use `WHERE` to filter out as much junk data as possible *before* making the database do the heavy lifting of grouping and summing.

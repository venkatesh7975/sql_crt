# Scenario-Based Interview Questions

---

## 1. Optimizing a Slow Query
**Scenario:** A junior developer wrote a query that takes 45 seconds to run: 
`SELECT * FROM users WHERE YEAR(created_at) = 2023 AND last_name LIKE '%son%';`
How do you optimize this?

**Your Answer:**
1.  **Analyze the Execution Plan:** I would prepend `EXPLAIN` to the query to verify it is doing a Full Table Scan (`type: ALL`).
2.  **Fix Non-SARGable Conditions:** The query currently breaks indexes in two ways. First, it wraps the `created_at` column in a function (`YEAR`). I would rewrite this to: `created_at >= '2023-01-01' AND created_at < '2024-01-01'`. Second, it uses a leading wildcard in the `LIKE` clause (`%son%`). If business logic permits, I would change this to `'son%'`. If we *must* search for strings in the middle of names, a B-Tree index won't help; we might need a Full-Text Search index.
3.  **Add Indexes:** After making the `created_at` clause SARGable, I would ensure there is an index on `created_at`.
4.  **Avoid SELECT *:** I would change `SELECT *` to only fetch the exact columns needed by the application to reduce network I/O and memory usage.

---

## 2. The Fan-Out Trap (Cartesian Explosion)
**Scenario:** You write a query to find the total revenue of a user, and you decide to `LEFT JOIN` their website visits in the same query. Suddenly, your revenue numbers are 10x higher than they should be. What happened?

**Your Answer:**
1.  **The Diagnosis:** This is the Fan-Out Trap (Cartesian Explosion). By joining two different "One-to-Many" tables (Orders and Visits) to the root User table, the database multiplied the rows together. If the user had 2 orders and 5 visits, the join created 10 rows. When `SUM()` ran on the revenue, it added the same order multiple times.
2.  **The Fix:** I must aggregate the data *before* joining. I would write a CTE or Subquery that groups by User ID and calculates the `SUM` of revenue. I would write a second CTE that counts the visits. Then, I would `LEFT JOIN` those two aggregated, 1-to-1 result sets back to the User table.

---

## 3. Handling NULLs in Reporting
**Scenario:** The finance team is furious. The query `SELECT AVG(bonus) FROM employees` is reporting that the average bonus is $5,000, but they know for a fact the real average is closer to $1,000. Why is the database lying?

**Your Answer:**
1.  **The Diagnosis:** Aggregate functions (like `AVG()`) completely ignore `NULL` values. If 80% of the employees received no bonus, their column is likely `NULL`, not `0`. The `AVG` function only added up the 20% of employees who *did* get a bonus, and divided by that smaller headcount, artificially inflating the average.
2.  **The Fix:** We must use the `COALESCE()` function to convert `NULL`s to `0` *before* the aggregate evaluates them. The correct query is `SELECT AVG(COALESCE(bonus, 0)) FROM employees`.

---

## 4. Resolving Deadlocks
**Scenario:** Your application logs are filling up with "Deadlock found when trying to get lock" errors. What is happening and how do you fix it?

**Your Answer:**
1.  **The Diagnosis:** A deadlock happens when Transaction A locks Row 1 and needs Row 2, while Transaction B simultaneously locks Row 2 and needs Row 1. They wait for each other forever, so the database engine kills one of them.
2.  **The Fix:** The most common fix is to ensure that application code always accesses tables and rows in the **exact same alphabetical order**. If every transaction updates Row 1 first, then Row 2, a deadlock is mathematically impossible (Transaction B will just wait its turn). Additionally, keeping transactions as short and fast as possible reduces the window for deadlocks.

# Ranking Functions

---

## 1. Dedicated Window Functions

In the previous chapter, we used standard aggregate functions (`SUM`, `AVG`) as Window Functions by appending the `OVER()` clause.

However, SQL provides a set of dedicated functions that **only** work as Window Functions. The most famous of these are the **Ranking Functions**.

---

## 2. The ORDER BY inside OVER()

When you rank things, order matters. You can't rank salaries without telling the database to sort the salaries from highest to lowest.
Therefore, Ranking Functions require an `ORDER BY` clause *inside* the `OVER()` window.

```sql
SELECT 
    first_name, 
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;
```

---

## 3. ROW_NUMBER() vs RANK() vs DENSE_RANK()

These three functions do almost the exact same thing, but they handle **ties** differently. This is one of the most frequently asked questions in all of SQL interviewing.

Imagine we are ranking 4 employees by Salary:
*   Alice: $100k
*   Bob: $90k
*   Charlie: $90k (Tied with Bob)
*   David: $80k

### 1. ROW_NUMBER()
`ROW_NUMBER()` is dumb. It just assigns a sequential integer (1, 2, 3, 4) to every row. **It completely ignores ties.**
*   Alice: 1
*   Bob: 2
*   Charlie: 3 *(Wait, Charlie makes the same as Bob, why is he 3? Because ROW_NUMBER doesn't care).*
*   David: 4

### 2. RANK()
`RANK()` respects ties. It gives tied values the exact same rank. **However, it skips the next number(s) to compensate.**
*   Alice: 1
*   Bob: 2
*   Charlie: 2
*   David: **4** *(Notice that Rank 3 was completely skipped!)*

### 3. DENSE_RANK()
`DENSE_RANK()` respects ties just like `RANK()`, **but it DOES NOT skip numbers.** The ranking remains dense.
*   Alice: 1
*   Bob: 2
*   Charlie: 2
*   David: **3**

*(Best Practice: `DENSE_RANK()` is usually the correct choice for business logic. If David is the 3rd highest paid person, he should be ranked 3, not 4).*

---

## 4. Combining PARTITION BY and ORDER BY

You can combine `PARTITION BY` and `ORDER BY` inside the same window to generate localized rankings.

**Example: Find the highest paid employee IN EACH department.**
```sql
WITH RankedEmployees AS (
    SELECT 
        first_name, 
        department, 
        salary,
        DENSE_RANK() OVER(
            PARTITION BY department  -- Reset the rank to 1 for each new department
            ORDER BY salary DESC     -- Sort highest salary first within that department
        ) AS dept_salary_rank
    FROM employees
)
-- We use a CTE because you CANNOT put a Window Function directly inside a WHERE clause!
SELECT * 
FROM RankedEmployees 
WHERE dept_salary_rank = 1;
```

---

## 5. Interview Tips
*   **The "Top 3 Per Category" Problem:** The example above (finding the top 1, or top 3 items within a specific category) is an elite-level interview question. It is impossible to solve cleanly without using `DENSE_RANK() OVER(PARTITION BY... ORDER BY...)` inside a CTE. Memorize that pattern!
*   **The WHERE Restriction:** "Can you put `ROW_NUMBER()` in a `WHERE` clause?"
    *   **Answer:** "No. Window functions execute *after* the `WHERE` clause in the logical execution order. If you need to filter on a window function, you must calculate it inside a CTE or Derived Table first, and then filter it in the outer query."

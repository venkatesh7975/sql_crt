# Vertical Stitching with UNION

---

## 1. Joins vs Unions

If a `JOIN` combines tables **horizontally** (adding new columns to existing rows), a `UNION` combines result sets **vertically** (adding new rows to the bottom of the grid).

`UNION` is a "Set Operation" (borrowed from Set Theory in mathematics). It allows you to run two completely independent `SELECT` queries and stack their results on top of each other.

---

## 2. The Strict Rules of UNION

Because you are stacking two result sets into a single grid, the database enforces strict structural rules. If you break them, the query will crash.

1.  **Same Number of Columns:** Both `SELECT` statements must return the exact same number of columns.
2.  **Same Data Types:** The columns in the first query must have compatible data types with the corresponding columns in the second query (e.g., Column 1 must be an INT in both queries).
3.  **Order Matters:** The order of the columns in both `SELECT` statements must perfectly align.

*(Note: The actual names of the columns don't have to match. The final result set will inherit the column names from the **first** `SELECT` statement).*

---

## 3. UNION vs UNION ALL

There are two ways to use the `UNION` operator. Understanding the difference is a guaranteed interview question.

### UNION (Removes Duplicates)
By default, the `UNION` operator acts like a massive `DISTINCT` clause. It stacks the two tables together, and then it scans the entire combined result set and **deletes any duplicate rows**.

```sql
-- Find all unique email addresses across both users and contractors
SELECT email FROM users
UNION
SELECT email FROM contractors;
```

### UNION ALL (Keeps Duplicates)
`UNION ALL` simply stacks the two tables together and stops. It does not look for duplicates.

```sql
-- Find all email addresses, even if they exist in both tables
SELECT email FROM users
UNION ALL
SELECT email FROM contractors;
```

---

## 4. Performance Implications

Why does `UNION ALL` exist if `UNION` gives us a cleaner dataset? 
**Performance.**

To remove duplicates, the standard `UNION` operator must perform a massive, memory-intensive sorting operation (a "filesort") across the entire combined dataset. 
If you are unioning two tables with a million rows each, `UNION` will take seconds or minutes to deduplicate them. `UNION ALL` will run almost instantly.

*Best Practice:* Unless you have a specific business requirement to remove duplicates, **always use `UNION ALL` by default.**

---

## 5. Global Sorting and Limiting

If you want to apply an `ORDER BY` or a `LIMIT` to the combined result set, you only put it at the very end of the final query.

```sql
SELECT first_name, email FROM users
UNION ALL
SELECT first_name, email FROM contractors
ORDER BY first_name ASC  -- Applies to the combined data
LIMIT 50;                -- Applies to the combined data
```

---

## 6. Interview Tips
*   **The Difference:** "What is the difference between UNION and UNION ALL?" 
    *   **Answer:** "`UNION` removes duplicate rows, which makes it computationally expensive. `UNION ALL` keeps duplicates and is much faster."
*   **The Rules:** "What are the requirements for a UNION?"
    *   **Answer:** "Both queries must have the exact same number of columns, in the exact same order, with compatible data types."

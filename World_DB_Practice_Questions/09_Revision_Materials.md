# Revision Materials

---

## SQL Cheat Sheet

### Basic Keywords
*   **`SELECT`**: Determines which columns to return.
*   **`FROM`**: Determines which table to query.
*   **`WHERE`**: Filters rows *before* grouping based on a condition.
*   **`ORDER BY`**: Sorts the final output (`ASC` or `DESC`).
*   **`LIMIT`**: Restricts the number of rows returned (must be the absolute last clause).
*   **`DISTINCT`**: Removes duplicate rows from the output.

### Filtering Operators
*   **`LIKE`**: Partial string matching. `%` matches zero or more chars. `_` matches exactly one char.
*   **`BETWEEN x AND y`**: Inclusive range filtering.
*   **`IN (x, y, z)`**: Shorthand for multiple `OR` conditions.
*   **`IS NULL` / `IS NOT NULL`**: The only way to check for missing data. (`= NULL` fails).
*   **`AND` / `OR`**: Logical operators. `AND` evaluates before `OR`. Use parentheses to force precedence.

### Aggregate Functions
*   **`COUNT(*)`**: Counts all rows.
*   **`COUNT(col)`**: Counts non-null rows in that column.
*   **`SUM(col)`**: Adds numbers together.
*   **`AVG(col)`**: Calculates the mean. (Ignores NULLs!).
*   **`MIN(col)` / `MAX(col)`**: Finds the lowest/highest value.

### Grouping
*   **`GROUP BY`**: Collapses rows that share the same values into buckets so you can run aggregates on them. (Rule: All non-aggregated columns in SELECT must be in GROUP BY).
*   **`HAVING`**: Filters groups *after* aggregation occurs.

### Advanced
*   **`CASE WHEN x THEN y ELSE z END`**: Conditional logic (IF/ELSE). Great for Pivot Tables (`SUM(CASE...)`).
*   **`INNER JOIN`**: Stitches tables together. Discards rows without a match.
*   **`LEFT JOIN`**: Stitches tables together. Keeps all left rows; fills missing right rows with NULL.
*   **`EXISTS`**: Correlated subquery keyword. Evaluates to TRUE if the inner query returns at least one row.
*   **Window Functions (`OVER`)**: Performs calculations across rows without collapsing them.
    *   `PARTITION BY`: Resets the window calculation (like GROUP BY, but keeps all rows).
    *   `ROW_NUMBER()`: 1, 2, 3, 4
    *   `RANK()`: 1, 1, 3, 4
    *   `DENSE_RANK()`: 1, 1, 2, 3

---

## Query Pattern Summary

### Pattern 1: Basic Retrieval & Filtering
**Questions:** 1–20
**Characteristics:** `SELECT FROM WHERE`. Uses `LIKE`, `IN`, `BETWEEN`, and handles `NULL`s. Focuses on logical precedence (AND/OR).

### Pattern 2: Data Transformation
**Questions:** 21–25, 48
**Characteristics:** Uses `CONCAT`, `SUBSTRING`, `REPLACE`, `ROUND`, or `CASE` to format or categorize data before presenting it.

### Pattern 3: Aggregation & Grouping
**Questions:** 26–35
**Characteristics:** Uses `SUM`, `AVG`, `COUNT`. Heavily relies on `GROUP BY`. Differentiates between `WHERE` (pre-filter) and `HAVING` (post-filter).

### Pattern 4: Relational Joining
**Questions:** 36–42
**Characteristics:** Combines data across tables. Uses `INNER JOIN` for intersections, `LEFT JOIN ... IS NULL` for anti-joins (finding orphans), and `t1.id < t2.id` for Self-Joins.

### Pattern 5: Subqueries & Derived Tables
**Questions:** 43–47
**Characteristics:** Uses inner queries to drive outer queries. Uses `IN`, `EXISTS`, or places subqueries in the `FROM` or `SELECT` clauses.

### Pattern 6: Top N per Group (Window Functions)
**Questions:** 49–50
**Characteristics:** Uses `ROW_NUMBER()` or `DENSE_RANK()` paired with `OVER(PARTITION BY...)` to find the top performers within a specific category.

---

## Interview Revision Notes

### 1. Most Important Concepts
If you have 10 minutes before an interview, review these three things:
1.  **The Difference between WHERE and HAVING.**
2.  **The LEFT JOIN Anti-Join (`LEFT JOIN ... WHERE right.id IS NULL`).**
3.  **The "Top N per Group" pattern (`ROW_NUMBER() OVER(PARTITION BY...)`).**

### 2. Frequently Asked SQL Interview Topics
*   **The Gaps and Islands / Consecutive Numbers Problem:** Handled using `LAG/LEAD` or `ROW_NUMBER` minus Date tricks.
*   **Pivot Tables:** Rows to Columns. Handled using `SUM(CASE WHEN...)`.
*   **Orphaned Records:** "Find customers who never ordered." Handled using `LEFT JOIN` or `NOT EXISTS`.

### 3. Common Mistakes
*   **The Fan-Out Trap:** Joining multiple 1-to-Many tables together multiplies the rows, ruining your `SUM` and `COUNT` aggregates. Fix it using CTE pre-aggregation or `COUNT(DISTINCT)`.
*   **The NULL Trap:** `COUNT(col)` ignores NULLs. `AVG(col)` ignores NULLs. `col NOT IN (1, NULL)` fails completely. Always check for `IS NULL`.
*   **SELECT *:** Never use it. Always name your columns.

### 4. Performance Tips (SARGability)
*   Do not wrap indexed columns in functions in the `WHERE` clause. (e.g., Use `WHERE date >= '2023-01-01'` instead of `WHERE YEAR(date) = 2023`).
*   Do not use leading wildcards (`LIKE '%abc'`). They force Full Table Scans.
*   Use `EXISTS` instead of `IN` for large subqueries (though modern optimizers are getting better at fixing this for you).

### 5. Best Practices
*   Capitalize SQL keywords. Lowercase table/column names.
*   Always use table aliases (`users u, orders o`).
*   Prefer CTEs (`WITH ... AS ()`) over deeply nested subqueries in the `FROM` clause for readability.

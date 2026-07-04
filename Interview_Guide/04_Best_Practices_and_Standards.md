# Best Practices and Standards

---

## 1. Readability and Formatting
Writing SQL that works is only step one. Writing SQL that another engineer can read is the mark of a professional.

*   **Capitalization:** SQL keywords should be `UPPERCASE` (`SELECT`, `FROM`, `WHERE`). Table and column names should be `lowercase`.
*   **Aliasing:** Always use table aliases when querying more than one table. Use short, descriptive aliases (e.g., `users u`, `orders o`, NOT `users a`, `orders b`).
*   **Indentation:** The core clauses (`SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY`) should be left-aligned. The columns/conditions within them should be indented on new lines.

**Bad:**
```sql
select u.id,u.name,o.total from users u inner join orders o on u.id = o.uid where u.status='active'
```

**Good:**
```sql
SELECT 
    u.id, 
    u.name, 
    o.total 
FROM users u
INNER JOIN orders o 
    ON u.id = o.uid 
WHERE u.status = 'active';
```

---

## 2. CTEs > Subqueries
In modern SQL development, deeply nested subqueries in the `FROM` clause are heavily discouraged. 
You should default to using **Common Table Expressions (CTEs)** via the `WITH` keyword.

*   **Why?** CTEs read from top to bottom, making the logical flow of data transformation obvious to the reader. Nested subqueries require the reader to parse the code from the inside-out. Furthermore, CTEs can be referenced multiple times in the same query, whereas subqueries must be copied and pasted.

---

## 3. Avoid `SELECT *` in Production
While `SELECT *` is great for quick debugging, it should never be committed to production application code.

*   **Network I/O:** It pulls massive amounts of data across the network that the application likely doesn't need.
*   **Memory:** It bloats the RAM usage of the application server.
*   **Fragility:** If a DBA adds a new column to the table (like a massive BLOB image column), `SELECT *` will instantly pull it, potentially crashing the app. By explicitly naming your columns, you protect the application from database schema changes.

---

## 4. SARGability (Search ARGument ABLE)
Always write queries that allow the database engine to use its B-Tree indexes.

*   **No Math on Columns:** 
    *   Bad: `WHERE salary * 1.10 > 50000`
    *   Good: `WHERE salary > 50000 / 1.10`
*   **No Functions on Columns:**
    *   Bad: `WHERE YEAR(date) = 2023`
    *   Good: `WHERE date >= '2023-01-01' AND date < '2024-01-01'`
*   **No Leading Wildcards:**
    *   Bad: `WHERE name LIKE '%Smith'`
    *   Good: `WHERE name LIKE 'Smith%'` (if applicable to the business rule).

---

## 5. Use COALESCE over IFNULL
MySQL provides `IFNULL(column, fallback)`. Standard SQL provides `COALESCE(column1, column2, fallback)`.
*   **Why COALESCE?** It is ANSI SQL standard, meaning it works identically across PostgreSQL, SQL Server, and Oracle. `IFNULL` is MySQL specific. Furthermore, `COALESCE` accepts infinite arguments and returns the first non-null value, making it vastly more powerful.

---

## 6. ON DELETE Actions
When designing a database, never leave a Foreign Key hanging. Always specify an `ON DELETE` behavior.
*   Use `ON DELETE CASCADE` if the child record cannot logically exist without the parent (e.g., If a User is deleted, delete their Login History).
*   Use `ON DELETE SET NULL` if the child record should be kept for historical reasons (e.g., If a User is deleted, keep the Order record for financial reporting, but set the user_id to NULL).

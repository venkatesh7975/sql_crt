# Execution Order and Common Errors

---

## 1. The Logical Execution Order (Review)

Understanding how `GROUP BY` and `HAVING` fit into the grand scheme of a SQL query is the key to mastering SQL. 

When you write a query, you write it in this order:
`SELECT` -> `FROM` -> `WHERE` -> `GROUP BY` -> `HAVING` -> `ORDER BY` -> `LIMIT`

But the database **executes** it in this order:

1.  **FROM / JOIN:** Get the tables and link them together.
2.  **WHERE:** Filter the raw rows. Toss out anything that doesn't match.
3.  **GROUP BY:** Take the surviving rows and organize them into buckets.
4.  **HAVING:** Calculate the aggregate math for the buckets, and throw out any buckets that don't match the `HAVING` condition.
5.  **SELECT:** Finally, grab the specific columns requested to prepare the final output grid. (This is when Aliases are created!).
6.  **ORDER BY:** Sort the final grid.
7.  **LIMIT:** Cut off the bottom of the grid.

---

## 2. Common Errors Explained by Execution Order

### Error 1: Using an Alias in the WHERE clause
```sql
-- Fails!
SELECT (salary * 1.10) AS adjusted_salary 
FROM employees
WHERE adjusted_salary > 50000; 
```
*Why?* `WHERE` executes at Step 2. `SELECT` (where the alias is created) executes at Step 5. When `WHERE` is running, `adjusted_salary` doesn't exist yet!

### Error 2: Using an Aggregate in the WHERE clause
```sql
-- Fails!
SELECT department, AVG(salary) 
FROM employees
WHERE AVG(salary) > 50000
GROUP BY department;
```
*Why?* `WHERE` executes at Step 2. The buckets are made at Step 3, and the averages are calculated at Step 4. `WHERE` cannot filter on math that hasn't happened yet. You must use `HAVING`.

---

## 3. The "GROUP BY 1" Controversy

Many developers use shorthand indexing in their `GROUP BY` clauses.

```sql
SELECT department, COUNT(*)
FROM employees
GROUP BY 1; -- Refers to 'department'
```
While this works in MySQL and PostgreSQL, it is highly discouraged in enterprise environments for two reasons:
1.  **Fragility:** If someone adds a column to the beginning of the `SELECT` clause (e.g., `SELECT company_name, department...`), the `GROUP BY 1` silently changes to group by `company_name`, breaking the logic of the report.
2.  **Readability:** The next developer reading the code has to jump back and forth between the `SELECT` and `GROUP BY` clauses to figure out what `1, 2, 3` actually means.

**Best Practice:** Always type out the explicit column names in your `GROUP BY` clause.

---

## 4. Interview Tips
*   **The Whiteboard Test:** If you are asked to write a complex query on a whiteboard, always start by writing the `FROM` and `WHERE` clauses first, then the `GROUP BY` / `HAVING`, and write the `SELECT` clause *last*. This proves to the interviewer that you think like the database optimizer.
*   **Debugging:** If presented with a broken SQL query in an interview and asked to fix it, immediately check if there are Aggregates in the `WHERE` clause, or if the `SELECT` clause violates the Golden Rule of `GROUP BY`. These are the two most common "spot the bug" questions.

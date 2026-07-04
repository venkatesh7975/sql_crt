# Subqueries and CTEs - Part 1 (Questions 1-50)

**Q1. What is a scalar subquery in MySQL?**
A) A subquery that returns a single row with multiple columns
B) A subquery that returns a single value (one row and one column)
C) A subquery that can only be used in the FROM clause
D) A subquery that always returns multiple rows

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A scalar subquery is designed to return exactly one value (one row and one column) and can be used in most places where a single value or expression is expected.
</details>

**Q2. What happens if a scalar subquery used in a SELECT list returns more than one row?**
A) MySQL automatically uses the first row and ignores the rest.
B) MySQL throws an error: "Subquery returns more than 1 row".
C) MySQL returns an array of the values.
D) The query executes, but the result is NULL for that column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A scalar subquery must return at most one row. If it returns multiple rows, MySQL evaluates it as an error at runtime.
</details>

**Q3. If a scalar subquery returns zero rows, what is the result of the subquery expression?**
A) 0
B) An empty string
C) NULL
D) It raises a runtime error

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When a scalar subquery returns no rows, MySQL evaluates the result of the subquery as NULL, rather than throwing an error.
</details>

**Q4. Where can you NOT use a scalar subquery in a MySQL SELECT statement?**
A) In the SELECT list as a column value
B) In the WHERE clause for comparison
C) As the table name itself in the FROM clause without an alias
D) In the ORDER BY clause

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** While you can use subqueries in the FROM clause (Derived Tables), they must return a table structure and MUST be given an alias. A scalar subquery cannot be used simply as a table name without an alias.
</details>

**Q5. Which of the following comparison operators is valid to use with a scalar subquery?**
A) =
B) >
C) <=
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Since a scalar subquery returns a single value, all standard comparison operators (=, <, >, <=, >=, <>) can be used with it.
</details>

**Q6. Can a scalar subquery contain an aggregate function like SUM() or MAX()?**
A) Yes, but only if it does not contain a GROUP BY clause.
B) Yes, and it is one of the most common ways to ensure the subquery returns a single value.
C) No, aggregate functions are not allowed in subqueries.
D) Yes, but only if used in the HAVING clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Aggregate functions are perfectly valid and frequently used in scalar subqueries to guarantee that a single summary value is returned.
</details>

**Q7. When using the `IN` operator with a subquery, what type of subquery is expected?**
A) A scalar subquery returning one row and one column.
B) A subquery returning one column but potentially multiple rows.
C) A subquery returning multiple columns and multiple rows.
D) A derived table subquery in the FROM clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `IN` operator is designed to check if a value matches any value in a list, so it expects a single-column subquery that can return multiple rows.
</details>

**Q8. What is the equivalent of the condition `WHERE x = ANY (subquery)`?**
A) WHERE x IN (subquery)
B) WHERE x = ALL (subquery)
C) WHERE EXISTS (subquery)
D) WHERE x > (subquery)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `= ANY` is a synonym for the `IN` operator. Both evaluate to true if the value matches at least one value returned by the subquery.
</details>

**Q9. If a subquery returns (1, 2, NULL), what is the result of `WHERE 3 IN (subquery)`?**
A) TRUE
B) FALSE
C) NULL
D) Error

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `3 IN (1, 2, NULL)` translates to `3 = 1 OR 3 = 2 OR 3 = NULL`. Since `3 = NULL` is UNKNOWN (NULL) and none are true, the overall result is NULL.
</details>

**Q10. If a subquery used with `NOT IN` returns any NULL values, what happens to the condition `WHERE x NOT IN (subquery)`?**
A) It evaluates to TRUE if x doesn't match the non-NULL values.
B) It evaluates to FALSE or NULL, meaning no rows will be returned.
C) It ignores the NULL values and evaluates normally.
D) It raises a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NOT IN` evaluates to `x <> val1 AND x <> val2 AND x <> NULL`. Since `x <> NULL` is always NULL (UNKNOWN), the entire `AND` condition becomes NULL or FALSE, causing the WHERE clause to fail for all rows.
</details>

**Q11. What is the primary characteristic of a Correlated Subquery?**
A) It returns multiple columns.
B) It executes exactly once for the entire primary query.
C) It references columns from the outer query.
D) It must be placed in the FROM clause.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A correlated subquery contains a reference to a table that also appears in the outer query, meaning it depends on the outer query for its values.
</details>

**Q12. How does MySQL generally evaluate a Correlated Subquery?**
A) It evaluates the subquery once and caches the result.
B) It evaluates the subquery once for each row processed by the outer query.
C) It evaluates the subquery after the outer query finishes.
D) It converts the subquery into a scalar value before execution.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because it references columns from the outer query, a correlated subquery conceptually executes row-by-row for each row of the outer query.
</details>

**Q13. What is the equivalent of the condition `WHERE x <> ALL (subquery)`?**
A) WHERE x NOT IN (subquery)
B) WHERE x IN (subquery)
C) WHERE x != ANY (subquery)
D) WHERE NOT EXISTS (subquery)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `<> ALL` means the value must not be equal to any of the values in the subquery result, which is logically identical to `NOT IN`.
</details>

**Q14. The `EXISTS` operator returns TRUE when:**
A) The subquery returns exactly one row.
B) The subquery returns at least one row.
C) The subquery returns no rows.
D) The subquery returns a non-NULL value.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `EXISTS` tests for the existence of rows. It returns TRUE if the subquery returns one or more rows, regardless of the actual data in those rows.
</details>

**Q15. When using `EXISTS (SELECT * FROM table ...)`, does MySQL actually fetch all columns (`*`)?**
A) Yes, it fetches all data which makes it inefficient.
B) No, MySQL optimizes `EXISTS` to only check for row presence and ignores the select list.
C) Yes, but only for the first row.
D) It depends on whether there is an index.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In an `EXISTS` subquery, the SELECT list is mostly irrelevant. MySQL's optimizer ignores the SELECT list and only determines if rows can be found matching the WHERE conditions.
</details>

**Q16. What happens if a subquery in an `EXISTS` clause returns rows where all columns are NULL?**
A) `EXISTS` evaluates to FALSE.
B) `EXISTS` evaluates to NULL.
C) `EXISTS` evaluates to TRUE.
D) MySQL throws an error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `EXISTS` only checks for row presence. Even if the row contains only NULL values, a row is still returned, so `EXISTS` evaluates to TRUE.
</details>

**Q17. Which of the following is an example of a row subquery comparison?**
A) WHERE (col1, col2) = (SELECT col1, col2 FROM table1 LIMIT 1)
B) WHERE col1 IN (SELECT col1 FROM table1)
C) WHERE col1 = (SELECT col1 FROM table1 LIMIT 1)
D) WHERE EXISTS (SELECT col1, col2 FROM table1)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A row subquery returns a single row with multiple columns. You can compare it against a tuple of columns, like `(col1, col2) = (SELECT ...)`.
</details>

**Q18. If a multi-row subquery used with `> ALL` returns an empty set (zero rows), what is the result?**
A) TRUE
B) FALSE
C) NULL
D) Error

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If the subquery returns no rows, `> ALL` trivially evaluates to TRUE because there is no value in the empty set that violates the condition.
</details>

**Q19. If a multi-row subquery used with `> ANY` returns an empty set (zero rows), what is the result?**
A) TRUE
B) FALSE
C) NULL
D) Error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `> ANY` means "greater than at least one value". Since there are no values in an empty set, the condition cannot be met, so it evaluates to FALSE.
</details>

**Q20. In MySQL, which query is often rewritten by the optimizer into a semi-join?**
A) Correlated NOT EXISTS subquery
B) Subquery in the SELECT list
C) Uncorrelated IN subquery used in a WHERE clause
D) Scalar subquery in the ORDER BY clause

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL's optimizer frequently transforms `IN` (and `= ANY`) subqueries into semi-joins to improve execution performance by avoiding full materialization of the subquery.
</details>

**Q21. Can you modify a table (e.g., UPDATE or DELETE) while simultaneously selecting from the same table in a subquery in MySQL?**
A) Yes, without any restrictions.
B) No, MySQL throws an error saying "You can't specify target table for update in FROM clause".
C) Yes, but only if the subquery is correlated.
D) No, unless you disable safe updates.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL traditionally does not allow you to update or delete from a table if you are querying the same table in a direct subquery in the WHERE clause, though this can sometimes be bypassed by wrapping the subquery in another derived table.
</details>

**Q22. What is the best workaround in MySQL to UPDATE a table using a subquery that references the same table?**
A) Use a correlated subquery instead of an uncorrelated one.
B) Wrap the subquery inside another subquery (a derived table).
C) Use a scalar subquery.
D) Use the `EXISTS` operator instead of `IN`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By wrapping the subquery in an additional `SELECT` (creating a derived table), MySQL materializes the derived table first, allowing the outer UPDATE to proceed without the locking conflict error.
</details>

**Q23. Which clause CANNOT contain a correlated subquery?**
A) SELECT list
B) WHERE
C) HAVING
D) A correlated subquery can be used in all of these clauses.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A correlated subquery can be placed in the SELECT list, WHERE clause, or HAVING clause, as long as it references columns from the outer query correctly.
</details>

**Q24. In the context of `WHERE x > ANY (subquery)`, what does this logically mean?**
A) x must be greater than the maximum value returned by the subquery.
B) x must be greater than the minimum value returned by the subquery.
C) x must be equal to at least one value.
D) x must be greater than all values.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `> ANY` means greater than at least one element in the set. For this to be true, x only needs to be greater than the smallest (minimum) value in the subquery results.
</details>

**Q25. In the context of `WHERE x > ALL (subquery)`, what does this logically mean?**
A) x must be greater than the maximum value returned by the subquery.
B) x must be greater than the minimum value returned by the subquery.
C) x must be equal to all values.
D) x must not be NULL.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `> ALL` means greater than every single element in the set. For this to be true, x must be greater than the largest (maximum) value in the subquery results.
</details>

**Q26. What does the `SOME` operator do in MySQL?**
A) It behaves exactly like the `ALL` operator.
B) It is an alias for the `ANY` operator.
C) It checks if a subquery returns exactly one row.
D) It is an alias for `EXISTS`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, `SOME` is a synonym for `ANY`. `= SOME` is the same as `= ANY` and `IN`.
</details>

**Q27. Can a subquery contain its own subquery?**
A) Yes, subqueries can be nested deeply.
B) No, MySQL allows only a single level of subqueries.
C) Yes, but only in the FROM clause.
D) Yes, but only correlated subqueries can be nested.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL allows subqueries to be nested inside other subqueries, up to a deeply nested level, though performance may degrade with excessive nesting.
</details>

**Q28. What error is produced when a subquery in an `IN` clause returns multiple columns?**
A) "Subquery returns more than 1 row"
B) "Operand should contain 1 column(s)"
C) "Invalid use of group function"
D) "Table is specified twice"

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `IN` operator (when comparing a single scalar value) expects a one-column result set. Returning multiple columns results in the "Operand should contain 1 column(s)" error.
</details>

**Q29. Consider `SELECT * FROM t1 WHERE (col1, col2) IN (SELECT col1, col2 FROM t2)`. What kind of subquery is this?**
A) Scalar subquery
B) Row subquery used with IN
C) Correlated subquery
D) Derived table

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This is a multi-row, multi-column subquery. It's a row subquery used with the `IN` operator, comparing tuples `(col1, col2)` against the tuples returned by the subquery.
</details>

**Q30. If you use a correlated subquery in the `SELECT` list, what happens if the subquery returns no rows for a particular outer row?**
A) The query execution aborts with an error.
B) The outer query excludes that row from the final result set.
C) The value for that column becomes an empty string.
D) The value for that column becomes NULL.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A subquery in the SELECT list is a scalar subquery. If a scalar subquery returns no rows, its result is evaluated as NULL for that particular row of the outer query.
</details>

**Q31. How does `NOT EXISTS` handle NULL values returned by the subquery?**
A) It evaluates to NULL.
B) It treats them like any other row; if a row is returned (even with NULLs), `NOT EXISTS` is FALSE.
C) It ignores NULL rows and evaluates based on non-NULL rows.
D) It converts NULLs to zeros.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `EXISTS` and `NOT EXISTS` only care about the presence of rows. The actual values in those rows (including NULLs) do not matter. If a NULL row exists, `EXISTS` is TRUE and `NOT EXISTS` is FALSE.
</details>

**Q32. When might `NOT EXISTS` be preferable to `NOT IN`?**
A) When the subquery result set contains NULL values.
B) When the subquery is a scalar subquery.
C) When the subquery uses an aggregate function.
D) `NOT IN` is always faster than `NOT EXISTS`.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If a subquery returns a NULL value, `NOT IN` will yield NULL (effectively FALSE) for all rows. `NOT EXISTS` avoids this issue because it evaluates row presence rather than value equivalence.
</details>

**Q33. Which SQL operator is functionally equivalent to `EXISTS (SELECT 1 FROM t2 WHERE t1.id = t2.id)`?**
A) IN
B) ANY
C) ALL
D) There is no direct functional equivalent without context, though `IN` often achieves the same result for equality.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** While `IN (SELECT id FROM t2)` achieves the same logical result as the given `EXISTS` clause, `EXISTS` specifically evaluates a correlated condition. In modern MySQL, the optimizer often treats them interchangeably when producing execution plans.
</details>

**Q34. What is a "Derived Table" in MySQL?**
A) A table created using the CREATE TABLE ... SELECT statement.
B) A subquery used in the FROM clause of another query.
C) A temporary table created in memory.
D) A view.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A derived table is an inline view or a subquery specified in the `FROM` clause of a `SELECT` statement.
</details>

**Q35. What is a mandatory requirement when using a Derived Table in MySQL?**
A) It must include a GROUP BY clause.
B) It must have an alias.
C) It must not use JOINs inside.
D) It must return only one column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL requires that every derived table (subquery in the FROM clause) must have its own alias (e.g., `FROM (SELECT ...) AS derived_t1`).
</details>

**Q36. Can a correlated subquery refer to a table from a grandparent query (a query two levels up)?**
A) No, it can only reference the immediate parent query.
B) Yes, MySQL resolves column references by searching from the innermost query outwards.
C) Yes, but only if the grandparent table has an alias starting with `g_`.
D) No, subqueries are strictly limited to one level of outer reference.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Column scopes in MySQL resolve outward. A subquery can reference columns from its parent, grandparent, or any ancestor query, provided there are no naming ambiguities.
</details>

**Q37. Which of the following is true about Subquery Materialization in MySQL?**
A) MySQL always materializes correlated subqueries.
B) Subquery materialization means storing the subquery result in a temporary table to avoid re-evaluating it.
C) Materialization can only happen for scalar subqueries.
D) Materialization means converting the subquery into a JOIN.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Subquery materialization is an optimization technique where MySQL executes the subquery once, stores the result in a temporary table (often indexed), and uses it for outer query evaluations.
</details>

**Q38. What does the `LIMIT` clause do inside a scalar subquery?**
A) It forces the query to return multiple rows.
B) It is commonly used to ensure the subquery returns at most one row, avoiding runtime errors.
C) It limits the number of columns returned.
D) `LIMIT` is not allowed in subqueries.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Since a scalar subquery must return no more than one row, developers often add `LIMIT 1` to guarantee it won't throw a "Subquery returns more than 1 row" error.
</details>

**Q39. Can you use an `ORDER BY` clause inside an uncorrelated `IN` subquery?**
A) Yes, and it significantly improves performance.
B) Yes, but it is generally ignored by the optimizer unless paired with LIMIT.
C) No, MySQL throws a syntax error.
D) Yes, but only if you use descending order.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While syntactically allowed, an `ORDER BY` in a subquery (without `LIMIT`) does not affect the logical result of an `IN` or `EXISTS` condition and is typically discarded by the query optimizer.
</details>

**Q40. Is it possible to use a subquery inside a `CASE` or `IF()` statement?**
A) Yes, scalar subqueries can be used inside `CASE` or `IF()` statements.
B) No, subqueries are only allowed in WHERE and FROM clauses.
C) Yes, but only if it is a multi-row subquery.
D) No, it causes a parser error.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Scalar subqueries act as single values, so they can be embedded in control flow functions like `CASE`, `IF()`, `COALESCE()`, and others.
</details>

**Q41. What is the impact of an index on a column used in a correlated subquery's WHERE clause?**
A) It has no impact because correlated subqueries cannot use indexes.
B) It can significantly improve performance since the subquery is evaluated many times.
C) It slows down the query due to index locking.
D) It forces the query to materialize.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because a correlated subquery executes logically for every row of the outer query, having an index on the filtering columns inside the subquery drastically reduces execution time.
</details>

**Q42. How do you reference an outer query's column in a correlated subquery if the column name is identical in both tables?**
A) You cannot; MySQL throws an ambiguous column error.
B) You must use table aliases to explicitly qualify which table's column you are referencing.
C) MySQL automatically assumes you mean the inner table's column for both.
D) You must use the `OUTER.` keyword.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To avoid ambiguity when column names are identical, you must alias the tables and prefix the column names (e.g., `WHERE inner_t.id = outer_t.id`).
</details>

**Q43. What happens if you do NOT qualify an ambiguous column name in a subquery?**
A) MySQL throws an error.
B) MySQL resolves it to the table in the innermost scope.
C) MySQL resolves it to the table in the outermost scope.
D) MySQL randomly assigns it.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If an unqualified column name is found in a subquery, MySQL first looks for the column in the tables of the innermost query. If not found, it searches outward. If it exists in both, it binds to the inner table.
</details>

**Q44. Which query structure is typically used to find the 'second highest' or 'Nth highest' salary using only subqueries?**
A) Correlated subquery counting how many rows are greater than the current row.
B) Subquery in the FROM clause with a JOIN.
C) Subquery using `NOT IN`.
D) A multi-row `EXISTS` subquery.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A classic SQL technique for the Nth highest value is a correlated subquery: `WHERE N-1 = (SELECT COUNT(DISTINCT salary) FROM emp e2 WHERE e2.salary > e1.salary)`.
</details>

**Q45. Can a subquery be used inside an `INSERT INTO ... VALUES` statement?**
A) No, you must use `INSERT INTO ... SELECT` instead.
B) Yes, scalar subqueries can be used as values in the `VALUES` clause.
C) Yes, but only derived tables are allowed.
D) No, subqueries are strictly for reading data.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can insert the result of a scalar subquery directly in a values list: `INSERT INTO t1 (id, val) VALUES (1, (SELECT MAX(val) FROM t2))`.
</details>

**Q46. What does `SELECT * FROM t1 WHERE col1 = ANY (SELECT col1 FROM t2 WHERE 1=0)` evaluate to?**
A) TRUE for all rows
B) FALSE for all rows
C) NULL for all rows
D) It throws an error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The subquery returns an empty set. `= ANY` (or `IN`) against an empty set evaluates to FALSE.
</details>

**Q47. If `val NOT IN (subquery)` evaluates to UNKNOWN (NULL), how does the `WHERE` clause interpret it?**
A) As TRUE, the row is returned.
B) As FALSE, the row is discarded.
C) It triggers a warning and returns the row.
D) It converts the NULL to 0.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In SQL, a `WHERE` condition must evaluate strictly to TRUE for a row to be included. UNKNOWN (NULL) is treated effectively as FALSE.
</details>

**Q48. Which keyword is required when doing a `CREATE TABLE ... AS` with a subquery?**
A) `SELECT`
B) `EXISTS`
C) `IN`
D) `DERIVED`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The syntax is `CREATE TABLE new_table AS SELECT ...`. The subquery (or standard query) is a SELECT statement.
</details>

**Q49. Is it valid to use a subquery inside the `SET` clause of an `UPDATE` statement?**
A) Yes, provided it is a scalar subquery.
B) Yes, but it must be an `IN` subquery.
C) No, subqueries are only allowed in the `WHERE` clause of an `UPDATE`.
D) No, it requires a JOIN instead.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can update a column to the result of a subquery (e.g., `UPDATE t1 SET col1 = (SELECT max(val) FROM t2)`), as long as the subquery is scalar.
</details>

**Q50. How does a correlated subquery in the `WHERE` clause generally impact query performance compared to a standard `JOIN`?**
A) It is always much faster.
B) It has no performance difference.
C) It can often be slower because the query engine may execute the subquery once for every row of the outer query.
D) It prevents the use of indexes entirely.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Correlated subqueries can lead to nested loop execution where the inner query runs for every outer row. While the optimizer sometimes rewrites them into JOINs, unoptimized correlated subqueries are notorious for poor performance on large datasets.
</details>

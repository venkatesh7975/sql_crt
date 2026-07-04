# Subqueries and CTEs - Part 2 (Questions 51-100)

**Q51. What is a Lateral Derived Table in MySQL 8.0?**
A) A derived table that joins with another table using CROSS JOIN.
B) A derived table that can reference columns of preceding tables in the same FROM clause.
C) A derived table that automatically indexes its results.
D) A view that is created dynamically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Introduced in MySQL 8.0.14, the `LATERAL` keyword allows a derived table to reference columns from previous tables defined in the same `FROM` clause, acting somewhat like a correlated subquery within the FROM clause.
</details>

**Q52. How is a Lateral Derived Table declared in a query?**
A) FROM LATERAL (SELECT ...) AS alias
B) FROM (LATERAL SELECT ...) AS alias
C) FROM table1, LATERAL table2
D) FROM (SELECT ...) LATERAL alias

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The correct syntax is to place the `LATERAL` keyword directly before the subquery in the `FROM` clause: `FROM t1, LATERAL (SELECT ... FROM t2 WHERE t2.id = t1.id) AS t3`.
</details>

**Q53. Without the `LATERAL` keyword, can a derived table reference columns from other tables in the same `FROM` clause?**
A) Yes, it can do so natively in MySQL.
B) No, derived tables are strictly evaluated independently of other tables in the `FROM` clause.
C) Yes, but only if they are joined using INNER JOIN.
D) Yes, if it uses the DEPENDS keyword.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In standard SQL and older MySQL versions, a derived table cannot reference columns from other tables in the same `FROM` list. It is an independent query. `LATERAL` breaks this restriction.
</details>

**Q54. What is a CTE (Common Table Expression)?**
A) A temporary table stored on disk.
B) A named temporary result set that exists only within the execution scope of a single SQL statement.
C) A stored procedure returning a result set.
D) A global view accessible by all sessions.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A CTE provides a way to define a temporary, named result set that can be referenced multiple times within a single `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement.
</details>

**Q55. Which keyword is used to begin the definition of a CTE?**
A) WITH
B) CREATE CTE
C) TEMP TABLE
D) DEFINE

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** CTEs are defined using the `WITH` clause at the very beginning of the query (or immediately before the `SELECT` in subqueries).
</details>

**Q56. Can you define multiple CTEs in a single query?**
A) No, only one CTE is allowed per query.
B) Yes, by using multiple `WITH` keywords.
C) Yes, by separating them with commas after a single `WITH` keyword.
D) Yes, but they cannot reference each other.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Multiple CTEs can be defined by separating them with commas: `WITH cte1 AS (...), cte2 AS (...) SELECT ...`.
</details>

**Q57. If `cte2` is defined after `cte1` in the same `WITH` clause, can `cte2` query `cte1`?**
A) No, CTEs cannot reference other CTEs.
B) Yes, later CTEs can reference preceding CTEs.
C) Yes, but only if `WITH RECURSIVE` is used.
D) No, they are evaluated concurrently.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A CTE can reference any previously defined CTE within the same `WITH` clause, allowing for modular query building.
</details>

**Q58. What is the primary advantage of using a CTE over a Derived Table?**
A) CTEs automatically create indexes.
B) CTEs can be referenced multiple times in the main query without repeating the subquery code.
C) CTEs are strictly faster.
D) Derived tables cannot be used with aggregate functions.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CTEs improve readability and allow reuse of the same result set multiple times within the query, whereas a derived table would have to be written out multiple times.
</details>

**Q59. What happens if you define a CTE but never reference it in the main query?**
A) MySQL throws a syntax error.
B) The query executes normally; the CTE is just ignored.
C) The query fails at execution time.
D) The CTE is permanently saved as a view.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL allows you to define a CTE without using it. The optimizer will simply ignore it and it will not affect the output of the main query.
</details>

**Q60. How do you explicitly specify the column names for a CTE?**
A) WITH cte(col1, col2) AS (SELECT a, b FROM table)
B) WITH cte AS (SELECT a AS col1, b AS col2 FROM table)
C) Both A and B are valid.
D) You cannot specify column names; they must inherit from the SELECT statement exactly.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** You can specify CTE column names either inline inside the SELECT aliases or immediately after the CTE name in parentheses.
</details>

**Q61. What defines a Recursive CTE in MySQL?**
A) It uses the `LOOP` keyword.
B) It references itself within its own definition.
C) It iterates over a cursor.
D) It calls a stored procedure.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A recursive CTE is one that has a subquery referencing the CTE's own name, allowing it to process hierarchical or tree-structured data.
</details>

**Q62. What keyword MUST be used to define a recursive CTE in MySQL?**
A) WITH RECURSIVE
B) RECURSE AS
C) WITH RECURSION
D) LATERAL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** To define a recursive CTE in MySQL, the `WITH RECURSIVE` syntax must be used instead of just `WITH`.
</details>

**Q63. What are the two mandatory components of a recursive CTE definition?**
A) The Anchor member and the Recursive member.
B) The SELECT member and the UPDATE member.
C) The Base query and the LIMIT clause.
D) The WITH clause and the ORDER clause.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A recursive CTE consists of a non-recursive "anchor" SELECT (which produces the initial rows), followed by a recursive SELECT that references the CTE, joined by `UNION ALL` or `UNION`.
</details>

**Q64. Which operator is used to combine the anchor member and the recursive member in a recursive CTE?**
A) JOIN
B) UNION ALL or UNION
C) INTERSECT
D) CROSS JOIN

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The anchor and recursive queries are combined using `UNION ALL` (or `UNION DISTINCT`), appending the recursive results to the anchor results.
</details>

**Q65. How does a recursive CTE know when to stop executing?**
A) When it reaches a predefined depth of 10.
B) When the recursive member produces no new rows.
C) When the anchor member is exhausted.
D) When a `BREAK` statement is encountered.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The recursion continues iteratively. It stops automatically when an iteration of the recursive member returns an empty result set (no new rows).
</details>

**Q66. What MySQL system variable limits the maximum depth of a recursive CTE to prevent infinite loops?**
A) `max_cte_depth`
B) `cte_max_recursion_depth`
C) `recursion_limit`
D) `sql_recursive_depth`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The system variable `cte_max_recursion_depth` (default 1000) limits how many times the recursive member can be executed, throwing an error if exceeded.
</details>

**Q67. What happens if a recursive CTE exceeds `cte_max_recursion_depth`?**
A) It silently stops and returns the data accumulated so far.
B) It triggers a fatal server crash.
C) MySQL terminates the query and throws an error (e.g., "Recursive query aborted").
D) It writes to the slow query log and continues.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If the recursion limit is reached, MySQL aborts the execution and throws a specific error indicating that the maximum recursion depth was exceeded.
</details>

**Q68. Can aggregate functions like `SUM()` or `GROUP BY` be used in the recursive member of a recursive CTE?**
A) Yes, without restrictions.
B) No, they are strictly prohibited in the recursive member.
C) Yes, but only if paired with `ORDER BY`.
D) Yes, but only in MySQL 8.0.30 and later.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In standard SQL and MySQL, the recursive member cannot contain aggregate functions, `GROUP BY`, `ORDER BY`, `LIMIT`, or `DISTINCT`.
</details>

**Q69. Is it possible to use a CTE inside an `UPDATE` statement?**
A) Yes, CTEs can be used with UPDATE, DELETE, and INSERT statements in MySQL 8.0+.
B) No, CTEs are strictly for SELECT statements.
C) Yes, but only non-recursive CTEs.
D) No, only derived tables can be used in updates.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL 8.0 allows `WITH` clauses to prefix `UPDATE`, `DELETE`, and `INSERT` statements, enabling complex data manipulations using CTEs.
</details>

**Q70. In an `UPDATE` statement using a CTE, which table is actually updated?**
A) The CTE itself.
B) The base table referenced in the main UPDATE clause.
C) Both the CTE and the base table.
D) CTEs cannot be used with UPDATE.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A CTE acts as a readable temporary result set. The `UPDATE` statement targets the actual base table, often joining it against the data generated by the CTE.
</details>

**Q71. Consider the query: `WITH cte AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM cte WHERE n < 5) SELECT * FROM cte;`. What is the output?**
A) 1, 2, 3, 4, 5
B) 1, 2, 3, 4
C) 5
D) Error: Recursive without WITH RECURSIVE

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Because the CTE references its own name (`cte`), it is a recursive CTE. In MySQL, you MUST use the `WITH RECURSIVE` keyword. `WITH` alone will cause a syntax error.
</details>

**Q72. If we correct the previous query to use `WITH RECURSIVE`, what will the output be?**
A) 1, 2, 3, 4, 5
B) 1, 2, 3, 4
C) 5
D) An infinite loop

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The anchor is 1. The recursive step adds 1 as long as `n < 5`. Iterations: n=1 -> generates 2. n=2 -> generates 3. n=3 -> generates 4. n=4 -> generates 5. n=5 -> condition n<5 is false, recursion stops. Results: 1,2,3,4,5.
</details>

**Q73. Can a recursive CTE query multiple anchor members?**
A) Yes, by separating them with commas.
B) Yes, by joining them with UNION or UNION ALL before the recursive member.
C) No, only one anchor member is allowed.
D) No, multiple anchors are only supported in Oracle.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can have multiple anchor members combined with `UNION ALL` before the first recursive member.
</details>

**Q74. Which of the following is a common use case for a recursive CTE?**
A) Generating a sequence of numbers or dates.
B) Traversing an employee-manager hierarchy.
C) Parsing bill-of-materials structures.
D) All of the above.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Recursive CTEs are excellent for generating sequences, resolving hierarchical data (parent-child relationships like org charts), and navigating graph-like structures.
</details>

**Q75. Can you use `LIMIT` in the main query that selects from a recursive CTE?**
A) No, `LIMIT` is forbidden with recursive CTEs.
B) Yes, and it can force the recursion to stop early if the optimizer is smart enough, but generally it applies to the final result set.
C) Yes, but it must be placed inside the recursive member.
D) Yes, but only if you use `ORDER BY`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can use `LIMIT` in the outermost `SELECT`. In some cases, MySQL can optimize the execution to stop recursion once the outer limit is reached.
</details>

**Q76. What is the scope of a CTE defined in a subquery?**
A) Global to the entire database.
B) Global to the entire statement.
C) Restricted only to that specific subquery block.
D) Accessible by the immediate parent query only.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If a `WITH` clause is placed inside a subquery (e.g., `SELECT * FROM (WITH cte AS (...) SELECT ...) AS t`), the CTE is strictly scoped to that subquery and cannot be referenced outside of it.
</details>

**Q77. Can CTEs be recursive and non-recursive in the same `WITH` clause?**
A) No, a `WITH` clause must be entirely recursive or entirely non-recursive.
B) Yes, as long as `WITH RECURSIVE` is used, some CTEs in the list can be non-recursive.
C) Yes, but you must specify `RECURSIVE` before each recursive CTE name.
D) No, MySQL does not allow mixing them.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By declaring `WITH RECURSIVE`, you enable recursion for the entire clause. You can then define a mix of recursive and non-recursive CTEs separated by commas.
</details>

**Q78. In a tree structure table with `id` and `parent_id`, how do you find all ancestors of a specific node using a recursive CTE?**
A) The anchor selects the specific node, and the recursive member joins the CTE's `parent_id` to the table's `id`.
B) The anchor selects the specific node, and the recursive member joins the CTE's `id` to the table's `parent_id`.
C) The anchor selects all root nodes, and the recursive member joins downwards.
D) You cannot find ancestors, only descendants.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** To traverse upwards (find ancestors), you start at the child node (anchor), and the recursive step joins the current node's `parent_id` to the parent table's `id` to fetch the parent row.
</details>

**Q79. Does MySQL materialize CTEs?**
A) Always, CTEs are always written to temporary tables.
B) Never, CTEs are always merged into the main query.
C) MySQL decides whether to materialize a CTE or merge it based on the query structure (e.g., presence of aggregates) and optimizer hints.
D) Only recursive CTEs are materialized.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Similar to derived tables, MySQL's optimizer uses merging or materialization strategies for CTEs. Views and CTEs without aggregates/limits are often merged into the outer query for better index usage.
</details>

**Q80. Which optimizer hint can force a CTE to be materialized instead of merged?**
A) /*+ MERGE(cte_name) */
B) /*+ MATERIALIZE */
C) /*+ NO_MERGE(cte_name) */
D) /*+ FORCE_TEMP_TABLE */

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `NO_MERGE(cte_name)` optimizer hint instructs MySQL to materialize the CTE into an internal temporary table rather than folding it into the outer query block.
</details>

**Q81. What happens if a subquery in the `FROM` clause returns duplicate column names?**
A) MySQL automatically renames the second column (e.g., `col_1`).
B) MySQL throws a syntax error: "Duplicate column name".
C) The query succeeds but only the first column is accessible.
D) The query succeeds but the columns are merged.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A derived table (or CTE) must have unique column names. If the subquery `SELECT a, a FROM table` is used in a FROM clause, MySQL will throw a duplicate column name error.
</details>

**Q82. When using `WHERE col1 IN (SELECT col1 FROM table2)`, what does the optimizer often do in MySQL 8.0?**
A) It evaluates the subquery once for every row.
B) It converts the IN condition to an EXISTS condition.
C) It converts the query into a semi-join.
D) It limits the subquery to 1000 rows.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In modern MySQL versions, uncorrelated `IN` subqueries are typically rewritten as Semi-Joins by the optimizer, drastically improving execution speed compared to older versions.
</details>

**Q83. What is the difference between `UNION` and `UNION ALL` in a recursive CTE?**
A) `UNION` is not allowed in a recursive CTE, only `UNION ALL` is.
B) `UNION` removes duplicate rows during each recursive step, while `UNION ALL` keeps all generated rows.
C) `UNION ALL` sorts the results, `UNION` does not.
D) There is no difference in recursive CTEs.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `UNION DISTINCT` (or just `UNION`) eliminates duplicate rows as they are generated. This can be used to prevent infinite loops in cyclic graphs, but `UNION ALL` is more commonly used and performs faster when duplicates aren't an issue.
</details>

**Q84. What is the typical behavior when you attempt to use an `OUTER JOIN` with a Lateral Derived Table?**
A) It behaves exactly like a standard OUTER JOIN.
B) Lateral derived tables cannot be used with OUTER JOINs.
C) You must use `LEFT JOIN LATERAL (...) ON TRUE`.
D) It forces the query to become an INNER JOIN.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** To achieve an outer join effect where the left table's rows are kept even if the lateral subquery returns empty, you use `LEFT JOIN LATERAL (SELECT ...) AS alias ON TRUE` (or another join condition).
</details>

**Q85. Can a CTE be referenced inside another view's definition?**
A) Yes, views can be defined with queries containing `WITH` clauses.
B) No, views do not support CTEs.
C) Yes, but only non-recursive CTEs.
D) Yes, but the view must be materialized.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `CREATE VIEW` statement supports the use of the `WITH` clause, allowing you to encapsulate complex CTE logic within a reusable view.
</details>

**Q86. How does a single-row (scalar) subquery differ from a single-column (multi-row) subquery?**
A) Scalar returns multiple columns, single-column returns one.
B) Scalar returns exactly one cell (1 row, 1 column); single-column returns a list of values (N rows, 1 column).
C) Scalar is used in FROM, single-column in WHERE.
D) There is no difference.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A scalar subquery is guaranteed to return at most one single value. A single-column subquery can return many rows, creating a set of values typically used with `IN`, `ANY`, or `ALL`.
</details>

**Q87. What does the `EXISTS` operator evaluate to if the outer query has zero rows?**
A) TRUE
B) FALSE
C) NULL
D) The subquery is never executed because the outer query result set is empty.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** If the outer table evaluates to zero rows before reaching the `EXISTS` clause (or if the table is empty), the correlated subquery is never evaluated, and the final result set is simply empty.
</details>

**Q88. Which operator is most efficient for checking existence in a 1-to-many relationship without duplicating outer rows?**
A) INNER JOIN
B) EXISTS
C) CROSS JOIN
D) LEFT JOIN

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `EXISTS` is specifically designed for this. It stops evaluating as soon as it finds the first match in the child table, preventing duplicate parent rows (which an `INNER JOIN` might produce if not grouped).
</details>

**Q89. Can a lateral derived table reference a CTE defined in the same query?**
A) Yes, standard CTEs are accessible globally within the query, including inside lateral derived tables.
B) No, lateral derived tables can only reference base tables.
C) Yes, but only if the CTE is recursive.
D) No, the LATERAL keyword prevents CTE access.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Once a CTE is defined in the `WITH` clause, it acts as a temporary table for the duration of the query and can be referenced anywhere, including inside derived tables and lateral joins.
</details>

**Q90. In MySQL, which query is syntactically invalid?**
A) SELECT * FROM (SELECT 1)
B) SELECT * FROM (SELECT 1) AS t
C) WITH cte AS (SELECT 1) SELECT * FROM cte
D) SELECT (SELECT 1)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Query A is missing an alias for the derived table. MySQL mandates that every derived table in the FROM clause must have an alias.
</details>

**Q91. What is the scope of a column alias defined in the SELECT list of the outer query when used inside a correlated subquery?**
A) It is fully accessible.
B) It is not accessible in the subquery's WHERE clause because the SELECT list is processed after the WHERE clause.
C) It is accessible only if grouped by.
D) It is accessible only in the HAVING clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Due to logical query processing order, column aliases defined in the outer `SELECT` list cannot be referenced in the outer `WHERE` clause or in a subquery evaluated during the `WHERE` phase.
</details>

**Q92. Why might `SELECT COUNT(*) FROM t1 WHERE id IN (SELECT id FROM t2)` perform poorly on older MySQL versions?**
A) Because `IN` cannot use indexes.
B) Because it executes the subquery as a dependent subquery for every row in t1.
C) Because `COUNT(*)` ignores indexes.
D) Because subqueries cannot be counted.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL 5.5 and earlier, uncorrelated `IN` subqueries were notoriously optimized poorly, treating them as dependent (correlated) subqueries. MySQL 5.6+ resolved this with semi-join optimizations.
</details>

**Q93. What is a key benefit of using a recursive CTE for hierarchical data over traditional application-side recursion?**
A) It completely eliminates the need for database indexes.
B) It executes in a single database round-trip, significantly reducing network latency and application overhead.
C) It always uses less memory.
D) It converts the data to JSON automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By handling the recursion entirely within the database engine, recursive CTEs prevent the "N+1 queries" problem and save immense amounts of network round-trip time.
</details>

**Q94. If a recursive CTE traverses a graph that contains a cycle (a loop), what happens?**
A) MySQL detects it automatically and stops.
B) It enters an infinite loop until it hits `cte_max_recursion_depth` and then throws an error.
C) It ignores the cyclic row.
D) It converts the query to a CROSS JOIN.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL does not automatically detect cycles in graph data. If a loop exists, the CTE will recurse infinitely until it reaches the system limit (`cte_max_recursion_depth`), resulting in a query termination error.
</details>

**Q95. How can you prevent a recursive CTE from failing due to an infinite loop in cyclic data?**
A) By tracking visited nodes in a path string and checking if the next node is already in the path.
B) By using `LIMIT 1`.
C) By dropping foreign keys.
D) Infinite loops cannot be prevented in SQL.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A standard SQL technique is to concatenate node IDs into a string (e.g., `path = CONCAT(path, ',', id)`) during recursion and add a condition like `WHERE FIND_IN_SET(id, path) = 0` to prevent revisiting nodes.
</details>

**Q96. What is an anti-join?**
A) A join that uses the `!=` operator.
B) A pattern usually implemented via `NOT EXISTS` or `LEFT JOIN ... IS NULL` to find rows in one table that do not have matching rows in another.
C) A join that reverses the order of columns.
D) A deprecated join syntax.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** An anti-join retrieves rows from the left table that have no corresponding match in the right table. This is often written using `NOT EXISTS (subquery)`.
</details>

**Q97. When comparing `WHERE id NOT IN (SELECT id FROM t2)` and `WHERE NOT EXISTS (SELECT 1 FROM t2 WHERE t1.id = t2.id)`, which is safer regarding NULLs?**
A) `NOT IN` is safer.
B) `NOT EXISTS` is safer because it will not cause the entire query to fail if `t2.id` contains a NULL.
C) They are exactly the same in behavior.
D) Neither can handle NULLs.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If `t2` contains a NULL `id`, `NOT IN` will yield UNKNOWN for all comparisons, filtering out all rows. `NOT EXISTS` safely evaluates only whether matching non-NULL rows exist.
</details>

**Q98. In MySQL 8.0, how can you format the output of `EXPLAIN` to see if a subquery was materialized or executed as a semi-join?**
A) EXPLAIN FORMAT=JSON
B) EXPLAIN ANALYZE
C) SHOW WARNINGS after EXPLAIN
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** `EXPLAIN FORMAT=JSON` and `EXPLAIN ANALYZE` provide deep details about execution strategies (like `<materialize>` or `semi-join`). `SHOW WARNINGS` after a standard `EXPLAIN` shows the rewritten query.
</details>

**Q99. Can a Subquery be used in the `SET` clause of a `DELETE` statement?**
A) DELETE statements do not have a SET clause.
B) Yes, to set the deleted rows to a specific value.
C) No, only in UPDATE statements.
D) Yes, but only in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** This is a trick question. The `DELETE` statement is used to remove whole rows, so it does not possess a `SET` clause. Subqueries in `DELETE` statements are used in the `WHERE` clause.
</details>

**Q100. Which type of query can ALWAYS be rewritten as an equivalent JOIN?**
A) A correlated `NOT EXISTS` subquery.
B) A scalar subquery in the SELECT list containing an aggregate.
C) An uncorrelated `IN` subquery (without limits).
D) A recursive CTE.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Uncorrelated `IN` (or `= ANY`) subqueries essentially find matching keys, which logically perfectly maps to an `INNER JOIN` (specifically a semi-join to prevent duplicates). Other types like aggregations in SELECT lists or recursive queries cannot always be easily rewritten as simple joins.
</details>

**Q51. What is the fundamental difference between `INNER JOIN` and `CROSS JOIN` in standard SQL?**
A) INNER JOIN requires an ON clause, CROSS JOIN cannot have one.
B) CROSS JOIN requires an ON clause, INNER JOIN cannot have one.
C) INNER JOIN returns a Cartesian product, CROSS JOIN returns matched rows.
D) There is no difference; they are aliases.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** In standard SQL, an INNER JOIN requires a matching condition (ON clause), whereas a CROSS JOIN explicitly generates a Cartesian product and does not accept an ON clause. (Note: MySQL handles them slightly differently by making them equivalent if ON is omitted/provided).
</details>

**Q52. MySQL 8.0 introduces the `LATERAL` keyword. What does a `LATERAL` join allow you to do?**
A) Join tables from a remote database.
B) Allow a derived table (subquery in FROM clause) to reference columns from preceding tables in the same FROM clause.
C) Perform a join that executes in parallel.
D) Convert a LEFT JOIN into a RIGHT JOIN automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `LATERAL` allows a subquery in the FROM clause to act like a correlated subquery, referencing columns from tables declared earlier in the same FROM clause, evaluating row by row.
</details>

**Q53. Which of the following queries correctly uses a `LATERAL` join?**
A) SELECT * FROM t1, LATERAL (SELECT * FROM t2 WHERE t2.id = t1.id) AS sub;
B) SELECT * FROM t1 JOIN LATERAL t2 ON t1.id = t2.id;
C) SELECT LATERAL * FROM t1 JOIN t2;
D) SELECT * FROM t1 INNER JOIN LATERAL (SELECT id FROM t2) ON 1=1;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `LATERAL` is placed before a derived table (subquery). It allows the subquery to reference `t1.id`, which was defined earlier in the FROM clause.
</details>

**Q54. When joining two tables on a column containing NULLs (`a.val = b.val`), will the rows where `val` is NULL be joined?**
A) Yes, NULL equals NULL in SQL.
B) No, standard equality (`=`) evaluation for NULL against NULL returns NULL (falsey), so they will not join.
C) Yes, but only in a LEFT JOIN.
D) Yes, if you use the `USING` clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In SQL, `NULL = NULL` is not true. Therefore, rows with NULL values in the join columns will not match each other using the standard `=` operator.
</details>

**Q55. If you specifically want to join rows where the join columns might both be NULL, which operator should you use in the `ON` clause?**
A) =
B) IS NULL
C) <=> (Null-safe equal to)
D) LIKE

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The null-safe equal operator (`<=>`) returns 1 (true) if both operands are NULL, allowing you to successfully join rows where the key columns are both NULL.
</details>

**Q56. What happens if you perform a `LEFT JOIN` and put a condition for the LEFT table in the `WHERE` clause instead of the `ON` clause?**
A) It behaves like an INNER JOIN.
B) The condition is applied after the join, filtering the final result set normally.
C) It causes a Cartesian explosion.
D) It throws an error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** For the LEFT table, conditions in the WHERE clause act as standard filters applied to the result set after the join is processed. (Unlike conditions on the RIGHT table, which can convert it to an INNER JOIN).
</details>

**Q57. To find records in `TableA` that have NO corresponding records in `TableB`, which SQL pattern is commonly used?**
A) INNER JOIN with WHERE TableB.id = NULL
B) LEFT JOIN with WHERE TableB.id IS NULL
C) RIGHT JOIN with WHERE TableA.id IS NULL
D) CROSS JOIN with WHERE TableB.id IS NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This pattern is known as an anti-join. You perform a LEFT JOIN and then filter for `TableB.id IS NULL`, which isolates the rows from TableA that found no match in TableB.
</details>

**Q58. A `SELF JOIN` is often used to query hierarchical data. If you have an `employee_id` and a `manager_id` (which references `employee_id`), how do you list employees alongside their manager's name?**
A) SELECT e.name, m.name FROM emp e INNER JOIN emp m ON e.employee_id = m.manager_id
B) SELECT e.name, m.name FROM emp e INNER JOIN emp m ON e.manager_id = m.employee_id
C) SELECT e.name, m.name FROM emp e CROSS JOIN emp m WHERE e.employee_id = m.employee_id
D) SELECT name, name FROM emp GROUP BY manager_id

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By aliasing the table as `e` (employee) and `m` (manager), you join where the employee's `manager_id` equals the manager's `employee_id`.
</details>

**Q59. In the context of performance, what is a "Hash Join" in MySQL 8.0?**
A) A join that hashes passwords before comparing them.
B) An in-memory join algorithm used when no suitable indexes are available for an equi-join condition.
C) A physical index structure that must be created manually.
D) A join that automatically removes duplicate rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When MySQL 8.0 encounters an equi-join without an index, it creates an in-memory hash table for the smaller table and probes it with the larger table, significantly outperforming the old Block Nested-Loop algorithm.
</details>

**Q60. Can MySQL use a Hash Join if the ON condition uses a less-than (`<`) operator?**
A) Yes, Hash Joins support all operators.
B) No, Hash Joins are specifically designed for equi-joins (equality operators).
C) Yes, but it requires a special optimizer hint.
D) No, it falls back to Block Nested-Loop.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Hash Joins rely on hashing specific values to find matches. They only work for equi-join conditions (`=`). Non-equi joins without indexes will use other nested-loop strategies.
</details>

**Q61. What does the `EXPLAIN` keyword show when applied to a query with multiple JOINs?**
A) The query execution time in milliseconds.
B) The actual result set of the query.
C) The optimizer's execution plan, including table access order, join types, and index usage.
D) The SQL syntax errors in the query.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `EXPLAIN` outputs a breakdown of how the MySQL optimizer plans to execute the query, detailing the order tables are joined, algorithms used (e.g., hash join), and whether indexes are utilized.
</details>

**Q62. When using `EXPLAIN`, what does a `type` of `ALL` on the first table of a JOIN indicate?**
A) A full table scan is being performed on that table.
B) All indexes are being used perfectly.
C) All rows are matching in the join.
D) A Cartesian product is guaranteed.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A type of `ALL` means MySQL must scan the entire table sequentially because it cannot use an index to find the starting rows.
</details>

**Q63. You have `SELECT * FROM A LEFT JOIN B ON A.id = B.a_id AND B.status = 1`. What is the equivalent query using a subquery?**
A) SELECT * FROM A LEFT JOIN (SELECT * FROM B WHERE status = 1) B ON A.id = B.a_id
B) SELECT * FROM A WHERE A.id IN (SELECT a_id FROM B WHERE status = 1)
C) SELECT * FROM A INNER JOIN (SELECT * FROM B WHERE status = 1) B ON A.id = B.a_id
D) SELECT * FROM A CROSS JOIN B WHERE A.id = B.a_id AND B.status = 1

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Filtering `B` by `status = 1` before the left join (via a derived table/subquery) guarantees that unmatched `A` rows are still returned. Option B converts the logic into an INNER JOIN equivalent.
</details>

**Q64. In a complex database schema, how does MySQL decide the order in which to join multiple tables?**
A) It strictly follows the order written in the FROM clause.
B) The query optimizer evaluates various permutations and chooses the one with the lowest estimated cost.
C) It always starts with the table having the most rows.
D) It always starts with the table having the fewest columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL uses a cost-based optimizer that looks at table statistics, indexes, and row counts to determine the most efficient table execution sequence, often reordering the joins specified in the SQL query.
</details>

**Q65. How can you override the optimizer's join order if you believe it is making a poor choice?**
A) Use the `FORCE_ORDER` clause.
B) Use `STRAIGHT_JOIN` or optimizer hints like `/*+ JOIN_ORDER(...) */`.
C) Use `ORDER BY` before the `JOIN`.
D) Add more `LEFT JOIN` clauses.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can force the join order using the `STRAIGHT_JOIN` keyword in place of `JOIN`, or by using MySQL 8.0 optimizer hints.
</details>

**Q66. What is the impact of omitting the `ON` clause in an `INNER JOIN` in MySQL?**
A) It returns a syntax error.
B) It results in a Cartesian product (CROSS JOIN).
C) It automatically joins on primary keys.
D) It automatically joins on columns with the same name.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, `INNER JOIN` and `CROSS JOIN` are functionally equivalent. If you omit the `ON` condition, it falls back to evaluating a full Cartesian product.
</details>

**Q67. You want to delete rows from `Table1` that have matching rows in `Table2`. Which query achieves this using a JOIN?**
A) DELETE FROM Table1 JOIN Table2 ON Table1.id = Table2.id;
B) DELETE Table1 FROM Table1 INNER JOIN Table2 ON Table1.id = Table2.id;
C) DROP FROM Table1 INNER JOIN Table2 ON Table1.id = Table2.id;
D) DELETE * FROM Table1, Table2 WHERE Table1.id = Table2.id;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL supports multi-table `DELETE` syntax. You specify the table name(s) to delete from before the `FROM` keyword, followed by the standard JOIN syntax.
</details>

**Q68. How do you perform an `UPDATE` that relies on a join between two tables?**
A) UPDATE t1 SET t1.col = t2.col FROM t1 INNER JOIN t2 ON t1.id = t2.id
B) UPDATE t1 INNER JOIN t2 ON t1.id = t2.id SET t1.col = t2.col
C) UPDATE FROM t1, t2 SET t1.col = t2.col WHERE t1.id = t2.id
D) UPDATE (SELECT * FROM t1 JOIN t2 ON t1.id = t2.id) SET col = col

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The correct MySQL syntax for a multi-table update places the `JOIN` logic directly after the `UPDATE` keyword, followed by the `SET` clause.
</details>

**Q69. If you perform `A INNER JOIN B ON A.val != B.val`, what kind of join is this?**
A) Equi-join
B) Non-equi join
C) Natural join
D) Anti-join

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Any join where the matching condition uses an operator other than equality (`=`) is categorized as a non-equi join.
</details>

**Q70. You have a `Dates` table and a `Reservations` table with `start_date` and `end_date`. How do you join to find all dates that fall within a reservation?**
A) SELECT d.date FROM Dates d INNER JOIN Reservations r ON d.date = r.start_date AND d.date = r.end_date
B) SELECT d.date FROM Dates d INNER JOIN Reservations r ON d.date BETWEEN r.start_date AND r.end_date
C) SELECT d.date FROM Dates d CROSS JOIN Reservations r WHERE d.date = r.start_date
D) SELECT d.date FROM Dates d LEFT JOIN Reservations r ON d.date IN (r.start_date, r.end_date)

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A non-equi join using the `BETWEEN` operator allows you to match a single date against a range defined by two columns in the joined table.
</details>

**Q71. Consider a database with tables `Students`, `Classes`, and `Enrollments` (a junction table). How do you retrieve all students and the names of the classes they are enrolled in?**
A) SELECT s.name, c.name FROM Students s JOIN Classes c ON s.id = c.id
B) SELECT s.name, c.name FROM Students s JOIN Enrollments e ON s.id = e.student_id JOIN Classes c ON e.class_id = c.id
C) SELECT s.name, c.name FROM Students s CROSS JOIN Classes c
D) SELECT s.name, c.name FROM Students s, Classes c

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To resolve a many-to-many relationship, you must perform two joins: from the first entity table to the junction table, and then from the junction table to the second entity table.
</details>

**Q72. What is the result if Table A has 3 rows with `id = 1` and Table B has 2 rows with `id = 1`, and you perform an `INNER JOIN` on `id`?**
A) 2 rows
B) 3 rows
C) 5 rows
D) 6 rows

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The join evaluates every combination of matching keys. 3 rows in A multiplied by 2 rows in B (all sharing `id = 1`) results in a Cartesian product of those specific subsets: 3 x 2 = 6 rows.
</details>

**Q73. To prevent the multiplication of rows (Cartesian explosion on matching keys) when you only want to know IF a match exists, what is a better alternative to a standard `JOIN`?**
A) EXISTS subquery or IN subquery
B) CROSS JOIN
C) NATURAL JOIN
D) FULL OUTER JOIN

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If you only need columns from Table A and just want to verify a relationship in Table B without duplicating Table A rows, an `EXISTS (SELECT 1 FROM B...)` or `IN` subquery is safer and often more performant.
</details>

**Q74. Which join allows you to effectively pivot data by joining the same table multiple times on different conditions?**
A) CROSS JOIN
B) SELF JOIN
C) NATURAL JOIN
D) FULL JOIN

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By using a SELF JOIN, you can reference the same table multiple times in the `FROM` clause (with different aliases) to compare rows within the same table or transpose column data.
</details>

**Q75. You are debugging a query: `SELECT * FROM A, B, C WHERE A.id = B.a_id`. What is wrong with this?**
A) Commas cannot be used for more than two tables.
B) Table C is not participating in any join condition, resulting in a massive Cartesian product of (A matched with B) multiplied by all rows in C.
C) The WHERE clause must be an ON clause.
D) Nothing is wrong; MySQL handles it perfectly.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In the comma syntax, failing to provide a filter condition connecting table C to A or B results in an unintended CROSS JOIN between the (A+B) result set and the entirety of table C.
</details>

**Q76. Which of the following is equivalent to `LEFT OUTER JOIN`?**
A) LEFT JOIN
B) INNER JOIN
C) RIGHT JOIN
D) CROSS JOIN

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `OUTER` is an optional keyword in SQL. `LEFT JOIN` and `LEFT OUTER JOIN` are functionally identical.
</details>

**Q77. What happens if you use `RIGHT JOIN` but the right table has no rows at all?**
A) The query throws an error.
B) An empty result set (0 rows) is returned.
C) All rows from the left table are returned with NULLs.
D) One row with all NULLs is returned.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A RIGHT JOIN returns all rows from the right table. If the right table is completely empty (0 rows), the final result set will also be empty.
</details>

**Q78. How can you find duplicate values in a single table column using a JOIN?**
A) SELECT t1.val FROM t t1 CROSS JOIN t t2 ON t1.val = t2.val
B) SELECT DISTINCT t1.val FROM t t1 INNER JOIN t t2 ON t1.val = t2.val AND t1.primary_key != t2.primary_key
C) SELECT t1.val FROM t t1 LEFT JOIN t t2 ON t1.val = t2.val
D) You cannot use a JOIN for this; you must use GROUP BY.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A SELF JOIN matching on the value but insisting the primary keys are different (`t1.id != t2.id`) successfully identifies rows that share the same value but are distinct records.
</details>

**Q79. When using `USING (column_name)`, what restriction exists on `column_name`?**
A) It must be a primary key.
B) It must have the exact same name and compatible data type in both tables being joined.
C) It must be indexed in both tables.
D) It cannot contain NULL values.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `USING` clause relies on name matching. The specified column must exist with the identical name in both the left and right tables.
</details>

**Q80. In MySQL 8.0, how do CTEs (Common Table Expressions) interact with JOINs?**
A) CTEs cannot be joined with regular tables.
B) CTEs can be joined with other tables or CTEs just like standard tables or views.
C) CTEs must be CROSS JOINed only.
D) CTEs disable the use of INNER JOINs.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A CTE (defined via the `WITH` clause) acts as a temporary result set. Within the main query, it can be joined with physical tables, views, or other CTEs identically to a standard table.
</details>

**Q81. You execute: `SELECT * FROM t1 JOIN t2 ON t1.c1 = t2.c1 AND t1.c2 = t2.c2`. This is an example of:**
A) A non-equi join.
B) A composite key join.
C) A lateral join.
D) A Cartesian product.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Joining on multiple columns (usually because the primary/foreign key relationship is a composite key made of multiple columns) ensures an exact match across the entire key combination.
</details>

**Q82. If table `A` has columns `(id, name)` and table `B` has columns `(id, name)`, what does `SELECT * FROM A NATURAL JOIN B` join on?**
A) Only the `id` column.
B) Both `id` and `name` columns.
C) Only the primary key column.
D) It results in an error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NATURAL JOIN` implicitly joins on ALL columns that share the exact same name across both tables. In this case, it will act as `ON A.id = B.id AND A.name = B.name`.
</details>

**Q83. Which of the following clauses applies its filter *before* the LEFT JOIN expands the result set?**
A) The ON clause
B) The WHERE clause
C) The HAVING clause
D) The ORDER BY clause

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `ON` clause dictates how tables are joined and evaluates the relationship *during* the join phase. The `WHERE` clause applies filters *after* the join has generated the logical result set.
</details>

**Q84. Why might `SELECT * FROM A LEFT JOIN B ON A.id = B.id WHERE B.status = 'ACTIVE'` return fewer rows from `A` than exist in `A`?**
A) LEFT JOIN natively drops rows if they don't match.
B) The WHERE clause forces rows with NULL in `B.status` (unmatched `A` rows) to be discarded, converting it into an INNER JOIN.
C) `ACTIVE` is not a valid MySQL status.
D) The ON clause is written incorrectly.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Unmatched rows from A will have NULL for `B.status`. Since `NULL = 'ACTIVE'` is false, the WHERE clause filters out all unmatched rows, effectively negating the LEFT JOIN.
</details>

**Q85. To fix the query in Q84 so it returns all rows from `A`, how should it be rewritten?**
A) SELECT * FROM A INNER JOIN B ON A.id = B.id AND B.status = 'ACTIVE'
B) SELECT * FROM A LEFT JOIN B ON A.id = B.id AND B.status = 'ACTIVE'
C) SELECT * FROM A LEFT JOIN B ON A.id = B.id OR B.status = 'ACTIVE'
D) SELECT * FROM A RIGHT JOIN B ON A.id = B.id WHERE B.status = 'ACTIVE'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Moving the condition to the `ON` clause means it restricts which rows from `B` are joined, but the core mechanic of `LEFT JOIN` (preserving all rows from `A`) remains intact.
</details>

**Q86. What is a "Semi-Join" in MySQL terminology?**
A) A join that only returns half the columns.
B) A join optimization strategy used internally for `IN` or `EXISTS` subqueries, returning rows from the outer query if a match is found in the inner query, without duplicating rows.
C) A join that uses a partial index.
D) A join without an ON clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A semi-join is an optimizer concept. When resolving `WHERE x IN (SELECT y FROM table2)`, MySQL uses semi-join optimizations to find matches without doing a full Cartesian product or duplicating rows of the outer table.
</details>

**Q87. What is an "Anti-Join"?**
A) A query optimized to find rows in one table that DO NOT have matches in another.
B) A JOIN syntax deprecated in MySQL 8.0.
C) A join that automatically deletes duplicate records.
D) Joining a table with a reversed table.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** An anti-join returns rows from the left side that have no matches on the right side. It is typically implemented using a `LEFT JOIN ... WHERE right_table.id IS NULL` or `NOT EXISTS`.
</details>

**Q88. How does `FULL OUTER JOIN` handling in MySQL differ from PostgreSQL?**
A) MySQL uses the `FULL OUTER JOIN` keyword natively, PostgreSQL requires unions.
B) PostgreSQL supports `FULL OUTER JOIN` natively, while MySQL requires combining a LEFT JOIN and RIGHT JOIN with `UNION`.
C) They both support it identically.
D) MySQL only supports it via the `CROSS JOIN` keyword.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Standard SQL `FULL OUTER JOIN` is natively supported by PostgreSQL, SQL Server, and Oracle, but is notoriously absent in MySQL, requiring a `UNION` workaround.
</details>

**Q89. If a table has a foreign key referencing another table, does MySQL automatically join them if you don't specify a JOIN clause?**
A) Yes, if you use the SELECT * FROM A, B syntax without WHERE.
B) Yes, foreign keys create implicit joins.
C) No, foreign keys enforce referential integrity but do not dictate query join behavior; explicit JOIN clauses are always required.
D) Yes, but only in views.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Foreign keys are for data integrity constraints. The SQL engine does not automatically join tables based on foreign keys; the developer must explicitly define all joins in the query.
</details>

**Q90. When designing a database schema, why is it beneficial to index columns that are frequently used in `JOIN ... ON` clauses?**
A) It prevents the use of OUTER JOINs.
B) It allows the MySQL optimizer to use fast lookup algorithms (like index nested-loop) instead of scanning the entire table for every row of the joined table.
C) It automatically turns them into primary keys.
D) It encrypts the join operation.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Indexes on join columns drastically reduce the amount of data the engine needs to read, converting slow full table scans into extremely fast B-Tree lookups.
</details>

**Q91. Can you use aliases for table names in a JOIN?**
A) Yes, and they are mandatory for SELF JOINs.
B) Yes, but only for INNER JOINs.
C) No, table aliases are only for the SELECT clause.
D) No, they cause parsing errors in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Table aliases (e.g., `FROM users u JOIN orders o`) simplify queries and are absolutely required when joining a table to itself (SELF JOIN) to distinguish the different instances.
</details>

**Q92. Which keyword can be used to prevent duplicate rows resulting from a one-to-many JOIN?**
A) UNIQUE
B) DISTINCT
C) FILTER
D) ONLY

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Adding `DISTINCT` to the `SELECT` clause forces MySQL to remove duplicate rows from the final result set, which is a common quick fix for row duplication caused by one-to-many joins.
</details>

**Q93. What is the impact of a `JOIN` on a very large table without any `WHERE` filter?**
A) The query will execute in constant time.
B) The query might exhaust temporary storage space or memory (Temp table size limit).
C) It will automatically be aborted by MySQL.
D) It will only return the first 1000 rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Large joins can generate massive intermediate result sets. If these exceed memory limits (tmp_table_size), MySQL writes them to disk, heavily impacting I/O and performance.
</details>

**Q94. You write: `SELECT * FROM (A JOIN B ON A.id=B.id) JOIN C ON B.id=C.id`. Are the parentheses required?**
A) Yes, MySQL requires them to define join order.
B) No, MySQL allows chained joins without parentheses, and evaluates them sequentially left-to-right.
C) Yes, otherwise a syntax error is thrown.
D) No, but they speed up the query significantly.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Parentheses in the FROM clause are valid for overriding join logic order, but standard chained JOINs do not require them and naturally evaluate left-to-right.
</details>

**Q95. Consider `t1 LEFT JOIN t2 ON t1.id = t2.id AND t1.type = 'admin'`. What happens to rows in `t1` where `type != 'admin'`?**
A) They are filtered out of the results.
B) They are returned, but matched with NULLs from `t2` because the ON condition evaluates to false for those rows.
C) They cause an error.
D) They are matched with `t2` anyway.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because it is a LEFT JOIN, all rows from `t1` are preserved. If a row in `t1` does not have `type = 'admin'`, the ON condition is false, meaning it finds no match in `t2`, so it gets NULLs for `t2` columns.
</details>

**Q96. What is the main characteristic of an "Equi-Join"?**
A) It uses equal number of tables.
B) It uses the equality operator (`=`) in the `ON` or `WHERE` clause to match columns.
C) It returns an equal number of rows from both tables.
D) It is an obsolete term for OUTER JOIN.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** An equi-join strictly uses the equality operator to combine rows. Most typical primary key to foreign key joins are equi-joins.
</details>

**Q97. In a star schema data warehouse, joining the central fact table to multiple dimension tables is typically done using:**
A) FULL OUTER JOINs
B) CROSS JOINs
C) INNER JOINs or LEFT JOINs
D) NATURAL JOINs

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Star schemas rely on joining the central fact table outward to dimensions via foreign keys, almost always using INNER JOINs (if integrity is guaranteed) or LEFT JOINs.
</details>

**Q98. How does a `RIGHT JOIN` behave differently from a `LEFT JOIN` conceptually?**
A) It processes data faster.
B) It preserves the un-matched rows of the table defined on the right side of the JOIN keyword, rather than the left.
C) It joins tables backwards.
D) It removes NULLs automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The only difference is the "direction" of preservation. `LEFT JOIN` preserves the first table; `RIGHT JOIN` preserves the second table.
</details>

**Q99. You see this query: `SELECT * FROM employees e1 JOIN employees e2 USING(department_id)`. What is a potential issue with this SELF JOIN?**
A) It is perfectly fine and standard.
B) `USING` cannot be used with SELF JOINs because the column names are identical.
C) It will pair every employee with every other employee in the same department, including themselves, causing a localized Cartesian explosion per department.
D) It will return 0 rows.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Joining on just `department_id` means an employee matches with themselves AND everyone else in the department. You usually need an additional condition like `e1.id != e2.id` to prevent self-pairing.
</details>

**Q100. Which system variable controls the maximum size of the in-memory temporary tables often used during complex JOINs before they are written to disk?**
A) max_join_size
B) tmp_table_size and max_heap_table_size
C) join_buffer_size
D) memory_limit

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `tmp_table_size` and `max_heap_table_size` determine how large a temporary table (often created for sorting or joining) can grow in memory before MySQL converts it to an on-disk temporary table.
</details>

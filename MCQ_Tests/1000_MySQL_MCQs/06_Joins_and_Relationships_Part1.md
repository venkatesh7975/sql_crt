**Q1. Which of the following clauses is used to combine rows from two or more tables based on a related column between them?**
A) COMBINE
B) MERGE
C) JOIN
D) APPEND

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The JOIN clause is specifically used in SQL to combine rows from two or more tables based on a related column between them.
</details>

**Q2. What is the default type of JOIN in MySQL if you simply use the keyword `JOIN` without any prefix?**
A) LEFT JOIN
B) RIGHT JOIN
C) INNER JOIN
D) CROSS JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, specifying `JOIN` without any prefix (like LEFT, RIGHT, or CROSS) defaults to an `INNER JOIN`.
</details>

**Q3. Which type of join returns only the rows where there is a match in both tables?**
A) LEFT JOIN
B) FULL OUTER JOIN
C) INNER JOIN
D) CROSS JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** An INNER JOIN returns only those rows that have matching values in both tables based on the join condition.
</details>

**Q4. In an `INNER JOIN` query, what happens to rows in the left table that do not have a matching row in the right table?**
A) They are included in the result set with NULL values for the right table's columns.
B) They are excluded from the result set.
C) They cause an error to be thrown.
D) They are included in the result set without any right table columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** INNER JOIN strictly requires a match in both tables. Unmatched rows from either table are entirely excluded from the result set.
</details>

**Q5. Consider `Table_A` with 5 rows and `Table_B` with 10 rows. If every row in `Table_A` matches exactly one row in `Table_B`, how many rows will an `INNER JOIN` return?**
A) 5
B) 10
C) 15
D) 50

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Since each of the 5 rows in Table_A finds exactly one match in Table_B, the resulting joined table will have exactly 5 rows.
</details>

**Q6. Which keyword is typically used alongside the `JOIN` keyword to specify the column(s) used for matching rows?**
A) WHERE
B) ON
C) MATCH
D) USING

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ON` clause is standard for specifying the exact condition (usually equating columns) for a JOIN. `USING` can also be used if the column names are identical, but `ON` is the general keyword.
</details>

**Q7. If you join two tables on a column named `id` that exists in both tables, which of the following is valid syntax?**
A) JOIN table2 USING (id)
B) JOIN table2 ON id = id
C) JOIN table2 MATCHING id
D) JOIN table2 WHERE id = id

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `USING (id)` is a valid and shorthand syntax when the join column has the exact same name in both tables. `ON id = id` is ambiguous without table aliases.
</details>

**Q8. Which of the following best describes a `LEFT JOIN` (or `LEFT OUTER JOIN`)?**
A) Returns all rows from the right table, and matched rows from the left table.
B) Returns all rows from the left table, and matched rows from the right table.
C) Returns only rows that match in both tables.
D) Returns the Cartesian product of both tables.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A LEFT JOIN ensures all rows from the left (first) table are returned, filling in NULLs for the right table's columns if there is no match.
</details>

**Q9. In a `LEFT JOIN` between `Customers` and `Orders`, what value is populated for `Orders.OrderDate` if a customer has not placed any orders?**
A) '0000-00-00'
B) 0
C) NULL
D) Empty string

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When there is no matching row in the right table (Orders) for a left table (Customers) row, MySQL returns NULL for all columns from the right table.
</details>

**Q10. What is the difference between `LEFT JOIN` and `LEFT OUTER JOIN` in MySQL?**
A) `LEFT JOIN` excludes NULLs, while `LEFT OUTER JOIN` includes them.
B) `LEFT OUTER JOIN` is not supported in MySQL.
C) `LEFT JOIN` requires an ON clause, `LEFT OUTER JOIN` does not.
D) There is no difference; they are completely synonymous.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** In standard SQL and MySQL, `LEFT JOIN` and `LEFT OUTER JOIN` mean the exact same thing; `OUTER` is an optional keyword.
</details>

**Q11. You want to find all employees who do NOT have an assigned department. You perform a `LEFT JOIN` from `Employees` to `Departments`. Which `WHERE` clause filters correctly?**
A) WHERE Departments.DepartmentID = NULL
B) WHERE Departments.DepartmentID IS NULL
C) WHERE Employees.DepartmentID IS NOT NULL
D) WHERE Departments.DepartmentID = 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** After a LEFT JOIN, unmatched rows will have NULLs for the right table's columns. You must use `IS NULL` to check for this absence of a match.
</details>

**Q12. What does a `RIGHT JOIN` do in MySQL?**
A) Returns all rows from the left table, and matched rows from the right.
B) Returns only unmatched rows from the right table.
C) Returns all rows from the right table, and matched rows from the left table.
D) Reverses the column order in the SELECT output.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A RIGHT JOIN guarantees all rows from the right table are returned, pairing them with NULLs for left table columns if no match exists.
</details>

**Q13. How can any `RIGHT JOIN` be rewritten without changing the result set?**
A) As an `INNER JOIN`
B) As a `LEFT JOIN` by swapping the table order
C) As a `CROSS JOIN` with a WHERE clause
D) As a `FULL OUTER JOIN`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `A RIGHT JOIN B` is logically equivalent to `B LEFT JOIN A`. Swapping the tables and using a LEFT JOIN achieves the same result.
</details>

**Q14. Which syntax is NOT supported natively in MySQL 8.0?**
A) LEFT OUTER JOIN
B) RIGHT OUTER JOIN
C) FULL OUTER JOIN
D) CROSS JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL does not have a native `FULL OUTER JOIN` syntax. It must be emulated using a `LEFT JOIN`, `UNION`, and `RIGHT JOIN`.
</details>

**Q15. How do you emulate a `FULL OUTER JOIN` between Table A and Table B in MySQL?**
A) Select A CROSS JOIN B
B) (A LEFT JOIN B) UNION (A RIGHT JOIN B)
C) (A INNER JOIN B) UNION ALL (A CROSS JOIN B)
D) A LEFT JOIN B AND A RIGHT JOIN B

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To emulate a FULL OUTER JOIN, you take the result of a LEFT JOIN and combine it with the result of a RIGHT JOIN using the `UNION` operator to eliminate duplicates.
</details>

**Q16. What is the result of a `CROSS JOIN` between a table with 4 rows and a table with 5 rows (assuming no WHERE clause)?**
A) 4 rows
B) 5 rows
C) 9 rows
D) 20 rows

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A CROSS JOIN produces a Cartesian product, multiplying the number of rows from the first table by the number of rows from the second table (4 x 5 = 20).
</details>

**Q17. What is a "Cartesian Explosion"?**
A) A syntax error caused by joining too many tables.
B) The massive, unintended output of rows when tables are joined without proper join conditions (effectively a CROSS JOIN).
C) A performance optimization technique in MySQL 8.0.
D) The automatic dropping of duplicate rows during a JOIN.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A Cartesian Explosion occurs when join conditions are omitted or flawed, resulting in an exponentially large Cartesian product that consumes excessive memory and CPU.
</details>

**Q18. In MySQL, what happens if you write `SELECT * FROM table1 JOIN table2;` without an ON or USING clause?**
A) It returns an error.
B) It defaults to an INNER JOIN on primary keys.
C) It behaves as a CROSS JOIN.
D) It returns an empty set.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, if you omit the `ON` condition for a `JOIN` or `INNER JOIN`, it automatically behaves as a `CROSS JOIN`, producing the Cartesian product.
</details>

**Q19. What is a `SELF JOIN`?**
A) A specific keyword used to join a table to itself.
B) A technique where a table is joined with itself using table aliases.
C) A join that automatically removes duplicate columns.
D) A join that does not require an ON clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** There is no `SELF JOIN` keyword. It is a logical concept where you join a table to itself using `INNER JOIN` or `LEFT JOIN`, distinguishing the instances via table aliases.
</details>

**Q20. When performing a SELF JOIN to find employees and their managers from a single `Employees` table, what is absolutely required?**
A) A CROSS JOIN keyword
B) Table aliases (e.g., e1, e2)
C) A FULL OUTER JOIN
D) A GROUP BY clause

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because you are referring to the same table twice in the same query, you must assign different aliases to each instance so MySQL knows which one you are referencing.
</details>

**Q21. Given `SELECT * FROM A, B WHERE A.id = B.id;`, what type of join is this implicitly performing?**
A) LEFT JOIN
B) CROSS JOIN
C) INNER JOIN
D) FULL JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The comma-separated table syntax with a WHERE clause filtering the keys is the older ANSI SQL-89 standard equivalent to an INNER JOIN.
</details>

**Q22. What is the primary disadvantage of using the comma syntax (`FROM A, B WHERE...`) instead of explicit `JOIN ... ON ...` syntax?**
A) It executes slower in MySQL.
B) It cannot use indexes.
C) It mixes join conditions with filter conditions, making the query harder to read and prone to Cartesian explosions if the WHERE clause is forgotten.
D) It only supports LEFT JOINs.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Explicit JOIN syntax separates the relationship logic (`ON`) from the filtering logic (`WHERE`), reducing the risk of accidental CROSS JOINs and improving readability.
</details>

**Q23. Can you chain multiple JOINs in a single SQL statement?**
A) No, only two tables can be joined per query.
B) Yes, you can join multiple tables sequentially in the FROM clause.
C) Yes, but only if they are all INNER JOINs.
D) Yes, but you must use subqueries for more than two tables.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can chain multiple JOIN clauses (e.g., `FROM A JOIN B ON... JOIN C ON...`) to combine data from many tables in a single query.
</details>

**Q24. In a multi-table join `FROM A LEFT JOIN B ON... LEFT JOIN C ON...`, which of the following is true?**
A) Table A is joined to the Cartesian product of B and C.
B) The result of joining A and B is then left-joined with C.
C) Table C is left-joined to B independently of A.
D) The order of joins does not matter at all for LEFT JOINs.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Joins are evaluated sequentially from left to right. The intermediate result of `A LEFT JOIN B` becomes the left side of the next `LEFT JOIN C`.
</details>

**Q25. What happens if you place a filter condition for the right table of a `LEFT JOIN` in the `WHERE` clause instead of the `ON` clause?**
A) It behaves exactly the same.
B) It effectively turns the `LEFT JOIN` into an `INNER JOIN`.
C) It throws a syntax error.
D) It forces a CROSS JOIN.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If you put a condition like `WHERE right_table.status = 'Active'`, it rejects the NULLs created by the LEFT JOIN for unmatched rows, effectively converting it into an INNER JOIN.
</details>

**Q26. If you want to keep all rows from the left table in a `LEFT JOIN`, but only want to join right table rows that meet a certain condition, where should that condition go?**
A) In the WHERE clause
B) In the SELECT clause
C) In the ON clause
D) In a HAVING clause

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Adding the condition to the `ON` clause (e.g., `ON a.id = b.id AND b.status = 'Active'`) restricts which rows from the right table are joined, while still preserving all rows from the left table.
</details>

**Q27. The `NATURAL JOIN` clause in MySQL joins tables based on:**
A) All columns with the same name and compatible data types in both tables.
B) Primary and foreign key constraints explicitly defined in the schema.
C) The first column of each table.
D) The columns specified in the USING clause.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A NATURAL JOIN automatically creates an implicit join condition matching all columns that have the exact same name in both tables.
</details>

**Q28. Why is `NATURAL JOIN` generally considered dangerous or discouraged in production code?**
A) It is much slower than INNER JOIN.
B) It requires a FULL OUTER JOIN to work.
C) Adding a new column with a matching name to both tables in the future can silently change the join condition and break the query.
D) It cannot be used with views.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Because NATURAL JOIN implicitly joins on column names, unexpected schema changes (like adding a `created_at` column to both tables) will alter the join logic without warning.
</details>

**Q29. Consider `SELECT * FROM T1 LEFT JOIN T2 ON T1.id = T2.t1_id`. If `T1` has 3 rows and `T2` has 0 rows, how many rows will be returned?**
A) 0
B) 1
C) 3
D) 6

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Because it's a LEFT JOIN, all 3 rows from T1 are returned. Since T2 is empty, the T2 columns for those 3 rows will just be populated with NULL.
</details>

**Q30. Which join type can be used to generate all possible combinations of products and colors for a catalog?**
A) INNER JOIN
B) LEFT JOIN
C) CROSS JOIN
D) NATURAL JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A CROSS JOIN creates a Cartesian product, which perfectly generates every possible combination of rows from the first table (products) with rows from the second table (colors).
</details>

**Q31. Which of the following is equivalent to `SELECT * FROM A CROSS JOIN B`?**
A) SELECT * FROM A LEFT JOIN B ON 1=1
B) SELECT * FROM A INNER JOIN B ON 1=1
C) SELECT * FROM A, B
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** All of these syntaxes will produce a Cartesian product in MySQL. `INNER JOIN ON 1=1` and comma syntax without a WHERE clause both evaluate to a CROSS JOIN.
</details>

**Q32. When emulating a FULL OUTER JOIN using `UNION`, why should you use `UNION` instead of `UNION ALL`?**
A) `UNION` executes faster.
B) `UNION ALL` throws an error with joins.
C) `UNION ALL` will duplicate the rows that matched in both the LEFT and RIGHT joins.
D) `UNION` preserves NULL values better.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `UNION ALL` does not remove duplicates. Since the INNER JOIN portion is returned by both the LEFT JOIN and the RIGHT JOIN, `UNION ALL` would result in duplicates for matched rows. `UNION` removes these duplicates.
</details>

**Q33. To optimize a query emulating a FULL OUTER JOIN, one can use `LEFT JOIN ... UNION ALL ... RIGHT JOIN ... WHERE left_table.id IS NULL`. Why does this work?**
A) It avoids evaluating the right table twice.
B) The WHERE clause restricts the RIGHT JOIN to only return rows that were NOT already included by the LEFT JOIN, preventing duplicates and allowing the faster `UNION ALL`.
C) It converts the UNION ALL into a standard UNION.
D) It forces the optimizer to use a hash join.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By selecting only the unmatched rows from the RIGHT JOIN (`WHERE left_table.id IS NULL`), you ensure no overlap with the LEFT JOIN's results, allowing you to safely use the more performant `UNION ALL`.
</details>

**Q34. In MySQL 8.0, what does `STRAIGHT_JOIN` do?**
A) It acts as an INNER JOIN but forces the optimizer to read the left table before the right table.
B) It straightens out JSON arrays within joined columns.
C) It ignores all NULL values in both tables.
D) It prevents Cartesian explosions by throwing an error if ON is omitted.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `STRAIGHT_JOIN` is a MySQL-specific keyword identical to `JOIN`, except it strictly enforces the table reading order (left table first), bypassing the optimizer's join order decisions.
</details>

**Q35. If you need to join three tables (A, B, C) and you use `STRAIGHT_JOIN`, what happens?**
A) A is joined to B, then the result is joined to C, exactly in that sequence.
B) The optimizer chooses the best sequence but uses hash joins.
C) C is joined to B, then to A.
D) An error occurs; `STRAIGHT_JOIN` only supports two tables.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `STRAIGHT_JOIN` forces the execution plan to join the tables in the exact order they are listed in the `FROM` clause.
</details>

**Q36. You have a query: `SELECT * FROM orders o INNER JOIN customers c USING (customer_id);`. How does the output differ from `ON o.customer_id = c.customer_id`?**
A) There is no difference in the output.
B) `USING` ensures that `customer_id` appears only once in the result set, while `ON` includes `customer_id` twice (once for each table) when using `SELECT *`.
C) `USING` returns an error if `SELECT *` is used.
D) `ON` removes duplicate columns automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `USING` clause coalesces the matched columns, meaning `SELECT *` will only return one `customer_id` column. With `ON`, `SELECT *` returns `o.customer_id` and `c.customer_id` as separate columns.
</details>

**Q37. Can you join a table on multiple conditions?**
A) No, `ON` only supports a single column equality check.
B) Yes, by separating conditions with commas.
C) Yes, by using `AND` or `OR` logical operators within the `ON` clause.
D) Yes, but only by using multiple `JOIN` clauses for the same table.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `ON` clause supports complex boolean expressions, including multiple conditions connected by `AND` or `OR` (e.g., `ON a.id = b.id AND a.type = b.type`).
</details>

**Q38. What is the behavior of `JOIN` with an inequality operator in the `ON` clause (e.g., `ON A.date > B.date`)?**
A) It throws a syntax error; joins must use equality (`=`).
B) It creates a non-equi join, matching rows based on the range/inequality condition.
C) It behaves as a CROSS JOIN.
D) It only matches the first row that satisfies the condition.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This is called a non-equi join. MySQL perfectly supports joins based on inequalities (`<`, `>`, `<=`, `>=`, `!=`, `BETWEEN`), matching rows that fulfill the specified logic.
</details>

**Q39. In a hierarchical table representing employees, where `manager_id` references `emp_id` in the same table, how do you find all employees who are managers?**
A) SELECT e1.* FROM employees e1 LEFT JOIN employees e2 ON e1.manager_id = e2.emp_id
B) SELECT DISTINCT e1.* FROM employees e1 INNER JOIN employees e2 ON e1.emp_id = e2.manager_id
C) SELECT e1.* FROM employees e1 CROSS JOIN employees e2
D) SELECT * FROM employees WHERE manager_id = emp_id

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By performing a SELF JOIN matching `e1.emp_id` to `e2.manager_id`, `e1` represents the manager. Using `DISTINCT` ensures managers with multiple subordinates are listed only once.
</details>

**Q40. Which statement is true regarding indexes and joins in MySQL 8.0?**
A) Indexes are useless during a JOIN operation.
B) MySQL automatically creates temporary indexes for all joins.
C) Creating indexes on the columns used in the `ON` clause can significantly speed up JOIN performance.
D) You can only join tables if they have primary keys defined.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Join performance relies heavily on indexing. If the columns involved in the `ON` condition are indexed, MySQL can quickly locate matching rows without doing full table scans.
</details>

**Q41. Consider two tables: `posts` and `comments`. You want to list every post, and if it has comments, show the number of comments. Which join must you use?**
A) INNER JOIN
B) CROSS JOIN
C) LEFT JOIN
D) RIGHT JOIN

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A LEFT JOIN from `posts` to `comments` ensures that posts with zero comments are still included in the result set, paired with NULLs (which can be counted as 0).
</details>

**Q42. In an outer join, what does MySQL return for columns of a row that has no match in the joined table?**
A) An empty string
B) A default value defined in the schema
C) NULL
D) Zero

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When a row from the preserved table in an OUTER JOIN (LEFT or RIGHT) does not find a match, the database fills all columns from the un-matched table with NULL.
</details>

**Q43. Is it possible to use a `LEFT JOIN` and a `RIGHT JOIN` in the same query?**
A) Yes, they can be chained together in the same FROM clause.
B) No, they are mutually exclusive.
C) Only if they are inside a UNION.
D) Yes, but only if they reference the exact same two tables.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can mix different types of joins in a single query (e.g., `FROM A LEFT JOIN B ON... RIGHT JOIN C ON...`), though mixing directions can make the query logic difficult to understand.
</details>

**Q44. What happens when a JOIN results in duplicate column names in the SELECT clause (e.g., `SELECT *`)?**
A) MySQL throws an error stating "Column name is ambiguous".
B) MySQL returns both columns with identical names.
C) MySQL automatically drops one of the duplicate columns.
D) MySQL prefixes the columns with the table names automatically in the output.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When using `SELECT *`, MySQL will output multiple columns with the exact same name. However, if you explicitly reference an ambiguous column in `WHERE` or `SELECT` without a table alias, it throws an error.
</details>

**Q45. How does MySQL 8.0 handle the execution of a `CROSS JOIN` that is filtered by a `WHERE` clause matching keys?**
A) It executes a full Cartesian product and then filters it in memory.
B) The optimizer recognizes the condition and executes it as an efficient INNER JOIN.
C) It throws a syntax warning.
D) It uses a block nested-loop join regardless of indexes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL's optimizer is smart enough to convert `CROSS JOIN ... WHERE a.id = b.id` (or comma syntax) into an efficient INNER JOIN plan using indexes.
</details>

**Q46. Which JOIN algorithm was introduced in MySQL 8.0 to improve the performance of joins that lack indexes, replacing Block Nested-Loop?**
A) Hash Join
B) Sort-Merge Join
C) Index Nested-Loop
D) Lateral Join

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL 8.0.18 introduced Hash Joins, which are heavily used to optimize equi-joins that don't have suitable indexes, completely replacing the older Block Nested-Loop algorithm.
</details>

**Q47. If you join `TableA` with 1,000 rows and `TableB` with 1,000 rows without an `ON` clause, what is the size of the result set?**
A) 1,000 rows
B) 2,000 rows
C) 100,000 rows
D) 1,000,000 rows

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Without an ON clause, it performs a CROSS JOIN (Cartesian product). 1,000 rows * 1,000 rows = 1,000,000 rows. This is a classic Cartesian explosion.
</details>

**Q48. You want to retrieve data from `Orders` and their corresponding `Customers`. If you use `NATURAL LEFT JOIN`, what potential risk do you run?**
A) It will perform an INNER JOIN instead.
B) It might join on unintended columns if both tables have columns like `created_at` or `status`.
C) It restricts the output to only 100 rows.
D) It drops the primary keys from the output.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NATURAL JOIN` (even LEFT) matches ALL columns with identical names. If `Orders` and `Customers` both have a `created_at` column, it will require them to match perfectly, which is likely unintended and will exclude valid rows.
</details>

**Q49. In a one-to-many relationship (e.g., one Author has many Books), an `INNER JOIN` from Authors to Books will:**
A) Return one row for every Author, concatenating their books into a single string.
B) Duplicate the Author information for each Book they have written.
C) Drop Authors who have written more than one book.
D) Return exactly the number of rows as there are Authors.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In a one-to-many join, the data from the "one" side (Author) is repeated for every matching row on the "many" side (Book).
</details>

**Q50. How does a `JOIN` differ from a `UNION`?**
A) JOIN combines columns side-by-side; UNION combines rows vertically.
B) JOIN combines rows vertically; UNION combines columns side-by-side.
C) There is no difference; they are interchangeable.
D) JOIN requires matching data types, UNION does not.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A JOIN merges columns from different tables horizontally based on a related key. A UNION appends rows from one query vertically to the rows of another query.
</details>

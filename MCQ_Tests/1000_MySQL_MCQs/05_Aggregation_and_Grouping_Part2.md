# MySQL 8.0 Aggregation and Grouping - Part 2

**Q51. What happens when you group by multiple columns (e.g., `GROUP BY col1, col2`)?**
A) MySQL groups only by the first column and ignores the second.
B) MySQL groups by unique combinations of values from both columns.
C) MySQL throws an error because only one column can be grouped.
D) MySQL calculates separate group subtotals for each column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When multiple columns are specified, the result set is divided into groups based on the unique combination of values across all the specified columns.
</details>

**Q52. Are you allowed to group by a function or expression in MySQL? (e.g., `GROUP BY YEAR(order_date)`)**
A) Yes, MySQL supports grouping by expressions and functions.
B) No, `GROUP BY` only accepts standard column names.
C) Yes, but only mathematical functions are allowed.
D) No, expressions must be aliased in the SELECT list first, and then the alias must be grouped.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL allows grouping by arbitrary expressions, such as `YEAR(order_date)` or `salary * 10`, without requiring an alias (though using an alias is common practice).
</details>

**Q53. Can you use aggregate functions in the `GROUP BY` clause? (e.g., `GROUP BY SUM(salary)`)**
A) Yes, it groups by the summed values.
B) No, it throws a syntax error because aggregate functions cannot be used in `GROUP BY`.
C) Yes, but only in strict SQL mode.
D) No, it simply ignores the aggregate function and groups by the column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You cannot group by an aggregate function. Aggregations evaluate after the groups are formed, creating a logical paradox if they were used to define the groups.
</details>

**Q54. What is the `ANY_VALUE()` function used for in MySQL 8.0?**
A) It returns a random row from the entire table.
B) It checks if any value in a group is NULL.
C) It bypasses the `ONLY_FULL_GROUP_BY` restriction by picking an arbitrary value from a group.
D) It returns a boolean true if any value exists.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `ANY_VALUE()` tells MySQL to pick an arbitrary value from the group for a non-aggregated column, making it valid under `ONLY_FULL_GROUP_BY` mode.
</details>

**Q55. Does `ANY_VALUE()` guarantee which specific row's value it returns?**
A) Yes, it returns the minimum value.
B) Yes, it returns the maximum value.
C) Yes, it returns the value from the row with the lowest primary key.
D) No, the returned value is arbitrary and non-deterministic.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** `ANY_VALUE()` does not guarantee sorting or determinism; it simply returns the first value the optimizer happens to read for that group.
</details>

**Q56. What does the SQL mode `ONLY_FULL_GROUP_BY` enforce?**
A) It forces `GROUP BY` to sort results automatically.
B) It prevents queries from selecting non-aggregated columns that are not functionally dependent on `GROUP BY` columns.
C) It requires all tables in a join to have a `GROUP BY` clause.
D) It forbids the use of `HAVING` without a `WHERE` clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This SQL mode rejects queries where the `SELECT` list, `HAVING`, or `ORDER BY` refer to non-aggregated columns that are neither named in the `GROUP BY` nor functionally dependent on them.
</details>

**Q57. Is `ONLY_FULL_GROUP_BY` enabled by default in MySQL 8.0?**
A) Yes, it is enabled by default.
B) No, it was disabled by default in 8.0.
C) It depends on whether the storage engine is InnoDB or MyISAM.
D) Yes, but only for the `root` user.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** In MySQL 5.7 and later, including 8.0, `ONLY_FULL_GROUP_BY` is enabled by default as part of the `sql_mode` to align closer with standard SQL rules.
</details>

**Q58. If `ONLY_FULL_GROUP_BY` is disabled, what does MySQL do when selecting a non-aggregated column missing from the `GROUP BY`?**
A) It returns a compilation error.
B) It returns an arbitrary value from the group for that column.
C) It returns NULL for that column.
D) It concatenates all the values of the group into a comma-separated string.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When this mode is disabled, MySQL freely permits the query and arbitrarily picks the value from one of the rows in each group.
</details>

**Q59. What is "functional dependency" in the context of `ONLY_FULL_GROUP_BY`?**
A) If you group by a primary key, MySQL knows other columns from that table are uniquely determined, so they can be selected without being aggregated.
B) It means mathematical functions can be grouped.
C) It means `GROUP BY` must be dependent on a `HAVING` clause.
D) If you use one function, you must use it everywhere in the query.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL recognizes that if the grouped columns uniquely determine the other columns (like grouping by a Primary Key), those other columns are functionally dependent and are allowed in the `SELECT` list.
</details>

**Q60. Which query will fail under `ONLY_FULL_GROUP_BY` if `dept_name` is not functionally dependent on `dept_id`?**
A) `SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id, dept_name;`
B) `SELECT dept_id, ANY_VALUE(dept_name) FROM employees GROUP BY dept_id;`
C) `SELECT dept_id, dept_name FROM employees GROUP BY dept_id;`
D) `SELECT dept_name, SUM(salary) FROM employees GROUP BY dept_name;`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Since `dept_name` is neither aggregated, nor inside `ANY_VALUE()`, nor functionally dependent, it violates the `ONLY_FULL_GROUP_BY` rule.
</details>

**Q61. Can the `HAVING` clause reference columns not included in the `SELECT` list?**
A) Yes, standard SQL allows `HAVING` to reference any column, provided it's in the `GROUP BY` or an aggregate function.
B) No, `HAVING` can only reference columns visible in the `SELECT` list.
C) Yes, it can reference any column in the table regardless of grouping or aggregation.
D) No, `HAVING` can only reference table aliases.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `HAVING` can filter using aggregate functions or grouped columns that are not necessarily returned in the final `SELECT` output.
</details>

**Q62. What happens if you use an alias created in the `SELECT` clause within a `HAVING` clause in MySQL?**
A) It causes an error in MySQL.
B) The alias is completely ignored.
C) It successfully filters the rows, as MySQL specifically allows this extension.
D) It acts like a `WHERE` clause instead.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Although standard SQL forbids evaluating aliases in `HAVING` (since SELECT technically occurs after HAVING), MySQL's optimizer permits it for convenience.
</details>

**Q63. If `department` is grouped, which of the following is valid syntax?**
A) `HAVING department = 'Sales' AND SUM(salary) > 50000`
B) `HAVING WHERE department = 'Sales'`
C) `HAVING SUM(salary) > 50000 WHERE department = 'Sales'`
D) `HAVING department = 'Sales' OR LIMIT 1`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can combine multiple logical conditions in the `HAVING` clause using `AND` / `OR`, mixing both grouped columns and aggregate results.
</details>

**Q64. In standard execution order, how does `HAVING` handle NULLs if evaluating `HAVING sum(col) > 10`?**
A) It includes the row.
B) It evaluates to UNKNOWN and filters out the group.
C) It throws an error.
D) It converts the NULL to 0.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If an aggregate evaluates to NULL, a comparison like `NULL > 10` evaluates to UNKNOWN, and the `HAVING` clause filters out the group (just like `WHERE`).
</details>

**Q65. Why might a query run significantly slower if a condition is moved from the `WHERE` clause to the `HAVING` clause?**
A) `HAVING` cannot evaluate strings.
B) `HAVING` runs before data is grouped, causing it to run twice.
C) `WHERE` filters rows before grouping and can use indexes; `HAVING` filters after grouping and usually requires a full scan of the aggregated data.
D) `HAVING` requires creating a temporary table on disk.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `WHERE` operates optimally on the raw table data often utilizing indexes, while `HAVING` must evaluate the grouped, temporary result set which lacks indexes.
</details>

**Q66. Which modifier is used with `GROUP BY` to provide super-aggregate (subtotal) rows?**
A) WITH SUBTOTALS
B) WITH CUBE
C) WITH ROLLUP
D) WITH TOTALS

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `WITH ROLLUP` modifier is used in the `GROUP BY` clause to generate higher-level (super-aggregate) summary rows.
</details>

**Q67. What is the output of `GROUP BY year, country WITH ROLLUP`?**
A) Aggregates by (year, country), then (year), then a grand total.
B) Aggregates by (year, country), then (country), then a grand total.
C) Aggregates by (year, country), (year), (country), and a grand total.
D) Aggregates by (year, country) and a grand total only.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `WITH ROLLUP` generates subtotals rolling up from right to left in the column list. It removes the right-most column step-by-step.
</details>

**Q68. Does MySQL 8.0 support the `CUBE` grouping modifier?**
A) Yes, fully natively.
B) No, MySQL only supports `ROLLUP`.
C) Yes, but only with InnoDB.
D) Yes, by using `WITH CUBE`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** As of MySQL 8.0, standard SQL `CUBE` (which generates all possible grouping combinations) is not natively supported; only `ROLLUP` is available.
</details>

**Q69. How does `WITH ROLLUP` represent the column value for a super-aggregate (subtotal) row?**
A) It prints "TOTAL".
B) It leaves it blank.
C) It displays a NULL value in the column that was rolled up.
D) It displays a 0.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL sets the grouping column to NULL in the super-aggregate row to indicate that the row represents "all values" for that column.
</details>

**Q70. If a column already contains NULL data values, how can you distinguish a data NULL from a ROLLUP NULL?**
A) You cannot distinguish them in MySQL.
B) By using the `IS_ROLLUP()` function.
C) By using the `GROUPING()` function.
D) Data NULLs are colored differently in the console.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `GROUPING(column_name)` function returns 1 if the NULL in the column is a super-aggregate result created by `ROLLUP`, and 0 otherwise.
</details>

**Q71. Can you use `ORDER BY` in a query that uses `WITH ROLLUP`?**
A) No, it results in an error.
B) Yes, and this is newly supported in MySQL 8.0.
C) Yes, but only if you order by the grouped columns.
D) Yes, it has always been fully supported in all MySQL versions.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In earlier versions of MySQL, `WITH ROLLUP` was mutually exclusive with `ORDER BY`. Starting in MySQL 8.0, you can use `ORDER BY` with `WITH ROLLUP`.
</details>

**Q72. What will `SELECT GROUPING(dept), GROUPING(role) ...` return for a grand-total row in a `ROLLUP` query?**
A) 0, 0
B) 1, 1
C) NULL, NULL
D) 'TOTAL', 'TOTAL'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** For the grand total row, both columns are rolled up (representing all departments and all roles), so `GROUPING()` returns 1 for both.
</details>

**Q73. What is a limitation of `WITH ROLLUP` regarding the `DISTINCT` keyword?**
A) `DISTINCT` cannot be used with `WITH ROLLUP`.
B) `DISTINCT` makes `ROLLUP` drop the grand total row.
C) `ROLLUP` ignores `DISTINCT` inside aggregate functions like `COUNT(DISTINCT)`.
D) There is no limitation.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You cannot use `DISTINCT` in the `SELECT` list when the query includes `WITH ROLLUP`.
</details>

**Q74. Can `WITH ROLLUP` be used with multiple `GROUP BY` expressions?**
A) Yes, up to a maximum of 3 expressions.
B) No, only one column can be specified.
C) Yes, it creates a hierarchy of subtotals from right to left.
D) Yes, it creates a hierarchy of subtotals from left to right.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When multiple expressions are grouped, `ROLLUP` creates subtotals by discarding grouping columns sequentially from right to left.
</details>

**Q75. How does the `LIMIT` clause interact with `WITH ROLLUP`?**
A) `LIMIT` applies before the ROLLUP rows are generated.
B) `LIMIT` applies after all ROLLUP rows are generated, potentially slicing off the grand total.
C) `LIMIT` is ignored when `ROLLUP` is present.
D) `LIMIT` only limits the raw data, not the summary rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `LIMIT` is evaluated at the very end of the query execution. It limits the final output, meaning it can cut off the generated subtotal or grand total rows.
</details>

**Q76. Can you group by a boolean column in MySQL?**
A) No, booleans cannot be aggregated.
B) Yes, the results will group into true (1), false (0), and NULL (if applicable).
C) Yes, but they must be converted to strings first.
D) No, `GROUP BY` ignores boolean logic.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, booleans are essentially `TINYINT(1)`. They can be grouped just like integers, resulting in groups for 0, 1, and NULL.
</details>

**Q77. What does `SELECT COUNT(age > 18) FROM users;` do?**
A) Counts only the users older than 18.
B) Throws an error.
C) Counts all non-NULL evaluations of the condition (which includes both true and false).
D) Returns the sum of users older than 18.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `age > 18` evaluates to 1 (true) or 0 (false). Since neither is NULL, `COUNT()` counts all rows where `age` is not NULL, failing to filter as a `WHERE` clause would. You would use `SUM(age > 18)` to count them.
</details>

**Q78. To safely count rows where `age > 18` using an aggregate function, which of the following is correct?**
A) `COUNT(age > 18)`
B) `SUM(age > 18)`
C) `SUM(age)`
D) `MAX(age > 18)`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `age > 18` evaluates to 1 or 0. Using `SUM()` adds up the 1s, effectively counting how many rows meet the condition.
</details>

**Q79. Which function returns the bitwise AND of all values in a group?**
A) BIT_AND()
B) AND_AGG()
C) GROUP_AND()
D) BITWISE_AND()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `BIT_AND()` is an aggregate function that returns the bitwise AND of all values in the column or expression for each group.
</details>

**Q80. Which function returns the bitwise OR of all values in a group?**
A) BIT_OR()
B) GROUP_OR()
C) OR_AGG()
D) BITWISE_OR()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `BIT_OR()` computes the bitwise OR of all non-NULL values in the grouped set.
</details>

**Q81. What happens when a `GROUP BY` clause generates too many groups and exceeds memory limits?**
A) MySQL automatically uses disk-based temporary tables to handle the grouping.
B) MySQL skips the remaining rows and returns partial data.
C) The query succeeds but throws a truncation warning.
D) MySQL ignores the `GROUP BY` clause.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If the grouped result exceeds the `tmp_table_size` or `max_heap_table_size` in memory, MySQL converts the in-memory temporary table to a disk-based temporary table.
</details>

**Q82. Does standard SQL allow `COUNT(DISTINCT col1, col2)`?**
A) Yes, and MySQL supports it.
B) No, standard SQL only allows one column, but MySQL allows multiple.
C) Yes, but MySQL does not support it.
D) No, neither standard SQL nor MySQL support it.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL allows `COUNT(DISTINCT col1, col2)` to count the number of distinct combinations of `col1` and `col2` that are not entirely NULL.
</details>

**Q83. Which of the following clauses can NOT contain aggregate functions?**
A) SELECT
B) HAVING
C) ORDER BY
D) ON

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The `ON` clause is used in `JOIN` conditions before aggregation takes place, so it cannot contain aggregate functions. `ORDER BY` can sort by aggregated values.
</details>

**Q84. What happens if you use `GROUP BY 0`?**
A) It groups all rows into a single group.
B) It results in an error: "Unknown column '0' in 'group statement'".
C) It groups by the primary key.
D) It orders the groups randomly.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While `GROUP BY 1` refers to the first column in the SELECT list, `GROUP BY 0` is invalid because columns are 1-indexed.
</details>

**Q85. Can you perform calculations on aggregated data in the `SELECT` list? (e.g., `SELECT SUM(salary) * 1.1`)**
A) Yes.
B) No, aggregations must stand alone.
C) Yes, but only in strict SQL mode.
D) No, it requires a subquery.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Once the aggregate function computes the value for the group, it behaves like a normal scalar value and can be mathematically manipulated.
</details>

**Q86. What is the behavior of `SELECT MAX(id), MIN(id) FROM table` when the table is empty?**
A) Returns `0, 0`
B) Returns `NULL, NULL`
C) Returns an empty set (0 rows)
D) Throws an error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If there is no `GROUP BY` clause, aggregate functions on an empty set return one row with `NULL` for functions like MIN/MAX/SUM.
</details>

**Q87. What is the difference between `GROUP BY` and `DISTINCT`?**
A) There is no difference; they compile to the exact same bytecode.
B) `DISTINCT` is used for eliminating duplicate rows, while `GROUP BY` is used for aggregating data across groups of rows.
C) `GROUP BY` is faster than `DISTINCT`.
D) `DISTINCT` supports aggregate functions while `GROUP BY` does not.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While a simple `GROUP BY col` and `SELECT DISTINCT col` achieve similar deduplication, `GROUP BY` is designed to be paired with aggregate functions to compute values per group.
</details>

**Q88. True or False: You can group by a column from a joined table.**
A) True
B) False

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `GROUP BY` can reference any valid column from any table included in the `FROM` or `JOIN` clauses.
</details>

**Q89. In a query with `JOIN` and `GROUP BY`, which happens first?**
A) The grouping occurs first, then the tables are joined.
B) The tables are joined first, then the resulting rows are grouped.
C) They are processed concurrently.
D) It depends on the storage engine.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Logically, the `JOIN` operation (part of the FROM clause) builds the full dataset before `WHERE` filtering and `GROUP BY` aggregation are applied.
</details>

**Q90. Which of the following is an invalid use of the `HAVING` clause?**
A) `HAVING MAX(salary) > 100000`
B) `HAVING department = 'HR'`
C) `HAVING employee_id IN (1,2,3)` (where employee_id is not grouped or aggregated, and ONLY_FULL_GROUP_BY is active)
D) `HAVING COUNT(*) > 0`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Under `ONLY_FULL_GROUP_BY`, you cannot reference a non-aggregated column in the `HAVING` clause unless it is functionally dependent on the `GROUP BY` columns.
</details>

**Q91. What is returned by `SELECT GROUP_CONCAT(name ORDER BY name ASC SEPARATOR ', ')`?**
A) A comma-separated list of names sorted alphabetically.
B) A single name picked randomly.
C) An array of names.
D) A syntax error.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The query successfully aggregates all names in the group, sorts them alphabetically inside the concatenation, and separates them with ", ".
</details>

**Q92. If `GROUP_CONCAT` encounters a NULL value in the group, what does it do?**
A) Replaces it with the string 'NULL'.
B) Throws an error.
C) Ignored; it drops the NULL value from the concatenated string.
D) Returns NULL for the entire concatenation.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `GROUP_CONCAT()` simply ignores NULL values. If all values in the group are NULL, it returns NULL.
</details>

**Q93. True or False: Window functions (e.g., `OVER()`) operate before `GROUP BY`.**
A) True
B) False

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Window functions are processed *after* the `GROUP BY` clause and `HAVING` clauses, operating on the grouped result set.
</details>

**Q94. If you write `SELECT department, SUM(salary) FROM employees GROUP BY department HAVING SUM(salary) > 50000`, does MySQL calculate the sum twice?**
A) Yes, once for the SELECT and once for the HAVING.
B) No, the optimizer recognizes the duplicate expression and evaluates it once per group.
C) Yes, unless an alias is used.
D) No, the HAVING clause is ignored.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The MySQL query optimizer caches the result of the aggregate function for the group and reuses it for both the `HAVING` evaluation and the `SELECT` output.
</details>

**Q95. How does MySQL 8.0 handle `GROUP BY` optimization compared to MySQL 5.7?**
A) MySQL 8.0 uses Hash Aggregation by default for better performance without implicit sorting.
B) MySQL 8.0 relies entirely on B-trees.
C) MySQL 8.0 removed the `GROUP BY` clause in favor of Window functions.
D) MySQL 5.7 is much faster at GROUP BY due to strict memory limits.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL 5.7 implicitly sorted `GROUP BY` results and often used temporary tables with filesort. MySQL 8.0 removed implicit sorting, allowing it to heavily utilize memory-based Hash Aggregation.
</details>

**Q96. What is the difference between `COUNT(*)` and `COUNT(1)` regarding NULL values in specific columns?**
A) `COUNT(*)` includes NULLs, `COUNT(1)` does not.
B) `COUNT(1)` includes NULLs, `COUNT(*)` does not.
C) Both include rows regardless of whether any specific columns contain NULL values.
D) `COUNT(1)` checks the first column for NULLs.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Both `COUNT(*)` and `COUNT(1)` count the physical rows in the result set, ignoring whether individual column values inside those rows are NULL.
</details>

**Q97. In a table with columns `(id, category, value)`, what happens in MySQL 8.0 (default settings) if you run `SELECT category, id FROM table GROUP BY category;`?**
A) It returns the first ID for each category.
B) It results in an Error 1055 because `id` is not in GROUP BY.
C) It groups by category and returns all IDs concatenated.
D) It returns a random ID for each category.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because `ONLY_FULL_GROUP_BY` is enabled by default in 8.0, querying the unaggregated, non-functionally dependent column `id` throws Error 1055.
</details>

**Q98. To fix Error 1055 from the previous question without changing SQL modes, which function could you wrap `id` in?**
A) ARBITRARY(id)
B) RANDOM_VALUE(id)
C) ANY_VALUE(id)
D) FIRST(id)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `ANY_VALUE()` function suppresses the `ONLY_FULL_GROUP_BY` violation by instructing MySQL to pick an arbitrary value.
</details>

**Q99. What does the `GROUPING()` function return if the argument is NOT rolled up?**
A) NULL
B) -1
C) 0
D) 1

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `GROUPING()` returns 0 to indicate that the column value is standard grouped data, whereas it returns 1 if it is a super-aggregate (subtotal) row.
</details>

**Q100. If you need to calculate the average length of strings in a column, which query is correct?**
A) `SELECT AVG_LENGTH(column_name) FROM table;`
B) `SELECT AVG(LENGTH(column_name)) FROM table;`
C) `SELECT LENGTH(AVG(column_name)) FROM table;`
D) `SELECT MEAN(LENGTH(column_name)) FROM table;`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You apply the `LENGTH()` scalar function to evaluate the length of each string, and then apply the `AVG()` aggregate function to find the mean of those lengths.
</details>

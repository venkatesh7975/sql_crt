# MySQL 8.0 Aggregation and Grouping - Part 1

**Q1. What is the primary difference between `COUNT(*)` and `COUNT(column_name)`?**
A) `COUNT(*)` only counts rows where no column is NULL.
B) `COUNT(column_name)` counts all rows including NULL values in that column.
C) `COUNT(*)` counts all rows, while `COUNT(column_name)` ignores rows where the column is NULL.
D) There is no difference; they are functionally identical.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `COUNT(*)` counts total rows in the result set regardless of NULLs, whereas `COUNT(column_name)` counts only the non-NULL values of the specified column.
</details>

**Q2. What will `SELECT COUNT(NULL)` return in MySQL?**
A) 1
B) 0
C) NULL
D) An error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `COUNT(expression)` function ignores NULL values. Since the expression is explicitly NULL, it counts 0 items.
</details>

**Q3. How does `COUNT(DISTINCT column_name)` handle NULL values?**
A) It counts NULL as one distinct value.
B) It ignores NULL values completely.
C) It throws an error if NULL values are present.
D) It replaces NULL values with zero before counting.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `COUNT(DISTINCT column_name)` returns the number of unique, non-NULL values in the column.
</details>

**Q4. In MySQL, what is the data type returned by the `COUNT()` function?**
A) INT
B) BIGINT
C) DECIMAL
D) VARCHAR

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `COUNT()` function always returns a `BIGINT` value representing the number of rows.
</details>

**Q5. Is there a performance difference between `COUNT(*)` and `COUNT(1)` in MySQL's InnoDB engine?**
A) Yes, `COUNT(1)` is significantly faster.
B) Yes, `COUNT(*)` is significantly faster.
C) No, the optimizer treats them as identical.
D) `COUNT(1)` only counts the first column, making it faster.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB processes `COUNT(*)` and `COUNT(1)` in exactly the same way, resulting in identical performance.
</details>

**Q6. Can an aggregate function like `COUNT()` be used in a `SELECT` statement without a `GROUP BY` clause?**
A) No, it will result in a syntax error.
B) Yes, but it will return one row per row in the original table.
C) Yes, it will treat the entire result set as a single group and return one row.
D) Yes, but it only works if the table has less than 1000 rows.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If there is no `GROUP BY` clause, aggregate functions treat all selected rows as a single group and return a single row.
</details>

**Q7. What does `SELECT SUM(column_name)` return if all values in the column are NULL?**
A) 0
B) NULL
C) Error
D) -1

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If the result set contains no rows or all values provided to `SUM()` are NULL, it returns NULL, not 0.
</details>

**Q8. What happens if you use `SUM()` on a column of `VARCHAR` type containing string representations of numbers?**
A) MySQL throws a type mismatch error.
B) It silently returns 0.
C) MySQL implicitly converts the strings to numbers and calculates the sum.
D) It concatenates the strings.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL performs implicit type conversion, converting strings to numeric values to compute the sum, though warnings may be generated if strings contain non-numeric characters.
</details>

**Q9. If a query `SELECT COUNT(id) FROM users WHERE age > 100` finds zero matching rows, what is the result?**
A) NULL
B) 0
C) An empty result set (no rows)
D) -1

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `COUNT()` returns 0 when no rows match the `WHERE` condition.
</details>

**Q10. If a query `SELECT SUM(salary) FROM employees WHERE age > 100` finds zero matching rows, what is the result?**
A) 0
B) NULL
C) An empty result set (no rows)
D) -1

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Unlike `COUNT()`, `SUM()` returns NULL if there are no matching rows to aggregate.
</details>

**Q11. Which data type is returned by the `SUM()` function when used on an `INT` column?**
A) INT
B) BIGINT or DECIMAL
C) FLOAT
D) DOUBLE

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `SUM()` returns a `DECIMAL` value for exact-value arguments (like `INT`) or a `DOUBLE` for floating-point values to prevent overflow. In older versions or specific contexts, it returns `DECIMAL` for integers.
</details>

**Q12. What does `SUM(DISTINCT column_name)` do?**
A) Sums all non-NULL values, ignoring the `DISTINCT` keyword.
B) Sums only the unique, non-NULL values in the column.
C) Throws an error because `DISTINCT` cannot be used with `SUM`.
D) Sums all distinct values, including NULL (treating it as 0).

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `SUM(DISTINCT)` evaluates the unique values in the column and calculates the sum of those unique non-NULL values.
</details>

**Q13. How does the `AVG()` function handle NULL values?**
A) It treats NULL as 0 when calculating the average.
B) It ignores NULL values in both the sum and the row count.
C) It ignores NULLs in the sum but includes them in the row count.
D) It returns NULL if any value in the column is NULL.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `AVG()` calculates the average using only non-NULL values, effectively reducing both the total sum and the denominator (count) by ignoring NULL rows.
</details>

**Q14. What is the result of `SELECT AVG(score)` if the scores are `10, 20, NULL, 30`?**
A) 15 (60 / 4)
B) 20 (60 / 3)
C) NULL
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The NULL value is ignored. The sum is 10+20+30 = 60, and the count of non-NULL values is 3. 60 / 3 = 20.
</details>

**Q15. Can `AVG()` be used on a DATE column?**
A) Yes, it returns the middle date.
B) No, it results in a syntax error.
C) Yes, but it converts dates to numeric format, returning an unformatted number.
D) No, `AVG()` only works strictly on INT or DECIMAL data types.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL will convert the DATE into a numeric value (e.g., YYYYMMDD as an integer) and calculate the average, which usually does not represent a valid or useful date.
</details>

**Q16. If `SELECT AVG(salary)` is executed on an empty table, what is the output?**
A) 0
B) NULL
C) Error: Division by zero
D) 0.00

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Like `SUM()`, `AVG()` returns NULL when there are no rows to evaluate, avoiding a division by zero error.
</details>

**Q17. Which of the following is logically equivalent to `AVG(col)` (assuming no division by zero)?**
A) `SUM(col) / COUNT(*)`
B) `SUM(col) / COUNT(col)`
C) `MAX(col) + MIN(col) / 2`
D) `SUM(col) / COUNT(DISTINCT col)`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `COUNT(col)` ignores NULLs exactly like `AVG(col)` does, making `SUM(col) / COUNT(col)` mathematically equivalent.
</details>

**Q18. How does the `MIN()` function evaluate a column of `VARCHAR` data?**
A) It finds the shortest string by length.
B) It finds the longest string by length.
C) It finds the value that appears first alphabetically (lexicographically).
D) It returns an error because `MIN()` only works on numeric data.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** For character string types, `MIN()` and `MAX()` evaluate values based on the character set's collation, usually resulting in alphabetical ordering.
</details>

**Q19. What does `MAX(hire_date)` return for a `DATE` column?**
A) The earliest chronological date.
B) The most recent (latest) chronological date.
C) The date with the highest day number in the month.
D) NULL, as dates cannot be evaluated by MAX.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When applied to date and time data types, `MAX()` returns the most recent date or time.
</details>

**Q20. Can `MIN()` and `MAX()` utilize database indexes?**
A) No, aggregate functions always require a full table scan.
B) Yes, if an index exists on the column, MySQL can fetch the first or last entry in the index without scanning rows.
C) Only `MIN()` can use an index; `MAX()` cannot.
D) Yes, but only for `INT` columns, not strings or dates.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL optimizer is highly efficient at optimizing `MIN()` and `MAX()` queries by simply reading the first or last value of a B-tree index.
</details>

**Q21. What happens if you use `MIN()` on a column where all values are NULL?**
A) Returns 0
B) Returns empty string ''
C) Returns NULL
D) Raises an error

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Like most other aggregate functions, `MIN()` returns NULL if there are no non-NULL values in the set.
</details>

**Q22. Does using `DISTINCT` inside `MIN()` or `MAX()` change the result (e.g., `MIN(DISTINCT col)`)?**
A) Yes, it makes the query faster.
B) Yes, it returns the smallest unique value.
C) No, it has no effect on the result of MIN or MAX.
D) Yes, it throws a syntax error because DISTINCT is not allowed here.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The minimum or maximum value in a column is exactly the same whether duplicate values are considered or ignored.
</details>

**Q23. Which clause is used to divide the result set into subsets for aggregation?**
A) ORDER BY
B) PARTITION BY
C) GROUP BY
D) DIVIDE BY

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `GROUP BY` clause groups rows that have the same values into summary rows, allowing aggregate functions to be applied to each group.
</details>

**Q24. What is the fundamental requirement for non-aggregated columns in the `SELECT` list when using `GROUP BY` (under standard SQL rules)?**
A) They must be of string data type.
B) They must appear in the `GROUP BY` clause.
C) They must be aliased.
D) They must have an index.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In standard SQL (and MySQL with ONLY_FULL_GROUP_BY enabled), any column in the SELECT list that is not part of an aggregate function must be included in the `GROUP BY` clause.
</details>

**Q25. Can you use column aliases defined in the `SELECT` clause within the `GROUP BY` clause in MySQL?**
A) Yes, MySQL permits this as an extension to standard SQL.
B) No, it is strictly prohibited and throws an error.
C) Yes, but only for numeric aliases.
D) Yes, but it requires changing the SQL mode to ANSI.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Unlike strict standard SQL, MySQL allows the use of `SELECT` column aliases in the `GROUP BY`, `ORDER BY`, and `HAVING` clauses.
</details>

**Q26. What does `GROUP BY 1, 2` mean in a MySQL query?**
A) It groups by the values 1 and 2 literal integers.
B) It groups by the first and second columns listed in the `SELECT` clause.
C) It restricts the grouping to a maximum of 2 groups.
D) It is invalid syntax and throws an error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL allows ordinal positions in the `GROUP BY` clause to refer to the order of expressions defined in the `SELECT` list.
</details>

**Q27. How does the `GROUP BY` clause handle NULL values in the grouped column?**
A) It ignores rows with NULL values.
B) It throws an error if NULLs are encountered.
C) It groups all NULL values together into a single, separate group.
D) It places each NULL value into its own distinct group.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, NULL values are considered equal for the purpose of the `GROUP BY` clause, so all rows with NULL in the grouping column form a single group.
</details>

**Q28. In which order are clauses logically evaluated in a SQL query?**
A) SELECT -> WHERE -> GROUP BY -> HAVING -> ORDER BY
B) FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
C) WHERE -> GROUP BY -> SELECT -> ORDER BY -> HAVING
D) FROM -> GROUP BY -> WHERE -> HAVING -> SELECT -> ORDER BY

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Logically, SQL evaluates the source table (FROM), filters rows (WHERE), groups data (GROUP BY), filters groups (HAVING), selects the final columns (SELECT), and finally sorts them (ORDER BY).
</details>

**Q29. True or False: In MySQL 8.0, the `GROUP BY` clause automatically sorts the result set by the grouped columns by default.**
A) True, this is standard MySQL behavior.
B) False, automatic sorting for GROUP BY was removed in MySQL 8.0.
C) True, but only if the column is a primary key.
D) False, GROUP BY never sorted data in any MySQL version.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Prior to MySQL 8.0, `GROUP BY` implicitly sorted the results. In MySQL 8.0, this implicit sorting was removed to improve performance. An explicit `ORDER BY` is now required for sorted output.
</details>

**Q30. Which of the following queries correctly counts the number of employees in each department?**
A) `SELECT department_id, COUNT(*) FROM employees;`
B) `SELECT department_id, COUNT(*) FROM employees GROUP BY department_id;`
C) `SELECT department_id, COUNT(*) GROUP BY department_id FROM employees;`
D) `SELECT COUNT(*) FROM employees GROUP BY department_id, employee_id;`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The query must select the `department_id`, count the rows, and specify `GROUP BY department_id`.
</details>

**Q31. Can mathematical expressions be used inside aggregate functions, e.g., `SUM(price * quantity)`?**
A) Yes, the expression is evaluated for each row before aggregating.
B) No, aggregate functions only accept single column names.
C) Yes, but only in the `HAVING` clause.
D) No, mathematical expressions must be handled in a subquery first.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Aggregate functions can accept complex expressions, evaluating the expression per row and then aggregating the result.
</details>

**Q32. What is the behavior of aggregate functions on a query that uses `LIMIT 5`?**
A) The aggregate function is calculated only on the 5 rows returned.
B) The `LIMIT` is ignored because aggregate functions override it.
C) The aggregate is calculated on the full result set, and then `LIMIT` restricts the output rows (usually to 1 if no GROUP BY).
D) MySQL throws a syntax error for mixing aggregates with LIMIT.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Aggregations occur before the `LIMIT` clause is applied. The aggregates process the entire matching dataset, and then `LIMIT` limits the final aggregated rows.
</details>

**Q33. Which SQL function would you use to concatenate string values from a group into a single string?**
A) CONCAT()
B) STRING_AGG()
C) GROUP_CONCAT()
D) LISTAGG()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, `GROUP_CONCAT()` is the aggregate function used to concatenate string values from multiple rows into a single string.
</details>

**Q34. What is the default separator for `GROUP_CONCAT()` in MySQL?**
A) Space (` `)
B) Pipe (`|`)
C) Semicolon (`;`)
D) Comma (`,`)

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** By default, `GROUP_CONCAT()` uses a comma `,` to separate the concatenated values.
</details>

**Q35. How can you change the default separator in `GROUP_CONCAT()`?**
A) `GROUP_CONCAT(column SEPARATOR ';')`
B) `GROUP_CONCAT(column, ';')`
C) `GROUP_CONCAT(column DELIMITER ';')`
D) `GROUP_CONCAT(column SPLIT ';')`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `SEPARATOR` keyword is used within the `GROUP_CONCAT()` function to define a custom delimiter.
</details>

**Q36. What is `group_concat_max_len` in MySQL?**
A) A column property specifying the max characters of a grouped string.
B) A system variable that limits the maximum length of the string returned by `GROUP_CONCAT()`.
C) A function to calculate the length of the longest concatenated string.
D) A keyword used in the `GROUP_CONCAT` syntax.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `group_concat_max_len` is a MySQL system variable (default 1024) that strictly truncates the result of `GROUP_CONCAT()` if it exceeds this length.
</details>

**Q37. Can you sort the elements inside a `GROUP_CONCAT()` result?**
A) No, elements are always concatenated in the order they are read from the disk.
B) Yes, by adding an `ORDER BY` clause inside the `GROUP_CONCAT()` function.
C) Yes, by adding an `ORDER BY` clause at the very end of the query.
D) No, sorting strings requires an external application.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can control the order of concatenated values using an inner ORDER BY: `GROUP_CONCAT(name ORDER BY age DESC)`.
</details>

**Q38. Which aggregate function returns a JSON array of values from a group in MySQL 8.0?**
A) JSON_ARRAY()
B) JSON_AGG()
C) JSON_ARRAYAGG()
D) GROUP_JSON()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `JSON_ARRAYAGG()` is an aggregate function that aggregates a result set into a single JSON array.
</details>

**Q39. Which aggregate function returns a JSON object containing key-value pairs from a group in MySQL 8.0?**
A) JSON_OBJECT()
B) JSON_OBJECTAGG()
C) GROUP_OBJECT()
D) JSON_MAP()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `JSON_OBJECTAGG(key_col, value_col)` aggregates rows into a single JSON object (dictionary) using the provided keys and values.
</details>

**Q40. What happens if multiple rows have the same key when using `JSON_OBJECTAGG()`?**
A) An error is thrown.
B) The values are combined into a JSON array for that key.
C) The last value encountered for that key overwrites the previous ones.
D) The first value encountered for that key is preserved; subsequent ones are ignored.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If there are duplicate keys in `JSON_OBJECTAGG()`, the final JSON object keeps the last value associated with that key.
</details>

**Q41. Which function calculates the population standard deviation of a numeric column?**
A) STD()
B) STDDEV_SAMP()
C) VARIANCE()
D) STDDEV_POP()

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** `STDDEV_POP()` (and its synonym `STD()`) calculates the population standard deviation. `STDDEV_SAMP()` is for the sample standard deviation.
</details>

**Q42. Which function calculates the population variance of a numeric column?**
A) VAR_POP()
B) VAR_SAMP()
C) VARIANCE_SAMP()
D) VAR()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `VAR_POP()` calculates the population variance of a given expression.
</details>

**Q43. Which clause is primarily used to apply a filter on the aggregated groups?**
A) WHERE
B) HAVING
C) FILTER
D) WITH

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `HAVING` clause is explicitly designed to filter rows after the `GROUP BY` aggregation has taken place.
</details>

**Q44. What is a key difference between the `WHERE` clause and the `HAVING` clause?**
A) `HAVING` filters rows before grouping; `WHERE` filters rows after grouping.
B) `WHERE` can use aggregate functions; `HAVING` cannot.
C) `WHERE` filters individual rows before aggregation; `HAVING` filters aggregated group results.
D) There is no difference; they can be used interchangeably.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `WHERE` operates on individual rows prior to the `GROUP BY` phase. `HAVING` operates on the aggregate output of the groups.
</details>

**Q45. Can the `HAVING` clause be used without a `GROUP BY` clause?**
A) No, it requires a `GROUP BY` clause.
B) Yes, and it behaves similarly to a `WHERE` clause, evaluating against all rows as a single group.
C) Yes, but only if the query has no aggregate functions.
D) Yes, but it will return an empty result set.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If `HAVING` is used without `GROUP BY`, the entire table is treated as one group, and the `HAVING` clause filters the single aggregated result row.
</details>

**Q46. Is the following query valid? `SELECT department, SUM(salary) as total FROM employees WHERE SUM(salary) > 10000 GROUP BY department;`**
A) Yes.
B) No, because `WHERE` cannot contain aggregate functions like `SUM()`.
C) No, because `GROUP BY` must come before `WHERE`.
D) Yes, but only if `salary` is an integer.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Aggregate functions cannot be used in the `WHERE` clause because `WHERE` is evaluated before aggregations take place. `HAVING SUM(salary) > 10000` must be used instead.
</details>

**Q47. Can `HAVING` reference column aliases defined in the `SELECT` list in MySQL?**
A) Yes, MySQL extends standard SQL to allow this.
B) No, aliases are only available in the `ORDER BY` clause.
C) Yes, but only if the alias contains no spaces.
D) No, `HAVING` must evaluate the actual expressions.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL allows `HAVING` clauses to refer to aliases defined in the `SELECT` clause, unlike strict ANSI SQL which requires repeating the expression.
</details>

**Q48. Which query returns departments that have more than 5 employees?**
A) `SELECT dept_id FROM employees WHERE COUNT(*) > 5 GROUP BY dept_id;`
B) `SELECT dept_id FROM employees GROUP BY dept_id HAVING COUNT(*) > 5;`
C) `SELECT dept_id, COUNT(*) > 5 FROM employees GROUP BY dept_id;`
D) `SELECT dept_id FROM employees HAVING COUNT(*) > 5;`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `GROUP BY dept_id` creates the groups, and `HAVING COUNT(*) > 5` successfully filters out any groups that do not meet the criteria.
</details>

**Q49. When analyzing performance, which is better: filtering rows with `WHERE` or `HAVING`?**
A) `HAVING` is faster because it works on fewer rows.
B) `WHERE` is faster because it filters rows before the expensive aggregation phase.
C) They take the exact same amount of time.
D) `HAVING` is faster because it can use indexes better than `WHERE`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `WHERE` is much more efficient because it reduces the data size before the CPU-intensive grouping and aggregation occurs, and `WHERE` conditions can often utilize indexes.
</details>

**Q50. Can a query contain both a `WHERE` clause and a `HAVING` clause?**
A) No, they are mutually exclusive.
B) Yes, `WHERE` filters rows before grouping, and `HAVING` filters the resulting groups.
C) Yes, but `HAVING` must precede `WHERE` in the query syntax.
D) Yes, but they must test the exact same conditions.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** It is standard practice to use both: `WHERE` for row-level filtering and `HAVING` for group-level filtering after the aggregation.
</details>

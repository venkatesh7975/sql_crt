# 50 MySQL Multiple Choice Questions

This document contains 50 carefully curated Multiple Choice Questions designed to test your knowledge of MySQL 8.0, ranging from basic syntax to advanced architectural concepts.

---

## Part 1: Basic SQL & Syntax (Q1 - Q10)

**Q1. Which of the following SQL commands is categorized as Data Definition Language (DDL)?**
A) `INSERT`
B) `UPDATE`
C) `TRUNCATE`
D) `GRANT`

<details>
<summary>View Answer</summary>

**Answer:** C) `TRUNCATE`
**Explanation:** `TRUNCATE` alters the structure of the database by dropping and recreating the table (DDL). `INSERT` and `UPDATE` are DML. `GRANT` is DCL.
</details>

**Q2. Which MySQL data type is best suited for storing monetary values where exact precision is required?**
A) `FLOAT`
B) `DOUBLE`
C) `DECIMAL`
D) `INT`

<details>
<summary>View Answer</summary>

**Answer:** C) `DECIMAL`
**Explanation:** `DECIMAL` (or `NUMERIC`) stores exact precision values, avoiding the floating-point rounding errors inherent to `FLOAT` and `DOUBLE`.
</details>

**Q3. What is the correct order of clauses in a standard SQL `SELECT` statement?**
A) SELECT, FROM, WHERE, ORDER BY, GROUP BY
B) SELECT, FROM, WHERE, GROUP BY, ORDER BY
C) SELECT, WHERE, FROM, GROUP BY, ORDER BY
D) SELECT, FROM, GROUP BY, WHERE, ORDER BY

<details>
<summary>View Answer</summary>

**Answer:** B) SELECT, FROM, WHERE, GROUP BY, ORDER BY
**Explanation:** The syntax order dictates that `WHERE` filters rows before `GROUP BY` aggregates them, and `ORDER BY` occurs at the very end.
</details>

**Q4. In MySQL, which keyword is used to return only unique rows from a query?**
A) `UNIQUE`
B) `DIFFERENT`
C) `DISTINCT`
D) `SINGLE`

<details>
<summary>View Answer</summary>

**Answer:** C) `DISTINCT`
**Explanation:** The `DISTINCT` keyword placed immediately after `SELECT` ensures duplicate rows are removed from the result set.
</details>

**Q5. How do you select all columns from a table named `Employees`?**
A) `SELECT ALL FROM Employees;`
B) `SELECT [all] FROM Employees;`
C) `SELECT * FROM Employees;`
D) `SELECT Columns FROM Employees;`

<details>
<summary>View Answer</summary>

**Answer:** C) `SELECT * FROM Employees;`
**Explanation:** The asterisk (`*`) is a wildcard character in SQL that represents all available columns in the specified table.
</details>

**Q6. Which command is used to physically remove a table and all its data from the database entirely?**
A) `DELETE TABLE`
B) `DROP TABLE`
C) `REMOVE TABLE`
D) `TRUNCATE TABLE`

<details>
<summary>View Answer</summary>

**Answer:** B) `DROP TABLE`
**Explanation:** `DROP TABLE` deletes the table structure and its data completely. `TRUNCATE` deletes the data but keeps the table structure intact.
</details>

**Q7. If you insert a string into a `VARCHAR(10)` column that is 15 characters long, what happens by default in modern MySQL (Strict SQL Mode)?**
A) The string is silently truncated to 10 characters.
B) The database crashes.
C) MySQL throws an error and the insert fails.
D) The column automatically resizes to `VARCHAR(15)`.

<details>
<summary>View Answer</summary>

**Answer:** C) MySQL throws an error and the insert fails.
**Explanation:** In strict mode (the default in modern MySQL), data truncation throws an error (Data too long for column) rather than silently truncating the data as older versions did.
</details>

**Q8. Which operator is used to search for a specified pattern in a column?**
A) `=`
B) `LIKE`
C) `MATCH`
D) `SIMILAR TO`

<details>
<summary>View Answer</summary>

**Answer:** B) `LIKE`
**Explanation:** The `LIKE` operator is used in a `WHERE` clause to search for a specified pattern in a column, usually paired with `%` or `_` wildcards.
</details>

**Q9. What is the primary difference between `CHAR` and `VARCHAR`?**
A) `CHAR` stores numbers, `VARCHAR` stores letters.
B) `CHAR` is fixed-length, `VARCHAR` is variable-length.
C) `VARCHAR` is fixed-length, `CHAR` is variable-length.
D) There is no difference; they are aliases.

<details>
<summary>View Answer</summary>

**Answer:** B) `CHAR` is fixed-length, `VARCHAR` is variable-length.
**Explanation:** `CHAR(10)` will always use 10 bytes of storage (padding with spaces if necessary), whereas `VARCHAR(10)` uses only as much storage as the string requires (plus a byte for length).
</details>

**Q10. How do you add a new column named `BirthDate` to an existing `Users` table?**
A) `UPDATE TABLE Users ADD BirthDate DATE;`
B) `ALTER TABLE Users ADD COLUMN BirthDate DATE;`
C) `MODIFY TABLE Users INSERT BirthDate DATE;`
D) `ADD COLUMN BirthDate DATE TO Users;`

<details>
<summary>View Answer</summary>

**Answer:** B) `ALTER TABLE Users ADD COLUMN BirthDate DATE;`
**Explanation:** `ALTER TABLE` is the DDL command required to change the structure of an existing table.
</details>

---

## Part 2: Filtering & Sorting (Q11 - Q20)

**Q11. Which query correctly finds all employees whose LastName starts with 'S'?**
A) `SELECT * FROM Employees WHERE LastName = 'S%';`
B) `SELECT * FROM Employees WHERE LastName LIKE '%S';`
C) `SELECT * FROM Employees WHERE LastName LIKE 'S%';`
D) `SELECT * FROM Employees WHERE LastName STARTSWITH 'S';`

<details>
<summary>View Answer</summary>

**Answer:** C) `SELECT * FROM Employees WHERE LastName LIKE 'S%';`
**Explanation:** The `%` wildcard represents zero or more characters. Placing it after the 'S' means the string must start with 'S'.
</details>

**Q12. How do you filter records where the `Department` is either 'Sales', 'Marketing', or 'IT'?**
A) `WHERE Department = 'Sales' OR 'Marketing' OR 'IT'`
B) `WHERE Department IN ('Sales', 'Marketing', 'IT')`
C) `WHERE Department BETWEEN 'Sales' AND 'IT'`
D) `WHERE Department = ('Sales', 'Marketing', 'IT')`

<details>
<summary>View Answer</summary>

**Answer:** B) `WHERE Department IN ('Sales', 'Marketing', 'IT')`
**Explanation:** The `IN` operator allows you to specify multiple possible values in a `WHERE` clause, acting as a shorthand for multiple `OR` conditions.
</details>

**Q13. What is the correct way to check if a column contains a `NULL` value?**
A) `WHERE column = NULL`
B) `WHERE column == NULL`
C) `WHERE column IS NULL`
D) `WHERE ISNULL(column) = TRUE`

<details>
<summary>View Answer</summary>

**Answer:** C) `WHERE column IS NULL`
**Explanation:** Because `NULL` represents an unknown value, it cannot be compared using standard equality operators (`=`). You must use the `IS NULL` operator.
</details>

**Q14. In the condition `WHERE Age BETWEEN 20 AND 30`, which ages are included?**
A) 21 through 29 only
B) 20 through 29 only
C) 21 through 30 only
D) 20 through 30 inclusive

<details>
<summary>View Answer</summary>

**Answer:** D) 20 through 30 inclusive
**Explanation:** The `BETWEEN` operator in SQL is inclusive of both the start and end values.
</details>

**Q15. If `x = TRUE`, `y = FALSE`, and `z = NULL`, what is the result of `x AND (y OR z)`?**
A) `TRUE`
B) `FALSE`
C) `NULL`
D) Error

<details>
<summary>View Answer</summary>

**Answer:** C) `NULL`
**Explanation:** `(FALSE OR NULL)` evaluates to `NULL`. Then `(TRUE AND NULL)` evaluates to `NULL`. (Three-valued logic).
</details>

**Q16. By default, how does the `ORDER BY` clause sort data?**
A) Randomly
B) Descending order (`DESC`)
C) Ascending order (`ASC`)
D) Based on the order of insertion

<details>
<summary>View Answer</summary>

**Answer:** C) Ascending order (`ASC`)
**Explanation:** If you do not specify `ASC` or `DESC`, SQL defaults to sorting in ascending alphabetical or numerical order.
</details>

**Q17. Which clause restricts the total number of rows returned by a query in MySQL?**
A) `TOP`
B) `FETCH FIRST`
C) `ROWNUM`
D) `LIMIT`

<details>
<summary>View Answer</summary>

**Answer:** D) `LIMIT`
**Explanation:** MySQL uses the `LIMIT` keyword. (`TOP` is SQL Server, `ROWNUM` is Oracle).
</details>

**Q18. What does `LIMIT 10 OFFSET 5` mean?**
A) Skip the first 10 rows and return 5 rows.
B) Skip the first 5 rows and return 10 rows.
C) Return rows 5 through 10.
D) Return exactly 15 rows.

<details>
<summary>View Answer</summary>

**Answer:** B) Skip the first 5 rows and return 10 rows.
**Explanation:** `OFFSET` dictates how many rows to skip from the top of the sorted result set before beginning to return the number of rows specified by `LIMIT`.
</details>

**Q19. You want to sort by `Department` in ascending order, and then by `Salary` in descending order within each department. Which is correct?**
A) `ORDER BY Department, Salary DESC`
B) `ORDER BY Department ASC, Salary ASC`
C) `ORDER BY Department DESC, Salary DESC`
D) `ORDER BY Salary DESC, Department ASC`

<details>
<summary>View Answer</summary>

**Answer:** A) `ORDER BY Department, Salary DESC`
**Explanation:** `ASC` is implied for Department. The secondary sort on Salary explicitly specifies `DESC`.
</details>

**Q20. What does the `_` (underscore) wildcard represent in a `LIKE` clause?**
A) Any sequence of characters
B) Any single numerical digit
C) Exactly one single character
D) A blank space

<details>
<summary>View Answer</summary>

**Answer:** C) Exactly one single character
**Explanation:** While `%` represents zero or more characters, `_` mandates the presence of exactly one character in that position.
</details>

---

## Part 3: Functions & Aggregation (Q21 - Q30)

**Q21. Which function ignores NULL values when performing its calculation?**
A) `SUM()`
B) `AVG()`
C) `COUNT(column_name)`
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D) All of the above
**Explanation:** All standard aggregate functions (`SUM`, `AVG`, `MIN`, `MAX`, `COUNT(col)`) ignore `NULL` values. The only exception is `COUNT(*)`, which counts rows regardless of NULLs.
</details>

**Q22. What happens if you execute `SELECT Department, SUM(Salary) FROM Employees;` without a `GROUP BY` clause in modern MySQL?**
A) It returns the sum of all salaries and a random Department name.
B) It throws an `ONLY_FULL_GROUP_BY` syntax error.
C) It groups by Department automatically.
D) It returns the sum of salaries per department.

<details>
<summary>View Answer</summary>

**Answer:** B) It throws an `ONLY_FULL_GROUP_BY` syntax error.
**Explanation:** Standard SQL requires that any non-aggregated column in the `SELECT` clause must appear in the `GROUP BY` clause. MySQL 5.7+ strictly enforces this by default.
</details>

**Q23. What is the fundamental difference between the `WHERE` and `HAVING` clauses?**
A) `WHERE` is used with `UPDATE`, `HAVING` is used with `SELECT`.
B) `WHERE` filters rows before grouping; `HAVING` filters groups after grouping.
C) `HAVING` filters rows before grouping; `WHERE` filters groups after grouping.
D) They are completely interchangeable.

<details>
<summary>View Answer</summary>

**Answer:** B) `WHERE` filters rows before grouping; `HAVING` filters groups after grouping.
**Explanation:** You cannot use aggregate functions like `SUM()` in a `WHERE` clause because the groups don't exist yet. You must use `HAVING`.
</details>

**Q24. Which function combines two or more strings together?**
A) `JOIN()`
B) `MERGE()`
C) `CONCAT()`
D) `STRING_AGG()`

<details>
<summary>View Answer</summary>

**Answer:** C) `CONCAT()`
**Explanation:** `CONCAT(string1, string2, ...)` appends multiple strings into one continuous string.
</details>

**Q25. What is the result of `COALESCE(NULL, NULL, 'Hello', 'World')`?**
A) `NULL`
B) `HelloWorld`
C) `Hello`
D) `World`

<details>
<summary>View Answer</summary>

**Answer:** C) `Hello`
**Explanation:** `COALESCE()` evaluates its arguments in order and returns the very first non-NULL value it encounters.
</details>

**Q26. If `Population` is `NULL` for Antarctica, what will `AVG(Population)` do?**
A) Treat Antarctica's population as 0 in the calculation.
B) Throw an error.
C) Ignore Antarctica entirely (reducing the denominator).
D) Return `NULL` as the overall average.

<details>
<summary>View Answer</summary>

**Answer:** C) Ignore Antarctica entirely (reducing the denominator).
**Explanation:** `AVG()` ignores NULLs. If you have 10 countries and 1 has a NULL population, the sum is divided by 9, not 10.
</details>

**Q27. How would you calculate the number of unique departments in the `Employees` table?**
A) `SELECT DISTINCT COUNT(Department) FROM Employees;`
B) `SELECT COUNT(DISTINCT Department) FROM Employees;`
C) `SELECT UNIQUE(Department) FROM Employees;`
D) `SELECT COUNT(Department) FROM Employees GROUP BY DISTINCT;`

<details>
<summary>View Answer</summary>

**Answer:** B) `SELECT COUNT(DISTINCT Department) FROM Employees;`
**Explanation:** `COUNT(DISTINCT col)` builds a unique list of the values in the column, and then returns the size of that list.
</details>

**Q28. Which mathematical function always rounds a number UP to the nearest integer?**
A) `ROUND()`
B) `FLOOR()`
C) `CEIL()`
D) `TRUNCATE()`

<details>
<summary>View Answer</summary>

**Answer:** C) `CEIL()`
**Explanation:** `CEIL()` (Ceiling) always rounds up to the next whole number. `FLOOR()` always rounds down.
</details>

**Q29. What is the difference between `LENGTH()` and `CHAR_LENGTH()` in MySQL?**
A) `LENGTH()` counts bytes, `CHAR_LENGTH()` counts characters.
B) `LENGTH()` counts characters, `CHAR_LENGTH()` counts bytes.
C) They are aliases for the exact same function.
D) `LENGTH()` is for strings, `CHAR_LENGTH()` is for arrays.

<details>
<summary>View Answer</summary>

**Answer:** A) `LENGTH()` counts bytes, `CHAR_LENGTH()` counts characters.
**Explanation:** For multi-byte characters (like emojis or UTF-8 characters), `LENGTH()` will return a higher number than `CHAR_LENGTH()`.
</details>

**Q30. You want to extract the first 4 characters of a string column named `YearCode`. Which is correct?**
A) `SUBSTRING(YearCode, 0, 4)`
B) `SUBSTRING(YearCode, 1, 4)`
C) `LEFT(YearCode, 4)`
D) Both B and C

<details>
<summary>View Answer</summary>

**Answer:** D) Both B and C
**Explanation:** SQL strings are 1-indexed, so `SUBSTRING(col, 1, 4)` works perfectly, as does the syntactic sugar `LEFT(col, 4)`.
</details>

---

## Part 4: Joins & Relationships (Q31 - Q40)

**Q31. Which type of join returns only the rows where there is a match in BOTH tables?**
A) `LEFT JOIN`
B) `RIGHT JOIN`
C) `FULL OUTER JOIN`
D) `INNER JOIN`

<details>
<summary>View Answer</summary>

**Answer:** D) `INNER JOIN`
**Explanation:** An `INNER JOIN` requires the `ON` condition to evaluate to true for both tables; otherwise, the row is discarded.
</details>

**Q32. A query uses `FROM A LEFT JOIN B ON A.id = B.a_id`. If a row in Table A has no match in Table B, what happens?**
A) The row from Table A is discarded.
B) The query throws an error.
C) The row from Table A is kept, and Table B's columns are populated with `NULL`.
D) Table B creates a dummy record to match Table A.

<details>
<summary>View Answer</summary>

**Answer:** C) The row from Table A is kept, and Table B's columns are populated with `NULL`.
**Explanation:** This is the defining characteristic of a `LEFT JOIN`. It preserves the left table regardless of matches.
</details>

**Q33. What is a Cartesian Product (Cross Join)?**
A) Joining a table to itself.
B) Every row from the first table is paired with every row from the second table.
C) A join that uses three or more tables.
D) A join that filters out all NULL values.

<details>
<summary>View Answer</summary>

**Answer:** B) Every row from the first table is paired with every row from the second table.
**Explanation:** A `CROSS JOIN` creates a matrix. If Table A has 10 rows and Table B has 10 rows, the result has 100 rows.
</details>

**Q34. How do you find records in Table A that do NOT have a corresponding record in Table B?**
A) `INNER JOIN ... WHERE B.id IS NULL`
B) `LEFT JOIN ... WHERE B.id IS NULL`
C) `RIGHT JOIN ... WHERE A.id IS NOT NULL`
D) `CROSS JOIN ... WHERE B.id = 0`

<details>
<summary>View Answer</summary>

**Answer:** B) `LEFT JOIN ... WHERE B.id IS NULL`
**Explanation:** This is the standard "Anti-Join" pattern. You attempt the stitch using `LEFT JOIN`, and then explicitly filter for the rows where the stitch failed (`IS NULL`).
</details>

**Q35. What is a "Self-Join"?**
A) A special keyword in SQL (`SELF JOIN`).
B) Joining a table to itself using two different table aliases.
C) A join that automatically infers the foreign keys.
D) A join that operates in memory without reading from disk.

<details>
<summary>View Answer</summary>

**Answer:** B) Joining a table to itself using two different table aliases.
**Explanation:** To find hierarchical relationships (e.g., an Employee's Manager who is also an Employee), you `INNER JOIN employees e1 ON e1.manager_id = e2.employee_id`.
</details>

**Q36. You write `FROM Users u INNER JOIN Orders o ON u.id = o.user_id`. A user has exactly 3 orders. How many rows will represent this user in the result set?**
A) 1
B) 3
C) 4
D) 0

<details>
<summary>View Answer</summary>

**Answer:** B) 3
**Explanation:** Because the relationship is 1-to-Many, the User data is duplicated three times, once for each order row.
</details>

**Q37. Which of the following is TRUE about `FULL OUTER JOIN` in MySQL?**
A) It uses the `FULL OUTER JOIN` keyword.
B) It returns everything from the Left and Right tables.
C) MySQL does not support the `FULL OUTER JOIN` syntax directly.
D) It is much faster than an `INNER JOIN`.

<details>
<summary>View Answer</summary>

**Answer:** C) MySQL does not support the `FULL OUTER JOIN` syntax directly.
**Explanation:** Unlike Postgres or SQL Server, MySQL lacks `FULL OUTER JOIN`. You must emulate it by doing a `LEFT JOIN`, a `UNION`, and a `RIGHT JOIN`.
</details>

**Q38. Why is implicit join syntax (`FROM A, B WHERE A.id = B.id`) discouraged?**
A) It is slower than explicit joins.
B) It is prone to accidental Cartesian Products if you forget the `WHERE` clause.
C) It cannot be used with more than two tables.
D) It doesn't work in modern MySQL.

<details>
<summary>View Answer</summary>

**Answer:** B) It is prone to accidental Cartesian Products if you forget the `WHERE` clause.
**Explanation:** Mixing join logic with filtering logic in the `WHERE` clause makes code hard to read and highly prone to catastrophic Cross Joins if a condition is missed.
</details>

**Q39. Can you join a table on multiple conditions simultaneously?**
A) No, `ON` only accepts one equality check.
B) Yes, by chaining conditions with `AND` in the `ON` clause.
C) Yes, but only if you use a `WHERE` clause for the second condition.
D) No, you must write two separate `JOIN` statements.

<details>
<summary>View Answer</summary>

**Answer:** B) Yes, by chaining conditions with `AND` in the `ON` clause.
**Explanation:** E.g., `ON A.id = B.id AND A.date = B.date`.
</details>

**Q40. If Table A has a composite primary key consisting of two columns, how must you join Table B to it to ensure uniqueness?**
A) Join on just the first column.
B) Join on just the second column.
C) Join on both columns using `AND`.
D) Composite keys cannot be used in Joins.

<details>
<summary>View Answer</summary>

**Answer:** C) Join on both columns using `AND`.
**Explanation:** A composite key requires all its parts to guarantee row uniqueness. If you omit one, you risk a partial Cartesian fan-out.
</details>

---

## Part 5: Advanced SQL & Architecture (Q41 - Q50)

**Q41. What does the `EXISTS` keyword do in a `WHERE` clause?**
A) Checks if a table exists in the database.
B) Returns `TRUE` if the inner subquery returns one or more rows.
C) Checks if a specific column exists in the select list.
D) Confirms that a `NULL` value is present.

<details>
<summary>View Answer</summary>

**Answer:** B) Returns `TRUE` if the inner subquery returns one or more rows.
**Explanation:** `EXISTS` is used with correlated subqueries and utilizes short-circuit evaluation (it stops searching as soon as it finds the first match).
</details>

**Q42. In the Window Function `ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Salary DESC)`, what does `PARTITION BY` do?**
A) Groups the output so you only see one row per Department.
B) Resets the row numbering counter back to 1 for each new Department.
C) Sorts the Departments alphabetically.
D) Filters out Departments with low salaries.

<details>
<summary>View Answer</summary>

**Answer:** B) Resets the row numbering counter back to 1 for each new Department.
**Explanation:** `PARTITION BY` divides the result set into distinct partitions and applies the window function independently to each partition.
</details>

**Q43. What is the difference between `RANK()` and `DENSE_RANK()`?**
A) `RANK()` handles ties by skipping numbers (1, 1, 3); `DENSE_RANK()` does not skip (1, 1, 2).
B) `DENSE_RANK()` handles ties by skipping numbers; `RANK()` does not skip.
C) `RANK()` is a window function, `DENSE_RANK()` is an aggregate function.
D) There is no difference.

<details>
<summary>View Answer</summary>

**Answer:** A) `RANK()` handles ties by skipping numbers (1, 1, 3); `DENSE_RANK()` does not skip (1, 1, 2).
**Explanation:** `DENSE_RANK` leaves no gaps in the numbering sequence after ties.
</details>

**Q44. What is a Common Table Expression (CTE)?**
A) A permanent table created in the database.
B) A temporary result set defined using the `WITH` keyword, used for readability and recursion.
C) A specialized index used for faster joins.
D) A stored procedure that returns a table.

<details>
<summary>View Answer</summary>

**Answer:** B) A temporary result set defined using the `WITH` keyword, used for readability and recursion.
**Explanation:** CTEs act like disposable views that exist only for the duration of the query execution.
</details>

**Q45. What is the purpose of an Index in a database?**
A) To enforce data integrity and prevent NULLs.
B) To compress the size of the database on disk.
C) To vastly speed up data retrieval operations (SELECTs).
D) To automatically back up tables.

<details>
<summary>View Answer</summary>

**Answer:** C) To vastly speed up data retrieval operations (SELECTs).
**Explanation:** An index creates a separate data structure (usually a B-Tree) that allows the database engine to find rows in `O(log N)` time rather than scanning the entire table.
</details>

**Q46. Which of the following is a consequence of adding too many indexes to a table?**
A) `SELECT` statements become drastically slower.
B) `INSERT`, `UPDATE`, and `DELETE` operations become slower.
C) The database crashes due to memory overflow.
D) Data types are forcibly converted to strings.

<details>
<summary>View Answer</summary>

**Answer:** B) `INSERT`, `UPDATE`, and `DELETE` operations become slower.
**Explanation:** Every time you modify data in the table, the database must also update all associated indexes, creating a write-performance penalty.
</details>

**Q47. What does the "A" in ACID properties stand for?**
A) Availability
B) Asynchronous
C) Atomicity
D) Authenticity

<details>
<summary>View Answer</summary>

**Answer:** C) Atomicity
**Explanation:** Atomicity means that a database transaction must be "all or nothing." If part of the transaction fails, the entire transaction is rolled back.
</details>

**Q48. Which SQL statement is used to combine the result sets of two or more `SELECT` queries into a single column output?**
A) `JOIN`
B) `MERGE`
C) `UNION`
D) `APPEND`

<details>
<summary>View Answer</summary>

**Answer:** C) `UNION`
**Explanation:** `UNION` stacks the results vertically. `UNION` removes duplicates, while `UNION ALL` keeps duplicates and is much faster.
</details>

**Q49. A query fails with: "Subquery returns more than 1 row". Which operator was likely used inappropriately with the subquery?**
A) `IN`
B) `EXISTS`
C) `=`
D) `ANY`

<details>
<summary>View Answer</summary>

**Answer:** C) `=`
**Explanation:** The equality operator (`=`) requires the subquery to be a Scalar Subquery (returning exactly 1 row and 1 column). If it returns multiple rows, it crashes.
</details>

**Q50. Which operator allows you to pivot rows into columns without using specialized functions?**
A) `SUM(CASE WHEN ... THEN ... END)`
B) `GROUP_CONCAT()`
C) `OVER(PARTITION BY...)`
D) `ROLLUP`

<details>
<summary>View Answer</summary>

**Answer:** A) `SUM(CASE WHEN ... THEN ... END)`
**Explanation:** By wrapping a conditional `CASE` statement inside an aggregate function like `SUM`, you can conditionally count or add values to simulate a Pivot Table.
</details>

**Q51. What will be the result of `WHERE score = 100 OR score = 200 AND status = 'Pass'` if `score` is 100 and `status` is 'Fail'?**
A) The row is excluded.
B) The row is included.
C) The query throws an error.
D) The query hangs.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because AND has higher precedence, it groups as `score = 100 OR (score = 200 AND status = 'Pass')`. Since `score = 100` is TRUE, the entire OR expression evaluates to TRUE, including the row.
</details>

**Q52. How can you find all records where the `username` ends with an underscore `_`?**
A) WHERE username LIKE '%_'
B) WHERE username LIKE '%\_'
C) WHERE username = '%_'
D) WHERE username LIKE '*\_'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because `_` is a wildcard, it must be escaped with a backslash `\` to be treated as a literal underscore character.
</details>

**Q53. Can you use mathematical calculations directly within a WHERE clause?**
A) No, calculations must be done in the SELECT clause.
B) Yes, e.g., `WHERE salary * 1.1 > 50000`.
C) Yes, but only addition and subtraction.
D) No, calculations require a stored procedure.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL allows mathematical expressions and functions to be evaluated directly within the WHERE clause to filter rows based on calculated results.
</details>

**Q54. Which query correctly finds all rows where `hire_date` is in the year 2023?**
A) WHERE hire_date = 2023
B) WHERE YEAR(hire_date) = 2023
C) WHERE hire_date LIKE '2023'
D) WHERE hire_date IN (2023)

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `YEAR()` function extracts the year part from a DATE or DATETIME column, which can then be compared to the integer 2023.
</details>

**Q55. Is it good practice for performance to use functions on indexed columns in a WHERE clause (e.g., `WHERE YEAR(date_col) = 2023`)?**
A) Yes, it speeds up the query.
B) No, it typically prevents the use of indexes (creates non-sargable conditions).
C) It makes no difference to performance.
D) Yes, but only for DATETIME columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Wrapping a column in a function prevents MySQL from using standard B-tree indexes on that column, forcing a full table scan.
</details>

**Q56. How can you efficiently query dates in 2023 without breaking indexes?**
A) WHERE date_col LIKE '2023%'
B) WHERE YEAR(date_col) = 2023
C) WHERE date_col BETWEEN '2023-01-01' AND '2023-12-31'
D) WHERE date_col = '2023'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Using a range condition with raw column values allows the MySQL optimizer to efficiently utilize indexes.
</details>

**Q57. What is the difference between `IN` and `EXISTS`?**
A) `IN` evaluates a list of values, while `EXISTS` checks if a subquery returns any rows.
B) `EXISTS` is for numbers, `IN` is for strings.
C) There is no logical difference; they are aliases.
D) `IN` always performs faster than `EXISTS`.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `IN` compares a value against a literal list or a single-column subquery result. `EXISTS` simply checks if a subquery produces one or more rows.
</details>

**Q58. Which keyword can be used to explicitly specify an escape character for the LIKE operator?**
A) ESCAPE
B) AVOID
C) IGNORE
D) MATCH

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can define a custom escape character using the `ESCAPE` clause, e.g., `LIKE '%|%%' ESCAPE '|'`.
</details>

**Q59. If `qty` is 5, what is the result of `WHERE qty > 10 OR qty IS NULL`?**
A) TRUE
B) FALSE
C) NULL
D) Syntax Error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `5 > 10` is FALSE. `5 IS NULL` is FALSE. FALSE OR FALSE evaluates to FALSE.
</details>

**Q60. Which query uses aliases correctly to filter data?**
A) SELECT name AS n FROM users WHERE n = 'John';
B) SELECT name FROM users AS u WHERE u.name = 'John';
C) SELECT name AS n FROM users WHERE AS n = 'John';
D) SELECT name FROM users WHERE name AS 'John';

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Table aliases can be used in the WHERE clause. However, standard SQL (and MySQL without special settings) does not allow column aliases defined in the SELECT clause to be used in the WHERE clause because WHERE is evaluated before SELECT.
</details>

**Q61. Why can't you typically use a SELECT column alias in a WHERE clause?**
A) Because aliases are only for presentation.
B) Because WHERE is evaluated before the SELECT clause.
C) Because WHERE is evaluated after the ORDER BY clause.
D) Because aliases are case-sensitive.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The logical execution order of SQL processes the `FROM` and `WHERE` clauses before the `SELECT` clause, meaning the alias does not exist yet when the `WHERE` clause is evaluated.
</details>

**Q62. What does `WHERE column_name = ''` check for?**
A) NULL values
B) Empty string values
C) Both NULL and empty strings
D) Spaces only

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** An empty string `''` is a specific string of zero length, which is entirely distinct from `NULL` (the absence of a value).
</details>

**Q63. If a table has values (10, 20, NULL, 30), what will `SELECT COUNT(*) FROM table WHERE val NOT IN (10, 20)` return?**
A) 2 (NULL, 30)
B) 1 (30)
C) 0
D) 4

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NULL NOT IN (...)` evaluates to NULL (Unknown), which is not TRUE. Therefore, the row with NULL is excluded. Only the row with 30 matches.
</details>

**Q64. How does `WHERE val NOT IN (10, 20, NULL)` behave?**
A) It returns rows not equal to 10 or 20.
B) It returns rows with NULL.
C) It always evaluates to empty/false for all rows.
D) It ignores the NULL value in the list.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A `NOT IN` list containing a NULL value will always cause the condition to evaluate to NULL (Unknown) for any non-null input, meaning it will return 0 rows.
</details>

**Q65. To find rows where `name` doesn't contain the letter 'A', you would use:**
A) WHERE name LIKE '!%A%'
B) WHERE name NOT LIKE '%A%'
C) WHERE NOT name = '%A%'
D) WHERE name EXCLUDES 'A'

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `NOT LIKE` is the correct syntax to find strings that do not match the specified pattern.
</details>

**Q66. What is the standard behavior of trailing spaces in a `VARCHAR` column when using the `=` operator in a WHERE clause?**
A) They are strictly compared.
B) They cause a syntax error.
C) They are ignored during comparison.
D) They are converted to NULL.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, standard string comparison using `=` ignores trailing spaces. 'abc' is considered equal to 'abc '.
</details>

**Q67. How does the `LIKE` operator handle trailing spaces in a pattern comparison?**
A) It ignores trailing spaces, just like `=`.
B) It includes trailing spaces in the pattern match.
C) It trims spaces before matching.
D) It throws an error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Unlike `=`, the `LIKE` operator considers trailing spaces significant. 'abc' LIKE 'abc ' evaluates to FALSE.
</details>

**Q68. Which operator tests if a value is greater than all values returned by a subquery?**
A) > ANY
B) > ALL
C) > SOME
D) > EXISTS

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ALL` keyword, used with a comparison operator, evaluates to TRUE only if the condition is met for every single value returned by the subquery.
</details>

**Q69. Which of the following is synonymous with `<> ALL`?**
A) NOT IN
B) NOT LIKE
C) NOT EXISTS
D) != ANY

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Saying a value is "not equal to all" values in a list is logically the exact same as saying the value is "not in" the list.
</details>

**Q70. What does the `ANY` operator do when prefixed with `=` (i.e., `= ANY`)?**
A) It functions identically to `IN`.
B) It functions identically to `EXISTS`.
C) It functions identically to `ALL`.
D) It causes a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `= ANY` checks if a value is equal to at least one value in a subquery's result, which is precisely how the `IN` operator works.
</details>

**Q71. Consider `WHERE A AND B OR C AND D`. What is the order of evaluation?**
A) (A AND B) OR (C AND D)
B) A AND (B OR C) AND D
C) Left to right strictly
D) ((A AND B) OR C) AND D

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `AND` has higher precedence, so `A AND B` is evaluated, then `C AND D` is evaluated. Finally, the two results are combined with `OR`.
</details>

**Q72. If `val` is NULL, what does `WHERE val <> 5` return?**
A) TRUE
B) FALSE
C) NULL
D) 1

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Any arithmetic comparison involving NULL evaluates to NULL (Unknown), and the row will not be included in the results.
</details>

**Q73. Which function can be used to convert a NULL value to a specific alternate value for comparison?**
A) CONVERT_NULL()
B) COALESCE()
C) ISNULL()
D) AVOID_NULL()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `COALESCE()` (or `IFNULL()`) returns the first non-NULL value in a list, allowing you to substitute a default value during comparisons, e.g., `WHERE COALESCE(val, 0) = 0`.
</details>

**Q74. What is the result of `WHERE 1 = 1`?**
A) It filters out all records.
B) It always evaluates to TRUE, matching all records.
C) It creates a syntax error.
D) It drops the table.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `1 = 1` is a tautology (always true). It's frequently used in dynamic SQL generation to safely append subsequent `AND condition` blocks.
</details>

**Q75. How can you find records created in the last 7 days?**
A) WHERE created_at >= NOW() - 7
B) WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
C) WHERE created_at = 7 DAYS
D) WHERE created_at > LAST(7)

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `DATE_SUB()` function correctly subtracts a specified interval (7 days) from the current date and time (`NOW()`).
</details>

**Q76. Which query filters out rows where `status` is either 'Pending' or 'Draft'?**
A) WHERE status != 'Pending' OR status != 'Draft'
B) WHERE status != 'Pending' AND status != 'Draft'
C) WHERE NOT (status = 'Pending' AND status = 'Draft')
D) WHERE status NOT ('Pending', 'Draft')

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Using `AND` ensures that a valid row is simultaneously NOT 'Pending' AND NOT 'Draft'. Option A would include all rows because a status cannot be both at the same time.
</details>

**Q77. What happens when you combine `BETWEEN` with character strings?**
A) It is impossible.
B) It compares strings based on dictionary (lexicographical) sorting.
C) It compares strings based on their length.
D) It converts the strings to integers first.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `BETWEEN 'Apple' AND 'Banana'` will match words starting with Apple and everything up to Banana based on the active character set collation.
</details>

**Q78. In MySQL, can you use mathematical operators (+, -, *, /) in a WHERE clause?**
A) Yes, absolutely.
B) No, only logical operators are allowed.
C) Yes, but only with constants, not columns.
D) No, mathematical operators belong in the SELECT list.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can perform arithmetic directly in the WHERE clause, e.g., `WHERE price * quantity > 1000`.
</details>

**Q79. Which function allows pattern matching using Regular Expressions in a MySQL WHERE clause?**
A) REGEX_MATCH
B) REGEXP or RLIKE
C) MATCH_PATTERN
D) LIKE_REGEX

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `REGEXP` (and its synonym `RLIKE`) allows for complex pattern matching using regular expressions, which is more powerful than the standard `LIKE` operator.
</details>

**Q80. How would you match a string that begins with 'A', 'B', or 'C' using REGEXP?**
A) WHERE col REGEXP '^[ABC]'
B) WHERE col LIKE '[ABC]%'
C) WHERE col REGEXP 'A|B|C%'
D) WHERE col MATCH '^[ABC]'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `^` anchors the pattern to the beginning of the string, and `[ABC]` matches any one of the characters inside the brackets.
</details>

**Q81. Is the `BETWEEN` operator exclusive or inclusive in MySQL?**
A) Exclusive of both bounds.
B) Inclusive of both bounds.
C) Inclusive of the lower bound, exclusive of the upper.
D) Configurable via session variables.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `val BETWEEN x AND y` is logically identical to `val >= x AND val <= y`. Both the start and end values are included.
</details>

**Q82. If `val` is 15, what does `WHERE val BETWEEN 20 AND 10` evaluate to?**
A) TRUE
B) FALSE
C) NULL
D) Syntax Error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The syntax requires `BETWEEN min AND max`. Since 15 is not >= 20 and <= 10, it evaluates to FALSE. The order of values matters.
</details>

**Q83. How do you format a basic SELECT statement that filters data?**
A) WHERE [condition] SELECT * FROM [table];
B) SELECT * WHERE [condition] FROM [table];
C) SELECT * FROM [table] WHERE [condition];
D) FROM [table] SELECT * WHERE [condition];

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The standard SQL formatting is SELECT [columns] FROM [table] WHERE [conditions].
</details>

**Q84. Which statement represents correct boolean logic?**
A) NOT (A AND B) = (NOT A) AND (NOT B)
B) NOT (A AND B) = (NOT A) OR (NOT B)
C) NOT (A OR B) = (NOT A) OR (NOT B)
D) NOT (NOT A) = NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This is De Morgan's Law. Negating an `AND` expression is equivalent to negating both individual conditions and linking them with an `OR`.
</details>

**Q85. Can `IS NULL` and `IS NOT NULL` be used with composite types (like multiple columns)?**
A) Yes, e.g., `WHERE (col1, col2) IS NULL`
B) No, they can only evaluate one single column at a time.
C) Yes, but only in strict mode.
D) Yes, using the MULTI_NULL() function.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL supports row constructors. `(col1, col2) IS NULL` evaluates to true if BOTH `col1` and `col2` are NULL.
</details>

**Q86. What is the effect of `WHERE id = NULL`?**
A) Finds rows where id is explicitly set to the string 'NULL'.
B) Finds rows where id is the NULL value.
C) Yields an empty result set.
D) Raises a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `=` operator cannot compare NULL. The result of `id = NULL` is NULL (Unknown), so no rows are matched and returned.
</details>

**Q87. Which of the following is NOT a valid MySQL operator?**
A) `<=>`
B) `||`
C) `&&`
D) `==`

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL uses a single equals sign `=` for equality comparisons. `==` is used in many programming languages but is not valid in standard SQL or MySQL. (`||` and `&&` are synonyms for OR and AND).
</details>

**Q88. To retrieve distinct records after filtering, where does the `DISTINCT` keyword go?**
A) SELECT DISTINCT * FROM table WHERE condition;
B) SELECT * FROM DISTINCT table WHERE condition;
C) SELECT * FROM table WHERE DISTINCT condition;
D) SELECT * FROM table WHERE condition DISTINCT;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `DISTINCT` keyword must immediately follow the `SELECT` keyword to apply to the resulting columns.
</details>

**Q89. What happens if you run a `SELECT` without a `WHERE` clause?**
A) It prompts you to enter a WHERE clause.
B) It throws an error.
C) It retrieves all rows from the specified table(s).
D) It retrieves only the first row.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The WHERE clause is optional. Omitting it means there are no filtering conditions, so the query operates on every row in the table.
</details>

**Q90. Which combination of keywords allows testing if a value matches ANY value in a provided list?**
A) IN (...)
B) = ANY (...)
C) Both A and B
D) EXISTS (...)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `val IN (1, 2, 3)` is functionally identical to `val = ANY (1, 2, 3)`. Both return true if the value matches any item in the list.
</details>

**Q91. What is the difference between `<>` and `!=`?**
A) `<>` is for numbers, `!=` is for strings.
B) `<>` is standard SQL, `!=` is a common extension.
C) `!=` handles NULLs safely, `<>` does not.
D) There is absolutely no functional difference in MySQL.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Both `<>` and `!=` mean "not equal to" and function exactly the same way in MySQL. `<>` is the ANSI SQL standard.
</details>

**Q92. What will `SELECT * FROM users WHERE 0;` return?**
A) The first record.
B) An empty set.
C) All records where an ID is 0.
D) All records.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, an integer `0` evaluated in a boolean context is equivalent to FALSE. Therefore, `WHERE 0` filters out all rows.
</details>

**Q93. If a table `T` has 100 rows, how many rows will `SELECT * FROM T WHERE TRUE;` return?**
A) 1
B) 0
C) 100
D) It throws an error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The keyword `TRUE` acts as a constant that evaluates to 1. Because the condition is always met for every row, all 100 rows are returned.
</details>

**Q94. Which query finds rows where `desc` is exactly 3 characters, but doesn't start with 'A'?**
A) WHERE desc LIKE '___' AND desc NOT LIKE 'A%'
B) WHERE desc LIKE '___' OR desc NOT LIKE 'A%'
C) WHERE desc = '___' AND desc != 'A%'
D) WHERE desc IN ('___') AND NOT 'A%'

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The three underscores `___` enforce a 3-character length. The `AND` clause combines this with `NOT LIKE 'A%'` to exclude those starting with A.
</details>

**Q95. How does MySQL evaluate string numbers vs integers, e.g., `WHERE col_varchar = 123`?**
A) It throws a type mismatch error.
B) It converts the integer 123 to a string '123' and compares them.
C) It converts the `col_varchar` values to numbers and compares them.
D) It always evaluates to FALSE.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When comparing a string column to an integer, MySQL implicitly converts the string values to numbers for the comparison, which can hurt performance and prevent index usage.
</details>

**Q96. What is the safest way to prevent implicit type conversion when comparing a VARCHAR column to a number?**
A) Use `WHERE col_varchar = 123`
B) Use `WHERE col_varchar = '123'`
C) Use `WHERE col_varchar = CAST(123 AS VARCHAR)`
D) Use `WHERE NUMBER(col_varchar) = 123`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Wrapping the literal number in quotes ('123') makes it a string literal, allowing MySQL to perform a direct string-to-string comparison without converting column values, preserving index efficiency.
</details>

**Q97. Which query efficiently checks if a string contains any text (is not null and not empty)?**
A) WHERE col != '' AND col IS NOT NULL
B) WHERE col > ''
C) Both A and B
D) WHERE col IS NOT EMPTY

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Both approaches work. `col > ''` works because an empty string is the "lowest" visible string value. If a column is NULL, `NULL > ''` evaluates to NULL (excluded), covering both conditions concisely.
</details>

**Q98. How do you find rows where `name` starts with 'O' followed by a single quote, like "O'Connor"?**
A) WHERE name LIKE 'O'%'
B) WHERE name LIKE 'O''%'
C) WHERE name LIKE "O'%"
D) Both B and C

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** You can escape a single quote by doubling it (`O''%`), or by enclosing the entire pattern in double quotes (`"O'%"`).
</details>

**Q99. What evaluates to TRUE when checking `WHERE 'a' = 'A'` in a database with a binary collation (`utf8mb4_bin`)?**
A) TRUE
B) FALSE
C) NULL
D) 1

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Binary collations evaluate strings based on exact byte values. Since 'a' and 'A' have different byte values (ASCII codes), the comparison is FALSE.
</details>

**Q100. Which logical operator is completely equivalent to `!` in MySQL?**
A) NOT
B) OR
C) AND
D) XOR

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The exclamation mark `!` is a synonym for the `NOT` operator in MySQL. For example, `WHERE ! (id = 5)` is the same as `WHERE NOT (id = 5)`.
</details>

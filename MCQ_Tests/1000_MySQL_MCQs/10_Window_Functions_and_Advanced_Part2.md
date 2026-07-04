**Q51. Which window function returns the value of the specified expression from the first row of the window frame?**
A) LAST_VALUE()
B) FIRST_VALUE()
C) LEAD()
D) LAG()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** FIRST_VALUE() returns the value from the first row in the current window frame.
</details>

**Q52. By default, what is the window frame for a window function if the `ORDER BY` clause is present but the `ROWS` or `RANGE` clause is omitted?**
A) `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`
B) `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`
C) `RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING`
D) `ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If ORDER BY is specified, the default frame extends from the start of the partition to the current row (inclusive of peers).
</details>

**Q53. Why might `LAST_VALUE()` return the current row's value instead of the actual last value in the partition if used with just an `ORDER BY` clause?**
A) Because `LAST_VALUE()` is a buggy function in MySQL.
B) Because the default window frame ends at the `CURRENT ROW`, so the current row is evaluated as the last row of the frame.
C) Because `ORDER BY` reverses the partition.
D) `LAST_VALUE()` always ignores the `ORDER BY` clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** With the default frame of `UNBOUNDED PRECEDING TO CURRENT ROW`, the "last value" in the frame is the current row. To get the true last value of the partition, use `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.
</details>

**Q54. Which function allows you to get the value of the N-th row in a window frame?**
A) NTH_VALUE()
B) NTILE()
C) RANK()
D) ROW_NUMBER()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** NTH_VALUE(expr, N) returns the value of expr from the N-th row of the window frame.
</details>

**Q55. You want to assign rows to 4 quartile buckets (1 to 4) based on their sales volume. Which function performs this directly?**
A) `NTILE(4) OVER (ORDER BY sales)`
B) `RANK() OVER (ORDER BY sales) / 4`
C) `QUARTILE() OVER (ORDER BY sales)`
D) `PERCENT_RANK() OVER (ORDER BY sales)`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** NTILE(N) distributes rows into a specified number of roughly equal groups (buckets), in this case, 4 groups for quartiles.
</details>

**Q56. What does `ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING` specify in an OVER clause?**
A) A frame consisting of all rows in the partition.
B) A frame consisting of the current row, the row immediately before it, and the row immediately after it.
C) A frame consisting only of the first and last rows of the partition.
D) A frame that calculates a 1-day moving average.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The ROWS clause defines a physical offset frame. `1 PRECEDING` and `1 FOLLOWING` includes the current row and its two adjacent neighbors.
</details>

**Q57. What is the difference between `ROWS` and `RANGE` in a window frame specification?**
A) `ROWS` treats rows as physical rows, while `RANGE` handles logical groups of rows with the same ORDER BY value (peers).
B) `ROWS` is used for integers, while `RANGE` is for dates.
C) There is no difference; they are synonyms.
D) `RANGE` requires a `GROUP BY` clause, `ROWS` does not.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** ROWS defines the frame by physical row count. RANGE defines the frame by logical values, grouping rows that have the same value in the ORDER BY column.
</details>

**Q58. How can you calculate a cumulative sum (running total) of a `sales` column ordered by `date`?**
A) `SUM(sales) OVER(PARTITION BY date)`
B) `SUM(sales) OVER(ORDER BY date)`
C) `CUM_SUM(sales) OVER(ORDER BY date)`
D) `SUM(sales) GROUP BY date`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When SUM is used with OVER(ORDER BY date), it applies the default frame (`UNBOUNDED PRECEDING AND CURRENT ROW`), effectively creating a running total.
</details>

**Q59. If you want to calculate the moving average of sales over the past 3 days (including the current day), which window frame is correct?**
A) `ROWS BETWEEN 3 PRECEDING AND CURRENT ROW`
B) `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`
C) `RANGE BETWEEN 3 PRECEDING AND CURRENT ROW`
D) `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To include the past 3 days (assuming 1 row per day), you need the current row + 2 preceding rows.
</details>

**Q60. Which function computes the relative rank of a row as a percentage (from 0 to 1)?**
A) PERCENT_RANK()
B) CUME_DIST()
C) NTILE()
D) Both A and B

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** PERCENT_RANK() calculates `(rank - 1) / (total_rows - 1)`, giving a percentage ranking from 0 to 1. CUME_DIST() calculates the cumulative distribution.
</details>

**Q61. Pivot tables in standard SQL (without a built-in PIVOT operator like SQL Server) are typically created using a combination of which techniques?**
A) `JOIN` and `HAVING`
B) `GROUP BY` and `CASE WHEN` (Conditional Aggregation)
C) `ORDER BY` and `LIMIT`
D) Window functions only

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, pivoting rows to columns is usually achieved using an aggregate function (like SUM or MAX) wrapping a CASE expression, grouped by the row identifier.
</details>

**Q62. Given a table with `Year`, `Quarter`, and `Revenue`, which snippet pivots the `Quarter` column into columns Q1, Q2, Q3, Q4?**
A) `SUM(CASE WHEN Quarter = 'Q1' THEN Revenue ELSE 0 END) AS Q1_Rev`
B) `PIVOT(Quarter FOR Revenue IN ('Q1', 'Q2', 'Q3', 'Q4'))`
C) `SELECT Quarter AS Q1, Quarter AS Q2 FROM table`
D) `TRANSPOSE Quarter TO Q1, Q2, Q3, Q4`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL lacks a native PIVOT operator, so conditional aggregation using SUM(CASE...) is the standard approach to pivot data.
</details>

**Q63. When using conditional aggregation to pivot data containing strings (e.g., finding an employee name based on their role), which aggregate function is typically used?**
A) SUM()
B) AVG()
C) MAX()
D) COUNT()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MAX() or MIN() can be used on strings to pick the non-null string value out of a CASE statement where all other conditions evaluate to NULL.
</details>

**Q64. If you write `COUNT(CASE WHEN status = 'Active' THEN 1 END)`, what does this achieve in a pivot query?**
A) It sums the values of the active statuses.
B) It counts the number of rows where the status is 'Active'.
C) It raises an error because COUNT cannot take a CASE statement.
D) It counts all rows in the table.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The CASE statement returns 1 for 'Active' and implicitly NULL otherwise. COUNT ignores NULLs, thus counting only 'Active' rows.
</details>

**Q65. Why is `GROUP BY` essential when creating a pivot table using conditional aggregation?**
A) It isn't essential; it's optional.
B) It collapses the conditionally aggregated columns down to a single row per grouping entity (e.g., per Year or per Employee).
C) It sorts the columns alphabetically.
D) It converts NULL values to zeroes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The purpose of a pivot is to summarize data. Without GROUP BY, the query would aggregate the entire table into a single row, rather than pivoting by a specific category.
</details>

**Q66. Which JSON function is used in MySQL to extract data from a JSON document?**
A) JSON_EXTRACT()
B) JSON_GET()
C) JSON_SELECT()
D) EXTRACT_JSON()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_EXTRACT() is the primary function used to extract parts of a JSON document using JSON path expressions.
</details>

**Q67. What is the shorthand operator for `JSON_EXTRACT(json_col, '$.key')` in MySQL?**
A) `json_col->'$.key'`
B) `json_col=>'$.key'`
C) `json_col>>'$.key'`
D) `json_col::'$.key'`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `->` operator is shorthand for JSON_EXTRACT(). It returns a JSON value.
</details>

**Q68. What is the difference between the `->` operator and the `->>` operator in MySQL JSON functions?**
A) `->` extracts arrays; `->>` extracts objects.
B) `->` returns a JSON string (with quotes); `->>` unquotes the extracted result (returns unquoted text).
C) `->` is for extraction; `->>` is for insertion.
D) There is no difference.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `->>` is the shorthand for `JSON_UNQUOTE(JSON_EXTRACT(...))`, which removes the surrounding quotes from string values.
</details>

**Q69. In a JSON document `{"user": {"name": "Alice", "age": 30}}`, what is the JSON path to access the name "Alice"?**
A) `$.user.name`
B) `$->user->name`
C) `user[name]`
D) `$.name`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON path expressions in MySQL start with `$` (representing the current document) followed by `.key_name` to traverse objects.
</details>

**Q70. If `data` is `{"skills": ["SQL", "Python", "Java"]}`, how do you extract "Python"?**
A) `JSON_EXTRACT(data, '$.skills.Python')`
B) `JSON_EXTRACT(data, '$.skills[1]')`
C) `JSON_EXTRACT(data, '$.skills[2]')`
D) `JSON_EXTRACT(data, '$."Python"')`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON arrays are zero-indexed. "Python" is at index 1, so the path is `$.skills[1]`.
</details>

**Q71. Which function checks whether a specific JSON document contains another JSON document?**
A) JSON_CONTAINS()
B) JSON_HAS()
C) JSON_INCLUDES()
D) JSON_MATCH()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_CONTAINS(target, candidate[, path]) returns 1 if the candidate JSON is found within the target JSON document.
</details>

**Q72. What function is used to create a JSON array from a set of values?**
A) MAKE_JSON_ARRAY()
B) JSON_ARRAY()
C) ARRAY_TO_JSON()
D) CONCAT_JSON()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_ARRAY(val1, val2, ...) evaluates a list of values and returns a JSON array containing those values.
</details>

**Q73. How do you create a JSON object containing key-value pairs in MySQL?**
A) `JSON_OBJECT('key1', 'value1', 'key2', 'value2')`
B) `JSON_MAKE('key1': 'value1', 'key2': 'value2')`
C) `TO_JSON('key1'='value1')`
D) `JSON_DICT('key1', 'value1')`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_OBJECT takes a variable list of arguments in key, value pairs and constructs a valid JSON object string.
</details>

**Q74. Which aggregate function groups result set rows into a single JSON array?**
A) JSON_ARRAYAGG()
B) GROUP_CONCAT_JSON()
C) JSON_AGG()
D) ARRAY_AGG()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_ARRAYAGG() is an aggregate function that takes a column or expression and returns a JSON array of the aggregated values.
</details>

**Q75. Which aggregate function returns a JSON object containing key-value pairs derived from the aggregated rows?**
A) JSON_OBJECTAGG()
B) JSON_GROUP_OBJECT()
C) AGG_JSON_OBJECT()
D) JSON_MAPAGG()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_OBJECTAGG(key, value) aggregates two columns (or expressions) into a single JSON object containing key-value pairs.
</details>

**Q76. How does `JSON_SET()` differ from `JSON_REPLACE()`?**
A) They are synonyms.
B) `JSON_SET()` inserts new values or updates existing ones; `JSON_REPLACE()` only updates existing values and ignores missing paths.
C) `JSON_REPLACE()` inserts new values; `JSON_SET()` only updates.
D) `JSON_SET()` requires an array, `JSON_REPLACE()` requires an object.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_SET() performs an upsert (update if exists, insert if not). JSON_REPLACE() strictly performs an update (does nothing if the path doesn't exist).
</details>

**Q77. What does the `JSON_REMOVE()` function do?**
A) Drops a JSON column from a table.
B) Removes data from a JSON document at a specified path.
C) Deletes a row if the JSON column is empty.
D) Strips quotes from a JSON string.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_REMOVE(json_doc, path[, path] ...) removes the specified paths and their values from the JSON document.
</details>

**Q78. If `json_doc` is `["a", "b", "c"]`, what is the result of `JSON_REMOVE(json_doc, '$[1]')`?**
A) `["a", "b", "c"]`
B) `["a", "c"]`
C) `["b", "c"]`
D) `["a", NULL, "c"]`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** It removes the element at index 1 ("b"), and shifts the remaining array elements, leaving `["a", "c"]`.
</details>

**Q79. Which function returns the path to a given string within a JSON document?**
A) JSON_FIND()
B) JSON_LOCATE()
C) JSON_SEARCH()
D) JSON_PATH()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** JSON_SEARCH(json_doc, 'one'|'all', search_str) returns the JSON path(s) pointing to matching string values.
</details>

**Q80. In `JSON_SEARCH(json_doc, 'all', 'apple')`, what does the 'all' parameter signify?**
A) It searches all rows in the table.
B) It returns the paths of all matches within the document, rather than just the first one.
C) It searches for 'apple' in both keys and values.
D) It ignores case completely.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The second argument specifies whether to return the path to the first match ('one') or an array of paths for all matches ('all').
</details>

**Q81. Can you index a specific key inside a JSON column in MySQL to improve search performance?**
A) Yes, by creating a standard index directly on the JSON column.
B) Yes, by creating a generated column that extracts the JSON key, and then indexing that generated column.
C) No, JSON columns cannot be indexed in MySQL.
D) Yes, by using the `INDEX_JSON()` function.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You cannot directly index a JSON column. The standard method is to create a virtual or stored generated column using `JSON_EXTRACT` (or `->>`) and place an index on that generated column. (MySQL 8.0.17+ also supports multi-valued indexes for JSON arrays).
</details>

**Q82. Which function turns a JSON document into relational data (rows and columns)?**
A) JSON_EXTRACT_TABLE()
B) JSON_TABLE()
C) UNNEST_JSON()
D) JSON_TO_RECORD()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_TABLE() extracts data from a JSON document and returns it as a relational table, which can be joined with other tables.
</details>

**Q83. When creating a pivot table logic to calculate total sales per region over different years, what replaces the missing cell values for regions that didn't have sales in a specific year?**
A) 0 (Zero) automatically
B) NULL, unless `COALESCE` or an `IFNULL` is applied around the aggregate/CASE expression.
C) The row is dropped.
D) An empty string.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If the CASE condition is never met for a grouping, SUM() evaluates over NULLs, returning NULL. COALESCE() or IFNULL() is often used to display 0 instead.
</details>

**Q84. What happens if you try to `JSON_EXTRACT` from a string that is not a valid JSON document?**
A) It automatically converts the string to JSON.
B) It returns NULL.
C) It throws a syntax error.
D) It returns the original string.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL JSON functions expect valid JSON format. Passing improperly formatted JSON strings will result in a runtime error ("Invalid JSON text").
</details>

**Q85. What does the wildcard `$.*` do in a JSON path?**
A) Returns all elements of the document as a string.
B) Evaluates to the values of all members in the current object.
C) Deletes all keys in an object.
D) Searches recursively through the entire document.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `$.*` selects the values of all properties of the object at the root document level. `**` is used for recursive descent.
</details>

**Q86. How do you append a value to the end of a JSON array in MySQL?**
A) `JSON_APPEND()`
B) `JSON_ARRAY_APPEND()`
C) `JSON_INSERT()`
D) `JSON_ADD()`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_ARRAY_APPEND(json_doc, path, val) appends a value to the end of the specified JSON array. (JSON_APPEND was deprecated and removed in MySQL 8.0).
</details>

**Q87. What does `JSON_TYPE()` return when applied to `{"name": "John"}`?**
A) 'STRING'
B) 'ARRAY'
C) 'OBJECT'
D) 'JSON'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** JSON_TYPE() returns a string indicating the type of the JSON value, which in this case is a JSON Object.
</details>

**Q88. Which function calculates the number of keys in a JSON object or elements in a JSON array?**
A) JSON_COUNT()
B) JSON_LENGTH()
C) JSON_SIZE()
D) LENGTH()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_LENGTH() returns the length of a JSON document. For arrays, it's the element count; for objects, it's the key count.
</details>

**Q89. If a window function is used alongside an aggregate function (e.g., `SUM() OVER(...)` and `COUNT()`), what rule must be followed?**
A) They cannot be mixed in the same SELECT statement.
B) The window function operates after the standard `GROUP BY` aggregations are complete.
C) The window function will ignore the `GROUP BY` clause.
D) Standard aggregations must be placed inside the `OVER()` clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The logical order of operations puts standard GROUP BY and HAVING clauses before window function evaluation. Window functions operate on the aggregated result set.
</details>

**Q90. Which function tests whether a given value is a valid JSON document?**
A) IS_JSON()
B) JSON_VALID()
C) VALIDATE_JSON()
D) CHECK_JSON()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_VALID() returns 1 if the argument is a valid JSON string, and 0 otherwise.
</details>

**Q91. Can `JSON_TABLE()` be used in the `FROM` clause of a SELECT statement?**
A) Yes, it generates a derived table that can be queried and joined like any standard table.
B) No, it can only be used in the SELECT list.
C) No, it must be used within a WHERE clause.
D) Yes, but only with cross joins.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_TABLE() is a table function; its primary purpose is to be used in the FROM clause to parse a JSON document into a relational format.
</details>

**Q92. Which JSON operator extracts a JSON value but unquotes scalar string values automatically?**
A) `->`
B) `->>`
C) `=>`
D) `#>`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `->>` operator is equivalent to `JSON_UNQUOTE(JSON_EXTRACT())`.
</details>

**Q93. What is the result of `JSON_KEYS('{"a": 1, "b": {"c": 30}}')`?**
A) `["a", "b", "c"]`
B) `["a", "b"]`
C) `{"a", "b"}`
D) `["c"]`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON_KEYS() returns the keys from the top-level value of a JSON object as a JSON array. It does not search recursively.
</details>

**Q94. You have a window function `SUM(sales) OVER(PARTITION BY department ORDER BY month)`. What is this calculating?**
A) Total sales for the entire department.
B) Average sales per month across all departments.
C) A running cumulative total of sales month-by-month for each department separately.
D) The moving average for the department.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Using SUM with PARTITION BY and ORDER BY evaluates the sum from the beginning of the partition up to the current row, producing a running total per partition.
</details>

**Q95. Which JSON function would you use to merge two JSON objects into one?**
A) JSON_MERGE_PATCH()
B) JSON_COMBINE()
C) JSON_CONCAT()
D) JSON_ADD()

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON_MERGE_PATCH() (and JSON_MERGE_PRESERVE()) merges two or more JSON documents into a single document.
</details>

**Q96. What is a key difference between `JSON_MERGE_PATCH` and `JSON_MERGE_PRESERVE` when a key exists in both objects?**
A) `PRESERVE` throws an error, `PATCH` overrides.
B) `PATCH` overrides the old value with the new one, `PRESERVE` creates an array containing both values.
C) `PATCH` ignores the new value, `PRESERVE` overrides.
D) There is no difference in behavior for objects.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** As the names suggest, PATCH follows RFC 7396 and overwrites values, whereas PRESERVE retains all values by wrapping duplicate keys into arrays.
</details>

**Q97. In a query utilizing conditional aggregation to pivot data, which statement is generally true about performance?**
A) Conditional aggregation using CASE is generally slower than sequential subqueries.
B) Conditional aggregation requires scanning the base data only once (per GROUP BY), making it an efficient way to pivot.
C) Conditional aggregation forces a full table scan and ignores all indexes.
D) Pivot tables cannot process more than 100 rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A conditional aggregation pivot allows the database engine to group the data and resolve all conditional checks in a single pass over the required rows.
</details>

**Q98. To extract the 3rd element of a JSON array located at key 'items', which path expression is used?**
A) `$.items[3]`
B) `$.items[2]`
C) `$.items.3`
D) `$.items(2)`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** JSON arrays are zero-indexed. The first element is 0, second is 1, and the third is 2.
</details>

**Q99. What does `JSON_DEPTH('{"a": {"b": [1, 2]}}')` return?**
A) 1
B) 2
C) 3
D) 4

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The depth is 3: the root object (`{}`) is depth 1, the nested object (`"a": {}`) is depth 2, and the array (`[1, 2]`) is depth 3.
</details>

**Q100. If you need to filter a query based on the output of a window function like `ROW_NUMBER()`, what is the standard SQL approach?**
A) Use the `HAVING` clause.
B) Put the window function in the `WHERE` clause.
C) Use a Common Table Expression (CTE) or derived table (subquery) to calculate the window function first, then filter in the outer query's `WHERE` clause.
D) You cannot filter based on window function output.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Window functions are executed in the SELECT phase, after WHERE and HAVING. Therefore, you must compute them in a subquery or CTE, then filter on the computed column in the outer query.
</details>

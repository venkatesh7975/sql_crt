**Q1. What is the storage size in bytes of a standard `INT` data type in MySQL?**
A) 1 byte
B) 2 bytes
C) 4 bytes
D) 8 bytes

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, a standard `INT` or `INTEGER` takes 4 bytes of storage, allowing a signed range from -2147483648 to 2147483647.
</details>

**Q2. Which integer type should you use to store a maximum signed value of 127 in the most space-efficient manner?**
A) SMALLINT
B) TINYINT
C) MEDIUMINT
D) INT

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `TINYINT` requires only 1 byte of storage and can store signed values from -128 to 127.
</details>

**Q3. If you declare a column as `INT UNSIGNED`, what is the minimum value it can hold?**
A) -2147483648
B) -32768
C) 0
D) 1

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `UNSIGNED` attribute restricts an integer column to non-negative numbers only, meaning the minimum value is always 0.
</details>

**Q4. In MySQL 8.0, what does the display width integer in `INT(10)` represent?**
A) The maximum number of digits the column can store
B) The exact storage size in bytes
C) A display hint for applications, though deprecated for integer types
D) The number of decimal places allowed

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The integer display width attribute (e.g., `INT(10)`) does not affect the storage or the range of values. It was used as a display hint, but this feature is deprecated for integer types in MySQL 8.0.
</details>

**Q5. What happens when you insert a value larger than the maximum allowed by an integer column in strict SQL mode?**
A) The value is truncated to the maximum allowed value
B) The insert is successful and wraps around to the minimum value
C) An error occurs, and the statement is aborted
D) It converts the column automatically to a larger integer type

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In strict SQL mode (which is default in MySQL 8.0), inserting a value out of range for the data type produces an error and aborts the insert.
</details>

**Q6. What is the main difference between `CHAR` and `VARCHAR` data types in MySQL?**
A) `CHAR` stores variable-length strings, while `VARCHAR` stores fixed-length strings
B) `CHAR` pads trailing spaces to the specified length, while `VARCHAR` only uses required space plus a length prefix
C) `VARCHAR` can store numeric values, while `CHAR` cannot
D) `CHAR` is case-sensitive by default, while `VARCHAR` is not

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `CHAR` columns are fixed-length and padded with spaces to the specified length on storage. `VARCHAR` columns are variable-length and use 1 or 2 bytes to store the length prefix.
</details>

**Q7. When retrieving data from a `CHAR` column, how does MySQL handle trailing spaces by default?**
A) They are preserved exactly as inserted
B) They are replaced by NULL characters
C) They are automatically removed
D) They throw an error if the column is indexed

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Unless the `PAD_CHAR_TO_FULL_LENGTH` SQL mode is enabled, trailing spaces are automatically removed when `CHAR` values are retrieved.
</details>

**Q8. What is the maximum length in characters you can specify for a `VARCHAR(M)` column (assuming single-byte character set and no other columns)?**
A) 255
B) 65,535
C) 16,383
D) 4,294,967,295

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The maximum row size in MySQL is 65,535 bytes. A `VARCHAR` can take up to 65,535 bytes (minus overhead), meaning roughly 65,532 bytes are available for characters in a single-byte charset like latin1.
</details>

**Q9. If a string exceeds the maximum length of a `VARCHAR` column during an `INSERT` statement in strict mode, what happens?**
A) The string is silently truncated
B) MySQL automatically converts the column to `TEXT`
C) An error is generated and the statement fails
D) The extra characters are stored in a hidden overflow table

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In strict mode, if you try to insert a string longer than the column's defined maximum length, an error occurs, preventing the truncation and insertion.
</details>

**Q10. How much storage overhead is required for the length prefix of a `VARCHAR(500)` column?**
A) 1 byte
B) 2 bytes
C) 3 bytes
D) 4 bytes

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `VARCHAR` requires 1 byte for the length prefix if the maximum column length is 255 bytes or less, and 2 bytes if it is greater than 255 bytes. 500 characters requires 2 bytes.
</details>

**Q11. In the data type `DECIMAL(10, 2)`, what does the number 2 represent?**
A) The total number of digits
B) The number of digits before the decimal point
C) The scale, which is the number of digits after the decimal point
D) The storage size in bytes

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In `DECIMAL(M, D)`, `M` is the precision (total digits) and `D` is the scale (number of digits after the decimal point).
</details>

**Q12. What is the maximum allowed precision `M` for a `DECIMAL(M, D)` data type in MySQL?**
A) 38
B) 65
C) 255
D) 1024

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The maximum number of digits (precision) for `DECIMAL` is 65. The maximum scale `D` is 30.
</details>

**Q13. Why is `DECIMAL` preferred over `FLOAT` or `DOUBLE` for financial data?**
A) It uses less storage space
B) It stores exact numeric values without floating-point rounding errors
C) It allows for faster arithmetic calculations
D) It can store larger numbers than `DOUBLE`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `DECIMAL` is a fixed-point type that stores exact numeric values, avoiding the rounding inaccuracies inherent in approximate types like `FLOAT` or `DOUBLE`.
</details>

**Q14. How many bytes does MySQL use to store a `DECIMAL(9, 0)` column?**
A) 2 bytes
B) 4 bytes
C) 8 bytes
D) 9 bytes

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL stores `DECIMAL` values by packing 9 digits into 4 bytes. Since precision is 9 and there's no fractional part, it takes exactly 4 bytes.
</details>

**Q15. What happens if you insert the value `1234.567` into a column defined as `DECIMAL(6,2)`?**
A) It is stored as `1234.56`
B) It is stored as `1234.57` due to rounding
C) An error occurs because the value exceeds the precision
D) It is stored as `1234.567` by dynamically expanding the scale

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The value fits within the precision (4 digits before, 2 after). The fractional part has 3 digits, so it is rounded to the nearest scale, becoming `1234.57`. A warning may be generated, but it inserts if strict mode doesn't block rounding fractional digits.
</details>

**Q16. Under the hood, how are `ENUM` values stored in MySQL?**
A) As exact string copies
B) As numeric indices representing the string options
C) As a JSON array of strings
D) As a bitmask

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `ENUM` values are stored internally as integers representing the index of the string in the enumeration list. This makes storage very compact.
</details>

**Q17. What is the maximum number of distinct elements allowed in an `ENUM` definition?**
A) 255
B) 65,535
C) 1,024
D) 4,294,967,295

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** An `ENUM` column can have a maximum of 65,535 distinct elements.
</details>

**Q18. If a column is defined as `status ENUM('active', 'pending', 'closed')`, what integer index does the value `'pending'` have?**
A) 0
B) 1
C) 2
D) 3

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `ENUM` indices start at 1. Therefore, 'active' is 1, 'pending' is 2, and 'closed' is 3. Index 0 is reserved for the empty string (error value) in non-strict mode.
</details>

**Q19. How does `ORDER BY` behave on an `ENUM` column by default?**
A) Alphabetically based on the string values
B) Based on the integer index values (the order they were defined)
C) Randomly
D) By string length

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because `ENUM` is stored as an integer index, sorting defaults to the order in which the elements were defined in the column definition.
</details>

**Q20. What is a key difference between `ENUM` and `SET` data types?**
A) `ENUM` allows multiple values per row, while `SET` only allows one
B) `SET` allows multiple values per row from a predefined list, while `ENUM` only allows one
C) `SET` is case-sensitive, while `ENUM` is not
D) `ENUM` uses bitwise operations, while `SET` uses integer indices

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `ENUM` restricts a column to contain exactly one value from the list, whereas `SET` allows a column to contain zero, one, or multiple values from the list.
</details>

**Q21. Why is storing JSON data in the native `JSON` data type preferred over a `VARCHAR` or `TEXT` column?**
A) It avoids the maximum row size limitation
B) It automatically validates JSON syntax and provides optimized binary storage
C) It converts JSON to a relational format automatically
D) It enforces a predefined schema for the JSON document

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The native `JSON` type ensures the stored document is valid JSON, and it stores the data in an optimized binary format for faster read access to document elements without reparsing.
</details>

**Q22. Which function is used to extract a scalar value from a JSON column in MySQL?**
A) JSON_PARSE()
B) JSON_UNQUOTE(JSON_EXTRACT())
C) JSON_GET()
D) JSON_FETCH()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `JSON_EXTRACT()` retrieves the value, and `JSON_UNQUOTE()` removes surrounding quotes from strings. In MySQL, the shorthand `->>` operator is equivalent to this combination.
</details>

**Q23. By default, how are JSON keys sorted when a JSON object is stored in MySQL?**
A) In the order they were inserted
B) Randomly
C) Lexicographically by key name
D) By value data type length

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL's native JSON binary storage normalizes the JSON document, which includes sorting object keys lexicographically for faster lookups.
</details>

**Q24. How can you create an index on a specific key within a `JSON` column?**
A) `CREATE INDEX idx ON table (json_column.key)`
B) You cannot index JSON data directly; full table scans are required
C) By creating a generated column that extracts the key, and then indexing the generated column
D) `CREATE JSON_INDEX ON table (json_column->'$.key')`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** You cannot directly index a JSON column. Instead, you create a virtual generated column that extracts the JSON value and index that generated column.
</details>

**Q25. What happens if you try to insert invalid JSON syntax (e.g., missing closing brace) into a `JSON` column?**
A) It stores the value as a plain string
B) It stores NULL instead
C) MySQL attempts to auto-fix the syntax
D) An error is generated and the insert fails

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The `JSON` data type provides automatic validation. Inserting an invalid JSON document raises an error.
</details>

**Q26. What constraint guarantees that a column or a set of columns uniquely identifies each row in a table?**
A) UNIQUE
B) NOT NULL
C) PRIMARY KEY
D) FOREIGN KEY

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A `PRIMARY KEY` constraint uniquely identifies each record. It must contain unique values and cannot contain NULLs.
</details>

**Q27. How many `PRIMARY KEY` constraints can a single MySQL table have?**
A) One per table
B) One per column
C) Up to 16
D) Unlimited

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A table can only have one primary key constraint, although that primary key can be composite (made up of multiple columns).
</details>

**Q28. If a column is defined as `PRIMARY KEY`, what other constraint is implicitly applied to it?**
A) AUTO_INCREMENT
B) NOT NULL
C) DEFAULT
D) FOREIGN KEY

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Primary key columns must uniquely identify a row and cannot be NULL. MySQL implicitly adds the `NOT NULL` constraint to primary key columns.
</details>

**Q29. What is a "composite" primary key?**
A) A primary key that references another table
B) A primary key made of multiple data types
C) A primary key that automatically increments
D) A primary key composed of two or more columns

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A composite primary key uses multiple columns to create a unique identifier for a row, rather than relying on a single column.
</details>

**Q30. In InnoDB, how does the primary key affect the physical storage of data?**
A) It has no effect on storage order
B) Data is clustered (ordered physically on disk) by the primary key
C) Data is stored in a separate file from the primary key index
D) Data is stored alphabetically by the first column

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB tables are index-organized tables. The primary key acts as the clustered index, meaning the actual row data is stored at the leaf nodes of the primary key index.
</details>

**Q31. What is the primary purpose of a `FOREIGN KEY` constraint?**
A) To speed up queries between two tables
B) To automatically generate unique identifiers
C) To enforce referential integrity between two tables
D) To encrypt linked data

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A foreign key establishes a link between data in two tables, ensuring that the value in the child table matches a value in the referenced parent table (referential integrity).
</details>

**Q32. Which `FOREIGN KEY` action automatically deletes the dependent rows in the child table when the referenced row in the parent table is deleted?**
A) ON DELETE RESTRICT
B) ON DELETE SET NULL
C) ON DELETE CASCADE
D) ON DELETE NO ACTION

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `ON DELETE CASCADE` instructs MySQL to automatically delete matching rows in the child table whenever the parent row is deleted.
</details>

**Q33. What must be true about the data types of a foreign key column and the primary key column it references?**
A) They must be exact matches or similar types with matching size/signedness
B) They can be any type as long as they hold the same value
C) The parent must be INT, and the child can be VARCHAR
D) The child table must use a larger data type than the parent

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Foreign keys require matching data types. For example, if the parent is `INT UNSIGNED`, the child column must also be `INT UNSIGNED`.
</details>

**Q34. What does `ON UPDATE RESTRICT` do in a foreign key constraint?**
A) Updates the child table automatically
B) Rejects the update operation on the parent table if a matching row exists in the child table
C) Sets the child table foreign key to NULL
D) Ignores the update silently

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `RESTRICT` prevents a change (update or delete) in the parent table if there are dependent rows in the child table, throwing an error.
</details>

**Q35. What is required on the referenced (parent) column for a foreign key to be created successfully?**
A) It must be named 'id'
B) It must be an `AUTO_INCREMENT` column
C) It must be indexed (e.g., Primary Key or Unique Index)
D) It must not contain any data before the foreign key is created

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB requires that the referenced column(s) in the parent table have an index, typically a primary key or unique index, to allow fast lookups for referential checks.
</details>

**Q36. How does the `UNIQUE` constraint handle `NULL` values in MySQL?**
A) It allows only a single `NULL` value
B) It treats all `NULL` values as identical, throwing an error on the second `NULL` insert
C) It allows multiple `NULL` values because `NULL` is not considered equal to `NULL`
D) It completely forbids `NULL` values in the column

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, a `UNIQUE` constraint permits multiple `NULL` values in the column because, logically, one `NULL` is not equal to another `NULL`.
</details>

**Q37. What is the difference between a `PRIMARY KEY` and a `UNIQUE` index?**
A) A table can have multiple `PRIMARY KEY`s but only one `UNIQUE` index
B) `UNIQUE` indexes allow multiple NULLs (unless NOT NULL is specified), while `PRIMARY KEY` implicitly forbids NULLs
C) `PRIMARY KEY` allows duplicates, `UNIQUE` does not
D) There is no difference; they are synonymous

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A `PRIMARY KEY` requires columns to be `NOT NULL` and there can be only one per table. A `UNIQUE` constraint allows `NULL`s (unless strictly specified otherwise) and a table can have multiple `UNIQUE` constraints.
</details>

**Q38. Can a `UNIQUE` constraint be applied to a combination of multiple columns?**
A) Yes, it is called a composite unique constraint
B) No, `UNIQUE` can only be applied to a single column
C) Yes, but only if all columns are of the same data type
D) No, multiple columns must use a `PRIMARY KEY`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can define a `UNIQUE` constraint across multiple columns. The combination of values across those columns must be unique for each row.
</details>

**Q39. If you attempt to insert a duplicate value into a column with a `UNIQUE` constraint, what is the default behavior?**
A) The row is inserted, but the duplicate column is set to NULL
B) The existing row is overwritten
C) An error is returned (e.g., Error 1062) and the insert fails
D) A new duplicate row is inserted, but a warning is issued

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Inserting a duplicate value that violates a `UNIQUE` constraint results in a standard SQL constraint violation error, blocking the operation.
</details>

**Q40. Which statement can be used to handle a duplicate key violation on a `UNIQUE` constraint gracefully during an insert?**
A) INSERT IGNORE
B) INSERT FORCE
C) UPDATE ON DUPLICATE
D) INSERT ... ON ERROR RESUME

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `INSERT IGNORE` will ignore the duplicate key error. Instead of aborting the statement, it downgrades the error to a warning and skips inserting the offending row. `INSERT ... ON DUPLICATE KEY UPDATE` is another valid approach.
</details>

**Q41. What is the effect of applying the `NOT NULL` constraint to a column?**
A) It prevents empty strings ('') from being inserted
B) It prevents the value `0` from being inserted
C) It prevents the absence of a value (NULL) from being stored in the column
D) It automatically sets the column to `AUTO_INCREMENT`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `NOT NULL` constraint enforces that a column must always contain an explicit value and cannot be left as `NULL` (unknown/missing).
</details>

**Q42. Is an empty string `''` considered `NULL` in MySQL?**
A) Yes, empty strings are automatically converted to `NULL`
B) No, an empty string is a valid string value and is distinct from `NULL`
C) Yes, but only for `VARCHAR` columns
D) Yes, if strict SQL mode is disabled

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, an empty string `''` is a known, zero-length string. `NULL` represents an unknown or absent value. A `NOT NULL` column accepts an empty string.
</details>

**Q43. What happens if you perform an `INSERT` without providing a value for a `NOT NULL` column that has no `DEFAULT` defined (in strict mode)?**
A) MySQL inserts a blank string or `0` automatically
B) MySQL inserts `NULL` and issues a warning
C) MySQL returns an error and aborts the insert
D) MySQL generates a random default value

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In strict SQL mode, failing to provide a value for a `NOT NULL` column that lacks an explicit `DEFAULT` value will cause an error, preventing the insert.
</details>

**Q44. Can a `NOT NULL` constraint be added to an existing table column?**
A) No, constraints can only be defined during table creation
B) Yes, using `ALTER TABLE ... MODIFY column_name datatype NOT NULL`
C) Yes, but only if the table is empty
D) Yes, using `UPDATE TABLE ... SET NOT NULL`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ALTER TABLE` statement with `MODIFY` or `CHANGE` can be used to add a `NOT NULL` constraint to an existing column, provided no `NULL` values currently exist in that column.
</details>

**Q45. If you remove strict mode, what value does MySQL implicitly assign to a `NOT NULL` integer column if no value is inserted?**
A) NULL
B) -1
C) 0
D) The maximum integer value

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In non-strict mode, MySQL applies an implicit default. For numeric types, this implicit default is `0`.
</details>

**Q46. What is the purpose of the `DEFAULT` constraint?**
A) To specify a value that is automatically used when an `INSERT` statement does not provide a value for the column
B) To act as a fallback value when a `SELECT` query returns no results
C) To automatically update a column when any other column in the row changes
D) To restrict the column to only accept a specific value

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The `DEFAULT` clause specifies a default value for a column. If a new row is inserted and no value is specified for that column, MySQL uses the default value.
</details>

**Q47. Which of the following is a valid `DEFAULT` definition for a `DATETIME` or `TIMESTAMP` column to record the creation time of a row?**
A) DEFAULT NOW()
B) DEFAULT CURRENT_TIMESTAMP
C) DEFAULT TODAY()
D) DEFAULT SYSDATE

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `DEFAULT CURRENT_TIMESTAMP` is the standard MySQL syntax for automatically inserting the current date and time into a `TIMESTAMP` or `DATETIME` column upon row creation.
</details>

**Q48. As of MySQL 8.0.13, can you use expressions or functions (other than CURRENT_TIMESTAMP) as default values?**
A) No, defaults must be literal constants
B) Yes, by wrapping the expression in parentheses, e.g., `DEFAULT (UUID())`
C) Yes, but only for integer columns
D) No, you must use triggers for anything other than constants

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0.13 introduced support for expressions as default values. The expression must be enclosed in parentheses to distinguish it from literal constants.
</details>

**Q49. How does an explicit `NULL` insertion interact with a `DEFAULT` constraint (assuming the column allows NULLs)?**
A) The explicit `NULL` is overridden, and the `DEFAULT` value is inserted
B) The explicit `NULL` is inserted; the `DEFAULT` value is ignored
C) It triggers a syntax error
D) The `DEFAULT` is appended to the `NULL`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Providing an explicit `NULL` in an `INSERT` statement tells MySQL to insert `NULL`. The `DEFAULT` value is only triggered if the column is entirely omitted from the `INSERT` list or if the `DEFAULT` keyword is explicitly passed as a value.
</details>

**Q50. If you insert the keyword `DEFAULT` as a value in an `INSERT` statement (e.g., `INSERT INTO t (col1) VALUES (DEFAULT)`), what happens?**
A) An error occurs; `DEFAULT` is a reserved word and cannot be used in `VALUES`
B) The string literal 'DEFAULT' is inserted
C) MySQL inserts the column's defined default value
D) It inserts a `NULL` regardless of the column definition

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Passing the keyword `DEFAULT` in the `VALUES` clause explicitly instructs MySQL to insert the defined default value for that column.
</details>

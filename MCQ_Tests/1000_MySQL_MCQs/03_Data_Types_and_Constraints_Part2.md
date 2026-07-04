**Q51. In MySQL 8.0, what is the status of the `ZEROFILL` attribute for integer columns?**
A) It is the recommended way to pad numbers
B) It has been deprecated and will be removed in a future version
C) It automatically converts the column to a string type
D) It is newly introduced to format currency

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ZEROFILL` attribute, along with the display width attribute for integer data types, is deprecated in MySQL 8.0 and is slated for removal in a future release.
</details>

**Q52. How many bytes of storage does a `BIGINT` column require?**
A) 2 bytes
B) 4 bytes
C) 8 bytes
D) 16 bytes

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A `BIGINT` requires 8 bytes of storage, allowing for a signed range of -9223372036854775808 to 9223372036854775807.
</details>

**Q53. When using an `AUTO_INCREMENT` column, what happens if a transaction that inserts a row is rolled back?**
A) The auto-increment counter is decremented to prevent gaps
B) The auto-increment value is lost, resulting in a gap in the sequence
C) The next insert will crash unless the gap is manually fixed
D) MySQL reuses the value for the very next insert automatically

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** For performance reasons, InnoDB does not roll back auto-increment counters. If a transaction is rolled back, the generated auto-increment values are lost, creating gaps in the sequence.
</details>

**Q54. Which integer type is typically used as a synonym for `BOOLEAN` or `BOOL` in MySQL?**
A) BIT(1)
B) TINYINT(1)
C) SMALLINT(1)
D) ENUM('true', 'false')

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, `BOOLEAN` and `BOOL` are aliases for `TINYINT(1)`. A value of zero is considered false, and non-zero values are considered true.
</details>

**Q55. If you define a column with the `SERIAL` data type alias, what is its actual underlying definition?**
A) INT NOT NULL AUTO_INCREMENT PRIMARY KEY
B) BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
C) VARCHAR(36) DEFAULT (UUID())
D) SMALLINT UNSIGNED AUTO_INCREMENT

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `SERIAL` is an alias for `BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE`.
</details>

**Q56. How does the character set affect the maximum number of characters you can store in a `VARCHAR(M)` column?**
A) It doesn't; `M` is always the exact number of bytes
B) Multi-byte character sets (like `utf8mb4`) require more bytes per character, reducing the maximum `M` value compared to single-byte character sets (like `latin1`)
C) `VARCHAR` always allocates 4 bytes per character regardless of the character set
D) Multi-byte character sets allow for a larger `M` value

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because the maximum row size is limited to 65,535 bytes, a `VARCHAR` column using `utf8mb4` (up to 4 bytes per character) can store fewer maximum characters (M ≤ 16,383) than one using `latin1` (1 byte per character, M ≤ 65,532).
</details>

**Q57. In contrast to `CHAR`, how does `VARCHAR` handle trailing spaces when storing and retrieving data?**
A) They are automatically trimmed upon storage
B) They are replaced with NULLs
C) They are retained both when stored and when retrieved
D) They are padded to a minimum of 10 spaces

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL retains trailing spaces for `VARCHAR` values when storing them, and does not trim them upon retrieval (unlike the default behavior for `CHAR`).
</details>

**Q58. Why might you prefer `VARCHAR(100)` over `VARCHAR(255)` if you know the strings will never exceed 100 characters?**
A) To reduce the length prefix storage from 2 bytes to 1 byte
B) To optimize memory allocation during query execution and sorting
C) To bypass the 65,535-byte row limit
D) There is no performance or memory difference between the two

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While storage on disk uses only the necessary space for both, during query execution (like sorting in memory using `MEMORY` tables or internal temporary tables), MySQL often allocates memory based on the maximum defined length of the column.
</details>

**Q59. If strict SQL mode is DISABLED and you insert a string exceeding the length of a `VARCHAR` column, what happens?**
A) The insert fails with an error
B) The string is silently truncated to the maximum length and a warning is generated
C) The table automatically alters to increase the column length
D) The extra characters overwrite the next column's data

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When strict mode is not enabled, MySQL truncates the string to fit the column's defined maximum length, inserts the truncated value, and generates a warning.
</details>

**Q60. What is the storage requirement for an empty string `''` in a `VARCHAR(50)` column?**
A) 0 bytes
B) 1 byte
C) 50 bytes
D) 51 bytes

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The empty string has 0 characters. However, `VARCHAR` requires 1 byte to store the length prefix (since maximum length is < 256). So, it takes 1 byte.
</details>

**Q61. Which of the following data types performs exact arithmetic in MySQL without floating-point errors?**
A) FLOAT
B) DOUBLE
C) REAL
D) DECIMAL

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** `DECIMAL` is an exact numeric data type. Operations on `DECIMAL` values use exact math, which is critical for financial and precise calculations.
</details>

**Q62. What is the maximum scale (`D` - digits after the decimal point) allowed for a `DECIMAL(M, D)` column?**
A) 10
B) 30
C) 65
D) 255

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The maximum scale `D` supported for `DECIMAL` columns in MySQL is 30, provided it does not exceed the precision `M` (which maxes at 65).
</details>

**Q63. How does MySQL internally pack digits for a `DECIMAL` column to save space?**
A) By converting them to a JSON array
B) By compressing every 9 digits into 4 bytes
C) By storing them as a string with a length prefix
D) By representing them as floating-point binary

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL stores `DECIMAL` values in a binary format that packs every 9 decimal digits into 4 bytes. Any remaining digits take a fraction of 4 bytes.
</details>

**Q64. If a column is defined as `DECIMAL` without specifying precision or scale (e.g., `amount DECIMAL`), what are the default precision and scale?**
A) DECIMAL(10, 0)
B) DECIMAL(10, 2)
C) DECIMAL(65, 30)
D) DECIMAL(8, 2)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** If omitted, the default precision `M` is 10, and the default scale `D` is 0. So it behaves like an integer column allowing up to 10 digits.
</details>

**Q65. In a comparison between a `DECIMAL` column and a `FLOAT` column, which statement is true?**
A) `FLOAT` comparisons are always strictly exact
B) `DECIMAL` comparisons may fail due to rounding approximations, while `FLOAT` does not
C) Equality comparisons with `FLOAT` can be unpredictable due to approximate storage
D) `FLOAT` and `DECIMAL` are physically stored the same way, making comparisons perfectly equal

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `FLOAT` is an approximate numeric type subject to floating-point rounding errors. Checking for exact equality (e.g., `WHERE float_val = 0.1`) can fail unpredictably. `DECIMAL` guarantees exact value comparisons.
</details>

**Q66. What happens if you insert an empty string `''` into an `ENUM('A','B')` column when strict mode is ON?**
A) It is inserted successfully and assigned index 0
B) It is converted to NULL
C) An error occurs and the insert fails
D) It defaults to the first value, 'A'

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In strict SQL mode, inserting an invalid value (like an empty string that isn't defined in the `ENUM` list) results in an error. In non-strict mode, it would insert the empty string with an index of 0.
</details>

**Q67. How can you sort an `ENUM` column alphabetically by its string values rather than by its internal integer index?**
A) ORDER BY ALPHABETICAL(enum_col)
B) ORDER BY enum_col ASC
C) ORDER BY CAST(enum_col AS CHAR)
D) It is not possible to sort `ENUM` alphabetically

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** To force MySQL to sort the `ENUM` alphabetically rather than by its defined index order, you can cast it to a string type, such as `ORDER BY CAST(enum_col AS CHAR)` or `ORDER BY CONCAT(enum_col)`.
</details>

**Q68. Under which condition is altering an `ENUM` column an "instant" or fast metadata-only operation in MySQL?**
A) When removing an element from the beginning of the list
B) When renaming an element in the middle of the list
C) When adding new elements to the end of the ENUM list
D) When changing the data type from ENUM to VARCHAR

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Adding new elements to the end of an `ENUM` list does not require rebuilding the table and can be performed as a fast, metadata-only change.
</details>

**Q69. How much storage space is required for an `ENUM` column with 300 distinct elements?**
A) 1 byte
B) 2 bytes
C) 3 bytes
D) 4 bytes

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `ENUM` columns require 1 byte if the number of distinct elements is 255 or fewer, and 2 bytes if the number of elements is between 256 and 65,535.
</details>

**Q70. If you declare a column as `ENUM('Yes', 'No') DEFAULT 'No'`, what is inserted if you supply `NULL` explicitly (assuming the column allows NULLs)?**
A) 'Yes'
B) 'No'
C) NULL
D) An error is thrown

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Explicitly inserting `NULL` overrides the `DEFAULT` value. As long as the column doesn't have a `NOT NULL` constraint, `NULL` will be stored.
</details>

**Q71. Which MySQL function converts a JSON document into a relational table format, allowing you to query it using standard SQL clauses?**
A) JSON_UNQUOTE()
B) JSON_EXTRACT()
C) JSON_TABLE()
D) JSON_RELATIONAL()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `JSON_TABLE()` is a powerful function introduced in MySQL 8.0 that extracts data from a JSON document and returns it as a relational table, which can be joined with other tables.
</details>

**Q72. In MySQL 8.0.17+, how can you index an array of values stored inside a `JSON` column?**
A) By creating a standard B-tree index on the JSON column directly
B) By using a Multi-Valued Index
C) By using a Full-Text Index
D) It is impossible to index arrays within JSON

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0.17 introduced Multi-Valued Indexes, which allow indexing JSON arrays. This helps optimize functions like `MEMBER OF()`, `JSON_CONTAINS()`, and `JSON_OVERLAPS()`.
</details>

**Q73. What will the function `JSON_OBJECT('id', 1, 'name', 'Alice')` return?**
A) A string formatted as an array: `["id", 1, "name", "Alice"]`
B) A valid JSON object: `{"id": 1, "name": "Alice"}`
C) A JSON scalar value: `"Alice"`
D) An error, because keys cannot be strings

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `JSON_OBJECT()` takes a list of key-value pairs and returns a valid JSON object document.
</details>

**Q74. Which function checks if a specific path exists within a JSON document?**
A) JSON_PATH_EXISTS()
B) JSON_CONTAINS_PATH()
C) JSON_SEARCH()
D) HAS_JSON_PATH()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `JSON_CONTAINS_PATH(json_doc, one_or_all, path)` returns 1 or 0 to indicate whether the specified path or paths exist within the JSON document.
</details>

**Q75. What is the primary purpose of `JSON_UNQUOTE()`?**
A) To remove the JSON array brackets `[]`
B) To convert a valid JSON document into invalid JSON
C) To remove surrounding quotes from a JSON string value and unescape characters
D) To decode a Base64 string within JSON

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When extracting a string from JSON using `JSON_EXTRACT()`, the result is quoted (e.g., `"value"`). `JSON_UNQUOTE()` removes those quotes and unescapes any escaped characters (resulting in `value`).
</details>

**Q76. Why is using a standard `UUID()` as an InnoDB `PRIMARY KEY` generally discouraged for very large tables?**
A) UUIDs cannot be indexed
B) UUIDs are random, causing heavy page splits, index fragmentation, and poor write performance in a clustered index
C) UUIDs take up exactly 4 bytes, causing rapid integer overflow
D) UUIDs can generate duplicates within the same millisecond

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB uses a clustered index based on the primary key. Random `UUID` values cause rows to be inserted at random locations, leading to page splits and severe disk fragmentation. Sequential UUIDs (like `UUID_TO_BIN(UUID(), 1)`) mitigate this.
</details>

**Q77. In MySQL 8.0, can a `PRIMARY KEY` be defined as an invisible column?**
A) Yes, invisible columns can be part of a primary key
B) No, primary keys must always be visible
C) Yes, but only for MyISAM tables
D) No, making a column invisible drops its primary key constraint

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Since MySQL 8.0.23, you can create invisible columns (columns hidden from `SELECT *`), and they are permitted to be part of a `PRIMARY KEY`.
</details>

**Q78. In an InnoDB table, what do secondary indexes (non-primary indexes) contain at their leaf nodes?**
A) The physical disk address (rowid) of the row
B) A complete copy of the row data
C) The primary key value(s) for the row
D) A pointer to the previous index

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Secondary indexes in InnoDB store the primary key values of the row at their leaf nodes. InnoDB uses this value to perform a secondary lookup in the clustered (primary) index to retrieve the full row.
</details>

**Q79. Which statement is TRUE regarding dropping and recreating a `PRIMARY KEY` on a large InnoDB table?**
A) It is an instant operation that only updates metadata
B) It requires a full table rebuild because the primary key dictates the physical storage order of rows
C) It deletes all data in the table automatically
D) It only rebuilds secondary indexes, leaving the table data untouched

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because the clustered index dictates the physical layout of the table, changing or dropping/adding a primary key generally requires a costly full table rebuild.
</details>

**Q80. What is the maximum number of columns allowed in a composite `PRIMARY KEY` in MySQL?**
A) 8
B) 16
C) 32
D) 64

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL allows up to 16 columns to be included in a composite index, including a composite primary key.
</details>

**Q81. What is the purpose of executing `SET foreign_key_checks = 0;`?**
A) It permanently deletes all foreign keys in the database
B) It temporarily disables foreign key constraint checking for the current session, useful for bulk data loading or schema migrations
C) It prevents updates to parent tables
D) It converts all foreign keys to primary keys

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Setting `foreign_key_checks = 0` bypasses referential integrity checks temporarily. This dramatically speeds up bulk imports and allows dropping/recreating tables in any order without constraint errors.
</details>

**Q82. Does MySQL automatically create an index on the foreign key column in the child table?**
A) No, you must create it manually
B) Yes, InnoDB automatically creates an index on the foreign key column if one does not already exist
C) Yes, but only if the column is also a UNIQUE constraint
D) No, foreign keys do not require indexes on the child table

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB requires indexes on foreign keys to optimize referential checks. If there is no suitable index on the child table's foreign key columns, InnoDB creates one automatically.
</details>

**Q83. Which MySQL storage engine supports `FOREIGN KEY` constraints natively?**
A) MyISAM
B) MEMORY
C) CSV
D) InnoDB

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** InnoDB is the default and standard storage engine in MySQL that fully supports ACID transactions and foreign key referential integrity constraints.
</details>

**Q84. What happens when a parent row is deleted and the foreign key is set to `ON DELETE SET NULL`?**
A) The deletion is blocked
B) The child rows are deleted as well
C) The foreign key columns in matching child rows are updated to `NULL`
D) The child rows are moved to an archive table

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `ON DELETE SET NULL` means that if a referenced row in the parent table is deleted, the corresponding foreign key column values in the child table are set to `NULL` (provided the child column is not `NOT NULL`).
</details>

**Q85. Can a table have a foreign key that references a column within the exact same table (self-referencing)?**
A) No, foreign keys must reference distinct tables
B) Yes, this is common for hierarchical or tree data structures (e.g., an employee table with a manager_id)
C) Yes, but only using the MyISAM storage engine
D) No, this creates an infinite loop during inserts

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Self-referencing foreign keys are perfectly valid and are the standard way to represent hierarchical relationships (e.g., parent-child categories) within a single table.
</details>

**Q86. How can you apply a `UNIQUE` constraint to a very long `VARCHAR` or `TEXT` column to avoid exceeding the maximum key length?**
A) By using a Multi-Valued Index
B) By creating a prefix index that enforces uniqueness on the first N characters (e.g., `UNIQUE (col_name(50))`)
C) By setting `FOREIGN_KEY_CHECKS=0`
D) It is impossible to make `TEXT` columns unique

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If a column is too long to index entirely, you can create a prefix index on the first N characters. This will enforce uniqueness based purely on that prefix.
</details>

**Q87. In MySQL 8.0, how can you enforce case-insensitive uniqueness on an email column that uses a case-sensitive collation?**
A) You cannot; you must change the collation of the entire database
B) By creating a functional unique index: `UNIQUE ( (LOWER(email)) )`
C) By using a trigger to delete duplicates
D) By wrapping the column in `JSON_EXTRACT`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0 introduced functional indexes. You can enforce uniqueness based on an expression, such as `LOWER(email)`, by defining a functional unique index.
</details>

**Q88. What is a potential performance drawback of having many `UNIQUE` constraints on a table that receives high insert rates?**
A) The table size grows exponentially
B) MySQL disables the query cache
C) Every insert requires checking the index to ensure the value doesn't already exist, adding overhead
D) `UNIQUE` constraints prevent the use of `AUTO_INCREMENT`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Unlike non-unique secondary indexes (which can use the change buffer for deferred writes), unique index checks must immediately verify that a duplicate does not exist, adding disk I/O overhead on inserts.
</details>

**Q89. If a table has a composite `UNIQUE(a, b)` constraint, which of the following inserts will fail? (Assume the table is initially empty).**
A) Insert (1, 2) followed by Insert (1, 3)
B) Insert (1, 2) followed by Insert (2, 2)
C) Insert (NULL, 1) followed by Insert (NULL, 1)
D) Insert (1, 2) followed by Insert (1, 2)

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A composite unique constraint ensures that the *combination* of values is unique. Inserting (1, 2) twice violates this. (NULL, 1) inserted twice does not violate it because NULLs are treated as distinct.
</details>

**Q90. When you define a `UNIQUE` constraint in a `CREATE TABLE` statement, what object does MySQL create behind the scenes?**
A) A view
B) A trigger
C) A UNIQUE index
D) A foreign key

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A `UNIQUE` constraint is implemented internally by creating a UNIQUE index on the specified column(s).
</details>

**Q91. What happens if you try to add a `NOT NULL` constraint to an existing column that currently contains `NULL` records?**
A) The command succeeds, but future inserts cannot be NULL
B) The `NULL` records are automatically deleted
C) The `NULL` records are converted to zero or empty strings
D) The command fails with an error stating invalid use of NULL value

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** You cannot enforce a `NOT NULL` constraint on a column if the table already has rows with `NULL` in that column. You must update the existing `NULL`s to valid values first.
</details>

**Q92. From a storage optimization perspective in InnoDB, what is an advantage of defining a column as `NOT NULL`?**
A) It eliminates the need for a NULL bitmask in the row header for that column, saving 1 bit per row
B) It halves the size of integer columns
C) It prevents the column from being indexed
D) It allows the table to bypass transaction logs

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** InnoDB uses a NULL bitmask in the row header to track which columns contain `NULL`. Declaring columns as `NOT NULL` can slightly reduce storage overhead by eliminating the need for this bit.
</details>

**Q93. Can a `JSON` column be defined as `NOT NULL`?**
A) Yes, just like any other column type
B) No, JSON columns must always allow NULL
C) Yes, but only in MySQL 5.7
D) No, JSON columns default to an empty string instead

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** JSON columns can absolutely be declared as `NOT NULL`. If they are, you must insert a valid JSON document, and cannot leave it as `NULL`.
</details>

**Q94. If a column is defined as `INT NOT NULL`, what happens when a query executes `SELECT ... WHERE col IS NULL`?**
A) The query throws a syntax error
B) The optimizer can instantly return an empty result set (or skip checking that column) because it knows `NULL` is impossible
C) The query performs a full table scan
D) The query returns rows where `col = 0`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because the schema enforces that `NULL` values cannot exist, the query optimizer uses this metadata to short-circuit the execution, knowing `IS NULL` will always evaluate to false.
</details>

**Q95. Which constraint is absolutely required for an `AUTO_INCREMENT` column to function properly?**
A) DEFAULT
B) FOREIGN KEY
C) An index (usually PRIMARY KEY or UNIQUE)
D) CHECK

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL requires that an `AUTO_INCREMENT` column must be part of an index (such as a `PRIMARY KEY` or `UNIQUE` index) so it can quickly look up the maximum current value.
</details>

**Q96. Which data types support the `ON UPDATE CURRENT_TIMESTAMP` clause?**
A) INT and BIGINT
B) TIMESTAMP and DATETIME
C) VARCHAR and CHAR
D) DATE and TIME

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `TIMESTAMP` and `DATETIME` types can be automatically updated to the current date and time whenever the row is modified by using the `ON UPDATE CURRENT_TIMESTAMP` clause.
</details>

**Q97. In MySQL 8.0.13 and later, can you assign a `DEFAULT` value to `BLOB` or `TEXT` columns?**
A) No, it is strictly forbidden
B) Yes, provided the default value is specified as an expression in parentheses
C) Yes, but only for `TINYTEXT`
D) No, it requires a BEFORE INSERT trigger

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Historically, `BLOB` and `TEXT` could not have defaults. Starting in MySQL 8.0.13, you can use expressions for defaults, allowing `TEXT` and `BLOB` to have default values if enclosed in parentheses, e.g., `DEFAULT ('default text')`.
</details>

**Q98. How do you remove a `DEFAULT` constraint from a column using `ALTER TABLE`?**
A) ALTER TABLE t1 DROP DEFAULT FROM col_name;
B) ALTER TABLE t1 ALTER COLUMN col_name DROP DEFAULT;
C) ALTER TABLE t1 MODIFY col_name NO DEFAULT;
D) ALTER TABLE t1 DELETE DEFAULT col_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The standard syntax to remove a default value from a column is `ALTER TABLE table_name ALTER COLUMN column_name DROP DEFAULT`.
</details>

**Q99. Can a `DEFAULT` constraint expression reference other columns in the same table?**
A) Yes, without any restrictions
B) No, the default expression cannot refer to other columns
C) Yes, but only if the other column is a `PRIMARY KEY`
D) Yes, but only for integer columns

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While MySQL 8.0.13 introduced default expressions, a `DEFAULT` expression cannot reference other columns in the table. If you need a value derived from other columns, you should use a Generated Column or a Trigger.
</details>

**Q100. In an `UPDATE` statement, how can you explicitly set a column back to its defined default value?**
A) UPDATE table SET col = REVERT
B) UPDATE table SET col = INITIAL
C) UPDATE table SET col = DEFAULT
D) UPDATE table SET col = NULL

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `DEFAULT` keyword can be used in an `UPDATE` statement (e.g., `UPDATE t SET c = DEFAULT`) to assign the column's defined default value to the row.
</details>

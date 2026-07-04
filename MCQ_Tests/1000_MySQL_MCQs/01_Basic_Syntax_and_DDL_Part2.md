# Basic Syntax and DDL - Part 2

**Q51. What is the correct syntax to add a new column named `age` of type INT to an existing table `users`?**
A) ALTER TABLE users ADD COLUMN age INT;
B) ALTER TABLE users INSERT age INT;
C) ALTER TABLE users NEW age INT;
D) MODIFY TABLE users ADD age INT;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The ALTER TABLE statement with the ADD COLUMN (or just ADD) clause is used to add a new column to a table.
</details>

**Q52. How do you add a new column as the very first column in a table?**
A) ALTER TABLE t1 ADD col1 INT START;
B) ALTER TABLE t1 ADD col1 INT TOP;
C) ALTER TABLE t1 ADD col1 INT FIRST;
D) ALTER TABLE t1 ADD col1 INT BEGIN;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Using the FIRST keyword at the end of the ADD COLUMN clause places the new column at the beginning of the table.
</details>

**Q53. How do you specify that a newly added column should appear immediately after an existing column named `email`?**
A) ALTER TABLE users ADD phone VARCHAR(15) NEXT TO email;
B) ALTER TABLE users ADD phone VARCHAR(15) FOLLOWING email;
C) ALTER TABLE users ADD phone VARCHAR(15) BEHIND email;
D) ALTER TABLE users ADD phone VARCHAR(15) AFTER email;

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** The AFTER clause allows you to precisely position a newly added column immediately following an existing column.
</details>

**Q54. Which statement correctly drops the column `age` from the table `users`?**
A) ALTER TABLE users REMOVE age;
B) ALTER TABLE users DROP age;
C) ALTER TABLE users DELETE COLUMN age;
D) DROP COLUMN age FROM users;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The standard syntax to remove a column is ALTER TABLE table_name DROP COLUMN column_name (the word COLUMN is optional in MySQL).
</details>

**Q55. In MySQL 8.0, can you drop multiple columns in a single ALTER TABLE statement?**
A) No, each column requires a separate ALTER TABLE statement.
B) Yes, by separating multiple DROP clauses with commas.
C) Yes, by using DROP COLUMN (col1, col2).
D) No, unless the columns are adjacent.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can perform multiple alterations in one statement by separating them with commas, e.g., ALTER TABLE t1 DROP col1, DROP col2;
</details>

**Q56. Which keyword in ALTER TABLE allows you to change the data type of a column without renaming it?**
A) RENAME
B) MODIFY
C) UPDATE
D) REPLACE

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The MODIFY clause changes the data type or properties of an existing column without renaming it.
</details>

**Q57. What is the difference between MODIFY and CHANGE in an ALTER TABLE statement?**
A) MODIFY requires providing the old and new column names, while CHANGE does not.
B) CHANGE requires providing the old column name and the new column name, allowing you to rename it. MODIFY keeps the same name.
C) MODIFY changes data, CHANGE changes structure.
D) There is no difference; they are exact synonyms.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ALTER TABLE ... CHANGE old_col new_col data_type can rename the column and change its type, while MODIFY col_name data_type only changes the type.
</details>

**Q58. In MySQL 8.0, what is the dedicated, standard-compliant clause to rename a column without having to restate its data type?**
A) ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
B) ALTER TABLE table_name CHANGE old_name TO new_name;
C) ALTER TABLE table_name MODIFY old_name AS new_name;
D) RENAME COLUMN old_name TO new_name IN table_name;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL 8.0 introduced ALTER TABLE ... RENAME COLUMN old_name TO new_name, matching the SQL standard and avoiding the need to re-specify the column's data type.
</details>

**Q59. Which command is used to change the name of an existing table?**
A) ALTER TABLE old_name MODIFY NAME new_name;
B) RENAME TABLE old_name TO new_name;
C) UPDATE TABLE old_name SET NAME = new_name;
D) CHANGE TABLE old_name new_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** RENAME TABLE old_name TO new_name is the standard MySQL command to rename one or more tables.
</details>

**Q60. Can the ALTER TABLE command also be used to rename a table?**
A) Yes, using ALTER TABLE old_name RENAME TO new_name;
B) No, only RENAME TABLE can be used.
C) Yes, using ALTER TABLE old_name AS new_name;
D) Yes, using ALTER TABLE old_name NAME = new_name;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MySQL supports ALTER TABLE old_name RENAME [TO|AS] new_name; as an alternative to the RENAME TABLE command.
</details>

**Q61. What is the syntax to add a Primary Key to an existing table that doesn't have one?**
A) ALTER TABLE t1 ADD PRIMARY KEY (id);
B) ALTER TABLE t1 MODIFY id PRIMARY KEY;
C) ALTER TABLE t1 SET PRIMARY KEY = id;
D) Both A and B are valid.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** You can add a primary key using `ADD PRIMARY KEY (col_name)` or by using `MODIFY` to redefine the column definition to include the `PRIMARY KEY` constraint.
</details>

**Q62. How do you remove a Primary Key from a table?**
A) ALTER TABLE t1 DROP id;
B) ALTER TABLE t1 DROP PRIMARY KEY;
C) ALTER TABLE t1 REMOVE KEY PRIMARY;
D) DROP PRIMARY KEY FROM t1;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The syntax to drop a primary key constraint is ALTER TABLE table_name DROP PRIMARY KEY. No column name is needed since a table can only have one primary key.
</details>

**Q63. What must be true before you can drop a Primary Key that is also an AUTO_INCREMENT column?**
A) You must drop the entire table.
B) You must first remove the AUTO_INCREMENT attribute using MODIFY, as AUTO_INCREMENT requires a key.
C) You can drop it directly; MySQL handles the AUTO_INCREMENT removal automatically.
D) You must convert it to a Foreign Key.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because an AUTO_INCREMENT column must be defined as a key, you cannot drop the Primary Key without first modifying the column to remove the AUTO_INCREMENT property (or adding another key to it).
</details>

**Q64. How do you add a named Foreign Key constraint to an existing table?**
A) ALTER TABLE orders ADD FOREIGN KEY (user_id) REFERENCES users(id);
B) ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
C) ALTER TABLE orders CONSTRAINT fk_user ADD FOREIGN KEY (user_id) REFERENCES users(id);
D) Both A and B are valid.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** You can either let MySQL auto-generate the constraint name (A) or explicitly name it using the ADD CONSTRAINT clause (B).
</details>

**Q65. How do you drop a Foreign Key constraint?**
A) ALTER TABLE t1 DROP FOREIGN KEY foreign_key_name;
B) ALTER TABLE t1 DROP CONSTRAINT foreign_key_name;
C) ALTER TABLE t1 DROP KEY foreign_key_name;
D) Both A and B are correct in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** In MySQL 8.0, you can drop a foreign key using either `DROP FOREIGN KEY fk_name` or the standard SQL `DROP CONSTRAINT constraint_name`.
</details>

**Q66. Which statement sets a new default value for an existing column?**
A) ALTER TABLE t1 ALTER COLUMN col1 SET DEFAULT 10;
B) ALTER TABLE t1 MODIFY col1 DEFAULT 10;
C) ALTER TABLE t1 CHANGE DEFAULT col1 TO 10;
D) ALTER TABLE t1 ADD DEFAULT 10 TO col1;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The standard way to only alter a column's default value without restating the entire column definition is ALTER TABLE table_name ALTER COLUMN col_name SET DEFAULT value.
</details>

**Q67. How do you remove the default value from a column?**
A) ALTER TABLE t1 ALTER COLUMN col1 DROP DEFAULT;
B) ALTER TABLE t1 ALTER COLUMN col1 SET DEFAULT NULL;
C) ALTER TABLE t1 MODIFY col1 DROP DEFAULT;
D) ALTER TABLE t1 DROP DEFAULT col1;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The ALTER COLUMN ... DROP DEFAULT syntax explicitly removes the default value from a column.
</details>

**Q68. What command changes the storage engine of an existing table to InnoDB?**
A) ALTER TABLE t1 SET ENGINE = InnoDB;
B) ALTER TABLE t1 ENGINE = InnoDB;
C) MODIFY TABLE t1 ENGINE = InnoDB;
D) UPDATE TABLE t1 SET ENGINE = InnoDB;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can rebuild a table with a different storage engine using ALTER TABLE table_name ENGINE = engine_name;.
</details>

**Q69. If you want to change the character set of an entire table and convert all existing data to the new character set, which command is used?**
A) ALTER TABLE t1 CHARACTER SET utf8mb4;
B) ALTER TABLE t1 CONVERT TO CHARACTER SET utf8mb4;
C) ALTER TABLE t1 MODIFY CHARSET utf8mb4;
D) ALTER TABLE t1 CHANGE CHARSET TO utf8mb4;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The CONVERT TO CHARACTER SET clause converts the data in the text columns to the new character set, rather than just changing the default character set for future columns.
</details>

**Q70. What happens if you run `ALTER TABLE t1 CHARACTER SET utf8mb4;` without `CONVERT TO`?**
A) It returns a syntax error.
B) It converts all existing data to utf8mb4.
C) It changes the default character set for the table, but existing columns retain their current character set.
D) It drops columns that cannot be implicitly converted.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Specifying CHARACTER SET without CONVERT TO only changes the default character set used for new columns added to the table later.
</details>

**Q71. Which statement adds a UNIQUE index to an existing table?**
A) ALTER TABLE t1 ADD UNIQUE (col_name);
B) ALTER TABLE t1 ADD INDEX UNIQUE (col_name);
C) ALTER TABLE t1 MODIFY col_name UNIQUE;
D) Both A and C.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The standard syntax is ALTER TABLE table_name ADD UNIQUE [index_name] (col_name). You cannot just use MODIFY without restating the full data type.
</details>

**Q72. In MySQL, how can you view the columns and their data types of a table named `customers`?**
A) DISPLAY customers;
B) DESCRIBE customers;
C) SHOW COLUMNS IN customers;
D) Both B and C.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Both DESCRIBE table_name (or DESC) and SHOW COLUMNS FROM/IN table_name return the structure of the table.
</details>

**Q73. When creating a database, how do you see all the warnings if you used `IF NOT EXISTS` and it already existed?**
A) SHOW ERRORS;
B) SHOW WARNINGS;
C) DISPLAY WARNINGS;
D) GET WARNINGS;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The SHOW WARNINGS command displays the warning messages, including those generated by `IF NOT EXISTS` or `IF EXISTS` clauses.
</details>

**Q74. Which DDL statement is used to delete an index (other than a PRIMARY KEY) in MySQL?**
A) DROP INDEX index_name ON table_name;
B) ALTER TABLE table_name DROP INDEX index_name;
C) ALTER TABLE table_name DROP KEY index_name;
D) All of the above.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL supports `DROP INDEX index_name ON table_name` as well as `ALTER TABLE ... DROP INDEX` and `ALTER TABLE ... DROP KEY`.
</details>

**Q75. What keyword can optionally follow `CREATE TABLE` to create the table only if it does not already exist?**
A) IF MISSING
B) IF NOT EXISTS
C) UNLESS EXISTS
D) REQUIRE NOT EXISTS

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The IF NOT EXISTS clause is heavily used in setup scripts to ensure no error is thrown if the table is already present.
</details>

**Q76. Which data type is best used for a column that stores boolean (True/False) values in MySQL?**
A) BOOLEAN or TINYINT(1)
B) BIT(1)
C) VARCHAR(5)
D) Both A and B are commonly used.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL treats BOOLEAN as a synonym for TINYINT(1), where 0 is false and non-zero is true. BIT(1) is also natively used to store a single bit of information.
</details>

**Q77. What happens if you define a column as `INT(4)` in MySQL?**
A) The column can only store numbers up to 4 digits (e.g., 9999).
B) It takes 4 bytes of storage. The (4) is a display width hint for zerofill and does not limit the maximum value.
C) The integer size is reduced to 4 bits.
D) It results in an error in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** For integer types, the number in parentheses specifies the display width, not the storage capacity or value range. (Note: Display width for integers is deprecated in MySQL 8.0.17+ unless ZEROFILL is used).
</details>

**Q78. In a CREATE TABLE statement, what does the ZEROFILL attribute do to an integer column?**
A) It sets the default value to 0.
B) It pads the displayed value with zeros up to the display width and automatically adds the UNSIGNED attribute.
C) It replaces NULL values with 0.
D) It prevents the column from being a primary key.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ZEROFILL pads the output with zeros (e.g., 0005) and inherently forces the column to be UNSIGNED because you cannot zero-pad negative numbers properly.
</details>

**Q79. Which data type is specifically designed for storing variable-length strings with a maximum limit?**
A) CHAR
B) VARCHAR
C) TEXT
D) BLOB

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** VARCHAR (Variable Character) stores strings up to a defined maximum length, only taking up space for the actual characters used (plus length prefixes).
</details>

**Q80. What is the fundamental difference between CHAR and VARCHAR data types?**
A) CHAR is for numbers, VARCHAR is for letters.
B) CHAR stores variable-length strings, VARCHAR stores fixed-length strings.
C) CHAR is fixed-length and padded with spaces to the declared length, while VARCHAR is variable-length.
D) There is no difference; they are synonyms in MySQL.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A CHAR column always uses the declared length (padding with spaces if necessary), making it faster for fixed-length data like hashes. VARCHAR uses only the required space.
</details>

**Q81. When defining a decimal number that represents currency (e.g., $99.99), which data type is most appropriate to avoid floating-point inaccuracies?**
A) FLOAT
B) DOUBLE
C) DECIMAL
D) REAL

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** DECIMAL (or NUMERIC) is an exact fixed-point data type, which prevents the rounding errors typical of approximate floating-point types like FLOAT and DOUBLE.
</details>

**Q82. In `DECIMAL(10,2)`, what do the numbers 10 and 2 represent?**
A) 10 is the maximum value, 2 is the minimum value.
B) 10 is the total number of digits (precision), 2 is the number of digits after the decimal point (scale).
C) 10 is the number of digits before the decimal, 2 is after.
D) 10 is the storage size in bytes, 2 is the scale.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Precision (10) is the total number of significant digits, and Scale (2) is the number of digits allowed to the right of the decimal point.
</details>

**Q83. Which column definition correctly stores the date and time, adjusting automatically to the session's time zone?**
A) DATETIME
B) TIMESTAMP
C) DATE
D) TIME

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The TIMESTAMP data type automatically converts values from the current time zone to UTC for storage, and back to the current time zone for retrieval. DATETIME does not.
</details>

**Q84. What does the ENUM data type do in MySQL?**
A) Stores a large block of text.
B) Automatically increments integer values.
C) Restricts the column value to one from a predefined list of permitted string values.
D) Creates an index on a text column.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** ENUM is a string object with a value chosen from a list of permitted values defined at table creation, which is stored efficiently as an integer internally.
</details>

**Q85. Which attribute is used to ensure an integer column cannot contain negative numbers?**
A) POSITIVE
B) UNSIGNED
C) ABSOLUTE
D) NO_NEGATIVE

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The UNSIGNED attribute doubles the upper limit of the integer type by disallowing negative values.
</details>

**Q86. What is a "Generated Column" introduced in MySQL 5.7 and fully supported in 8.0?**
A) A column that fetches data from a remote server automatically.
B) A column whose value is computed using a mathematical or logical expression based on other columns in the same row.
C) A column created by a trigger.
D) An alias for the AUTO_INCREMENT column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Generated columns (VIRTUAL or STORED) evaluate an expression using other columns in the same table, e.g., `total_price AS (quantity * price)`.
</details>

**Q87. In a CREATE TABLE statement, how do you define a VIRTUAL generated column?**
A) full_name VARCHAR(100) AS (CONCAT(first_name, ' ', last_name)) VIRTUAL
B) full_name VARCHAR(100) GENERATED BY DEFAULT
C) full_name VARCHAR(100) VIRTUAL (first_name + last_name)
D) full_name VARCHAR(100) EXPRESSION VIRTUAL

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The syntax is `col_name data_type AS (expression) VIRTUAL`. Virtual means the value is calculated on the fly when queried, not stored on disk.
</details>

**Q88. Which command drops an entire schema/database and suppresses any error if it doesn't exist?**
A) DROP SCHEMA IF EXISTS db_name;
B) DROP DATABASE IF NOT EXISTS db_name;
C) DELETE SCHEMA IF EXISTS db_name;
D) REMOVE DATABASE db_name;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** DROP SCHEMA is synonymous with DROP DATABASE, and the IF EXISTS clause prevents errors if the schema isn't present.
</details>

**Q89. How can you clone a table's structure AND its data without copying the original indexes and triggers?**
A) CREATE TABLE new_tbl LIKE old_tbl;
B) CREATE TABLE new_tbl AS SELECT * FROM old_tbl;
C) INSERT INTO new_tbl SELECT * FROM old_tbl;
D) DUPLICATE TABLE old_tbl TO new_tbl;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `CREATE TABLE ... AS SELECT` creates the table and populates it, but ignores constraints, indexes, and AUTO_INCREMENT attributes from the original table.
</details>

**Q90. Which of the following is an invalid identifier name without backticks in MySQL?**
A) user_name
B) 123_table
C) table_123
D) myTable

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Identifiers can contain numbers, but they cannot consist entirely of numbers or start with a number unless they are enclosed in backticks (`123_table` starts with numbers, making backticks necessary depending on parser strictness, but an identifier starting strictly with a digit and containing only digits MUST be quoted; starting with a digit like 123_table often needs quoting to avoid syntax issues).
</details>

**Q91. What is the impact of executing `ALTER TABLE t1 AUTO_INCREMENT = 1000;`?**
A) All existing IDs are recalculated to start from 1000.
B) The next inserted row without a specified ID will receive the value 1000.
C) The command fails because AUTO_INCREMENT cannot be altered.
D) It creates a new AUTO_INCREMENT column starting at 1000.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Altering the AUTO_INCREMENT value sets the starting point for the sequence for the *next* inserted record. It does not affect existing records.
</details>

**Q92. What happens if you try to set the AUTO_INCREMENT value lower than the maximum value currently in the column?**
A) MySQL throws an error.
B) The existing rows with higher IDs are deleted.
C) MySQL ignores the lower value and resets it to MAX(id) + 1 (in InnoDB).
D) Subsequent inserts will fill in the gaps.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In InnoDB, if you set the AUTO_INCREMENT value to a number less than or equal to the current maximum value, the engine will automatically adjust it to MAX(id) + 1.
</details>

**Q93. How do you specify a table collation that is case-insensitive for UTF-8 in MySQL 8.0?**
A) COLLATE utf8mb4_cs
B) COLLATE utf8mb4_bin
C) COLLATE utf8mb4_0900_ai_ci
D) COLLATE utf8_strict

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `_ai_ci` stands for Accent Insensitive, Case Insensitive. `utf8mb4_0900_ai_ci` is the default collation for utf8mb4 in MySQL 8.0.
</details>

**Q94. If a query requires creating a table with a keyword as its name (e.g., `select`), how must it be written?**
A) CREATE TABLE select (id INT);
B) CREATE TABLE 'select' (id INT);
C) CREATE TABLE `select` (id INT);
D) CREATE TABLE "select" (id INT);

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Reserved keywords used as identifiers must be enclosed in backticks in MySQL to be parsed correctly.
</details>

**Q95. Which DDL command is used to remove a view from the database?**
A) DELETE VIEW view_name;
B) DROP VIEW view_name;
C) REMOVE VIEW view_name;
D) TRUNCATE VIEW view_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Similar to DROP TABLE, DROP VIEW is the standard DDL command to delete a view definition.
</details>

**Q96. What does the `CHECK` constraint do in a CREATE TABLE statement (fully enforced in MySQL 8.0)?**
A) Checks if the table exists before creating it.
B) Verifies referential integrity with another table.
C) Enforces a condition that column values must satisfy before a row can be inserted or updated.
D) Validates the data types of all columns.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The CHECK constraint (e.g., `CHECK (age >= 18)`) ensures that all values in a column satisfy a specific boolean expression. Prior to MySQL 8.0.16, CHECK constraints were parsed but ignored; in 8.0.16+, they are fully enforced.
</details>

**Q97. How do you define a CHECK constraint during table creation?**
A) age INT CHECK (age >= 18)
B) age INT CONDITION (age >= 18)
C) age INT VERIFY (age >= 18)
D) age INT VALIDATE age >= 18

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The standard syntax attaches the CHECK keyword followed by the boolean expression in parentheses directly to the column definition or as a table constraint.
</details>

**Q98. Can you use ALTER TABLE to drop a CHECK constraint in MySQL 8.0?**
A) No, CHECK constraints cannot be dropped once created.
B) Yes, using `ALTER TABLE t1 DROP CHECK constraint_name`.
C) Yes, using `ALTER TABLE t1 DROP CONSTRAINT constraint_name`.
D) Both B and C are valid in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL 8.0 supports both `DROP CHECK symbol` and the generic `DROP CONSTRAINT symbol` for dropping check constraints.
</details>

**Q99. What does the invisible column feature in MySQL 8.0 do?**
A) The column is hidden from `SELECT *` queries but can still be queried if explicitly named.
B) The column is encrypted on the disk.
C) Only root users can access the column data.
D) The column data is never logged in the binary log.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Declaring a column as INVISIBLE means it will not appear in the results of `SELECT *`. It must be explicitly listed in the SELECT clause to be retrieved.
</details>

**Q100. How do you create an invisible column in MySQL 8.0?**
A) secret_data VARCHAR(100) HIDDEN
B) secret_data VARCHAR(100) INVISIBLE
C) secret_data VARCHAR(100) NOT VISIBLE
D) INVISIBLE secret_data VARCHAR(100)

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The INVISIBLE keyword is added at the end of the column definition in the CREATE TABLE or ALTER TABLE statement.
</details>

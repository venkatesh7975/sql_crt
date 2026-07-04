# Basic Syntax and DDL - Part 1

**Q1. Which of the following statements is used to create a database in MySQL?**
A) CREATE DB db_name;
B) GENERATE DATABASE db_name;
C) CREATE DATABASE db_name;
D) NEW DATABASE db_name;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The standard SQL command to create a new database in MySQL is CREATE DATABASE followed by the database name.
</details>

**Q2. In MySQL, which keyword is a synonym for DATABASE when creating a database?**
A) COLLECTION
B) SCHEMA
C) CATALOG
D) DIRECTORY

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CREATE SCHEMA is synonymous with CREATE DATABASE in MySQL. Both achieve the exact same result.
</details>

**Q3. How can you prevent an error if you try to create a database that already exists?**
A) CREATE DATABASE db_name IGNORE EXISTS;
B) CREATE DATABASE IF NOT EXISTS db_name;
C) CREATE DATABASE WITHOUT ERROR db_name;
D) CREATE DATABASE UNLESS EXISTS db_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Adding the IF NOT EXISTS clause ensures MySQL only issues a warning instead of an error if the database already exists.
</details>

**Q4. Which statement correctly sets the default character set and collation when creating a database?**
A) CREATE DATABASE mydb SET CHARSET utf8mb4 AND COLLATE utf8mb4_0900_ai_ci;
B) CREATE DATABASE mydb WITH CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
C) CREATE DATABASE mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
D) CREATE DATABASE mydb CHAR=utf8mb4, COLLATE=utf8mb4_0900_ai_ci;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The correct syntax specifies CHARACTER SET and COLLATE directly after the database name without using SET or WITH.
</details>

**Q5. What happens if you do not specify a character set when creating a new database in MySQL 8.0?**
A) The database creation fails.
B) It uses the latin1 character set.
C) It uses the utf8mb3 character set.
D) It inherits the server's default character set, which is utf8mb4 in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL 8.0 defaults to the utf8mb4 character set for the server, and a new database inherits this if not explicitly specified.
</details>

**Q6. Which command is used to permanently delete a database and all its contents?**
A) DELETE DATABASE db_name;
B) DROP DATABASE db_name;
C) TRUNCATE DATABASE db_name;
D) REMOVE DATABASE db_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DROP DATABASE removes the database, its tables, and all data permanently.
</details>

**Q7. How do you safely attempt to drop a database without causing an error if it does not exist?**
A) DROP DATABASE db_name IGNORE;
B) DROP DATABASE IF EXISTS db_name;
C) DROP DATABASE SAFELY db_name;
D) DELETE DATABASE IF EXISTS db_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The IF EXISTS clause prevents an error and instead generates a warning if the database is not found.
</details>

**Q8. After successfully executing DROP DATABASE, where are the deleted tables stored?**
A) In the MySQL Recycle Bin.
B) In the undo tablespace.
C) They are permanently removed from the file system.
D) In the ibdata1 file for recovery.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** DROP DATABASE drops all tables and removes the database directory from the data directory permanently.
</details>

**Q9. Which of the following is NOT a valid comment style in MySQL?**
A) `# This is a comment`
B) `/* This is a comment */`
C) `-- This is a comment` (with a trailing space)
D) `// This is a comment`

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** MySQL supports `#`, `/* ... */`, and `-- ` (must have a space after the dashes). `//` is not a valid SQL comment in MySQL.
</details>

**Q10. Why does the `--` comment style in MySQL require a space or control character after the second dash?**
A) To distinguish it from negative numbers in arithmetic expressions like `id--1`.
B) To comply strictly with HTML comment standards.
C) To differentiate it from the `#` comment style.
D) To make it compatible with Oracle comments only.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The required space after `--` prevents ambiguity with operations such as subtraction of a negative value (e.g., `5--5`).
</details>

**Q11. What is the maximum length of an unquoted database name or table name identifier in MySQL?**
A) 32 characters
B) 64 characters
C) 128 characters
D) 255 characters

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In MySQL, identifiers such as database, table, and column names can be up to 64 characters long.
</details>

**Q12. How must you enclose an identifier (like a table name) if it is a reserved keyword in MySQL?**
A) Single quotes (' ')
B) Double quotes (" ")
C) Backticks (` `)
D) Square brackets ([ ])

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** By default, MySQL uses backticks to quote identifiers. This is required if the identifier is a reserved word or contains special characters.
</details>

**Q13. Which command specifies which database to use as the default for subsequent queries?**
A) SELECT DATABASE db_name;
B) USE db_name;
C) OPEN db_name;
D) SET DATABASE db_name;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The USE command sets the specified database as the default (current) database for the session.
</details>

**Q14. What does the fundamental DDL acronym stand for in SQL?**
A) Data Definition Language
B) Database Design Language
C) Data Manipulation Language
D) Database Declaration Logic

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** DDL stands for Data Definition Language, which includes commands like CREATE, ALTER, and DROP to define or modify database structures.
</details>

**Q15. Which statement correctly creates a table named `users` with an integer ID and a variable-length name?**
A) CREATE TABLE users (id INT, name VARCHAR(50));
B) CREATE TABLE users [id INT, name VARCHAR(50)];
C) NEW TABLE users (id INT, name VARCHAR(50));
D) MAKE TABLE users (id INT, name VARCHAR(50));

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The CREATE TABLE statement requires parentheses to enclose the comma-separated list of column definitions.
</details>

**Q16. In a CREATE TABLE statement, how do you define a column that must not accept NULL values?**
A) REQUIRED
B) NOT NULL
C) NO NULL
D) MANDATORY

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The NOT NULL constraint ensures that a column cannot store a NULL value.
</details>

**Q17. What is the purpose of the IF NOT EXISTS clause in a CREATE TABLE statement?**
A) To create the table only if it has rows.
B) To silently skip table creation and avoid an error if a table with the same name already exists.
C) To drop the existing table and recreate it.
D) To rename the existing table.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** IF NOT EXISTS prevents a MySQL error from occurring if the table already exists, simply issuing a warning instead.
</details>

**Q18. How do you set a default value of 0 for an integer column during table creation?**
A) col_name INT DEFAULT(0)
B) col_name INT SET DEFAULT 0
C) col_name INT DEFAULT 0
D) col_name INT VALUE 0

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The DEFAULT keyword followed by the desired value is used in the column definition to specify a default value.
</details>

**Q19. Which syntax accurately defines a primary key in a CREATE TABLE statement for a single column?**
A) id INT PRIMARY KEY
B) id INT KEY PRIMARY
C) id PRIMARY KEY INT
D) PRIMARY KEY id INT

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The PRIMARY KEY constraint can be specified immediately following the column data type definition.
</details>

**Q20. When specifying multiple columns for a primary key, where must the PRIMARY KEY constraint be declared?**
A) Next to each column definition.
B) As a separate table constraint at the end of the column list.
C) Before the table name.
D) You cannot have a primary key on multiple columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A composite primary key (multiple columns) must be defined using the PRIMARY KEY (col1, col2) syntax at the end of the column definitions.
</details>

**Q21. What happens if you define a column as AUTO_INCREMENT without making it a key (Primary or Unique)?**
A) The table is created successfully.
B) MySQL throws an error; AUTO_INCREMENT columns must be defined as a key.
C) It defaults to being a Primary Key automatically.
D) The column increments but allows duplicate values.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL requires that any column with the AUTO_INCREMENT attribute be indexed, typically as a PRIMARY KEY or UNIQUE key.
</details>

**Q22. Which command lets you view the exact CREATE TABLE statement that was used to create an existing table?**
A) DESCRIBE table_name;
B) SHOW TABLE table_name;
C) SHOW CREATE TABLE table_name;
D) EXPLAIN table_name;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** SHOW CREATE TABLE outputs the full DDL statement, including all constraints, default values, and character sets, used to create the table.
</details>

**Q23. What is the default storage engine used when creating a new table in MySQL 8.0?**
A) MyISAM
B) MEMORY
C) InnoDB
D) CSV

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB has been the default storage engine in MySQL since version 5.5 and remains the default in 8.0.
</details>

**Q24. How can you explicitly specify the storage engine during table creation?**
A) CREATE TABLE t1 (id INT) ENGINE=InnoDB;
B) CREATE TABLE t1 (id INT) STORAGE=InnoDB;
C) CREATE TABLE t1 (id INT) WITH ENGINE InnoDB;
D) CREATE TABLE t1 (id INT) USING InnoDB;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The ENGINE=engine_name table option is used at the end of the CREATE TABLE statement to specify the storage engine.
</details>

**Q25. Which statement creates an exact empty copy of an existing table's structure (including indexes)?**
A) CREATE TABLE new_table AS SELECT * FROM old_table WHERE 1=0;
B) CREATE TABLE new_table LIKE old_table;
C) COPY TABLE old_table TO new_table;
D) DUPLICATE TABLE old_table AS new_table;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** CREATE TABLE ... LIKE creates a new table with exactly the same column definitions, indexes, and table options as the original.
</details>

**Q26. When using `CREATE TABLE new_table AS SELECT * FROM old_table`, what is NOT copied to the new table?**
A) Column names
B) Column data types
C) Indexes and Primary Keys
D) Table data

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** CREATE TABLE AS SELECT copies the structure and the data, but it does not copy indexes, primary keys, or AUTO_INCREMENT attributes.
</details>

**Q27. How can you create a table and populate it simultaneously from another table?**
A) CREATE TABLE t2 LIKE t1 WITH DATA;
B) CREATE TABLE t2 AS SELECT * FROM t1;
C) CREATE TABLE t2 INSERT INTO t1;
D) COPY t1 INTO t2;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The CREATE TABLE ... AS SELECT (CTAS) statement allows you to create a table and populate it with the result set of a SELECT query in one step.
</details>

**Q28. What is the result of using `CREATE TABLE t2 AS SELECT id, name FROM t1 LIMIT 0;`?**
A) It creates a table with data from `t1`.
B) It results in a syntax error.
C) It creates an empty table `t2` with only the `id` and `name` columns.
D) It creates `t2` with full structure and indexes of `t1` but no data.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LIMIT 0 returns no rows, so CTAS creates the table with the inferred column definitions based on the SELECT list, but leaves the table empty (and no indexes are created).
</details>

**Q29. Which option correctly adds a table comment during table creation?**
A) CREATE TABLE t1 (id INT) COMMENT='Users table';
B) CREATE TABLE t1 (id INT) -- Users table;
C) CREATE TABLE t1 (id INT, COMMENT 'Users table');
D) CREATE TABLE t1 COMMENT 'Users table' (id INT);

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Table comments are specified as a table option at the end of the CREATE TABLE statement using COMMENT='string'.
</details>

**Q30. Can a column definition include its own comment in a CREATE TABLE statement?**
A) No, only tables can have comments.
B) Yes, using the COMMENT keyword after the data type and constraints.
C) Yes, by enclosing the comment in `/* */` next to the column name.
D) Yes, by using the DESCRIBE command.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Individual columns can have comments specified by adding COMMENT 'string' at the end of the column definition in the CREATE TABLE statement.
</details>

**Q31. Which command deletes a table named `employees` from the database permanently?**
A) DELETE TABLE employees;
B) DROP TABLE employees;
C) TRUNCATE TABLE employees;
D) REMOVE employees;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DROP TABLE removes one or more tables completely, deleting both the structure (definition) and all data.
</details>

**Q32. How do you drop multiple tables in a single SQL statement?**
A) DROP TABLE t1 AND t2;
B) DROP TABLE t1, t2;
C) DROP TABLES t1, t2;
D) You cannot drop multiple tables in one statement.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Multiple tables can be dropped simultaneously by providing a comma-separated list of table names after the DROP TABLE command.
</details>

**Q33. What is the effect of the IF EXISTS clause in a DROP TABLE statement?**
A) It drops the table only if it contains data.
B) It drops the table only if no foreign keys reference it.
C) It prevents an error from occurring if the table does not exist.
D) It pauses execution to ask for confirmation if the table exists.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Using DROP TABLE IF EXISTS ensures that MySQL throws a warning instead of a fatal error when attempting to drop a non-existent table.
</details>

**Q34. In MySQL 8.0, what does the RESTRICT keyword do in `DROP TABLE t1 RESTRICT;`?**
A) It prevents dropping the table if it contains any rows.
B) It prevents dropping the table if it is referenced by a foreign key constraint.
C) It restricts dropping to users with root privileges only.
D) It does nothing; it is parsed but ignored in MySQL.

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Standard SQL uses RESTRICT to prevent dropping if dependencies exist. While MySQL accepts the RESTRICT and CASCADE keywords in DROP TABLE for portability, it simply ignores them.
</details>

**Q35. What happens to privileges explicitly granted on a table when the table is dropped?**
A) They are automatically revoked.
B) They remain in the grant tables. If a table with the same name is created, the privileges apply to it.
C) They are temporarily suspended until a new table is created.
D) The database throws an error preventing the drop.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Dropping a table does NOT remove privileges specifically granted on that table. If you recreate a table with the same name, the old privileges will still apply.
</details>

**Q36. Which statement quickly removes all rows from a table but keeps the table structure intact?**
A) DELETE TABLE t1;
B) DROP TABLE t1;
C) TRUNCATE TABLE t1;
D) CLEAR TABLE t1;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** TRUNCATE TABLE empties a table completely, removing all rows while leaving the table structure (columns, constraints, indexes) in place.
</details>

**Q37. Internally, how does MySQL typically execute a TRUNCATE TABLE command?**
A) It executes a DELETE statement for every row one by one.
B) It drops the table and recreates it with the same definition.
C) It hides the rows until they are overwritten.
D) It renames the table and creates a blank one.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** TRUNCATE TABLE is a DDL operation. MySQL logically drops and re-creates the table, which makes it much faster than a DML DELETE statement.
</details>

**Q38. How does TRUNCATE TABLE affect an AUTO_INCREMENT column?**
A) It leaves the sequence at its current highest value.
B) It resets the sequence to its starting value (usually 1).
C) It drops the AUTO_INCREMENT attribute from the column.
D) It causes an error if an AUTO_INCREMENT column exists.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Truncating a table resets the AUTO_INCREMENT counter to its initial value, unlike a DELETE statement without a WHERE clause, which leaves the sequence intact.
</details>

**Q39. Can a TRUNCATE TABLE operation be rolled back in MySQL (using InnoDB)?**
A) Yes, because it is a DML statement.
B) No, because it is a DDL operation and causes an implicit commit.
C) Yes, if used within a SAVEPOINT.
D) No, because InnoDB does not support transactions.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DDL statements in MySQL, including TRUNCATE TABLE, trigger an implicit commit. Therefore, it cannot be rolled back even if executed within an active transaction.
</details>

**Q40. When will a TRUNCATE TABLE statement fail in MySQL?**
A) If the table contains more than 1 million rows.
B) If there is an active foreign key constraint referencing the table from another table.
C) If the table has a primary key defined.
D) If the table has no data in it.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** TRUNCATE TABLE fails if the table is referenced by a foreign key constraint in another table. You must use DELETE or temporarily disable foreign key checks.
</details>

**Q41. Which DDL statement is used to modify the structure of an existing table?**
A) MODIFY TABLE
B) CHANGE TABLE
C) UPDATE TABLE
D) ALTER TABLE

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** ALTER TABLE is the standard DDL command to add, drop, or modify columns and constraints in an existing table.
</details>

**Q42. How do you create a temporary table that is automatically dropped when the session ends?**
A) CREATE TRANSIENT TABLE t1 (id INT);
B) CREATE TEMP TABLE t1 (id INT);
C) CREATE TEMPORARY TABLE t1 (id INT);
D) CREATE SESSION TABLE t1 (id INT);

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** CREATE TEMPORARY TABLE creates a table that is visible only to the current session and is dropped automatically when the session closes.
</details>

**Q43. What happens if you create a TEMPORARY table with the same name as an existing regular table in the same database?**
A) MySQL throws a syntax error.
B) The existing table is permanently dropped.
C) The existing table is hidden, and the temporary table takes precedence for the session.
D) The query is ignored.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The temporary table "shadows" the base table. Any queries against that table name will hit the temporary table until it is dropped or the session ends.
</details>

**Q44. In a CREATE TABLE statement, what does the UNIQUE keyword ensure?**
A) Every value in the column must be a positive integer.
B) The column can only hold one single value repeatedly.
C) All values in the column must be distinct from one another.
D) The column becomes the Primary Key.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A UNIQUE constraint ensures that all values in a column or a set of columns are different (distinct) from each other.
</details>

**Q45. Can a table have multiple UNIQUE constraints?**
A) Yes, a table can have multiple UNIQUE constraints on different columns.
B) No, a table can only have one UNIQUE constraint, similar to a Primary Key.
C) Yes, but only if they are combined into a single index.
D) No, only the Primary Key guarantees uniqueness.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Unlike the PRIMARY KEY constraint (which is limited to one per table), you can define multiple UNIQUE constraints on different columns in a single table.
</details>

**Q46. What is the difference between a PRIMARY KEY and a UNIQUE index?**
A) A UNIQUE index allows multiple NULL values (in MySQL), while a PRIMARY KEY does not allow any NULLs.
B) A PRIMARY KEY allows NULL values, but a UNIQUE index does not.
C) There is no difference; they are exactly the same.
D) A PRIMARY KEY must be numeric, but a UNIQUE index can be a string.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A PRIMARY KEY strictly prohibits NULL values, whereas a UNIQUE constraint typically allows one or more NULL values, as NULL is generally not considered equal to NULL.
</details>

**Q47. Which keyword is used to specify that a column should automatically assign the current timestamp when a new row is inserted?**
A) CURRENT_TIME
B) DEFAULT CURRENT_TIMESTAMP
C) AUTO_TIMESTAMP
D) SET TIMESTAMP

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `DEFAULT CURRENT_TIMESTAMP` automatically inserts the current date and time when a row is created if no value is provided.
</details>

**Q48. How do you specify that a column should automatically update its timestamp whenever the row is modified?**
A) ON UPDATE CURRENT_TIMESTAMP
B) ON MODIFY CURRENT_TIME
C) AUTO_UPDATE TIMESTAMP
D) UPDATE TO CURRENT_TIMESTAMP

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The clause `ON UPDATE CURRENT_TIMESTAMP` is used with TIMESTAMP or DATETIME columns to auto-update the value whenever any column in the row is changed.
</details>

**Q49. Which syntax is valid for creating a foreign key during table creation?**
A) FOREIGN KEY (user_id) REFERENCES users(id)
B) FOREIGN user_id REFERENCES users(id)
C) KEY FOREIGN (user_id) REFERENCES users(id)
D) FOREIGN KEY user_id TO users(id)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The correct syntax defines the FOREIGN KEY followed by the local column in parentheses, then REFERENCES, the target table, and the target column in parentheses.
</details>

**Q50. What does the ON DELETE CASCADE constraint do in a Foreign Key definition?**
A) It prevents the deletion of a record in the parent table.
B) It deletes the foreign key index if the parent table is dropped.
C) It automatically deletes matching rows in the child table when a row in the parent table is deleted.
D) It sets the child column to NULL when the parent row is deleted.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** ON DELETE CASCADE ensures referential integrity by automatically removing child rows whenever the referenced parent row is deleted.
</details>

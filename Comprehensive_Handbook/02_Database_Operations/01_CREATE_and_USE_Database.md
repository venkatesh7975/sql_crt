# CREATE and USE Database

---

## 1. What is a Database Object?

Before creating tables to store data, you must first create the container that holds them. In MySQL, this container is called a **Database** (sometimes referred to as a schema). 
You can think of a MySQL server as a giant warehouse. A database is a specific locked room within that warehouse where all the tables for a particular application are kept.

---

## 2. CREATE DATABASE

The `CREATE DATABASE` command is a Data Definition Language (DDL) statement used to instantiate a new database.

### Basic Syntax
```sql
CREATE DATABASE my_database;
```
If the command succeeds, MySQL will return a message like `Query OK, 1 row affected (0.01 sec)`.

### Defensive Creation (`IF NOT EXISTS`)
If you try to create a database that already exists, MySQL will throw an error: `ERROR 1007: Can't create database 'my_database'; database exists`.
To write robust SQL scripts (especially for automated deployments), you should use the `IF NOT EXISTS` clause. This tells MySQL to silently ignore the command if the database is already there, preventing the script from crashing.

```sql
CREATE DATABASE IF NOT EXISTS my_database;
```

### Specifying Character Sets and Collations
By default, MySQL creates databases using its default character set (usually `utf8mb4` in modern versions). This determines what kind of text characters can be stored (e.g., English letters, Chinese characters, Emojis). 

You can explicitly define these settings during creation:
```sql
CREATE DATABASE IF NOT EXISTS my_database
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```
*   `utf8mb4` is the standard for modern web applications because it fully supports 4-byte characters (like emojis 🚀).
*   `utf8mb4_unicode_ci` ensures that sorting and comparisons are Case Insensitive (`_ci`).

---

## 3. Viewing Databases

To see all the databases that currently exist on your MySQL server, use the `SHOW` command:

```sql
SHOW DATABASES;
```
This will output a list of names. You will likely see some system databases in there as well (e.g., `information_schema`, `mysql`, `performance_schema`, `sys`). **Never delete or modify these system databases.**

---

## 4. USE DATABASE

Once you have created a database, you cannot immediately start creating tables. A MySQL server can host hundreds of databases simultaneously. You must explicitly tell the engine *which* database you want to work inside.

### The USE Command
```sql
USE my_database;
```
When you run this command, MySQL will reply with `Database changed`. From this point forward, any `CREATE TABLE`, `SELECT`, or `INSERT` commands will automatically execute against `my_database`.

### Working Without USE
If you do not want to use the `USE` command, you can prefix your table names with the database name, separated by a dot.
```sql
-- Valid even if you haven't run 'USE my_database;'
SELECT * FROM my_database.users; 
```
This dotted notation is incredibly useful when you need to write a query that joins tables from two completely different databases!

---

## 5. Interview Tips
*   **The Emoji Question:** A common junior backend question is "Why do emojis sometimes save as `???` in the database?"
    *   **Answer:** "Because the database was created using the legacy `utf8` character set, which only supports 3-byte characters. Emojis require 4 bytes. The database must be created or altered to use `utf8mb4`."
*   **Idempotency:** Using `IF NOT EXISTS` is a best practice for writing **idempotent** scripts. An idempotent script can be run 100 times in a row and yield the same safe result as running it once.

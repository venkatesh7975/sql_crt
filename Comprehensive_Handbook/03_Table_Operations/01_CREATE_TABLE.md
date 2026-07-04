# CREATE TABLE

---

## 1. What is a Table?

If a Database is a filing cabinet, a **Table** is a single folder inside that cabinet containing perfectly organized, grid-like data. 
In a Relational Database, data is exclusively stored in tables consisting of **Columns** (attributes/fields) and **Rows** (individual records).

Before you can insert data, you must define the strict structure of the table using the `CREATE TABLE` command.

---

## 2. Basic Syntax

To create a table, you must provide three things for every column:
1.  The column name.
2.  The data type (e.g., `INT`, `VARCHAR`).
3.  Optional constraints (e.g., `NOT NULL`, `PRIMARY KEY`).

```sql
CREATE TABLE table_name (
    column1_name datatype constraints,
    column2_name datatype constraints,
    column3_name datatype constraints
);
```

### Example: Creating a Users Table

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
**Breakdown of the above query:**
*   `id`: An integer. `PRIMARY KEY` means it uniquely identifies the row. `AUTO_INCREMENT` tells MySQL to automatically generate the next number (1, 2, 3...) when a new row is added.
*   `first_name` & `last_name`: Strings up to 50 characters long. `NOT NULL` means these fields cannot be left blank.
*   `email`: A string up to 100 characters. `UNIQUE` guarantees no two users can register with the same email.
*   `created_at`: A timestamp. `DEFAULT CURRENT_TIMESTAMP` means if we don't provide a time when inserting the row, MySQL will automatically fill it in with the exact moment the row was created.

---

## 3. Defensive Creation (`IF NOT EXISTS`)

Just like with databases, trying to create a table that already exists will crash your script: `ERROR 1050: Table 'users' already exists`.
Always use `IF NOT EXISTS` for safe, repeatable (idempotent) scripts.

```sql
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY,
    username VARCHAR(50)
);
```

---

## 4. Creating a Table from Another Table

Sometimes you want to create a brand new table using the exact structure and data of an existing table (e.g., creating a backup before running a dangerous update).

### Copying Structure AND Data
```sql
CREATE TABLE users_backup AS
SELECT * FROM users;
```

### Copying Structure ONLY (No Data)
To copy the columns without copying the rows, use a `WHERE` clause that is mathematically impossible (like `1 = 0`).
```sql
CREATE TABLE users_empty_copy AS
SELECT * FROM users WHERE 1 = 0;
```

---

## 5. Viewing Table Structure

Once a table is created, you can inspect its structure (columns, types, and constraints) using the `DESCRIBE` command.

```sql
DESCRIBE users;
-- OR 
DESC users;
```

If you want to see the exact SQL code that the database used to generate the table, use:
```sql
SHOW CREATE TABLE users;
```

---

## 6. Interview Tips
*   **Data Types:** Be prepared to justify your data type choices. "Why did you use `VARCHAR(50)` instead of `TEXT` for the first name?" (Answer: Names are short, and `VARCHAR` allows for fast indexing and sorting, whereas `TEXT` does not).
*   **Idempotency:** Mentioning `IF NOT EXISTS` during a live coding interview shows that you write production-ready deployment scripts, not just scratchpad queries.

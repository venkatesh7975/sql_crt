# INSERT (Create)

---

## 1. What is CRUD?

**CRUD** is an acronym that represents the four basic operations of persistent storage in software engineering:
*   **C**reate (SQL: `INSERT`)
*   **R**ead (SQL: `SELECT`)
*   **U**pdate (SQL: `UPDATE`)
*   **D**elete (SQL: `DELETE`)

All of these are DML (Data Manipulation Language) commands because they interact directly with the rows of data, not the structure of the tables.

---

## 2. Basic INSERT Syntax

The `INSERT INTO` statement is used to add new rows of data to a table.

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

### Example
Imagine a table: `users (id AUTO_INCREMENT, first_name, last_name, status DEFAULT 'active')`

```sql
INSERT INTO users (first_name, last_name)
VALUES ('John', 'Doe');
```
*Notice that we did not provide a value for `id` or `status`.* 
*   `id` is automatically generated because it is `AUTO_INCREMENT`.
*   `status` automatically becomes `'active'` because of the `DEFAULT` constraint.
*   If we omitted a column that was `NOT NULL` without a default, the query would fail.

---

## 3. Inserting Multiple Rows (Bulk Insert)

If you need to add 5 new users, you *could* write 5 separate `INSERT INTO` statements. However, executing 5 separate network calls to the database is incredibly slow.
Instead, use a **Bulk Insert** by chaining comma-separated tuples.

```sql
INSERT INTO users (first_name, last_name)
VALUES 
    ('Alice', 'Smith'),
    ('Bob', 'Johnson'),
    ('Charlie', 'Brown');
```
This inserts all 3 rows in a single, lightning-fast transaction. 
*Best Practice:* Whenever you are writing an application (like a Python script parsing a CSV), always batch your inserts like this instead of looping and inserting row-by-row.

---

## 4. INSERT ... SELECT (Copying Data)

Sometimes you want to insert data into a table based on data that *already exists* in another table. You can replace the `VALUES` clause entirely with a `SELECT` statement.

**Scenario:** We have a `users` table, and we want to copy all users from New York into a new table called `new_york_users`.

```sql
-- The columns in the SELECT must perfectly match the columns in the target table
INSERT INTO new_york_users (user_id, full_name, email)
SELECT 
    id, 
    CONCAT(first_name, ' ', last_name), 
    email
FROM 
    users
WHERE 
    city = 'New York';
```
This is a massively powerful tool in Data Engineering for ETL (Extract, Transform, Load) pipelines.

---

## 5. Handling Duplicates (MySQL Specific)

What happens if you try to `INSERT` a row that violates a `UNIQUE` constraint (e.g., trying to register an email that already exists)? The query will crash.

MySQL offers two powerful extensions to handle this gracefully:

### INSERT IGNORE
If the insert causes a duplicate key error, MySQL will silently ignore the error, discard the new row, and keep the old row. The rest of your bulk insert will continue unaffected.
```sql
INSERT IGNORE INTO users (email) VALUES ('existing@email.com');
```

### INSERT ... ON DUPLICATE KEY UPDATE (Upsert)
This is an "Upsert" (Update or Insert). If the email is new, it inserts the row. If the email already exists, it updates the existing row instead of crashing!
```sql
INSERT INTO users (email, login_count) 
VALUES ('test@test.com', 1)
ON DUPLICATE KEY UPDATE 
login_count = login_count + 1;
```

---

## 6. Interview Tips
*   **Bulk Inserts:** If you are asked how to optimize an application that is taking 10 minutes to insert 10,000 records, the answer is always: "Stop doing individual inserts in a loop. Batch them into a single `INSERT INTO ... VALUES (), (), ()` statement."
*   **Upserts:** "How do you handle inserting a record if you aren't sure whether it already exists or not?" Answer: "Use `INSERT ... ON DUPLICATE KEY UPDATE`."

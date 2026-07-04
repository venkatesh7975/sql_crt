# DELETE (Delete)

---

## 1. The DELETE Statement

The `DELETE` statement is used to permanently remove existing rows from a table. It is the "Delete" in CRUD.

### Basic Syntax
```sql
DELETE FROM table_name
WHERE condition;
```

### Example
```sql
-- Remove a specific user
DELETE FROM users WHERE id = 42;

-- Remove all inactive users
DELETE FROM users WHERE status = 'inactive';
```

---

## 2. The WHERE Clause Warning (Danger!)

Just like with `UPDATE`, the `WHERE` clause in a `DELETE` statement is the only thing standing between you and total data destruction.
**If you omit the `WHERE` clause, you will delete EVERY SINGLE ROW in the table.**

```sql
-- CATASTROPHIC ERROR! 
DELETE FROM users;
```
*(MySQL's `sql_safe_updates` mode will also block this if enabled).*

---

## 3. DELETE with LIMIT

If you have a massive table (e.g., millions of logs) and you want to clean up old data, running a massive `DELETE` query can lock the table and overwhelm the database transaction log, bringing your production server to its knees.

**Best Practice: Chunked Deletions**
To avoid table locks, you should delete data in small, manageable chunks using the `LIMIT` clause.

```sql
-- Delete 10,000 old logs at a time, pausing the script between runs
DELETE FROM system_logs 
WHERE created_at < '2022-01-01' 
LIMIT 10000;
```

---

## 4. DELETE with JOIN (Self Joins and Cross-Table)

Like `UPDATE`, MySQL allows you to `JOIN` tables during a `DELETE` statement. 

However, because multiple tables are involved in the `FROM` clause, **you must explicitly declare WHICH table's rows you are deleting** by placing the alias immediately after the `DELETE` keyword.

### Example: Delete Duplicate Emails (Self Join)
This is a famous LeetCode problem. We want to delete duplicate emails, keeping only the row with the smallest ID.

```sql
-- Notice we specify 'p1' right after DELETE
DELETE p1 
FROM 
    person p1
JOIN 
    person p2 ON p1.email = p2.email 
WHERE 
    p1.id > p2.id;
```

### Example: Delete Users without Orders (Left Join)
```sql
-- Delete rows from the 'u' (users) table
DELETE u
FROM 
    users u
LEFT JOIN 
    orders o ON u.id = o.user_id
WHERE 
    o.id IS NULL;
```

---

## 5. Soft Deletes vs Hard Deletes

In professional software engineering, **we rarely use the `DELETE` command.**

When a user clicks "Delete Account", companies do not usually wipe their data from the database. That data is valuable, and deleting it might break Foreign Key constraints across the system.

Instead, we use **Soft Deletes**.
A Soft Delete is simply an `UPDATE` command that sets a flag.

```sql
-- Adding a soft delete column
ALTER TABLE users ADD is_deleted BOOLEAN DEFAULT FALSE;

-- "Deleting" the user (Soft Delete)
UPDATE users SET is_deleted = TRUE WHERE id = 42;

-- Your application queries must now always include this filter:
SELECT * FROM users WHERE is_deleted = FALSE;
```

A **Hard Delete** is the actual SQL `DELETE` command. It is usually reserved for automated background jobs clearing out 30-day-old trash data or complying with GDPR "Right to be Forgotten" requests.

---

## 6. Recap: TRUNCATE vs DELETE vs DROP

Because this comes up constantly:
*   `DROP TABLE users;` -> Annihilates the table and the data. (DDL)
*   `TRUNCATE TABLE users;` -> Vaporizes all data instantly, keeps the empty table. Resets Auto-Increment. Cannot use WHERE. Cannot be rolled back easily. (DDL)
*   `DELETE FROM users;` -> Removes rows one by one. Can use WHERE. Does not reset Auto-Increment. Slower. Can be rolled back. (DML)

---

## 7. Interview Tips
*   **Soft vs Hard Delete:** If an interviewer asks you to write an API to delete a user, always ask: "Should this be a Hard Delete or a Soft Delete?" Bringing up the concept of a `deleted_at` timestamp or an `is_deleted` boolean flag shows maturity and real-world system design experience.
*   **Massive Deletions:** "How do you delete 50 million rows from a 100 million row table?" 
    *   **Answer:** "Never run a single `DELETE` statement. It will lock the table and bloat the transaction log. I would either write a script to loop and `DELETE ... LIMIT 10000`, OR, if it's faster, I would `INSERT ... SELECT` the 50 million rows I want to *keep* into a temporary table, `TRUNCATE` the main table, and move the good rows back."

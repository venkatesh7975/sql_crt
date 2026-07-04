# RENAME TABLE

---

## 1. Renaming a Table

If you need to completely change the name of an existing table, MySQL provides two different ways to do it.

### Method 1: RENAME TABLE Command (Preferred)
This is the standard, dedicated command for renaming tables.

```sql
RENAME TABLE old_table_name TO new_table_name;
```

**Renaming Multiple Tables at Once:**
The massive advantage of the `RENAME TABLE` command is that it allows you to swap multiple table names simultaneously in a single, atomic operation.

```sql
RENAME TABLE 
    users TO inactive_users,
    new_users TO users;
```
*Why is this atomic swap important?* In production environments, if you are migrating data to a new table structure, this atomic swap guarantees zero downtime. The application queries `users` and never experiences a millisecond where the `users` table doesn't exist.

### Method 2: ALTER TABLE Command
You can also use the `ALTER TABLE` syntax to rename a table.

```sql
ALTER TABLE old_table_name RENAME TO new_table_name;
```
This does exactly the same thing, but it cannot rename multiple tables simultaneously like the `RENAME TABLE` command can.

---

## 2. Moving Tables Between Databases

A hidden superpower of the `RENAME TABLE` command is that you can use it to instantly move a table from one database to another database on the same server.

```sql
-- Move the users table from the 'legacy_db' to the 'modern_db'
RENAME TABLE legacy_db.users TO modern_db.users;
```
This operation is incredibly fast because MySQL just updates the directory pointers on the file system; it doesn't actually copy the gigabytes of data.

---

## 3. Interview Tips
*   **Zero-Downtime Deployments:** If an interviewer asks how you would replace a massive, heavily-queried table with a newly structured version without bringing down the application, explain the atomic multi-table rename: `RENAME TABLE old TO backup, new TO old;`. This proves you understand production-grade deployment strategies.

# ALTER TABLE and Column Modifications

---

## 1. What is ALTER TABLE?

The `ALTER TABLE` command is a Data Definition Language (DDL) statement used to change the structure of an existing table *without* deleting it. 
As applications grow, database schemas inevitably change. You will need to add new columns, delete obsolete ones, or change data types.

---

## 2. Adding a Column (`ADD`)

To add a new column to an existing table, use `ADD`.

```sql
-- Add a simple column
ALTER TABLE users 
ADD phone_number VARCHAR(15);
```

### Positioning the New Column (MySQL Specific)
By default, `ADD` places the new column at the very end of the table. In MySQL, you can precisely control where the column goes using `FIRST` or `AFTER`.

```sql
-- Put it at the very beginning
ALTER TABLE users 
ADD uuid VARCHAR(36) FIRST;

-- Put it right after the email column
ALTER TABLE users 
ADD date_of_birth DATE AFTER email;
```

---

## 3. Modifying an Existing Column (`MODIFY` vs `CHANGE`)

If you need to change a column's data type (e.g., expanding a `VARCHAR(50)` to `VARCHAR(100)`) or add constraints (e.g., making a column `NOT NULL`), you must modify it.
MySQL provides two different keywords for this: `MODIFY` and `CHANGE`.

### Using MODIFY (Change Type, Keep Name)
Use `MODIFY` when you want to change the data type or constraints, but you want to **keep the same column name**.

```sql
-- Change email from VARCHAR(100) to VARCHAR(255)
ALTER TABLE users 
MODIFY email VARCHAR(255) NOT NULL;
```
*(Warning: You must restate all constraints like `NOT NULL` when modifying. If you leave it out, MySQL might drop the constraint).*

### Using CHANGE (Change Type AND Name)
Use `CHANGE` when you want to rename the column *and* redefine its type at the same time. You must provide the old name, the new name, and the type.

```sql
-- Rename 'phone_number' to 'mobile_number' and change type
ALTER TABLE users 
CHANGE phone_number mobile_number VARCHAR(20);
```

---

## 4. Dropping a Column (`DROP`)

If a column is no longer needed, you can delete it. **This permanently deletes all the data stored in that column.**

```sql
ALTER TABLE users 
DROP COLUMN mobile_number;
```
*(Note: The word `COLUMN` is technically optional in MySQL, but it is best practice to include it for readability).*

---

## 5. Adding and Dropping Constraints

You can use `ALTER TABLE` to add constraints (like Unique or Primary Keys) after a table has been created.

### Adding a Unique Constraint
```sql
ALTER TABLE users 
ADD CONSTRAINT unique_email UNIQUE (email);
```

### Dropping a Constraint
To drop a constraint, you must reference its internal name. If you didn't name it (like the `unique_email` above), MySQL auto-generated a name for you (which you can find using `SHOW CREATE TABLE users`).
```sql
-- Drop an index/unique constraint
ALTER TABLE users 
DROP INDEX unique_email;
```

---

## 6. Interview Tips
*   **The Locking Danger:** In massive production tables (e.g., millions of rows), running `ALTER TABLE` can lock the entire table for minutes or even hours while the database engine rewrites the underlying files. During this time, the application goes down. Interviewers love asking how to handle this.
    *   **Answer:** "For massive tables, I would not use a direct `ALTER TABLE` during peak hours. I would use a tool like `pt-online-schema-change` (Percona) or GitHub's `gh-ost`, which creates a shadow copy of the table, alters it in the background, syncs the live data, and swaps them instantly without locking the database."
*   **MODIFY vs CHANGE:** Knowing that `CHANGE` requires typing the column name twice (old name, new name) while `MODIFY` only requires typing it once is a great piece of MySQL trivia.

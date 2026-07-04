# UPDATE (Update)

---

## 1. The UPDATE Statement

The `UPDATE` statement is used to modify existing records in a table. It is the "Update" in CRUD.

Unlike `INSERT`, which creates brand new rows, `UPDATE` reaches into existing rows and changes the values inside specific columns.

### Basic Syntax
```sql
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;
```

### Example
Imagine a user gets married and changes their last name and email.
```sql
UPDATE users
SET 
    last_name = 'Smith-Doe',
    email = 'new.email@example.com',
    updated_at = CURRENT_TIMESTAMP
WHERE 
    id = 42;
```

---

## 2. The WHERE Clause Warning (Danger!)

The `WHERE` clause in an `UPDATE` statement dictates *which* rows will be modified. 
**If you omit the `WHERE` clause, the update will apply to EVERY SINGLE ROW in the table.**

```sql
-- CATASTROPHIC ERROR! 
-- This sets EVERY user's password to 'password123'
UPDATE users 
SET password = 'password123';
```

### Safe Updates Mode
Because omitting the `WHERE` clause is such a common and devastating mistake, MySQL includes a feature called `sql_safe_updates`.
When this mode is enabled, MySQL will completely block any `UPDATE` or `DELETE` statement that does not include a `WHERE` clause utilizing a Primary Key or an Indexed column.

---

## 3. Updating using Math and Logic

You don't just have to update columns to static strings. You can reference existing column values to do math.

**Example: Give everyone in the IT department a 10% raise.**
```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'IT';
```

**Example: Increment a counter.**
```sql
UPDATE articles
SET views = views + 1
WHERE id = 99;
```

---

## 4. UPDATE with JOIN (MySQL Specific Syntax)

Sometimes you need to update a table based on data that lives in a completely different table. 

**Scenario:** We have a `users` table and a `subscriptions` table. We want to update the `users.is_premium` flag to `TRUE` for anyone who has an active record in the `subscriptions` table.

In MySQL, you can `JOIN` tables directly inside the `UPDATE` statement!

```sql
UPDATE 
    users u
JOIN 
    subscriptions s ON u.id = s.user_id
SET 
    u.is_premium = TRUE
WHERE 
    s.status = 'active' AND s.expires_at > CURRENT_DATE;
```
*(Note: This syntax is highly specific to MySQL. SQL Server and PostgreSQL handle cross-table updates using a different `UPDATE ... FROM ...` syntax).*

---

## 5. Interview Tips
*   **The Missing WHERE:** "What happens if you run an UPDATE without a WHERE clause?" 
    *   **Answer:** "It updates every row in the table, destroying your data unless you have `sql_safe_updates` turned on."
*   **Cross-Table Updates:** Knowing how to do an `UPDATE JOIN` is a great way to show intermediate-level SQL mastery. Beginners will often try to solve this by writing a Python script that pulls all the data, loops through it, and fires off thousands of individual `UPDATE` queries. The `UPDATE JOIN` does it in one database transaction.

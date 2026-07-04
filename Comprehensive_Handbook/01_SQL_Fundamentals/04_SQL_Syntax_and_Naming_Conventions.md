# SQL Syntax and Naming Conventions

---

## 1. General Syntax Rules

SQL syntax is remarkably forgiving compared to modern programming languages like Python or Java, but there are still fundamental rules you must follow.

### Case Sensitivity
*   **Keywords:** SQL keywords (`SELECT`, `FROM`, `WHERE`) are **case-insensitive**. `select`, `Select`, and `SELECT` all work identically.
*   **Table and Column Names:** In MySQL, case sensitivity for table names depends on your operating system. On Windows, they are case-insensitive. On Linux, they are case-sensitive. It is highly recommended to treat everything as case-sensitive to avoid cross-platform deployment disasters.
*   **String Values:** The actual data inside a table *is* usually case-sensitive, depending on the collation (e.g., `'Alice'` is not the same as `'alice'` in strict collations).

### Statements and Semicolons
Every SQL statement should end with a semicolon `;`. 
While some database clients allow you to omit it if you are only running a single query, the semicolon is strictly required when executing multiple queries in a script.

### Whitespace
SQL ignores extra whitespace (spaces, tabs, line breaks). You can write a query on one line, or break it across twenty lines.

**Valid, but unreadable:**
```sql
SELECT id,name FROM users WHERE age>18;
```

**Valid and readable (Recommended):**
```sql
SELECT 
    id, 
    name 
FROM 
    users 
WHERE 
    age > 18;
```

---

## 2. Naming Conventions (Best Practices)

While MySQL allows you to name a table `my_super_awesome_table_123`, following professional naming conventions makes your database maintainable.

### 1. Snake Case vs Camel Case
*   **Snake Case (Recommended for SQL):** `first_name`, `user_accounts`, `created_at`.
*   **Camel Case (Avoid in SQL):** `firstName`, `userAccounts`, `createdAt`.
*   *Why?* Because many SQL engines force everything to lowercase behind the scenes. If you rely on CamelCase, it becomes impossible to read.

### 2. Table Names (Plural vs Singular)
This is the most hotly debated topic in database design.
*   **Plural (Standard in Web Dev):** `users`, `orders`, `products`. This matches ORM frameworks like Ruby on Rails and Django.
*   **Singular (Standard in Enterprise):** `user`, `order`, `product`. The logic is that a table represents an "entity", and a row is a single instance of that entity.
*   *Verdict:* **Pick one and stick to it strictly.** Do not mix `users` and `product`.

### 3. Primary Key Names
*   **Recommended:** Always name the primary key `id`. (e.g., in the `users` table, the primary key is just `id`).
*   **Alternative:** Prefix the table name: `user_id`.

### 4. Foreign Key Names
*   **Recommended:** Use the singular form of the target table followed by `_id`. 
*   *Example:* If an order belongs to a user, the foreign key in the `orders` table should be named `user_id`.

### 5. Boolean Columns
Prefix boolean (true/false) columns with `is_`, `has_`, or `can_`.
*   *Example:* `is_active`, `has_premium`, `can_login`.

### 6. Date Columns
Append `_at` for timestamps and `_date` for raw dates.
*   *Example:* `created_at` (2023-10-01 14:30:00), `birth_date` (1990-05-15).

---

## 3. Reserved Words and Quoting

SQL has many **reserved words**—words that have special meaning to the engine (e.g., `SELECT`, `FROM`, `ORDER`, `GROUP`). 

If you absolutely *must* name a column with a reserved word (which you should avoid at all costs), you must quote it.

*   **MySQL Identifier Quotes:** Use backticks `` ` ``.
    ```sql
    SELECT `order`, `select` FROM `users`;
    ```
*   **ANSI SQL Standard Quotes:** Use double quotes `" "`. (PostgreSQL, SQL Server).
    ```sql
    SELECT "order", "select" FROM "users";
    ```

### Single Quotes vs Double Quotes
*   **Single Quotes `' '`:** Used exclusively for **String literals** (the actual data). 
    ```sql
    SELECT * FROM users WHERE name = 'John';
    ```
*   **Double Quotes `" "`:** Depending on the SQL dialect, used for column/table identifiers.
*   *Rule of Thumb:* **Always use single quotes for strings in SQL.**

---

## 4. Interview Tips
*   **Consistency is Key:** If given a coding test where you must design a schema, the interviewer is looking to see if your naming is consistent. If you use snake_case for one table and CamelCase for another, you lose points.
*   **The "User" Trap:** `USER` is a reserved keyword in almost every SQL dialect. If you name a table `user`, you will constantly have to wrap it in quotes. Always name it `users` or `user_accounts` to avoid syntax headaches.

# Comments and Aliases

---

## 1. Comments in SQL

Just like in Python, Java, or C++, you can write comments in your SQL code. Comments are ignored by the database engine; they exist purely to help human developers (or your future self) understand the logic behind complex queries.

### Single-Line Comments
There are two ways to write a single-line comment in MySQL:

**1. The Double Dash (ANSI Standard)**
This is the most universally accepted way across all SQL dialects (Postgres, Oracle, SQL Server).
*Note: In MySQL, the double dash MUST be followed by a space!*
```sql
-- This query fetches active users
SELECT * FROM users WHERE status = 'active'; 
```

**2. The Hash Symbol (MySQL Specific)**
This is borrowed from Unix shell scripts and Python. It is supported in MySQL, but will break if you migrate to PostgreSQL.
```sql
# This also fetches active users
SELECT * FROM users WHERE status = 'active';
```

### Multi-Line Comments (Block Comments)
Borrowed from C/C++, use `/*` to start the comment block and `*/` to end it. This is highly useful for temporarily disabling large chunks of code during debugging.

```sql
/* 
This query is currently broken, so I am commenting it out.
It was supposed to find top spenders.
SELECT * FROM transactions
WHERE amount > 1000;
*/

-- Here is the temporary fix:
SELECT * FROM transactions LIMIT 10;
```

---

## 2. Aliases (AS)

An **Alias** is a temporary name you give to a table or a column for the duration of a single query. It does not permanently rename the object in the database.

### Column Aliases
When you perform calculations, aggregate functions, or string concatenations, the output column header usually looks terrible (e.g., `COUNT(DISTINCT user_id)`). Aliases allow you to rename the output column to something clean.

Use the `AS` keyword:
```sql
SELECT 
    first_name,
    last_name,
    salary * 12 AS annual_salary
FROM 
    employees;
```
*(Now, the application receiving the data will see a column named `annual_salary` instead of `salary * 12`).*

**Rules for Column Aliases:**
1.  The `AS` keyword is technically optional in MySQL (`SELECT salary * 12 annual_salary`), but omitting it makes the code incredibly hard to read. Always use `AS`.
2.  If your alias contains spaces, you MUST wrap it in quotes (e.g., `AS 'Annual Salary'`). However, having spaces in column names is generally frowned upon. Stick to snake_case (`annual_salary`).

### Table Aliases
When you join multiple tables together, prefixing every column with the full table name becomes tedious. Table aliases allow you to create short, one- or two-letter nicknames for your tables.

**Without Aliases (Exhausting to read):**
```sql
SELECT 
    departments.department_name, 
    employees.first_name, 
    employees.last_name
FROM 
    employees
JOIN 
    departments ON employees.department_id = departments.department_id;
```

**With Aliases (Clean and Professional):**
```sql
SELECT 
    d.department_name, 
    e.first_name, 
    e.last_name
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id;
```
Notice that we usually **omit** the `AS` keyword when aliasing tables. `FROM employees e` is the universally accepted standard syntax.

### The Scope of Aliases
Remember the Logical Execution Order!
1.  **Table Aliases** are created in the `FROM` clause (Step 1). This means they are immediately available to be used in the `WHERE`, `GROUP BY`, `SELECT`, and `ORDER BY` clauses.
2.  **Column Aliases** are created in the `SELECT` clause (Step 5). In strict ANSI SQL, they can *only* be used in the `ORDER BY` clause. (Though, as discussed in the Execution Order section, MySQL bends this rule and allows you to use them in `GROUP BY` and `HAVING`).

---

## 3. Interview Tips
*   **Table Aliasing Habit:** In a live coding interview, NEVER write a `JOIN` without aliasing your tables (`e`, `d`, `o`, `u`). Writing out full table names shows a lack of daily SQL experience.
*   **Column Prefixing:** When joining tables, always prefix your columns in the `SELECT` clause with the table alias (e.g., `e.id`, `d.id`). If both tables have a column named `id` and you just write `SELECT id`, the engine will throw an `Ambiguous Column` error and crash your query.

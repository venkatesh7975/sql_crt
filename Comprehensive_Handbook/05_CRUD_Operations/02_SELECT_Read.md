# SELECT (Read)

---

## 1. The SELECT Statement

`SELECT` is the "Read" operation in CRUD. It is the most frequently used command in all of SQL. It fetches data from a database and returns it in a result table, called a **result set**.

### Basic Syntax
```sql
SELECT column1, column2, column3
FROM table_name;
```

If you want to fetch *every* column in the table, you use the asterisk `*` wildcard.
```sql
SELECT * FROM users;
```

---

## 2. Why "SELECT *" is Dangerous

While `SELECT *` is fantastic for quickly exploring a table in your SQL client, it is considered a severe anti-pattern in production application code.

**Why?**
1.  **Network Bandwidth:** If a table has a `BLOB` column storing images, `SELECT *` will pull gigabytes of image data across the network even if your application only needed the user's `first_name`.
2.  **Application Fragility:** If your Python backend expects `SELECT *` to return `[id, name, email]`, and tomorrow a DBA adds a `phone_number` column to the middle of the table, `SELECT *` now returns `[id, name, phone_number, email]`. This shifting column order will instantly break your application logic.

**Best Practice:** Always explicitly name the columns you need.
```sql
-- Production Ready
SELECT id, first_name, email FROM users; 
```

---

## 3. The DISTINCT Keyword

Sometimes a table contains duplicate values, and you only want to see a list of the unique values. 
For example, if you want to know all the different cities your users live in, `SELECT city FROM users;` might return "New York" 50,000 times.

The `DISTINCT` keyword removes duplicate rows from the result set.

```sql
SELECT DISTINCT city FROM users;
```

### DISTINCT on Multiple Columns
If you apply `DISTINCT` to multiple columns, it evaluates the *combination* of those columns.
```sql
SELECT DISTINCT city, state FROM users;
```
*(This will return unique combinations. If you have 5 users in "Springfield, IL" and 3 users in "Springfield, MA", both rows will be returned).*

---

## 4. Expanding the SELECT Query

A pure `SELECT` statement pulls the entire table. In reality, you almost always attach modifiers to limit the result set. 
*(Note: These clauses have their own dedicated deep-dive chapters later in the handbook).*

### 1. Filtering Rows (`WHERE`)
Limits the output based on conditions.
```sql
SELECT name FROM users WHERE status = 'active';
```

### 2. Sorting Rows (`ORDER BY`)
Sorts the output alphabetically or numerically.
```sql
SELECT name FROM users ORDER BY name ASC; -- (Ascending: A to Z)
SELECT name FROM users ORDER BY name DESC; -- (Descending: Z to A)
```

### 3. Limiting Rows (`LIMIT` and `OFFSET`)
Limits the sheer volume of output. Crucial for pagination (e.g., "Show me page 2 of the results").
```sql
-- Give me the first 10 users
SELECT name FROM users LIMIT 10;

-- Skip the first 10, then give me the next 10 (Page 2)
SELECT name FROM users LIMIT 10 OFFSET 10;
```

---

## 5. Interview Tips
*   **The SELECT * Trap:** Interviewers often show a snippet of application code using `SELECT *` and ask "What's wrong with this?" The answer is always Network I/O bloat and column-order fragility.
*   **DISTINCT Placement:** "Can I do `SELECT name, DISTINCT city`?" 
    *   **Answer:** "No. `DISTINCT` is not a function you apply to a specific column; it is a keyword that applies to the entire row returned by the `SELECT` clause. It must be placed immediately after the word `SELECT`."

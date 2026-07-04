# LIMIT and OFFSET (Pagination)

---

## 1. The LIMIT Clause

The `LIMIT` clause restricts the maximum number of rows returned by the query. It is placed at the very end of the SQL statement.

If your query matches 1,000,000 rows, but you append `LIMIT 5`, the database will only return the first 5 rows it finds and immediately stop processing.

### Basic Syntax
```sql
-- Get the first 10 rows
SELECT * FROM users LIMIT 10;
```

### Combining with ORDER BY (The "Top-N" Query)
`LIMIT` on its own isn't incredibly useful because the database doesn't guarantee the order of rows. The first 5 rows it grabs are effectively random.
However, when you combine `LIMIT` with `ORDER BY`, it becomes extremely powerful.

**Example: Find the 3 most expensive products.**
```sql
SELECT name, price 
FROM products 
ORDER BY price DESC 
LIMIT 3;
```

---

## 2. The OFFSET Clause

`OFFSET` is used in conjunction with `LIMIT` to skip a specified number of rows *before* it starts returning the limited rows.

### Basic Syntax
```sql
-- Skip the first 10 rows, then give me the next 5 rows
SELECT * FROM users 
LIMIT 5 OFFSET 10;
```

### The MySQL Shorthand
MySQL allows a shorthand syntax for `LIMIT` and `OFFSET` using a comma. It is written as `LIMIT offset, row_count`.
```sql
-- Exactly the same as LIMIT 5 OFFSET 10
SELECT * FROM users 
LIMIT 10, 5;
```
*(Warning: This shorthand can be very confusing because the order of the numbers is reversed from the verbose syntax. It is recommended to use the explicit `LIMIT ... OFFSET ...` syntax for readability).*

---

## 3. Pagination (How the Web Works)

`LIMIT` and `OFFSET` are the backbone of web pagination. When you search for "Shoes" on Amazon, you get 10,000 results, but the page only shows you 20 at a time. The backend is generating SQL queries using `LIMIT` and `OFFSET`.

Assuming a page size of 20 items:

*   **Page 1:** Give me the first 20.
    ```sql
    SELECT * FROM products ORDER BY id ASC LIMIT 20 OFFSET 0;
    ```
*   **Page 2:** Skip the 20 on page 1, give me the next 20.
    ```sql
    SELECT * FROM products ORDER BY id ASC LIMIT 20 OFFSET 20;
    ```
*   **Page 3:** Skip the 40 on pages 1 & 2, give me the next 20.
    ```sql
    SELECT * FROM products ORDER BY id ASC LIMIT 20 OFFSET 40;
    ```

**The Pagination Formula:**
`OFFSET = (Page_Number - 1) * Page_Size`

---

## 4. Interview Tips
*   **The Nth Highest Salary:** "Write a query to find the 2nd highest salary from the Employee table."
    *   **Answer:** You sort descending to put the highest salaries at the top. You want the 2nd one, so you skip the 1st one (`OFFSET 1`) and grab exactly one row (`LIMIT 1`).
    ```sql
    SELECT DISTINCT salary 
    FROM Employee 
    ORDER BY salary DESC 
    LIMIT 1 OFFSET 1;
    ```
*   **The Deep Pagination Problem:** Interviewers for senior roles will ask: "What happens to performance on Page 10,000?"
    *   **Answer:** "It crashes. `OFFSET 200000` forces the database engine to generate and then throw away 200,000 rows just to get the 20 you requested. For deep pagination, you cannot use `OFFSET`. Instead, you must use **Keyset Pagination** (also known as Cursor Pagination), where you track the `ID` of the last item on the page: `WHERE id > last_seen_id ORDER BY id ASC LIMIT 20;`"

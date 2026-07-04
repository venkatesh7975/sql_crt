# Control Flow (CASE, IF, COALESCE)

---

## 1. Logic Inside the Query

Control Flow functions allow you to write `IF-THEN-ELSE` logic directly inside your SQL `SELECT` statements. 
Instead of pulling raw data and using Python to categorize it, you can have the database categorize it for you on the fly.

---

## 2. The CASE Statement (The Standard)

The `CASE` statement is the SQL equivalent of an `if/elif/else` block. It is standard ANSI SQL and works in every major relational database.

It goes through conditions sequentially and stops evaluating as soon as one is true. If no conditions are true, it returns the value in the `ELSE` clause (or `NULL` if there is no `ELSE`).

### Basic Syntax
```sql
SELECT 
    product_name,
    price,
    CASE
        WHEN price > 1000 THEN 'Luxury'
        WHEN price > 500 THEN 'Premium'
        WHEN price > 100 THEN 'Standard'
        ELSE 'Budget'
    END AS price_category
FROM products;
```

**Use Case:** You can use `CASE` inside a `SELECT` clause to create new virtual columns, inside an `ORDER BY` clause for custom sorting logic, or even inside an `UPDATE` statement to apply complex logic!

---

## 3. The IF() Function (MySQL Specific Shortcut)

MySQL provides a shorthand function called `IF()` for simple `True/False` conditions. It is exactly like the ternary operator (`condition ? true : false`) in programming languages.

### Syntax
`IF(condition, value_if_true, value_if_false)`

### Example
```sql
SELECT 
    order_id,
    IF(status = 'delivered', 'Complete', 'Pending') AS order_status
FROM orders;
```
*Warning: While `IF()` is cleaner to read, it is specific to MySQL. If you migrate to PostgreSQL later, you will have to rewrite all your `IF()` functions as `CASE` statements. It is generally safer to stick to `CASE`.*

---

## 4. Handling NULLs Gracefully

Because `NULL` means "Unknown", math or concatenation involving `NULL` usually results in `NULL`. SQL provides specific functions to safely handle them.

### IFNULL() (MySQL Specific)
Checks if the first argument is `NULL`. If it is, it returns the second argument. If it isn't, it returns the first argument.

```sql
-- If phone_number is NULL, return 'No Phone'. Otherwise, return the phone_number.
SELECT IFNULL(phone_number, 'No Phone') FROM users;
```

### COALESCE() (The Industry Standard)
`COALESCE()` is vastly superior to `IFNULL()`. It is standard ANSI SQL, and it accepts an *unlimited* number of arguments.
It evaluates the arguments from left to right and **returns the very first non-NULL value it finds.**

```sql
-- Returns 'A'
SELECT COALESCE(NULL, 'A', 'B');

-- Fallback mechanism for contact info
-- Tries mobile first, then home phone, then email, then gives up.
SELECT 
    name, 
    COALESCE(mobile_phone, home_phone, email, 'No Contact Info') AS primary_contact
FROM users;
```

---

## 5. Interview Tips
*   **Pivoting Tables:** The `CASE` statement is the secret weapon for answering "Pivot Table" interview questions. (e.g., "Convert these rows of monthly sales into columns"). You combine `SUM()` with `CASE WHEN month='Jan' THEN sales ELSE 0 END`. (We cover this deeply in the Advanced sections).
*   **COALESCE vs IFNULL:** "What is the difference between `COALESCE` and `IFNULL`?"
    *   **Answer:** "`IFNULL` only takes exactly two arguments and is specific to MySQL. `COALESCE` takes an infinite number of arguments, returns the first non-null value, and is ANSI SQL standard, making it portable." Always recommend `COALESCE`.

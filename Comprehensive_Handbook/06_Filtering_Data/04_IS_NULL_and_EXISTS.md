# IS NULL and EXISTS

---

## 1. IS NULL and IS NOT NULL

As covered extensively in the SQL Fundamentals section, `NULL` represents the total absence of data. Because `NULL` means "Unknown", you cannot use standard equality operators (`=`, `!=`) to find it.

### The Syntax
To check if a column has no data, you must use `IS NULL`.
```sql
-- Find users who haven't provided a phone number
SELECT * FROM users WHERE phone_number IS NULL;
```

To check if a column *does* have data, you must use `IS NOT NULL`.
```sql
-- Find users who have provided a phone number
SELECT * FROM users WHERE phone_number IS NOT NULL;
```

---

## 2. The EXISTS Operator

The `EXISTS` operator is used to test for the existence of *any* record in a subquery. 
It returns a boolean `TRUE` if the subquery returns one or more records, and `FALSE` if the subquery returns zero records.

`EXISTS` is highly optimized because the database engine will stop scanning the moment it finds the very first matching row (it doesn't care how many rows match, only that *at least one* matches).

### Basic Syntax
```sql
SELECT column_name
FROM table_name
WHERE EXISTS (subquery);
```

### Example: Finding customers who have placed an order
We have a `customers` table and an `orders` table. We want a list of all customers who have placed at least one order.

```sql
SELECT customer_name 
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.id
);
```
*   Notice the `SELECT 1` in the subquery. Because `EXISTS` only cares *if* a row exists and doesn't care *what* data is inside it, returning the integer `1` is a standard convention. You could write `SELECT *`, but `SELECT 1` is slightly cleaner.
*   This is a **Correlated Subquery**, meaning the subquery references a column from the outer query (`c.id`).

---

## 3. NOT EXISTS

`NOT EXISTS` is the exact opposite. It returns `TRUE` if the subquery returns zero rows.

### Example: Finding customers who have NEVER placed an order
```sql
SELECT customer_name 
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.id
);
```

---

## 4. EXISTS vs IN

In many cases, you can write the exact same query using `IN` or `EXISTS`.

**Using IN:**
```sql
SELECT customer_name FROM customers 
WHERE id IN (SELECT customer_id FROM orders);
```
**Using EXISTS:**
```sql
SELECT customer_name FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

### Which one should you use?
*   **Use `IN`** when the subquery is small and static (e.g., `WHERE status IN ('active', 'pending')`).
*   **Use `EXISTS`** when comparing two massive tables. 
    *   *Why?* The `IN` clause usually executes the subquery entirely, stores the massive list of IDs in memory, and then compares them. `EXISTS` evaluates row-by-row and short-circuits (stops searching) as soon as it finds a single match, making it vastly superior for large datasets.

---

## 5. Interview Tips
*   **The NULL Trap in NOT IN (Again):** As mentioned previously, `NOT IN` completely breaks if the subquery returns any `NULL` values. `NOT EXISTS` is totally immune to this bug. Therefore, always use `NOT EXISTS` instead of `NOT IN` when checking subqueries.
*   **`SELECT 1`:** If an interviewer asks why you wrote `SELECT 1` instead of `SELECT *` in an `EXISTS` clause, explain that it signals to other developers that the actual projected data doesn't matter, only the presence of the row matters.

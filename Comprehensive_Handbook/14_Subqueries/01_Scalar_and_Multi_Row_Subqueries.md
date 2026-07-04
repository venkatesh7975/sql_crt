# Scalar and Multi-Row Subqueries

---

## 1. What is a Subquery?

A **Subquery** (also known as an Inner Query or Nested Query) is a query completely enclosed within another query. 

Subqueries allow you to perform dynamic lookups. Instead of hardcoding a value (like `WHERE price > 100`), you can calculate that value on the fly (like `WHERE price > (SELECT AVG(price) FROM products)`).

---

## 2. Scalar Subqueries (Returns ONE Value)

A **Scalar Subquery** is a query that returns exactly **one single row and one single column** (a single scalar value, like a number or a string).

Because it returns a single value, you can use it anywhere you would normally type a number or a string, usually with standard equality operators (`=`, `>`, `<`).

### Example: Finding products above the average price
```sql
SELECT product_name, price
FROM products
WHERE price > (
    -- This inner query returns exactly one number (e.g., 50.25)
    SELECT AVG(price) FROM products
);
```

### The Trap
If you use an `=` or `>` operator, the database expects a Scalar Subquery. If your subquery accidentally returns *multiple* rows, the entire query will crash with the error: `Subquery returns more than 1 row`.

---

## 3. Multi-Row Subqueries (Returns A List)

If your inner query returns a single column but **multiple rows** (a list of values), it is a Multi-Row Subquery.

You cannot use `=` or `>` with a list. You must use list operators like `IN`, `NOT IN`, `ANY`, or `ALL`.

### Example: Using IN
```sql
-- Find all employees who work in the New York or London offices
SELECT first_name, last_name
FROM employees
WHERE office_id IN (
    -- This returns a list of IDs (e.g., 1, 4)
    SELECT id FROM offices WHERE city IN ('New York', 'London')
);
```

### Example: Using ALL
Find the product that is strictly more expensive than *every* product in the 'Clothing' category.
```sql
SELECT product_name, price
FROM products
WHERE price > ALL (
    SELECT price FROM products WHERE category = 'Clothing'
);
```

---

## 4. Interview Tips
*   **The Single Row Guarantee:** "How do you guarantee a subquery only returns one row so it doesn't crash the outer query?" 
    *   **Answer:** "You can either use an Aggregate Function like `MAX()` or `SUM()` which naturally collapses rows, or you can append `LIMIT 1` to the end of the subquery."
*   **Performance:** In older database systems, deeply nested `IN` subqueries could be very slow. Modern optimizers (like in MySQL 8) usually automatically rewrite them as `JOIN`s behind the scenes, but writing an explicit `JOIN` is often still considered best practice for readability and guaranteed performance.

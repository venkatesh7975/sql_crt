# INTERSECT and EXCEPT

---

## 1. Advanced Set Operations

While `UNION` stacks two result sets together, Set Theory in mathematics defines two other major operations: **Intersection** and **Difference**.

SQL implements these using the `INTERSECT` and `EXCEPT` operators.

*Historical Note for MySQL:* For over two decades, MySQL completely lacked support for `INTERSECT` and `EXCEPT`. Developers had to write complex `JOIN` workarounds. However, **MySQL 8.0.31 officially introduced native support for both!**

---

## 2. INTERSECT (The Overlap)

The `INTERSECT` operator takes two `SELECT` queries and **only returns the rows that appear in BOTH result sets.**

Just like `UNION`, the queries must have the same number of columns and compatible data types.

### Example
Imagine a company has two mailing lists: `newsletter_subscribers` and `premium_members`. We want to find people who are on BOTH lists.

```sql
SELECT email FROM newsletter_subscribers
INTERSECT
SELECT email FROM premium_members;
```

*(Note: `INTERSECT` automatically removes duplicate rows from the final result set).*

### The Pre-MySQL 8.0 Workaround (INNER JOIN)
If you are working on an older legacy MySQL database, you must simulate `INTERSECT` using an `INNER JOIN`.

```sql
-- Legacy simulation of INTERSECT
SELECT DISTINCT n.email 
FROM newsletter_subscribers n
INNER JOIN premium_members p ON n.email = p.email;
```

---

## 3. EXCEPT (The Difference)

The `EXCEPT` operator (known as `MINUS` in Oracle databases) takes two `SELECT` queries and returns the rows from the first query **that DO NOT appear in the second query.**

The order of the queries matters entirely! `A EXCEPT B` is not the same as `B EXCEPT A`.

### Example
We want to find people who are `newsletter_subscribers`, but we want to exclude anyone who is already a `premium_member` (perhaps to send them an upgrade promotion).

```sql
SELECT email FROM newsletter_subscribers
EXCEPT
SELECT email FROM premium_members;
```

### The Pre-MySQL 8.0 Workaround (LEFT JOIN / NOT EXISTS)
If you are on an older database, you must simulate `EXCEPT` using the "Orphaned Record" pattern with a `LEFT JOIN` or `NOT EXISTS`.

```sql
-- Legacy simulation using LEFT JOIN
SELECT n.email 
FROM newsletter_subscribers n
LEFT JOIN premium_members p ON n.email = p.email
WHERE p.email IS NULL;

-- Legacy simulation using NOT EXISTS (Often faster)
SELECT email 
FROM newsletter_subscribers n
WHERE NOT EXISTS (
    SELECT 1 FROM premium_members p WHERE p.email = n.email
);
```

---

## 4. Interview Tips
*   **The Big Three:** In advanced interviews, you are expected to know all three Set Operations:
    *   `UNION`: A + B
    *   `INTERSECT`: Only the overlap of A and B
    *   `EXCEPT`: A minus B
*   **The Legacy Question:** Because MySQL added `INTERSECT` and `EXCEPT` relatively recently, older interviewers might explicitly ask: "How do you simulate an INTERSECT in MySQL?" 
    *   **Answer:** "Modern MySQL 8 supports INTERSECT natively. But on legacy systems, you simulate it with an `INNER JOIN` (or an `IN` subquery). You simulate `EXCEPT` with a `LEFT JOIN ... IS NULL` (or `NOT EXISTS`)." This answer shows deep historical knowledge of the engine.

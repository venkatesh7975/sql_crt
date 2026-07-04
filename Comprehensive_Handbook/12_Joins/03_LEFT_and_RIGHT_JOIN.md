# LEFT and RIGHT JOIN

---

## 1. Outer Joins

While an `INNER JOIN` strictly eliminates any rows that don't match, an **OUTER JOIN** guarantees that all rows from one side of the join will be kept, regardless of whether they find a match on the other side.

The most common of these is the `LEFT JOIN` (technically called `LEFT OUTER JOIN`).

---

## 2. LEFT JOIN

A `LEFT JOIN` returns **ALL** rows from the "Left" table (the table specified first in the `FROM` clause).
If it finds a matching row in the "Right" table, it stitches the data together. 
If it does *not* find a match, it still returns the left row, but it fills the right side's columns with `NULL`.

### Example: Users with or without Orders
We want a list of EVERY user in our system. If they have an order, show the total. If they don't have an order, just leave it blank.

```sql
SELECT 
    u.username,
    o.order_total
FROM 
    users u            -- THIS IS THE LEFT TABLE (All users are kept)
LEFT JOIN 
    orders o           -- THIS IS THE RIGHT TABLE (Optional data)
    ON u.id = o.user_id;
```
**The Result:**
| username | order_total |
| :--- | :--- |
| Alice | 50.00 |
| Bob | 120.00 |
| Charlie | **NULL** | *(Charlie has never bought anything, but he wasn't eliminated!)*

---

## 3. Finding Orphans using LEFT JOIN

A massive superpower of the `LEFT JOIN` is its ability to find "Orphaned" records (or records that lack a relationship).

**Scenario:** We want to find a list of users who have **never** placed an order so we can send them a marketing email.

You cannot do this with an `INNER JOIN`. You must use a `LEFT JOIN` and then filter for the `NULL` values that the `LEFT JOIN` generated!

```sql
SELECT 
    u.username
FROM 
    users u
LEFT JOIN 
    orders o ON u.id = o.user_id
WHERE 
    o.id IS NULL; -- "Where the right side failed to find a match"
```
*(This is often faster than using a `NOT IN` subquery!)*

---

## 4. RIGHT JOIN

A `RIGHT JOIN` is exactly the same as a `LEFT JOIN`, just reversed. It returns ALL rows from the right table, and fills the left side with `NULL` if no match is found.

```sql
SELECT u.username, o.order_total
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;
```

**Industry Secret:** `RIGHT JOIN` is almost never used in professional code. Why? Because human beings read from top to bottom, left to right. It is mentally much easier to put your "Base" table in the `FROM` clause, and `LEFT JOIN` everything onto it. 
Any `RIGHT JOIN` can be rewritten as a `LEFT JOIN` simply by swapping the order of the tables.

---

## 5. FULL OUTER JOIN (The Missing MySQL Feature)

A `FULL OUTER JOIN` guarantees that ALL rows from the Left table AND ALL rows from the Right table are kept. If they match, they are stitched together. If they don't match on either side, the blanks are filled with `NULL`.

**The Catch:** MySQL does NOT support the `FULL OUTER JOIN` syntax! (PostgreSQL and SQL Server do).

**The MySQL Workaround:**
To simulate a Full Outer Join in MySQL, you must write a `LEFT JOIN`, write a `RIGHT JOIN`, and slap a `UNION` between them.

```sql
-- Simulate FULL OUTER JOIN in MySQL
SELECT u.username, o.order_total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id

UNION 

SELECT u.username, o.order_total
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;
```

---

## 6. Interview Tips
*   **The "Find the Missing" Pattern:** If an interview asks "Find all employees who do not belong to a department," you have two options:
    1.  `LEFT JOIN department ON... WHERE department.id IS NULL`
    2.  `WHERE NOT EXISTS (SELECT 1 FROM department...)`
    Both are fantastic answers. The `LEFT JOIN` approach is classic.
*   **Venn Diagram Mastery:** You MUST be able to draw the Venn Diagrams for Inner, Left, Right, and Full joins on a whiteboard. Left Join = Left Circle shaded, including the intersection.

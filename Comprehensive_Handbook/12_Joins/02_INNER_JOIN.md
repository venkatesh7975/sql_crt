# INNER JOIN

---

## 1. The Default Join

The `INNER JOIN` is the most common type of join. If you just type the word `JOIN` in a SQL query, the database automatically assumes you mean `INNER JOIN`.

### The Logic
An `INNER JOIN` acts as a strict filter. It looks at the two tables being joined and **only returns rows where there is a match in BOTH tables.**

If a user exists in the `users` table, but they have never placed an order in the `orders` table, they will be completely eliminated from the result set.

---

## 2. The Syntax

You specify the tables in the `FROM` and `JOIN` clauses, and you specify *how* they are linked in the `ON` clause.

### Example: Users and their Orders
```sql
SELECT 
    u.first_name,
    u.email,
    o.order_date,
    o.order_total
FROM 
    users u
INNER JOIN 
    orders o 
    ON u.id = o.user_id;
```
*(Note: `u.id` is the Primary Key of the users table, and `o.user_id` is the Foreign Key in the orders table. This is the standard way to link tables).*

---

## 3. Joining More Than Two Tables

You are not limited to joining two tables. You can chain as many `INNER JOIN` clauses as you need to traverse the entire database schema!

**Scenario:** We want to know the name of the User, the Date they ordered, and the Name of the Product they bought.
This requires traversing 3 tables: `users` -> `orders` -> `products`.

```sql
SELECT 
    u.first_name,
    o.order_date,
    p.product_name
FROM 
    users u
INNER JOIN 
    orders o ON u.id = o.user_id
INNER JOIN 
    products p ON o.product_id = p.id;
```
**How it executes:** 
1. The database joins `users` to `orders` and creates a massive temporary grid in memory. 
2. It then takes that temporary grid and joins it to `products`. 
3. Finally, it pulls the requested columns.

---

## 4. The USING() Shortcut

If the two columns you are joining on have the **exact same name** in both tables (e.g., both tables have a column literally named `customer_id`), you can use the `USING()` clause as a shortcut instead of the `ON` clause.

### Standard ON
```sql
SELECT * FROM customers c 
JOIN payments p ON c.customer_id = p.customer_id;
```

### USING Shortcut
```sql
SELECT * FROM customers c 
JOIN payments p USING (customer_id);
```
*(While this saves typing, many developers avoid it in enterprise code because if a DBA renames one of the columns later, the query breaks silently).*

---

## 5. Interview Tips
*   **JOIN vs INNER JOIN:** "What is the difference between `JOIN` and `INNER JOIN`?" 
    *   **Answer:** "There is no difference. `INNER` is the default keyword. They execute the exact same way."
*   **Performance:** `INNER JOIN` is generally the fastest type of join because it eliminates non-matching rows early in the execution plan, reducing the amount of data the database has to hold in memory.

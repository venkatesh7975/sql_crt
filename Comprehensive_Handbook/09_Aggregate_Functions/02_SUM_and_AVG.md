# SUM and AVG

---

## 1. Summarizing Numerical Data

While `COUNT` is used to count the physical *number of rows*, `SUM` and `AVG` are used to perform mathematical calculations on the *values* inside numerical columns.

Unlike `COUNT`, which can be applied to any data type (strings, dates, booleans), `SUM` and `AVG` can **only be applied to numerical columns** (e.g., `INT`, `DECIMAL`, `FLOAT`).

---

## 2. The SUM() Function

The `SUM()` function adds up all the values in a specific column and returns the total.

```sql
-- "What is the total revenue of all orders?"
SELECT SUM(order_total) 
FROM orders;
```

### SUM with Filters
```sql
-- "What is the total revenue for January 2023?"
SELECT SUM(order_total) 
FROM orders 
WHERE order_date >= '2023-01-01' AND order_date < '2023-02-01';
```

---

## 3. The AVG() Function

The `AVG()` function calculates the mathematical average (mean) of all the values in a specific column.

```sql
-- "What is the average order value (AOV) on our platform?"
SELECT AVG(order_total) 
FROM orders;
```

---

## 4. Handling Decimals (Formatting Aggregates)

When you run an `AVG()` function on integers, the database will often return a highly precise decimal (e.g., `33.3333333333`). 
It is standard practice to wrap your aggregate function in a `ROUND()` function to make the output readable for the application.

```sql
-- Round the average to 2 decimal places
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM orders;
```

---

## 5. The Boolean SUM Trick (Advanced)

In MySQL, boolean values (True/False) are internally represented as `1` and `0`. 
This allows for an incredibly powerful trick: **You can SUM a condition to count how many times it is true.**

Imagine a `users` table. We want to know the total number of users, AND the number of users who are admins.

**The Clunky Way (Two Queries):**
```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE role = 'admin';
```

**The Pro Way (One Query using Boolean SUM):**
```sql
SELECT 
    COUNT(*) AS total_users,
    SUM(role = 'admin') AS total_admins
FROM users;
```
*How this works:* `role = 'admin'` evaluates to `1` if True, and `0` if False. The `SUM()` function just adds up all the `1`s!

---

## 6. Interview Tips
*   **The Boolean SUM:** The trick mentioned above (summing a boolean condition or a `CASE WHEN 1 ELSE 0` statement) is one of the most frequently required techniques in LeetCode Hard SQL problems. Mastering it is mandatory for passing advanced SQL rounds.

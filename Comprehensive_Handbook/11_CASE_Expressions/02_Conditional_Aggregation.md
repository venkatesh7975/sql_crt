# Conditional Aggregation

---

## 1. Combining CASE with Aggregate Functions

In standard reporting, `GROUP BY` is used to aggregate data vertically (row by row).
But what if you want to apply different aggregate logic to different sets of data *without* splitting them into different rows?

Enter **Conditional Aggregation**. This is the technique of wrapping a `CASE` statement *inside* an Aggregate Function (`SUM`, `COUNT`, `AVG`).

---

## 2. Counting Specific Conditions

Imagine a `users` table. You want to know the total number of users, the number of active users, and the number of banned users, all in a single row.

If you use `GROUP BY status`, you get three different rows. 
To keep it in one row, we use Conditional Aggregation.

```sql
SELECT 
    COUNT(*) AS total_users,
    
    -- Count Active Users
    SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_users,
    
    -- Count Banned Users
    SUM(CASE WHEN status = 'banned' THEN 1 ELSE 0 END) AS banned_users
    
FROM users;
```

### How does this work?
1.  The `CASE` statement evaluates every row. If the user is active, it spits out a `1`. If not, it spits out a `0`.
2.  The `SUM()` function takes all those `1`s and `0`s and adds them up. The result is effectively a count of active users!

*(Note: In MySQL, you can use the boolean shortcut `SUM(status = 'active')`, but the `SUM(CASE...)` syntax is the industry standard and works on all databases).*

---

## 3. Summing Specific Conditions

You can do the exact same thing with actual numerical values, not just 1s and 0s.

Imagine an `orders` table. We want the total revenue, but we also want to see how much of that revenue came from credit cards vs PayPal.

```sql
SELECT 
    SUM(order_total) AS total_revenue,
    
    -- Sum only Credit Card revenue
    SUM(CASE WHEN payment_method = 'Credit Card' THEN order_total ELSE 0 END) AS cc_revenue,
    
    -- Sum only PayPal revenue
    SUM(CASE WHEN payment_method = 'PayPal' THEN order_total ELSE 0 END) AS paypal_revenue
    
FROM orders;
```

---

## 4. Conditional AVG() - The NULL Trick

Using `AVG()` with Conditional Aggregation requires a specific trick.

Remember the Golden Rule of Aggregates: **Aggregates ignore NULLs.**
If you use `ELSE 0` inside an `AVG`, the database will include that `0` in the average calculation, dragging your average down incorrectly.

To correctly average a subset of data, you must use `ELSE NULL` (or omit the `ELSE` clause entirely, which defaults to `NULL`).

```sql
-- "What is the average order value, but only for VIP customers?"
SELECT 
    -- CORRECT: Non-VIPs are turned into NULLs and safely ignored by the AVG function.
    AVG(CASE WHEN is_vip = TRUE THEN order_total ELSE NULL END) AS vip_avg,
    
    -- INCORRECT: Non-VIPs are turned into 0s, massively dragging down the average!
    AVG(CASE WHEN is_vip = TRUE THEN order_total ELSE 0 END) AS bad_vip_avg
FROM orders;
```

---

## 5. Interview Tips
*   **The "One Query" Requirement:** Interviewers will frequently present a scenario and say, "Return these 5 different metrics, *but you are only allowed to query the table once*." The answer is always Conditional Aggregation.
*   **COUNT vs SUM for Conditions:** You can use `COUNT(CASE WHEN status = 'active' THEN id ELSE NULL END)`, but `SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END)` is much more common and arguably easier to read. Both achieve the exact same result.

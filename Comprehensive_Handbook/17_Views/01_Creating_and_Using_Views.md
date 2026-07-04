# Creating and Using Views

---

## 1. The Need for Virtual Tables

As your database grows and your reporting requirements become more complex, you will find yourself writing the exact same 50-line `JOIN` query every single day. 

*   "The marketing team needs the Active Users Report again."
*   "The finance team needs the Monthly Revenue Summary again."

Copying and pasting complex SQL scripts is error-prone. What if you make a mistake? What if the underlying table structure changes?

To solve this, SQL provides **Views**. 
A View is a "Virtual Table". It is essentially a saved SQL query that you can treat exactly like a real table.

---

## 2. Creating a View

To create a view, you simply write your complex `SELECT` statement and put `CREATE VIEW view_name AS` at the top of it.

```sql
CREATE VIEW active_users_summary AS
SELECT 
    u.id,
    u.username,
    u.email,
    COUNT(o.id) AS total_orders,
    SUM(o.amount) AS lifetime_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.status = 'active'
GROUP BY u.id, u.username, u.email;
```

---

## 3. Querying a View

Once the View is created, the database engine stores the *query definition*, not the actual data. 
You can now query `active_users_summary` exactly as if it were a physical table.

```sql
-- Find our top 10 most valuable active users
SELECT username, lifetime_value 
FROM active_users_summary 
ORDER BY lifetime_value DESC 
LIMIT 10;
```

### How it works:
When you run the query above, the database behind the scenes takes your `SELECT` and merges it with the `SELECT` saved inside the View. It executes the combined query against the live, underlying tables in real-time. 
**Views always show up-to-date data.**

---

## 4. Why use Views?

1.  **Simplicity:** They hide massive, complex joins and aggregations behind a simple, single-table interface for end-users or reporting tools (like Tableau).
2.  **Consistency:** If the business logic for "Active User" changes, you update the View once, and every report that relies on that View is instantly updated.
3.  **Security:** You can grant a junior analyst `SELECT` permission on the `active_users_summary` View, while completely denying them access to the raw `users` table (which might contain passwords or PII).

---

## 5. Dropping and Altering Views

To delete a view:
```sql
DROP VIEW active_users_summary;
```

To update an existing view (without dropping it first), you can use the `CREATE OR REPLACE` syntax:
```sql
CREATE OR REPLACE VIEW active_users_summary AS
SELECT ... -- your new updated query here
```

---

## 6. Interview Tips
*   **Physical vs Virtual:** "Does a View store data on the hard drive?"
    *   **Answer:** "No, a standard View is a virtual table. It only stores the SQL query definition. When you query the View, it dynamically pulls data from the underlying physical tables."
    *   *(Advanced Note: Some databases like PostgreSQL and Oracle support "Materialized Views" which DO physically store the data for faster reading, but MySQL does not natively support Materialized Views).*
*   **Updatable Views:** "Can you run an `UPDATE` or `INSERT` statement on a View?"
    *   **Answer:** "Usually, no. If a View contains an aggregate function (`SUM`, `GROUP BY`), a `DISTINCT`, or a `UNION`, it is strictly Read-Only. You can only update simple Views that perfectly map 1-to-1 with a single underlying table."

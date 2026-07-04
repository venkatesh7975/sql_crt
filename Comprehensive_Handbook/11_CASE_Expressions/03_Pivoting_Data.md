# Pivoting Data (Rows to Columns)

---

## 1. What is Pivoting?

In data analysis, **Pivoting** is the process of transforming data from a "long" format (many rows) into a "wide" format (many columns). 
It is exactly what the "Pivot Table" feature does in Microsoft Excel.

While some databases (like SQL Server) have a dedicated `PIVOT` keyword, standard SQL (including MySQL and PostgreSQL) achieves this using **Conditional Aggregation** combined with a **GROUP BY**.

This is one of the most highly tested concepts in advanced SQL interviews.

---

## 2. The Setup: The "Long" Data

Imagine a `sales` table tracking the monthly revenue of different stores.

| store_id | month | revenue |
| :--- | :--- | :--- |
| 1 | Jan | 1000 |
| 1 | Feb | 1200 |
| 2 | Jan | 800 |
| 2 | Feb | 900 |

This is "long" data. It is great for databases, but terrible for human reporting. 
The boss wants a report that looks like this:

| store_id | Jan_Revenue | Feb_Revenue |
| :--- | :--- | :--- |
| 1 | 1000 | 1200 |
| 2 | 800 | 900 |

We need to **Pivot** the `month` values into their own distinct columns.

---

## 3. The Pivot Query

To achieve this, we group by the `store_id`, and then we use Conditional Aggregation (`SUM` + `CASE`) to create the new columns.

```sql
SELECT 
    store_id,
    
    -- Create the January Column
    SUM(CASE WHEN month = 'Jan' THEN revenue ELSE 0 END) AS Jan_Revenue,
    
    -- Create the February Column
    SUM(CASE WHEN month = 'Feb' THEN revenue ELSE 0 END) AS Feb_Revenue,
    
    -- Create the March Column
    SUM(CASE WHEN month = 'Mar' THEN revenue ELSE 0 END) AS Mar_Revenue
    
FROM sales
GROUP BY store_id;
```

### How it works:
1.  The `GROUP BY store_id` guarantees that the final output will have exactly one row per store (Store 1, Store 2).
2.  For Store 1's row, the database looks at all of Store 1's raw data. 
3.  The `Jan_Revenue` column logic says: "If the row's month is Jan, sum the revenue. If it's anything else, sum 0."
4.  This isolates January's revenue into the first column, February's into the second, and so on.

---

## 4. The Limitation: Dynamic Pivoting

There is a major limitation to doing this in raw SQL: **You must hardcode the columns.**

If you are pivoting by Month, you know there are exactly 12 months, so you can easily type out 12 `SUM(CASE...)` statements. 

But what if you are pivoting by User ID? You can't write 10,000 `SUM(CASE...)` statements. 
SQL requires the structure of the output table (the columns) to be known *before* the query executes. It cannot dynamically generate columns based on the data it finds.

To perform a **Dynamic Pivot**, you have to use complex "Prepared Statements" (Dynamic SQL) to construct the query string on the fly, or (much more commonly) you just output the "long" data and let a Business Intelligence tool (like Tableau, PowerBI) or a Python Pandas script handle the pivoting visually.

---

## 5. Interview Tips
*   **The Classic Question:** You will almost certainly be given a dataset with `Department`, `Job_Title`, and `Salary`, and asked to return a table where each row is a Department, and there is a column for "Manager_Salary", "Developer_Salary", and "Analyst_Salary".
    *   **The Blueprint:** `SELECT Department, SUM(CASE WHEN Job_Title = 'Manager' THEN Salary ELSE 0 END) AS Manager_Salary... GROUP BY Department;` Memorize this pattern!

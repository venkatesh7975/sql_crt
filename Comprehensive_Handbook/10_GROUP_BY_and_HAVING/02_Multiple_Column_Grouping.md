# Multiple Column Grouping

---

## 1. Grouping by More Than One Column

You are not restricted to grouping by a single column. You can group by two, three, or as many columns as you need to create highly specific "buckets" of data.

When you `GROUP BY column_a, column_b`, the database creates a separate bucket for every unique **combination** of those two columns.

---

## 2. Example: Sales Reporting

Imagine a `sales` table with the following columns: `store_location`, `product_category`, and `revenue`.

If we group by one column:
```sql
SELECT store_location, SUM(revenue) 
FROM sales 
GROUP BY store_location;
```
*Result:* We get 3 rows. One total for 'New York', one for 'London', one for 'Tokyo'.

If we group by **two** columns:
```sql
SELECT store_location, product_category, SUM(revenue) 
FROM sales 
GROUP BY store_location, product_category;
```
*Result:* We get a much deeper breakdown.
*   New York - Electronics - $50,000
*   New York - Clothing - $30,000
*   London - Electronics - $45,000
*   London - Clothing - $25,000
...and so on.

---

## 3. Order Matters (Visually, Not Logically)

Does the order of columns in the `GROUP BY` clause matter?
`GROUP BY store_location, product_category` vs `GROUP BY product_category, store_location`

**Logically:** No. The database will calculate the exact same buckets and the exact same sums regardless of the order.
**Visually:** The output order might change depending on how the database engine chooses to sort the results behind the scenes. 

*Best Practice:* Always add an explicit `ORDER BY` clause to guarantee the visual output, matching the order of your `GROUP BY`.

```sql
SELECT store_location, product_category, SUM(revenue) 
FROM sales 
GROUP BY store_location, product_category
ORDER BY store_location ASC, product_category ASC;
```

---

## 4. Grouping by Dates (Functions in GROUP BY)

One of the most powerful uses of multiple-column grouping is generating time-series reports (e.g., Monthly Sales).

You can use functions directly inside the `GROUP BY` clause!

```sql
-- Show me total sales per year, and then broken down by month within that year
SELECT 
    YEAR(order_date) AS order_year, 
    MONTH(order_date) AS order_month, 
    SUM(order_total) AS monthly_revenue
FROM orders
GROUP BY 
    YEAR(order_date), 
    MONTH(order_date)
ORDER BY 
    order_year DESC, 
    order_month DESC;
```

---

## 5. Interview Tips
*   **The Pivot Table Equivalent:** Grouping by multiple columns is exactly how you recreate Excel Pivot Tables in SQL. 
*   **Granularity:** Interviewers often use the word "granularity". Grouping by one column is low granularity (high-level summary). Grouping by three columns provides high granularity (very detailed breakdown).

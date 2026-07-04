# Value Functions (LAG and LEAD)

---

## 1. Time Travel in SQL

In a standard SQL query, a row is completely blind. It only knows about the data contained within itself.

But what if you need to compare today's revenue to yesterday's revenue? To do that, the current row needs to somehow "look up" at the previous row.

Before Window Functions, this required complex self-joins on dates. Now, we use **Value Functions**: `LAG()` and `LEAD()`.

---

## 2. The LAG() Function (Looking Backwards)

The `LAG()` function reaches back a specified number of rows and grabs a value.
Because it relies on sequence, it **requires** an `ORDER BY` inside the `OVER()` clause.

### Syntax
`LAG(column_to_grab, offset, default_value)`
*   `offset`: How many rows to look back. Default is 1.
*   `default_value`: What to return if it looks back too far (e.g., looking at row -1). Default is `NULL`.

### Example: Month-over-Month Revenue Growth
```sql
SELECT 
    sales_month,
    revenue,
    
    -- Grab the revenue from the previous row
    LAG(revenue, 1) OVER(ORDER BY sales_month ASC) AS previous_month_revenue,
    
    -- Calculate the difference
    revenue - LAG(revenue, 1) OVER(ORDER BY sales_month ASC) AS revenue_growth
    
FROM monthly_sales;
```

**The Output:**
| sales_month | revenue | previous_month_revenue | revenue_growth |
| :--- | :--- | :--- | :--- |
| Jan | 1000 | **NULL** *(No previous row!)* | NULL |
| Feb | 1200 | 1000 | +200 |
| Mar | 900 | 1200 | -300 |

---

## 3. The LEAD() Function (Looking Forwards)

`LEAD()` is the exact opposite of `LAG()`. It reaches forward a specified number of rows.

### Example: Analyzing Website Sessions
Imagine a log of user clicks. We want to know how long a user spent on a specific page. The easiest way is to subtract the time they clicked the *current* page from the time they clicked the *next* page.

```sql
SELECT 
    user_id,
    page_url,
    click_time,
    
    -- Grab the click_time of their NEXT click.
    -- We partition by user_id so we don't accidentally grab a different user's click time!
    LEAD(click_time, 1) OVER(
        PARTITION BY user_id 
        ORDER BY click_time ASC
    ) AS next_click_time
    
FROM page_clicks;
```

---

## 4. FIRST_VALUE() and LAST_VALUE()

While `LAG` and `LEAD` look at adjacent rows, `FIRST_VALUE()` and `LAST_VALUE()` grab the absolute first or last row within the window partition.

```sql
-- Compare every employee's salary to the absolute highest salary in their department
SELECT 
    first_name, 
    department,
    salary,
    FIRST_VALUE(salary) OVER(
        PARTITION BY department 
        ORDER BY salary DESC
    ) AS highest_dept_salary
FROM employees;
```

---

## 5. Interview Tips
*   **The Year-Over-Year Question:** "Write a query to calculate the Year-Over-Year (YoY) revenue growth percentage."
    *   **Answer:** You must use `LAG(revenue) OVER(ORDER BY year)`. The formula for percentage growth is `((Current - Previous) / Previous) * 100`.
*   **The Default Fallback:** If an interviewer asks how to avoid a `NULL` in the first row of a `LAG` function, explain that `LAG()` accepts a third argument: the default fallback value. `LAG(revenue, 1, 0)` will return `0` instead of `NULL` for January.

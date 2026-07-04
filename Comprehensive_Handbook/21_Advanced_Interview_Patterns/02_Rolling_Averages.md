# Rolling Averages and Cumulative Sums

---

## 1. Expanding the Window Frame

We learned how to use `OVER(PARTITION BY... ORDER BY...)` to calculate ranks and lags.
However, Window Functions have a third, hidden superpower: **The Window Frame Clause (`ROWS BETWEEN`)**.

This allows you to specify exactly *which* rows surrounding the current row should be included in the aggregate calculation.

---

## 2. Cumulative Sum (Running Total)

A Cumulative Sum calculates the total revenue from the beginning of time up to the current row.

To do this, we tell the window frame to calculate the sum from `UNBOUNDED PRECEDING` (the very first row) to the `CURRENT ROW`.

```sql
SELECT 
    sales_date,
    daily_revenue,
    SUM(daily_revenue) OVER(
        ORDER BY sales_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM daily_sales;
```
*(Note: If you use an `ORDER BY` inside an `OVER()` clause without explicitly writing the `ROWS BETWEEN` clause, MySQL defaults to `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. So you can usually just write `SUM(rev) OVER(ORDER BY date)` to get a running total!)*

---

## 3. The N-Day Rolling Average

A Rolling Average calculates the average of the current row and the preceding `N-1` rows (e.g., a 7-day rolling average). This smooths out volatility in charts.

To calculate a 7-Day Rolling Average, we tell the window frame to calculate the average of the current row and the 6 rows before it.

```sql
SELECT 
    sales_date,
    daily_revenue,
    AVG(daily_revenue) OVER(
        ORDER BY sales_date ASC
        -- Look at the 6 previous rows + the current row = 7 days
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS 7_day_rolling_avg
FROM daily_sales;
```

---

## 4. Centered Moving Average

Sometimes, statisticians prefer a centered average (e.g., the average of the current day, the 3 days before it, and the 3 days after it).

```sql
SELECT 
    sales_date,
    daily_revenue,
    AVG(daily_revenue) OVER(
        ORDER BY sales_date ASC
        -- 3 before, current, and 3 after = 7 days centered
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    ) AS 7_day_centered_avg
FROM daily_sales;
```

---

## 5. Interview Tips
*   **The Keyword:** If an interviewer asks you to calculate a "Running Total", "Cumulative Sum", or "Rolling Average", they are explicitly testing your knowledge of the `ROWS BETWEEN` syntax. 
*   **Handling Missing Dates:** A major trap in the Rolling Average question! What if the `daily_sales` table is missing a row for Tuesday because the store was closed?
    *   If you use `ROWS BETWEEN 6 PRECEDING...`, it literally counts back 6 physical rows, which would grab last Monday's data, making it an 8-day time span!
    *   **The Fix:** You must use `RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW` (if supported by the dialect), or you must first join your data to a continuous calendar table so that Tuesday exists with a revenue of `0` or `NULL` before you run the Window Function. Mentioning this edge case will heavily impress an interviewer.

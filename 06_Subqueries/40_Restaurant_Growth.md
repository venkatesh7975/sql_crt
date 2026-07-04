# Problem 40 – Restaurant Growth

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Self JOIN with Date Ranges
* Window Functions (`SUM(...) OVER(...)`) [Alternative]
* GROUP BY and Aggregation
* DATE_SUB() / DATEDIFF()

---

## 3. Pattern
Moving Average / Rolling Window

---

## 4. Problem Statement
You are the restaurant owner and you want to analyze a possible expansion. 
Compute the **moving average** of how much the customer paid in a **7 days window** (i.e., current day + 6 days before). 
`average_amount` should be rounded to 2 decimal places.
Return result table ordered by `visited_on` in ascending order.

---

## 5. Tables

Table: Customer

| Column      | Type    |
| ----------- | ------- |
| customer_id | INT     |
| name        | VARCHAR |
| visited_on  | DATE    |
| amount      | INT     |

* `(customer_id, visited_on)` is the primary key.
* This table contains data about customer transactions in a restaurant.

---

## 6. Sample Input

Customer table:

| customer_id | name         | visited_on | amount |
| ----------- | ------------ | ---------- | ------ |
| 1           | Jhon         | 2019-01-01 | 100    |
| 2           | Daniel       | 2019-01-02 | 110    |
| 3           | Jade         | 2019-01-03 | 120    |
| 4           | Khaled       | 2019-01-04 | 130    |
| 5           | Winston      | 2019-01-05 | 110    | 
| 6           | Elvis        | 2019-01-06 | 140    | 
| 7           | Anna         | 2019-01-07 | 150    |
| 8           | Maria        | 2019-01-08 | 80     |
| 9           | Jaze         | 2019-01-09 | 110    | 
| 1           | Jhon         | 2019-01-10 | 130    | 
| 3           | Jade         | 2019-01-10 | 150    | 

---

## 7. Expected Output

| visited_on | amount | average_amount |
| ---------- | ------ | -------------- |
| 2019-01-07 | 860    | 122.86         |
| 2019-01-08 | 840    | 120.00         |
| 2019-01-09 | 840    | 120.00         |
| 2019-01-10 | 1000   | 142.86         |

*(Notice that the output starts on Jan 07, which is exactly the 7th day of recorded data. The 7-day window for Jan 07 is Jan 01 through Jan 07. The total is 860. The average is 860/7 = 122.86).*

---

## 8. Understanding the Question
What information is being asked? For every valid date, the total amount made over the preceding 7-day window, and the daily average of that window.
What conditions matter? 
1. We only calculate for days that *have* 6 preceding days of data.
2. A single day might have multiple customers (e.g., Jan 10th has two customers). We must sum them up per day first!
3. Round the average to 2 decimal places.
What should be returned? `visited_on`, `amount` (the 7-day sum), `average_amount`.

---

## 9. Thinking Process
1. First, multiple customers can visit on the same day. I should create a clean "Daily Totals" view so I am only working with one row per day.
   * `SELECT visited_on, SUM(amount) AS daily_amount FROM Customer GROUP BY visited_on`
2. Now, for every day in that clean list, I need to look back 6 days and sum those daily totals.
3. This is the perfect use case for a Self-Join.
   * Join `DayList t1` against `DayList t2` where `t2.visited_on` is between `t1.visited_on - 6 days` and `t1.visited_on`.
4. Group by `t1.visited_on`. Now, for each day, I have a bucket of up to 7 previous days' data.
5. Filter out the incomplete windows (the first 6 days of the restaurant opening) using `HAVING COUNT(t2.visited_on) = 7`.
6. Calculate the total sum of the window, and calculate the average by dividing that sum by 7.

---

## 10. Approach 1 (Optimal)
CTE / Subquery with Self-Join

Pre-aggregate the data into daily totals, then self-join the daily totals based on a 7-day trailing date range, ensuring we only keep full 7-day buckets.

---

## 11. SQL Solution

```sql
-- Step 1: Pre-aggregate transactions into daily totals
WITH DailyTotals AS (
    SELECT 
        visited_on, 
        SUM(amount) AS daily_amount
    FROM 
        Customer
    GROUP BY 
        visited_on
)

-- Step 2: Self-join to create 7-day rolling windows
SELECT 
    d1.visited_on, 
    SUM(d2.daily_amount) AS amount, 
    ROUND(SUM(d2.daily_amount) / 7.0, 2) AS average_amount
FROM 
    DailyTotals d1
JOIN 
    DailyTotals d2 
    ON d2.visited_on BETWEEN DATE_SUB(d1.visited_on, INTERVAL 6 DAY) AND d1.visited_on
GROUP BY 
    d1.visited_on
HAVING 
    COUNT(d2.visited_on) = 7
ORDER BY 
    d1.visited_on;
```

---

## 12. Step-by-Step Dry Run
1. **CTE `DailyTotals`:**
   * Jan 1: 100
   * ...
   * Jan 7: 150
   * Jan 10: 280 (130 + 150)
2. **Self Join & Grouping:**
   * Take Jan 7 (d1). Match it with any d2 date between Jan 1 and Jan 7.
   * Match found: Jan 1, 2, 3, 4, 5, 6, 7.
   * Total matched rows: 7.
   * Take Jan 2 (d1). Match it with any d2 date between Dec 27 and Jan 2.
   * Match found: Jan 1, Jan 2. 
   * Total matched rows: 2.
3. **HAVING COUNT = 7:**
   * Jan 7 bucket passes (7 days of history).
   * Jan 2 bucket fails (only 2 days of history, it's dropped!).
4. **Calculations for Jan 7:**
   * `amount` = Sum of the 7 days = 860.
   * `average_amount` = 860 / 7 = 122.857... -> 122.86.

---

## 13. SQL Execution Order
1. **CTE:** Condenses the table to strictly 1 row per date.
2. **FROM/JOIN:** Creates massive combinations of dates, immediately filtering for the trailing 6-day window.
3. **GROUP BY:** Buckets the matched history against the target date.
4. **HAVING:** Throws out the first 6 days of the calendar that don't have enough history.
5. **SELECT:** Does the math.
6. **ORDER BY:** Sorts chronologically.

---

## 14. Query Breakdown
* **DATE_SUB(date, INTERVAL 6 DAY):** Because we want a 7-day window *inclusive* of the current day, we subtract 6 days. (e.g. Day 7 - 6 = Day 1. Days 1,2,3,4,5,6,7 equals 7 total days).
* **/ 7.0:** Again, enforcing float division to prevent accidental integer truncation.

---

## 15. Why This Solution Works
By using a CTE to flatten the customer data first, the Self-Join becomes incredibly easy to write and mathematically stable. If we tried to self-join the raw `Customer` table directly, the groupings would multiply wildly and destroy the math.

---

## 16. Alternative Solution
Using Window Functions (`ROWS BETWEEN`)

```sql
WITH DailyTotals AS (
    SELECT visited_on, SUM(amount) AS amount
    FROM Customer GROUP BY visited_on
),
MovingAverages AS (
    SELECT 
        visited_on,
        SUM(amount) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        COUNT(visited_on) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS valid_days
    FROM DailyTotals
)
SELECT visited_on, amount, ROUND(amount / 7.0, 2) AS average_amount
FROM MovingAverages
WHERE valid_days = 7
ORDER BY visited_on;
```
* **Advantages:** This is the most modern, professional way to calculate moving averages. `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` explicitly defines a sliding analytical window.
* **Disadvantages:** Some older databases don't support the full range of Window Function windowing clauses.

---

## 17. Time Complexity
**O(N^2)** for the Self Join where N is the number of *unique days*. Because N is just the number of days (max 365 in a year), this is extremely fast. The Window Function approach is **O(N log N)**.

---

## 18. Common Mistakes
* **Using `INTERVAL 7 DAY`:** This will create an 8-day window! (Current day + 7 preceding days). 
* **Not Pre-Aggregating:** If you try to join `Customer c1` to `Customer c2` directly, the Jan 10th row (which has 2 customers) will duplicate the entire 7-day history for BOTH customers, ruining your sums. Always flatten to a Daily view first.

---

## 19. Edge Cases
* **Missing Dates:** If the restaurant is closed on Jan 5th, there is no row for Jan 5th. The `HAVING COUNT = 7` logic brilliantly handles this by throwing out Jan 6 through Jan 11 entirely because they cannot form a complete 7-consecutive-day history.

---

## 20. Interview Tips
* Moving averages (7-day, 30-day) are a staple of financial and product data engineering. 
* Knowing the Window Function syntax (`ROWS BETWEEN X PRECEDING AND CURRENT ROW`) is an instant hire signal for advanced analytical roles.

---

## 21. Similar LeetCode Problems
* 1193. Monthly Transactions I
* 1454. Active Users

---

## 22. Key Takeaways
* Before performing date-math on transactional tables, flatten them using a CTE into Daily Totals.
* Use `BETWEEN DATE_SUB(..., INTERVAL X DAY)` to define trailing periods.
* Use `HAVING COUNT(...) = Target` to ensure periods are complete.

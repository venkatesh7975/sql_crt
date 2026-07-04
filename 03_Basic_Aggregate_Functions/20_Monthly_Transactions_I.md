# Problem 20 – Monthly Transactions I

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY (Multiple columns)
* Aggregate Functions (`COUNT`, `SUM`)
* Conditional Aggregation (`SUM(IF...)`)
* Date Formatting (`DATE_FORMAT`)

---

## 3. Pattern
Date Grouping / Conditional Aggregation

---

## 4. Problem Statement
We need to find the number of transactions, total amount, approved number of transactions, and total approved amount for **each month** and **country**.

---

## 5. Tables

Table: Transactions

| Column     | Type    |
| ---------- | ------- |
| id         | INT     |
| country    | VARCHAR |
| state      | ENUM    |
| amount     | INT     |
| trans_date | DATE    |

* `id` is the primary key.
* `state` is an ENUM of type ('approved', 'declined').
* Contains information about incoming transactions.

---

## 6. Sample Input

Transactions table:

| id  | country | state    | amount | trans_date |
| --- | ------- | -------- | ------ | ---------- |
| 121 | US      | approved | 1000   | 2018-12-18 |
| 122 | US      | declined | 2000   | 2018-12-19 |
| 123 | US      | approved | 2000   | 2019-01-01 |
| 124 | DE      | approved | 2000   | 2019-01-07 |

---

## 7. Expected Output

| month   | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
| ------- | ------- | ----------- | -------------- | ------------------ | --------------------- |
| 2018-12 | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01 | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01 | DE      | 1           | 1              | 2000               | 2000                  |

---

## 8. Understanding the Question
What information is being asked? Several counts and sums broken down by month and country.
What columns are important? `country`, `state`, `amount`, `trans_date`.
What conditions matter? We must extract the YYYY-MM format from the full date. We must conditionally count and sum based on whether the state is 'approved'.
What should be returned? `month`, `country`, `trans_count`, `approved_count`, `trans_total_amount`, `approved_total_amount`.

---

## 9. Thinking Process
1. **Grouping:** The prompt says "for each month and country". This means I must `GROUP BY month, country`.
2. **Formatting the Month:** The `trans_date` is a full date (`2018-12-18`), but the output requires just `YYYY-MM`. In MySQL, the `DATE_FORMAT(date, format_string)` function handles this perfectly: `DATE_FORMAT(trans_date, '%Y-%m')`.
3. **Metric 1 (Total Count):** This is just the number of rows in the bucket. -> `COUNT(id)`.
4. **Metric 2 (Total Amount):** This is the sum of the amounts in the bucket. -> `SUM(amount)`.
5. **Metric 3 (Approved Count):** This is a conditional count. We only want to count it if `state = 'approved'`. Using our IF trick: `SUM(IF(state = 'approved', 1, 0))`.
6. **Metric 4 (Approved Amount):** This is a conditional sum. We only want to add the amount if it's approved. `SUM(IF(state = 'approved', amount, 0))`.
7. Put it all together in the `SELECT` clause, apply the `GROUP BY`, and it's done.

---

## 10. Approach 1 (Optimal)
DATE_FORMAT and Conditional Aggregation

We transform the date into a month string, group by both month and country, and use `SUM()` with `IF()` to selectively calculate the approved metrics.

---

## 11. SQL Solution

```sql
-- Aggregate transaction metrics per month and country
SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month, 
    country, 
    COUNT(id) AS trans_count, 
    SUM(IF(state = 'approved', 1, 0)) AS approved_count, 
    SUM(amount) AS trans_total_amount, 
    SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
FROM 
    Transactions
GROUP BY 
    month, 
    country;
```

---

## 12. Step-by-Step Dry Run
1. **Extract Month:**
   * Row 1: '2018-12', US, approved, 1000
   * Row 2: '2018-12', US, declined, 2000
   * Row 3: '2019-01', US, approved, 2000
   * Row 4: '2019-01', DE, approved, 2000
2. **GROUP BY month, country:**
   * Bucket 1 ('2018-12', US): Rows 1, 2
   * Bucket 2 ('2019-01', US): Row 3
   * Bucket 3 ('2019-01', DE): Row 4
3. **Aggregations for Bucket 1 ('2018-12', US):**
   * `COUNT(id)`: 2 items -> **2**
   * `approved_count`: `SUM(1, 0)` -> **1**
   * `trans_total_amount`: `SUM(1000, 2000)` -> **3000**
   * `approved_total_amount`: `SUM(1000, 0)` -> **1000**

---

## 13. SQL Execution Order
1. **FROM Transactions:** Load the table.
2. **GROUP BY month, country:** Create the groupings. Note that MySQL allows using `SELECT` aliases (like `month`) in the `GROUP BY` clause. 
3. **SELECT:** Perform all the mathematical counting and summing for each group.

---

## 14. Query Breakdown
* **DATE_FORMAT(date, '%Y-%m'):** MySQL specific function. `%Y` is a 4-digit year. `%m` is a 2-digit month. It returns a string.
* **SUM(IF(state = 'approved', amount, 0)):** The core of conditional summing. If the transaction is approved, add the real amount to the running total. If it's declined, add 0 (which does nothing).
* **GROUP BY month, country:** You must group by *both* to create unique buckets for every country in every specific month.

---

## 15. Why This Solution Works
It efficiently combines data transformation (`DATE_FORMAT`) with advanced aggregation techniques (`SUM(IF...)`). It requires only a single pass over the data.

---

## 16. Alternative Solution
Using `SUBSTRING` or `LEFT` instead of `DATE_FORMAT`

```sql
SELECT 
    LEFT(trans_date, 7) AS month, 
...
```
* **Advantages:** Because dates in SQL are often stored or implicitly cast to strings in the format `YYYY-MM-DD`, grabbing the first 7 characters `LEFT(col, 7)` works perfectly and is extremely fast.
* **Disadvantages:** `DATE_FORMAT` is more semantic and self-documenting. 

---

## 17. Time Complexity
**O(N)** where N is the number of rows. Generating the string month and hashing it for the `GROUP BY` requires scanning the entire table once.

---

## 18. Common Mistakes
* **Grouping only by month:** If you `GROUP BY month`, all US and DE transactions for Jan 2019 will merge into a single row, which is wrong.
* **Using `COUNT` instead of `SUM` for approved_count:** `COUNT(IF(state='approved', 1, 0))` will just count the number of rows (because `COUNT` counts 0s!). You must use `SUM` when conditionally returning 1s and 0s.
* **Wrong Date Format:** Using `%y` (lowercase y) yields a 2-digit year (e.g., '18-12'), failing the expected '2018-12' output.

---

## 19. Edge Cases
* **All declined in a month:** `approved_count` and `approved_total_amount` gracefully evaluate to `0`.
* **Country is NULL:** If a country is missing, it will group all NULL countries together.

---

## 20. Interview Tips
* Knowing how to truncate dates to months or years is a daily task for Data Analysts and Backend Engineers. `DATE_FORMAT` is your best friend.
* Once again, Conditional Aggregation (`SUM(IF...)`) proves to be the most critical intermediate SQL skill to master.

---

## 21. Similar LeetCode Problems
* 1173. Immediate Food Delivery I
* 1211. Queries Quality and Percentage

---

## 22. Key Takeaways
* Use `DATE_FORMAT(date, '%Y-%m')` to extract the Month and Year.
* You can `GROUP BY` multiple columns by separating them with commas.
* Use `SUM(IF(condition, value, 0))` to conditionally sum data.

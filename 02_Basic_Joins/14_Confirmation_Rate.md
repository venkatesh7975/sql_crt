# Problem 14 – Confirmation Rate

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* LEFT JOIN
* GROUP BY
* ROUND(), IFNULL()
* Conditional Aggregation (`AVG(IF...)`)

---

## 3. Pattern
Join / Conditional Aggregation / Edge Case Handling (Zeros)

---

## 4. Problem Statement
The confirmation rate of a user is the number of `'confirmed'` messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is `0.00`.
We need to find the confirmation rate of each user, rounded to 2 decimal places.

---

## 5. Tables

Table: Signups

| Column     | Type     |
| ---------- | -------- |
| user_id    | INT      |
| time_stamp | DATETIME |

* `user_id` is the primary key.
* This table contains information about the signup time for the user.

Table: Confirmations

| Column     | Type     |
| ---------- | -------- |
| user_id    | INT      |
| time_stamp | DATETIME |
| action     | ENUM     |

* `(user_id, time_stamp)` is the primary key.
* `action` is an ENUM of the type ('confirmed', 'timeout').

---

## 6. Sample Input

Signups table:

| user_id | time_stamp          |
| ------- | ------------------- |
| 3       | 2020-03-21 10:16:13 |
| 7       | 2020-01-04 13:57:59 |
| 2       | 2020-07-29 23:09:44 |
| 6       | 2020-12-09 10:39:37 |

Confirmations table:

| user_id | time_stamp          | action    |
| ------- | ------------------- | --------- |
| 3       | 2021-01-06 03:30:46 | timeout   |
| 3       | 2021-07-14 14:00:00 | timeout   |
| 7       | 2021-06-12 11:57:29 | confirmed |
| 7       | 2021-06-13 12:58:28 | confirmed |
| 7       | 2021-06-14 13:59:27 | confirmed |
| 2       | 2021-01-22 00:00:00 | confirmed |
| 2       | 2021-02-28 23:59:59 | timeout   |

---

## 7. Expected Output

| user_id | confirmation_rate |
| ------- | ----------------- |
| 6       | 0.00              |
| 3       | 0.00              |
| 7       | 1.00              |
| 2       | 0.50              |

*(User 6 made no requests -> 0. User 3 had 2 timeouts -> 0. User 7 had 3 confirms -> 1. User 2 had 1 confirm out of 2 requests -> 0.5).*

---

## 8. Understanding the Question
What information is being asked? The `user_id` and their `confirmation_rate`.
What columns are important? `user_id` and `action`.
What conditions matter? The rate is `(count of 'confirmed') / (total requests)`. If total requests = 0, rate is 0. Round to 2 decimals.
What should be returned? `user_id`, `confirmation_rate`.

---

## 9. Thinking Process
1. We need a result for *every single user* in the `Signups` table, even if they have no confirmation requests (like User 6). This screams **LEFT JOIN** from `Signups` to `Confirmations`.
2. To calculate a rate per user, we need to `GROUP BY user_id`.
3. Now for the math: `Total Confirmed / Total Requests`.
4. In MySQL, comparing a value (`action = 'confirmed'`) evaluates to `1` (True) or `0` (False). 
5. The `AVG()` function perfectly handles this! `AVG(1, 0)` is exactly `0.50`. By using `AVG(IF(action='confirmed', 1, 0))`, we calculate the rate in one simple function.
6. What about User 6 who has no requests? Because of the LEFT JOIN, their `action` is `NULL`. `AVG()` of a NULL set returns `NULL`.
7. The problem explicitly states that if they have no requests, the rate should be `0.00`. We must wrap the `AVG()` in an `IFNULL(..., 0)` to convert that NULL to a 0.
8. Finally, wrap everything in `ROUND(..., 2)`.

---

## 10. Approach 1 (Optimal)
LEFT JOIN + AVG() Conditional Aggregation

We use a LEFT JOIN to guarantee all users appear. Then we use `AVG` combined with an `IF` statement to simultaneously sum up the successes and divide by the total attempts.

---

## 11. SQL Solution

```sql
-- Calculate the confirmation rate for every user, rounding to 2 decimals
SELECT 
    s.user_id, 
    ROUND(IFNULL(AVG(IF(c.action = 'confirmed', 1, 0)), 0), 2) AS confirmation_rate
FROM 
    Signups s
LEFT JOIN 
    Confirmations c 
    ON s.user_id = c.user_id
GROUP BY 
    s.user_id;
```

---

## 12. Step-by-Step Dry Run
1. **LEFT JOIN:**
   * User 6 -> NULL `action`
   * User 3 -> 'timeout', 'timeout'
   * User 7 -> 'confirmed', 'confirmed', 'confirmed'
   * User 2 -> 'confirmed', 'timeout'
2. **GROUP BY & IF(action='confirmed', 1, 0):**
   * User 6 -> list of `[NULL]`
   * User 3 -> list of `[0, 0]`
   * User 7 -> list of `[1, 1, 1]`
   * User 2 -> list of `[1, 0]`
3. **AVG():**
   * User 6 -> `AVG(NULL)` is `NULL`
   * User 3 -> `AVG(0, 0)` is `0.00`
   * User 7 -> `AVG(1, 1, 1)` is `1.00`
   * User 2 -> `AVG(1, 0)` is `0.50`
4. **IFNULL(..., 0) & ROUND(..., 2):**
   * User 6 -> `IFNULL(NULL, 0)` is 0 -> `ROUND(0, 2)` -> `0.00`
   * Others remain as calculated, beautifully rounded to 2 decimals.

---

## 13. SQL Execution Order
1. **FROM and LEFT JOIN:** Link users to their confirmation events.
2. **GROUP BY:** Bucket rows by user.
3. **SELECT:** Execute the `IF` logic to generate 1s and 0s, calculate the `AVG`, handle the `IFNULL`, and `ROUND` the result.

---

## 14. Query Breakdown
* **LEFT JOIN:** Essential so users without confirmation attempts are not dropped.
* **IF(condition, true_val, false_val):** A MySQL control flow function. Translates strings ('confirmed', 'timeout') into numbers (1, 0) that math functions can evaluate.
* **AVG():** Because we fed it 1s and 0s, `AVG` inherently calculates the percentage of 1s!
* **IFNULL():** Safely handles the math-breaking edge case of `AVG(NULL)`.

---

## 15. Why This Solution Works
`AVG(IF(...))` is a famously powerful trick in SQL (often called Conditional Aggregation). It avoids messy calculations like `COUNT(case when...) / COUNT(*)`. It's concise, readable, and highly optimized.

---

## 16. Alternative Solution
Using SUM() and COUNT()

```sql
SELECT 
    s.user_id, 
    ROUND(
        IFNULL(
            SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) 
            / COUNT(c.action), 
        0), 
    2) AS confirmation_rate
FROM 
    Signups s
LEFT JOIN 
    Confirmations c 
    ON s.user_id = c.user_id
GROUP BY 
    s.user_id;
```
* **Advantages:** It is highly explicit and doesn't rely on the "trick" of averaging 1s and 0s. It strictly calculates `Total Confirmed / Total Records`.
* **Disadvantages:** Much longer to write. The `AVG(IF...))` pattern is standard industry practice and is expected at the intermediate/advanced level.

---

## 17. Time Complexity
**O(S + C)** where S is Signups and C is Confirmations. The `LEFT JOIN` and `GROUP BY` resolve quickly because `user_id` is indexed.

---

## 18. Common Mistakes
* **Using `INNER JOIN`:** User 6 disappears completely.
* **Forgetting `IFNULL`:** User 6 will output a confirmation rate of `NULL`, which fails the strict LeetCode test cases that demand `0.00`.
* **Dividing by `COUNT(*)` in the alternative solution:** If you use `COUNT(*)`, User 6 will have a divisor of `1` (because LEFT JOIN created 1 row with NULLs), leading to weird math. Always use `COUNT(column)` or the `AVG` trick to ignore NULLs properly.

---

## 19. Edge Cases
* **Zero attempts:** Safely outputs `0.00`.
* **All 'timeout':** Safely outputs `0.00`.
* **All 'confirmed':** Safely outputs `1.00`.

---

## 20. Interview Tips
* If you have to calculate a "rate", "ratio", or "percentage of true/false", instantly default to the **`AVG(IF(...))`** or **`AVG(CASE WHEN...)`** trick. It proves you write concise, idiomatic SQL.

---

## 21. Similar LeetCode Problems
* 1193. Monthly Transactions I
* 1211. Queries Quality and Percentage

---

## 22. Key Takeaways
* **Conditional Aggregation** (`AVG(IF...)`) is the cleanest way to calculate boolean ratios.
* Whenever performing division or averages on `LEFT JOIN` data, proactively use `IFNULL` to protect against division-by-zero or `NULL` outputs.

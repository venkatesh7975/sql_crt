# Problem 24 – User Activity for the Past 30 Days I

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* Aggregate Functions (`COUNT`, `DISTINCT`)
* Date Functions (`DATEDIFF`, `DATE_SUB`, `BETWEEN`)

---

## 3. Pattern
Date Range Filtering / Distinct Counting

---

## 4. Problem Statement
We need to find the daily active user count for a period of 30 days ending on `2019-07-27` (inclusive). A user was active on a specific day if they made at least one activity on that day.

---

## 5. Tables

Table: Activity

| Column        | Type |
| ------------- | ---- |
| user_id       | INT  |
| session_id    | INT  |
| activity_date | DATE |
| activity_type | ENUM |

* This table has no primary key, it can have duplicate rows.
* `activity_type` is an ENUM of type ('open_session', 'end_session', 'scroll_down', 'send_message').
* Shows the activities of users on a social media website.

---

## 6. Sample Input

Activity table:

| user_id | session_id | activity_date | activity_type |
| ------- | ---------- | ------------- | ------------- |
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |

---

## 7. Expected Output

| day        | active_users |
| ---------- | ------------ |
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |

*(User 1 and 2 were active on 07-20. User 2 and 3 were active on 07-21. User 4 was active on 06-25, but that is more than 30 days before 07-27, so it is excluded).*

---

## 8. Understanding the Question
What information is being asked? The date (`day`) and the number of distinct active users (`active_users`).
What columns are important? `activity_date` and `user_id`.
What conditions matter? 
1. The date must be strictly within the 30-day window ending on `2019-07-27`.
2. A user doing 5 actions in one day counts as only 1 active user for that day.
What should be returned? `day` (alias of `activity_date`), `active_users`.

---

## 9. Thinking Process
1. I need a metric *per day*. That means I must `GROUP BY activity_date`.
2. I only want data for a specific time window: a 30-day period ending on 2019-07-27. In SQL, "30 days ending on X" means between `X - 29 days` and `X`. 
3. Why 29 days? If today is the 1st, a 2-day period ending today includes the 1st and the previous day (the 0th or 31st). So it's `(Date - (N-1))` to `Date`.
4. So the range is `2019-06-28` to `2019-07-27`. I can write this manually, or use `DATEDIFF('2019-07-27', activity_date) BETWEEN 0 AND 29`.
5. Now that the table is filtered and grouped, I need to count the active users. Since a user can have multiple activities in one day, I must use `COUNT(DISTINCT user_id)`.
6. Alias `activity_date` as `day`, and the count as `active_users`.

---

## 10. Approach 1 (Optimal)
Date filtering with `DATEDIFF` and Distinct Counting

Filter the table for the requested date range, bucket the data by date, and count the unique users in each bucket.

---

## 11. SQL Solution

```sql
-- Calculate Daily Active Users (DAU) for a specific 30-day window
SELECT 
    activity_date AS day, 
    COUNT(DISTINCT user_id) AS active_users
FROM 
    Activity
WHERE 
    activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY 
    activity_date;
```

*Or, if you don't want to calculate the start date manually:*

```sql
SELECT 
    activity_date AS day, 
    COUNT(DISTINCT user_id) AS active_users
FROM 
    Activity
WHERE 
    DATEDIFF('2019-07-27', activity_date) < 30 
    AND activity_date <= '2019-07-27'
GROUP BY 
    activity_date;
```

---

## 12. Step-by-Step Dry Run (Using the DATEDIFF version)
1. **Filter rows (WHERE):**
   * Row: 2019-07-20. Diff = 7. (7 < 30 and <= 07-27). **Keep**.
   * Row: 2019-07-21. Diff = 6. **Keep**.
   * Row: 2019-06-25. Diff = 32. (32 is NOT < 30). **Drop**.
2. **GROUP BY `activity_date`:**
   * Bucket 2019-07-20: Users `[1, 1, 1, 2]`.
   * Bucket 2019-07-21: Users `[2, 2, 3, 3, 3]`.
3. **COUNT(DISTINCT user_id):**
   * Bucket 2019-07-20: Unique users are `[1, 2]`. Count is **2**.
   * Bucket 2019-07-21: Unique users are `[2, 3]`. Count is **2**.

---

## 13. SQL Execution Order
1. **FROM Activity:** Load table.
2. **WHERE ... :** Immediately discard any rows that occurred outside the target 30-day window.
3. **GROUP BY activity_date:** Separate the remaining rows into daily piles.
4. **SELECT:** Run the distinct math on each pile and rename the columns.

---

## 14. Query Breakdown
* **BETWEEN '2019-06-28' AND '2019-07-27':** The most performant way to filter dates, because it is fully sargable (can perfectly utilize indexes on `activity_date`).
* **COUNT(DISTINCT user_id):** The classic formula for Daily Active Users (DAU). It guarantees a user is only counted once per day, no matter how much they spam the server.

---

## 15. Why This Solution Works
DAU (Daily Active Users) is the most standard metric in software. This query perfectly mirrors the industry-standard way to calculate DAU over a trailing time window.

---

## 16. Alternative Solution
Using `DATE_SUB` (or `DATE_ADD`)

```sql
SELECT 
    activity_date AS day, 
    COUNT(DISTINCT user_id) AS active_users
FROM 
    Activity
WHERE 
    activity_date > DATE_SUB('2019-07-27', INTERVAL 30 DAY) 
    AND activity_date <= '2019-07-27'
GROUP BY 
    activity_date;
```
* **Advantages:** This is the most professional solution. By calculating the start date dynamically using `DATE_SUB(...)`, it avoids hardcoding `2019-06-28` and remains highly performant (index-friendly).
* **Disadvantages:** Slightly harder syntax for absolute beginners. Note the `>` instead of `>=` because `27 - 30 = -3` (which corresponds to June 27th), and we want June 28th.

---

## 17. Time Complexity
**O(N)**. With an index on `activity_date`, the `WHERE` clause reduces the data instantly. Grouping and distinct counting are very fast on the filtered dataset.

---

## 18. Common Mistakes
* **Mathematical error on "30 days":** People often use `BETWEEN '2019-06-27' AND '2019-07-27'`. That is actually **31** days. (27 days in July + 4 days in June = 31). The window should start on June 28th.
* **Using `COUNT(user_id)`:** This will calculate the total number of *events* per day, not the total number of *users*.
* **Missing the upper bound check:** If you just write `DATEDIFF('2019-07-27', activity_date) < 30`, you will accidentally include events from the future (e.g., 2019-08-05), because DATEDIFF(July 27, Aug 5) is `-9`, which is less than 30! Always ensure `activity_date <= '2019-07-27'`.

---

## 19. Edge Cases
* **A day with no active users:** Because we group by `activity_date` existing in the table, days with zero events won't appear in the output. This is expected behavior for this problem.
* **Duplicate exact events:** Ignored cleanly by `COUNT(DISTINCT)`.

---

## 20. Interview Tips
* Knowing how to calculate DAU (Daily Active Users), WAU, and MAU is mandatory for any product or data role. 
* Be ready to discuss the edge case of "what if they want the days with 0 users to show up?" (Answer: You'd need a master calendar table to `LEFT JOIN` against, or a recursive CTE to generate the dates).

---

## 21. Similar LeetCode Problems
* 1693. Daily Leads and Partners
* 2356. Number of Unique Subjects Taught by Each Teacher

---

## 22. Key Takeaways
* **DAU** = `COUNT(DISTINCT user_id) GROUP BY date`.
* "For the past N days ending on Date X" is functionally `Date X - (N-1) days`.
* Use `DATE_SUB()` or `BETWEEN` for cleaner, index-friendly date math.

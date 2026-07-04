# Problem 22 – Game Play Analysis IV

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* INNER JOIN
* Subqueries (Deriving Tables)
* DATEDIFF()
* ROUND()

---

## 3. Pattern
First-Event Filtering / Retention Analysis

---

## 4. Problem Statement
We need to report the **fraction** of players that logged in again on the **day exactly after** the day they first logged in. 
In other words: out of all players, what fraction played on their `first_login_date + 1`? Round the answer to 2 decimal places.

---

## 5. Tables

Table: Activity

| Column       | Type |
| ------------ | ---- |
| player_id    | INT  |
| device_id    | INT  |
| event_date   | DATE |
| games_played | INT  |

* `(player_id, event_date)` is the primary key.
* This table shows the activity of players of some game.

---

## 6. Sample Input

Activity table:

| player_id | device_id | event_date | games_played |
| --------- | --------- | ---------- | ------------ |
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |

---

## 7. Expected Output

| fraction |
| -------- |
| 0.33     |

*(Player 1 logged in on Mar 1 and Mar 2. (Success! Day 1 retention).*
*(Player 2 logged in only once.)*
*(Player 3 logged in Mar 2, then not again until 2018. (Failed retention).*
*(Out of 3 total players, only 1 had day 1 retention. 1/3 = 0.33).*

---

## 8. Understanding the Question
What information is being asked? A single fractional number representing "Day-1 Retention".
What columns are important? `player_id`, `event_date`.
What conditions matter? The player must have an `event_date` that is exactly 1 day after their *very first* `event_date`.
What should be returned? `fraction`.

---

## 9. Thinking Process
1. **Find the first login:** Just like in Problem 21, I need to know the first login date for every player.
   `SELECT player_id, MIN(event_date) as first_login FROM Activity GROUP BY player_id`
2. **Find the returning players:** Now I need to see if those players have another record in the `Activity` table where the date is `first_login + 1`.
3. I can do this by `INNER JOIN`ing the original `Activity` table to my First Login subquery.
4. The Join condition will be: `ON a.player_id = first.player_id AND DATEDIFF(a.event_date, first.first_login) = 1`.
5. This join will completely drop any player who didn't log in on day 2!
6. **Calculate the fraction:** The total number of players who survived the join divided by the total number of distinct players in the entire database.
7. Total retained = `COUNT(a.player_id)`.
8. Total players = `(SELECT COUNT(DISTINCT player_id) FROM Activity)`.
9. Divide them, wrap in `ROUND(..., 2)`.

---

## 10. Approach 1 (Optimal)
JOIN with Subquery

Create a derived table of first logins, join it against the main activity table checking for a 1-day difference, and divide by the total player count.

---

## 11. SQL Solution

```sql
-- Calculate Day-1 retention fraction
SELECT 
    ROUND(
        COUNT(a.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
    2) AS fraction
FROM 
    Activity a
JOIN 
    (SELECT player_id, MIN(event_date) AS first_login 
     FROM Activity 
     GROUP BY player_id) first
ON 
    a.player_id = first.player_id 
    AND DATEDIFF(a.event_date, first.first_login) = 1;
```

---

## 12. Step-by-Step Dry Run
1. **Subquery `first`:**
   * P1 -> 2016-03-01
   * P2 -> 2017-06-25
   * P3 -> 2016-03-02
2. **INNER JOIN Evaluation:**
   * Evaluate P1: Does P1 have a row in Activity where date is exactly 1 day after 2016-03-01? Yes (2016-03-02). **Keep P1.**
   * Evaluate P2: Does P2 have a row where date is exactly 1 day after 2017-06-25? No. **Drop P2.**
   * Evaluate P3: Does P3 have a row where date is exactly 1 day after 2016-03-02? No (next is 2018). **Drop P3.**
3. **Count the survivors:**
   * Only P1 survived. `COUNT(a.player_id)` = `1`.
4. **Scalar Subquery execution:**
   * `SELECT COUNT(DISTINCT player_id)` evaluates to `3`.
5. **Math:**
   * `1 / 3` = `0.3333...`. Rounded to 2 decimals -> `0.33`.

---

## 13. SQL Execution Order
1. **Subquery `first`:** Groups the data to find minimums.
2. **FROM Activity a JOIN first:** Filters the main table down to *only* the specific day-2 retention rows.
3. **Scalar Subquery:** Quickly counts the total unique users.
4. **SELECT:** Performs the division and rounding.

---

## 14. Query Breakdown
* **JOIN (SELECT ...) first:** This creates a temporary, virtual table (a Derived Table) that we can join against.
* **DATEDIFF(a, b) = 1:** Ensures the activity date is exactly the day after the first login.
* **(SELECT COUNT(DISTINCT player_id) FROM Activity):** Uncorrelated subquery acting as the global denominator.

---

## 15. Why This Solution Works
Retention analysis requires comparing a specific user's timeline against itself. By abstracting the "start of the timeline" (the `MIN` date) into a subquery, we easily perform date arithmetic against the rest of their timeline.

---

## 16. Alternative Solution
Tuple IN Subquery + DATE_SUB

```sql
SELECT 
    ROUND(
        COUNT(*) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
    2) AS fraction
FROM 
    Activity
WHERE 
    (player_id, DATE_SUB(event_date, INTERVAL 1 DAY)) IN (
        SELECT player_id, MIN(event_date)
        FROM Activity
        GROUP BY player_id
    );
```
* **Advantages:** Extremely readable. "Keep rows where (Player ID and Yesterday) is their very first login".
* **Disadvantages:** Performing `DATE_SUB` on a column inside a `WHERE` clause can bypass indexes on `event_date`, making it slower than an explicit `JOIN`. 

---

## 17. Time Complexity
**O(N)**. The `GROUP BY` subquery takes O(N). Joining them via primary key takes O(N). Calculating the total distinct players takes O(N).

---

## 18. Common Mistakes
* **Not using MIN(date):** If you just check for *any* consecutive days (`DATEDIFF = 1`), you might count a player who played on Day 10 and Day 11, which is not Day-1 retention!
* **Wrong denominator:** Using `COUNT(*)` in the scalar subquery will count total *logins* instead of total *players*. You must use `COUNT(DISTINCT player_id)`.

---

## 19. Edge Cases
* **Empty table:** If there are no rows, the scalar subquery returns 0, causing division by zero. (In real-world engines, this requires a `NULLIF` wrapper, but LeetCode guarantees at least 1 row).
* **Player logged in on Day 1, skipped Day 2, returned Day 3:** They fail the `DATEDIFF = 1` check and are correctly excluded from the numerator.

---

## 20. Interview Tips
* "Day-1 Retention", "Day-7 Retention", and "Day-30 Retention" are arguably the most common SQL queries written by Data Analysts at gaming/tech companies. Knowing this pattern inside-out is mandatory for Product Analytics interviews.

---

## 21. Similar LeetCode Problems
* 1098. Unpopular Books
* 1112. Highest Grade For Each Student

---

## 22. Key Takeaways
* **Retention Logic:** To find returning users, Join the activity table against a subquery of their *first* activity using `DATEDIFF = 1` (or 7, or 30).
* Use `COUNT(DISTINCT id)` to find the total number of unique users in a log table.

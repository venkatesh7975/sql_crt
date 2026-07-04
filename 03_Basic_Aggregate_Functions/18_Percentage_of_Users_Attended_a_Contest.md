# Problem 18 – Percentage of Users Attended a Contest

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Subquery (in the SELECT clause)
* GROUP BY
* Aggregate Functions (`COUNT`)
* ROUND()
* ORDER BY (Multiple columns)

---

## 3. Pattern
Aggregation / Uncorrelated Subquery

---

## 4. Problem Statement
We need to find the percentage of users registered in each contest. The percentage should be rounded to 2 decimal places. 
The result must be ordered by the percentage in descending order, and in case of a tie, by the `contest_id` in ascending order.

---

## 5. Tables

Table: Users

| Column    | Type    |
| --------- | ------- |
| user_id   | INT     |
| user_name | VARCHAR |

* `user_id` is the primary key.

Table: Register

| Column     | Type |
| ---------- | ---- |
| contest_id | INT  |
| user_id    | INT  |

* `(contest_id, user_id)` is the primary key.
* This table contains the registration data of users for various contests.

---

## 6. Sample Input

Users table:

| user_id | user_name |
| ------- | --------- |
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |

Register table:

| contest_id | user_id |
| ---------- | ------- |
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |

---

## 7. Expected Output

| contest_id | percentage |
| ---------- | ---------- |
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |

*(Total users = 3. Contest 208 has 3 users (3/3 = 100%). Contest 215 has 2 users (2/3 = 66.67%). Sorted by % DESC, then ID ASC).*

---

## 8. Understanding the Question
What information is being asked? The `contest_id` and the calculated `percentage`.
What columns are important? `contest_id`, `user_id` (from Register), and the total count of users (from Users).
What conditions matter? 
1. Formula: `(Users in contest / Total users in platform) * 100`.
2. Sort by percentage DESC, then contest_id ASC.
What should be returned? `contest_id`, `percentage`.

---

## 9. Thinking Process
1. I need to calculate a percentage per contest. This means I need to query the `Register` table and `GROUP BY contest_id`.
2. For each bucket (contest), I need the number of users in that contest: `COUNT(user_id)`.
3. To find the percentage, I must divide that count by the *total number of users on the entire platform*.
4. Where do I get the total number of users? From `SELECT COUNT(*) FROM Users`.
5. Because this total number is a single, static value across all rows, I can embed it directly into my math equation as a subquery.
6. The math is: `ROUND(COUNT(user_id) * 100.0 / (SELECT COUNT(*) FROM Users), 2)`. Note the `100.0`—multiplying by a float ensures the database doesn't perform integer division (which truncates decimals).
7. Finally, I need to apply the specific multi-column `ORDER BY` requested.

---

## 10. Approach 1 (Optimal)
GROUP BY with a Scalar Subquery

Group the registrations by contest, and use an independent subquery inside the `SELECT` clause to fetch the total user denominator.

---

## 11. SQL Solution

```sql
-- Calculate the percentage of users registered per contest
SELECT 
    contest_id, 
    ROUND(COUNT(user_id) * 100.0 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM 
    Register
GROUP BY 
    contest_id
ORDER BY 
    percentage DESC, 
    contest_id ASC;
```

---

## 12. Step-by-Step Dry Run
1. **Scalar Subquery:** `(SELECT COUNT(*) FROM Users)` evaluates to `3`.
2. **GROUP BY contest_id:**
   * Contest 207: 1 user.
   * Contest 208: 3 users.
   * Contest 209: 3 users.
   * Contest 210: 3 users.
   * Contest 215: 2 users.
3. **Calculation:**
   * 207: `1 * 100.0 / 3` = `33.333...` -> `33.33`
   * 208: `3 * 100.0 / 3` = `100.00`
   * 215: `2 * 100.0 / 3` = `66.666...` -> `66.67`
4. **ORDER BY:**
   * Sort by % DESC: 208, 209, 210 (all 100%), then 215 (66.67%), then 207 (33.33%).
   * Tie-breaker (ID ASC) on the 100% group: 208, 209, 210.

---

## 13. SQL Execution Order
1. **Scalar Subquery execution:** The database evaluates `(SELECT COUNT(*) FROM Users)` once, caching the result (`3`).
2. **FROM Register:** Target table identified.
3. **GROUP BY contest_id:** Groups created.
4. **SELECT:** Does the math for each group using the cached subquery value.
5. **ORDER BY:** Sorts the final result.

---

## 14. Query Breakdown
* **(SELECT COUNT(*) FROM Users):** This is called an Uncorrelated Scalar Subquery. It does not depend on the outer query, so it runs very fast (only once).
* **`* 100.0`:** Multiplying by a float forces SQL engines to treat the math as floating-point arithmetic. If you did `COUNT / COUNT * 100`, some strict SQL engines (like SQL Server or PostgreSQL) might do integer division (`2 / 3 = 0`, then `0 * 100 = 0`). MySQL is generally forgiving with division, but `100.0` is a best-practice safety net.
* **ORDER BY a DESC, b ASC:** Defines a primary sorting rule and a secondary tie-breaker rule.

---

## 15. Why This Solution Works
By utilizing a scalar subquery, we avoid having to do a messy `CROSS JOIN` with the `Users` table just to get the total count. It's clean, efficient, and mathematically sound.

---

## 16. Alternative Solution
Using a CROSS JOIN (Less elegant)

```sql
SELECT 
    r.contest_id, 
    ROUND(COUNT(r.user_id) * 100.0 / total.user_count, 2) AS percentage
FROM 
    Register r
CROSS JOIN 
    (SELECT COUNT(*) AS user_count FROM Users) total
GROUP BY 
    r.contest_id, 
    total.user_count
ORDER BY 
    percentage DESC, 
    r.contest_id ASC;
```
* **Advantages:** Shows an understanding of how to attach global aggregates to detail rows.
* **Disadvantages:** More verbose. Grouping by the `total.user_count` is annoying but required by SQL syntax. The subquery approach is much more standard.

---

## 17. Time Complexity
**O(R log R)** where R is the number of rows in `Register`. The subquery takes O(1) if indexed, grouping takes O(R), and sorting the results takes O(M log M) where M is the number of unique contests.

---

## 18. Common Mistakes
* **Using `JOIN Users`:** Trying to `LEFT JOIN` or `INNER JOIN` the `Users` table into the main query will mess up your counts. You don't need to join; you just need the grand total number.
* **Integer Division:** Forgetting to multiply by `100.0` before dividing.
* **Wrong Order By:** Forgetting the tie-breaker `contest_id ASC`.

---

## 19. Edge Cases
* **No users on the platform:** Technically, `COUNT` is 0, causing division by zero. However, logic dictates if there are no users, there are no registrations, so the query safely returns an empty set.
* **Nobody registered for a contest:** That contest isn't in the `Register` table, so it isn't returned (which is the correct behavior based on the problem statement).

---

## 20. Interview Tips
* Subqueries in the `SELECT` clause are powerful tools for calculating percentages against a "Grand Total". 
* Make sure you emphasize *why* you multiply by `100.0`—it proves you know about data types and implicit type casting in SQL.

---

## 21. Similar LeetCode Problems
* 1607. Sellers With No Sales
* 1211. Queries Quality and Percentage

---

## 22. Key Takeaways
* Use an **Uncorrelated Scalar Subquery** in the `SELECT` clause to fetch a "Grand Total" denominator.
* Multiply by `100.0` (not `100`) to prevent accidental integer division.
* You can define multiple sorting rules in `ORDER BY` separated by commas.

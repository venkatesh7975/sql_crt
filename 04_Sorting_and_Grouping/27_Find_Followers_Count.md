# Problem 27 – Find Followers Count

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* Aggregate Functions (`COUNT`)
* ORDER BY

---

## 3. Pattern
Grouping / Counting / Sorting

---

## 4. Problem Statement
We need to write a query that will, for each user, return the number of followers they have. The result table should be ordered by `user_id` in ascending order.

---

## 5. Tables

Table: Followers

| Column      | Type |
| ----------- | ---- |
| user_id     | INT  |
| follower_id | INT  |

* `(user_id, follower_id)` is the primary key for this table.
* This table contains the IDs of a user and a follower. The user with `follower_id` follows the user with `user_id`.

---

## 6. Sample Input

Followers table:

| user_id | follower_id |
| ------- | ----------- |
| 0       | 1           |
| 1       | 0           |
| 2       | 0           |
| 2       | 1           |

---

## 7. Expected Output

| user_id | followers_count |
| ------- | --------------- |
| 0       | 1               |
| 1       | 1               |
| 2       | 2               |

*(User 0 has 1 follower. User 1 has 1 follower. User 2 has 2 followers. The output is sorted by user_id: 0, 1, 2).*

---

## 8. Understanding the Question
What information is being asked? The `user_id` and the total number of followers they have.
What columns are important? `user_id` and `follower_id`.
What conditions matter? The output must be sorted by `user_id` in ascending order.
What should be returned? `user_id`, `followers_count`.

---

## 9. Thinking Process
1. I need a metric "for each user". This means I must group the rows by the user: `GROUP BY user_id`.
2. Within each group, I need to count the number of followers. Since the primary key guarantees no duplicate `(user_id, follower_id)` pairs, a simple `COUNT(follower_id)` is sufficient. I don't strictly need `DISTINCT`.
3. I need to alias this count as `followers_count`.
4. Finally, the problem explicitly states: "ordered by `user_id` in ascending order". So I must add `ORDER BY user_id ASC`.

---

## 10. Approach 1 (Optimal)
GROUP BY and COUNT

Group the table by `user_id`, apply the `COUNT` aggregation, and sort the final result.

---

## 11. SQL Solution

```sql
-- Count the number of followers per user, sorted by user ID
SELECT 
    user_id, 
    COUNT(follower_id) AS followers_count
FROM 
    Followers
GROUP BY 
    user_id
ORDER BY 
    user_id ASC;
```

---

## 12. Step-by-Step Dry Run
1. **GROUP BY user_id:**
   * Group `0`: Follower IDs [1]
   * Group `1`: Follower IDs [0]
   * Group `2`: Follower IDs [0, 1]
2. **COUNT(follower_id):**
   * Group `0`: 1 follower.
   * Group `1`: 1 follower.
   * Group `2`: 2 followers.
3. **ORDER BY user_id ASC:**
   * The IDs 0, 1, and 2 are sorted in ascending order.
   * The final output table is constructed.

---

## 13. SQL Execution Order
1. **FROM Followers:** Scan the table.
2. **GROUP BY user_id:** Group the records.
3. **SELECT:** Calculate the `COUNT` for each group and assign aliases.
4. **ORDER BY user_id ASC:** Sort the calculated result set.

---

## 14. Query Breakdown
* **COUNT(follower_id):** Counts the number of non-null `follower_id`s in each bucket. `COUNT(*)` would also work perfectly here.
* **ORDER BY user_id ASC:** `ASC` (ascending) is actually the default behavior of `ORDER BY`, but explicitly writing it is a good practice for readability.

---

## 15. Why This Solution Works
This is perhaps the most fundamental `GROUP BY` query possible. It perfectly leverages SQL's built-in grouping and sorting mechanisms.

---

## 16. Alternative Solution
Using COUNT(*)

```sql
SELECT 
    user_id, 
    COUNT(*) AS followers_count
FROM 
    Followers
GROUP BY 
    user_id
ORDER BY 
    user_id;
```
* **Advantages:** `COUNT(*)` is slightly faster in some database engines because it simply counts the rows in the bucket without checking if a specific column is `NULL`.
* **Disadvantages:** None, it is functionally identical for this schema.

---

## 17. Time Complexity
**O(N log N)**. Grouping takes O(N) using a hash map or sorting, but the final `ORDER BY` takes O(M log M) where M is the number of distinct users. If an index exists on `user_id`, the database can perform both operations in **O(N)**.

---

## 18. Common Mistakes
* **Forgetting `ORDER BY`:** In SQL, the output of a `GROUP BY` is *not* guaranteed to be sorted. Sometimes it looks sorted by coincidence (because of how the hash map evaluates), but you will eventually fail a test case if you omit `ORDER BY user_id`.

---

## 19. Edge Cases
* **A user has no followers:** If a user exists in another hypothetical `Users` table but has no rows in this `Followers` table, they won't show up in this output. The problem does not ask us to return 0 for them, so we don't need a `LEFT JOIN`.
* **Duplicate followers:** The primary key `(user_id, follower_id)` prevents the same person from following a user twice.

---

## 20. Interview Tips
* Always explicitly state that `GROUP BY` does not guarantee sorting, which is why the `ORDER BY` clause is mandatory here. This shows you understand SQL engine internals.

---

## 21. Similar LeetCode Problems
* 586. Customer Placing the Largest Number of Orders
* 1693. Daily Leads and Partners

---

## 22. Key Takeaways
* `COUNT(column)` or `COUNT(*)` counts the items in a grouped bucket.
* Always explicitly write `ORDER BY` if the prompt asks for a specific sort order, even if the database seems to do it automatically.

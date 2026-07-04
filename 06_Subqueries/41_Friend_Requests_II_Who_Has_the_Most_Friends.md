# Problem 41 – Friend Requests II: Who Has the Most Friends

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* UNION ALL
* Derived Tables (Subqueries in FROM)
* GROUP BY and Aggregation (`COUNT`, `SUM`)
* ORDER BY with LIMIT

---

## 3. Pattern
Graph Unpivoting / UNION ALL

---

## 4. Problem Statement
Write a SQL query to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has a strictly maximum number of friends.

---

## 5. Tables

Table: RequestAccepted

| Column       | Type |
| ------------ | ---- |
| requester_id | INT  |
| accepter_id  | INT  |
| accept_date  | DATE |

* `(requester_id, accepter_id)` is the primary key.
* This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.

---

## 6. Sample Input

RequestAccepted table:

| requester_id | accepter_id | accept_date |
| ------------ | ----------- | ----------- |
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |

---

## 7. Expected Output

| id | num |
| -- | --- |
| 3  | 3   |

*(User 1 is friends with 2, 3 (2 friends).*
*User 2 is friends with 1, 3 (2 friends).*
*User 3 is friends with 1, 2, 4 (3 friends).*
*User 4 is friends with 3 (1 friend).*
*User 3 has the most friends).*

---

## 8. Understanding the Question
What information is being asked? The user ID of the most popular person, and their friend count.
What columns are important? `requester_id`, `accepter_id`.
What conditions matter? Friendship is bidirectional. If A sends to B, they both gain a friend. We need to count how many times a user's ID appears in *either* column. We then find the absolute maximum sum.
What should be returned? `id`, `num`.

---

## 9. Thinking Process
1. We have two columns containing IDs (`requester` and `accepter`). To easily count the total occurrences of an ID, it is much easier if they are in a single column.
2. I can use `UNION ALL` to "unpivot" these two columns into a single, long column of IDs.
   * `SELECT requester_id AS id FROM RequestAccepted`
   * `UNION ALL`
   * `SELECT accepter_id AS id FROM RequestAccepted`
3. This creates a massive virtual table of every single ID involved in a friendship interaction.
4. I will treat this massive `UNION ALL` table as a Derived Table (a subquery in the `FROM` clause).
5. Now, I just need to `GROUP BY id` and `COUNT(id) AS num`.
6. To find the winner, I'll sort by the count descending: `ORDER BY num DESC`.
7. Finally, because the prompt guarantees a single winner, I'll take the top row using `LIMIT 1`.

---

## 10. Approach 1 (Optimal)
Unpivot via UNION ALL + Aggregation

Stack the requester IDs and accepter IDs into a single column, group by the ID, count the occurrences, and pull the highest result.

---

## 11. SQL Solution

```sql
-- Unpivot the friendship pairs and count total interactions per ID
SELECT 
    id, 
    COUNT(id) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id FROM RequestAccepted
) AS FriendsList
GROUP BY 
    id
ORDER BY 
    num DESC
LIMIT 1;
```

---

## 12. Step-by-Step Dry Run
1. **Inner Query 1 (requester):**
   * Output: `[1, 1, 2, 3]`.
2. **Inner Query 2 (accepter):**
   * Output: `[2, 3, 3, 4]`.
3. **UNION ALL:**
   * Stacked `FriendsList`: `[1, 1, 2, 3, 2, 3, 3, 4]`.
4. **GROUP BY id & COUNT:**
   * ID 1: Count = 2
   * ID 2: Count = 2
   * ID 3: Count = 3
   * ID 4: Count = 1
5. **ORDER BY num DESC:**
   * Sorted: (3, 3), (1, 2), (2, 2), (4, 1).
6. **LIMIT 1:**
   * Result: `id: 3, num: 3`.

---

## 13. SQL Execution Order
1. **FROM (Subqueries):** The database executes the two individual SELECTs.
2. **UNION ALL:** Merges them into a derived table in memory (`FriendsList`).
3. **GROUP BY:** Groups the derived table by ID.
4. **SELECT:** Computes the aggregate counts.
5. **ORDER BY:** Sorts the aggregations.
6. **LIMIT:** Extracts the single top row.

---

## 14. Query Breakdown
* **UNION ALL vs UNION:** This is absolutely critical. `UNION` removes duplicates. If you used `UNION`, `[1, 1, 2, 3]` and `[2, 3, 3, 4]` would collapse into `[1, 2, 3, 4]`, and every user would have exactly 1 friend! `UNION ALL` preserves every single occurrence, which is required for counting.
* **Derived Table Alias (`AS FriendsList`):** Every derived table in the `FROM` clause *must* have an alias in MySQL, even if you never use it.

---

## 15. Why This Solution Works
Graph databases (nodes and edges) are typically hard to represent in SQL. "Unpivoting" the two ends of an edge (the requester and accepter) into a single list of nodes is the standard pattern for solving simple Graph-degree problems.

---

## 16. Alternative Solution
Double Aggregation (Slightly more complex)

```sql
SELECT id, SUM(friends) AS num
FROM (
    SELECT requester_id AS id, COUNT(*) AS friends FROM RequestAccepted GROUP BY requester_id
    UNION ALL
    SELECT accepter_id AS id, COUNT(*) AS friends FROM RequestAccepted GROUP BY accepter_id
) AS grouped_friends
GROUP BY id
ORDER BY num DESC
LIMIT 1;
```
* **Advantages:** Pre-aggregating the counts *before* the UNION ALL can save memory on massive datasets because the intermediate table is much smaller.
* **Disadvantages:** You have to write `GROUP BY` three times, and switch from `COUNT` to `SUM` for the final outer query. The first approach is much cleaner for LeetCode scale.

---

## 17. Time Complexity
**O(N log N)**. Scanning the table twice is O(2N) -> O(N). Grouping and counting is O(N). Sorting the final counts is O(U log U) where U is the number of unique users.

---

## 18. Common Mistakes
* **Using `UNION` instead of `UNION ALL`:** Destroys the duplicates needed for counting.
* **Forgetting to alias the subquery:** Writing `FROM (SELECT... UNION ALL SELECT...) GROUP BY` will throw a Syntax Error: `Every derived table must have its own alias`.

---

## 19. Edge Cases
* **Empty Table:** The `LIMIT 1` on an empty set returns nothing, which handles it perfectly.
* **Multiple ties for first place:** The prompt explicitly states "only one person has a strictly maximum number of friends", meaning ties are guaranteed not to exist in the test cases. If ties *could* exist, you'd use a `RANK()` Window Function instead of `LIMIT 1`.

---

## 20. Interview Tips
* State clearly why you chose `UNION ALL` over `UNION` (to preserve duplicate occurrences for accurate counting).
* "Unpivoting" is a great term to drop in interviews when you transform columns into rows.

---

## 21. Similar LeetCode Problems
* 1393. Capital Gain/Loss
* 1873. Calculate Special Bonus

---

## 22. Key Takeaways
* When a metric depends on occurrences in multiple columns (like a bidirectional relationship), use `SELECT col1 UNION ALL SELECT col2` to unpivot them into a single column for easy counting.

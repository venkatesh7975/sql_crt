# Problem 19 – Queries Quality and Percentage

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* Aggregate Functions (`AVG`)
* Conditional Aggregation (`AVG(IF...)`)
* ROUND()

---

## 3. Pattern
Aggregation / Conditional Aggregation / Math

---

## 4. Problem Statement
We need to calculate two metrics for each `query_name`:
1. **quality**: The average of the ratio between query rating and its position.
2. **poor_query_percentage**: The percentage of all queries with a rating strictly less than 3.
Both metrics must be rounded to 2 decimal places.

---

## 5. Tables

Table: Queries

| Column     | Type    |
| ---------- | ------- |
| query_name | VARCHAR |
| result     | VARCHAR |
| position   | INT     |
| rating     | INT     |

* This table has no primary key, it may have duplicate rows.
* It contains data about search queries, the returned results, their position in the list, and the user rating (1 to 5).

---

## 6. Sample Input

Queries table:

| query_name | result            | position | rating |
| ---------- | ----------------- | -------- | ------ |
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |

---

## 7. Expected Output

| query_name | quality | poor_query_percentage |
| ---------- | ------- | --------------------- |
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |

*(Dog Quality: (5/1 + 5/2 + 1/200) / 3 = 2.50. Dog Poor %: 1 out of 3 is < 3, so 33.33%.)*
*(Cat Quality: (2/5 + 3/3 + 4/7) / 3 = 0.66. Cat Poor %: 1 out of 3 is < 3, so 33.33%.)*

---

## 8. Understanding the Question
What information is being asked? The `query_name` and two specific calculated metrics.
What columns are important? `query_name`, `rating`, `position`.
What conditions matter? Calculations are done per query name. A query is "poor" if `rating < 3`. 
What should be returned? `query_name`, `quality`, `poor_query_percentage`.

---

## 9. Thinking Process
1. Since we need metrics *for each query_name*, we must `GROUP BY query_name`.
2. **Metric 1 (Quality):** The formula is `average of (rating / position)`. This directly translates to `AVG(rating / position)`. We wrap this in `ROUND(..., 2)`.
3. **Metric 2 (Poor %):** We need the percentage of rows in the group where `rating < 3`.
4. From Problem 14 (Confirmation Rate), we know the ultimate trick for boolean percentages is `AVG(IF(condition, 1, 0))`.
5. So, the ratio of poor queries is `AVG(IF(rating < 3, 1, 0))`.
6. To make it a percentage (0-100) instead of a decimal (0.0-1.0), we multiply by 100.
7. Wrap this in `ROUND(..., 2)`.

---

## 10. Approach 1 (Optimal)
Grouping with Conditional Aggregation

We group by the query name and use `AVG` for both metrics. The first metric averages a mathematical division, and the second averages a boolean condition.

---

## 11. SQL Solution

```sql
-- Calculate quality and poor query percentage for each query
SELECT 
    query_name, 
    ROUND(AVG(rating / position), 2) AS quality, 
    ROUND(AVG(IF(rating < 3, 1, 0)) * 100, 2) AS poor_query_percentage
FROM 
    Queries
WHERE 
    query_name IS NOT NULL
GROUP BY 
    query_name;
```

---

## 12. Step-by-Step Dry Run
1. **GROUP BY query_name:**
   * Group 'Dog' contains 3 rows.
   * Group 'Cat' contains 3 rows.
2. **Calculate `quality`:**
   * Dog: `AVG(5/1, 5/2, 1/200)` -> `AVG(5, 2.5, 0.005)` -> `2.5016...` -> `ROUND` -> `2.50`.
   * Cat: `AVG(2/5, 3/3, 4/7)` -> `AVG(0.4, 1, 0.571)` -> `0.657...` -> `ROUND` -> `0.66`.
3. **Calculate `poor_query_percentage`:**
   * Dog: ratings are 5, 5, 1. Condition `< 3` yields `[0, 0, 1]`.
   * `AVG(0, 0, 1)` = `0.3333...`. Multiply by 100 -> `33.333...`. Round -> `33.33`.
   * Cat: ratings are 2, 3, 4. Condition `< 3` yields `[1, 0, 0]`.
   * `AVG(1, 0, 0)` = `0.3333...`. Multiply by 100 -> `33.333...`. Round -> `33.33`.

---

## 13. SQL Execution Order
1. **FROM Queries:** Get the table.
2. **WHERE query_name IS NOT NULL:** (Optional but good practice to filter dirty data).
3. **GROUP BY query_name:** Bucket the rows.
4. **SELECT:** Execute the math formulas for each bucket.

---

## 14. Query Breakdown
* **AVG(rating / position):** `AVG` executes the math inside the parenthesis row-by-row *first*, and then calculates the average of those results.
* **AVG(IF(..., 1, 0)):** The conditional aggregation trick.
* **`* 100`:** Crucial step to convert a 0.33 ratio into a 33.0 percentage.

---

## 15. Why This Solution Works
It relies on the inherent power of the `AVG()` function. By feeding `AVG()` raw mathematical expressions and boolean `IF` statements, we avoid writing massive, unreadable `CASE WHEN ... SUM(...) / COUNT(...)` blocks.

---

## 16. Alternative Solution
Using SUM and COUNT

```sql
SELECT 
    query_name, 
    ROUND(SUM(rating / position) / COUNT(*), 2) AS quality, 
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS poor_query_percentage
FROM 
    Queries
WHERE query_name IS NOT NULL
GROUP BY 
    query_name;
```
* **Advantages:** It is highly explicit. `SUM / COUNT` is exactly how you calculate an average manually.
* **Disadvantages:** Much longer to write and harder to read. The `AVG(IF...))` approach is the SQL standard for this pattern.

---

## 17. Time Complexity
**O(N)** where N is the number of rows. The database does a single scan of the table, hashes the groups, and computes the math on the fly.

---

## 18. Common Mistakes
* **Dividing integers:** Some SQL dialects (like SQL Server) do integer division (`5 / 2 = 2`). MySQL treats `/` as float division, so `rating / position` works perfectly. If you are on SQL Server, you would need to write `rating * 1.0 / position`.
* **Not multiplying by 100:** You will output `0.33` instead of `33.33` and fail the tests.
* **Forgetting `query_name IS NOT NULL`:** LeetCode sometimes sneaks `NULL` query names into the tests for this problem, resulting in a row with a `NULL` name.

---

## 19. Edge Cases
* **No poor queries:** `poor_query_percentage` correctly evaluates to `0.00`.
* **All poor queries:** Evaluates to `100.00`.
* **Missing query_name:** Addressed by the `WHERE` clause.

---

## 20. Interview Tips
* Again, whenever you see a requirement to calculate a percentage based on a condition, immediately use `AVG(IF(condition, 1, 0)) * 100`. 
* Mention the integer division quirk between MySQL and SQL Server. It shows deep knowledge of cross-platform database quirks.

---

## 21. Similar LeetCode Problems
* 1173. Immediate Food Delivery I
* 1633. Percentage of Users Attended a Contest

---

## 22. Key Takeaways
* `AVG()` can take an expression (like `rating / position`), evaluate it per row, and then average the result.
* **Conditional Aggregation** strikes again! `AVG(IF(cond, 1, 0)) * 100` is the ultimate percentage formula.

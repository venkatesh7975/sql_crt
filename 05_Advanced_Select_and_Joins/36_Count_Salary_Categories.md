# Problem 36 – Count Salary Categories

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* UNION
* Conditional Aggregation (`SUM(IF...)`)
* Hardcoded Columns

---

## 3. Pattern
Manual Scaffolding / Conditional Aggregation

---

## 4. Problem Statement
We need to calculate the number of bank accounts for each salary category. The categories are:
1. `"Low Salary"`: Strictly less than $20,000.
2. `"Average Salary"`: Between $20,000 and $50,000 (inclusive).
3. `"High Salary"`: Strictly greater than $50,000.
**Crucial Requirement:** The result table must contain *all three* categories. If there are no accounts in a category, return `0`.

---

## 5. Tables

Table: Accounts

| Column     | Type |
| ---------- | ---- |
| account_id | INT  |
| income     | INT  |

* `account_id` is the primary key.
* Each row contains the monthly income for one bank account.

---

## 6. Sample Input

Accounts table:

| account_id | income |
| ---------- | ------ |
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |

---

## 7. Expected Output

| category       | accounts_count |
| -------------- | -------------- |
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |

*(Account 2 is Low. Accounts 3, 8, 6 are High. No accounts are Average. We must still output 'Average Salary' with a count of 0).*

---

## 8. Understanding the Question
What information is being asked? The category name and the count of accounts in that category.
What columns are important? `income`.
What conditions matter? The exact boundary rules (< 20000, 20000 to 50000, > 50000) and the strict requirement to show `0` for empty categories.
What should be returned? `category`, `accounts_count`.

---

## 9. Thinking Process
1. A beginner might try to use a `CASE WHEN` statement and a `GROUP BY`:
   `SELECT CASE WHEN income < 20000 THEN 'Low' ... END as category, COUNT(account_id) FROM Accounts GROUP BY category`.
2. **Why does this fail?** If there are no 'Average' accounts in the table (like the sample input), the `GROUP BY` will only create two buckets ('Low' and 'High'). The 'Average' category will be entirely missing from the output!
3. To force a row to appear even when there is no data for it, we must **scaffold** it.
4. The easiest way to scaffold three exact rows is to write three separate queries and stack them with `UNION`.
5. Query 1: `SELECT 'Low Salary' AS category, SUM(IF(income < 20000, 1, 0)) AS accounts_count FROM Accounts`.
   * Wait, if I use `SUM(IF...)` without a `WHERE` clause, it scans the whole table and counts the matches, returning `0` if none exist.
6. Let's repeat this for the other two categories.
7. Stack them with `UNION`. 

---

## 10. Approach 1 (Optimal)
UNION with Conditional Aggregation

Construct the three category rows manually and calculate their counts using conditional summing over the entire table.

---

## 11. SQL Solution

```sql
-- Calculate account counts for the three exact salary categories
SELECT 
    'Low Salary' AS category, 
    SUM(IF(income < 20000, 1, 0)) AS accounts_count 
FROM 
    Accounts

UNION

SELECT 
    'Average Salary' AS category, 
    SUM(IF(income BETWEEN 20000 AND 50000, 1, 0)) AS accounts_count 
FROM 
    Accounts

UNION

SELECT 
    'High Salary' AS category, 
    SUM(IF(income > 50000, 1, 0)) AS accounts_count 
FROM 
    Accounts;
```

---

## 12. Step-by-Step Dry Run
1. **Query 1 ('Low Salary'):**
   * Income values: 108939, 12747, 87709, 91796.
   * `IF < 20000`: `[0, 1, 0, 0]`.
   * `SUM(0, 1, 0, 0)` = **1**.
2. **Query 2 ('Average Salary'):**
   * Income values: 108939, 12747, 87709, 91796.
   * `IF BETWEEN 20k AND 50k`: `[0, 0, 0, 0]`.
   * `SUM(0, 0, 0, 0)` = **0**.
3. **Query 3 ('High Salary'):**
   * Income values: 108939, 12747, 87709, 91796.
   * `IF > 50000`: `[1, 0, 1, 1]`.
   * `SUM(1, 0, 1, 1)` = **3**.
4. **UNION:**
   * Stacks the three results. Because Query 2 explicitly selects the string `'Average Salary'` and sums to `0`, the row survives!

---

## 13. SQL Execution Order
1. **Query 1, Query 2, Query 3:** All execute independently. They each do a full table scan of `Accounts`.
2. **UNION:** Merges the three independent 1-row result sets into a 3-row table.

---

## 14. Query Breakdown
* **'String' AS category:** You can create brand new columns in SQL just by selecting a hardcoded string. 
* **BETWEEN:** A clean inclusive operator. `BETWEEN 20000 AND 50000` is identical to `>= 20000 AND <= 50000`.
* **SUM(IF(...)):** As we've seen in many previous problems, this is the safest way to count occurrences without accidentally dropping rows.

---

## 15. Why This Solution Works
`GROUP BY` can only group data that *actually exists* in the table. By avoiding `GROUP BY` entirely and using `UNION` to manually construct the 3 required rows, we guarantee that all categories are reported, perfectly satisfying the edge case requirement.

---

## 16. Alternative Solution
Using a Virtual Category Table and LEFT JOIN (The "Proper" way)

```sql
SELECT 
    c.category, 
    IFNULL(COUNT(a.account_id), 0) AS accounts_count
FROM (
    SELECT 'Low Salary' AS category
    UNION SELECT 'Average Salary'
    UNION SELECT 'High Salary'
) AS c
LEFT JOIN Accounts a ON 
    (c.category = 'Low Salary' AND a.income < 20000) OR
    (c.category = 'Average Salary' AND a.income BETWEEN 20000 AND 50000) OR
    (c.category = 'High Salary' AND a.income > 50000)
GROUP BY c.category;
```
* **Advantages:** This is the most mathematically pure way to solve "missing category" problems in SQL. You create a dimension table of the categories, and `LEFT JOIN` the fact table onto it.
* **Disadvantages:** Much longer to write than the 3-query `UNION` approach.

---

## 17. Time Complexity
**O(N)**. The `UNION` solution scans the table 3 times (O(3N) -> O(N)). Given the small size of typical bank tables, this is fine. The `LEFT JOIN` approach scans the table once.

---

## 18. Common Mistakes
* **Using `GROUP BY CASE WHEN...`:** As explained, this will drop the 'Average Salary' row entirely in the sample test case and fail.
* **Using `COUNT(IF...)` instead of `SUM(IF...)`:** `COUNT(IF(condition, 1, 0))` will count the zeros too! You must use `SUM()` when dealing with binary 1s and 0s.
* **Overlapping boundaries:** Writing `<= 20000` for Low and `>= 20000` for Average will double-count someone with exactly 20k. The prompt is strictly `<` and `>=`.

---

## 19. Edge Cases
* **Empty Accounts Table:** All three sums return `NULL`. To be perfectly bulletproof, you could wrap them in `IFNULL(SUM(...), 0)`. LeetCode's engine often forgives this, but `IFNULL` is safer.

---

## 20. Interview Tips
* This is a classic "Scaffolding" problem. When an interviewer says "Show me all 12 months of the year, even if there were no sales," you immediately know you cannot just `GROUP BY month`. You must create a virtual table of the 12 months and `LEFT JOIN` the sales data to it.

---

## 21. Similar LeetCode Problems
* 1435. Create a Session Bar Chart
* 1873. Calculate Special Bonus

---

## 22. Key Takeaways
* `GROUP BY` cannot create rows for categories that do not exist in the source data.
* To guarantee rows exist, either use `UNION` to manually stitch them together, or create a virtual table of the categories and `LEFT JOIN` the data to it.

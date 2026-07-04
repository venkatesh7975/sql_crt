# Problem 32 – Triangle Judgement

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Mathematical Operators (`+`, `>`)
* Control Flow Functions (`IF`, `CASE`)

---

## 3. Pattern
Conditional Logic / Math

---

## 4. Problem Statement
We need to report for every three line segments whether they can form a triangle.
The rule for triangle formation is the **Triangle Inequality Theorem**: The sum of the lengths of any two sides must be strictly greater than the length of the third side.

---

## 5. Tables

Table: Triangle

| Column | Type |
| ------ | ---- |
| x      | INT  |
| y      | INT  |
| z      | INT  |

* `(x, y, z)` is the primary key.
* Each row contains the lengths of three line segments.

---

## 6. Sample Input

Triangle table:

| x  | y  | z  |
| -- | -- | -- |
| 13 | 15 | 30 |
| 10 | 20 | 15 |

---

## 7. Expected Output

| x  | y  | z  | triangle |
| -- | -- | -- | -------- |
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |

*(Row 1: 13 + 15 = 28. 28 is NOT strictly greater than 30. Fails. -> "No")*
*(Row 2: 10 + 20 > 15 (T). 10 + 15 > 20 (T). 20 + 15 > 10 (T). All pass. -> "Yes")*

---

## 8. Understanding the Question
What information is being asked? The three side lengths, plus a new column indicating "Yes" or "No".
What columns are important? `x`, `y`, `z`.
What conditions matter? The mathematical theorem: `x + y > z` AND `x + z > y` AND `y + z > x`.
What should be returned? `x`, `y`, `z`, `triangle`.

---

## 9. Thinking Process
1. I am returning the original columns `x`, `y`, `z`, so they just go in the `SELECT` clause.
2. I need to calculate a new column. This new column is conditional based on the values in the row.
3. The condition is: `x + y > z AND x + z > y AND y + z > x`. If all three are true, it's a triangle.
4. I can use MySQL's `IF()` function to handle this: `IF(condition, 'Yes', 'No')`.
5. Combine it all into the `SELECT` statement and alias it as `triangle`.

---

## 10. Approach 1 (Optimal)
Using the IF() function

Evaluate the three mathematical conditions simultaneously in an `IF` statement.

---

## 11. SQL Solution

```sql
-- Determine if the three segments form a valid triangle
SELECT 
    x, 
    y, 
    z, 
    IF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
FROM 
    Triangle;
```

---

## 12. Step-by-Step Dry Run
1. **Row 1 (13, 15, 30):**
   * Condition 1: `13 + 15 > 30` -> `28 > 30` -> **FALSE**.
   * The `AND` chain fails immediately.
   * `IF(FALSE, 'Yes', 'No')` evaluates to `'No'`.
2. **Row 2 (10, 20, 15):**
   * Condition 1: `10 + 20 > 15` -> `30 > 15` -> **TRUE**.
   * Condition 2: `10 + 15 > 20` -> `25 > 20` -> **TRUE**.
   * Condition 3: `20 + 15 > 10` -> `35 > 10` -> **TRUE**.
   * The `AND` chain passes.
   * `IF(TRUE, 'Yes', 'No')` evaluates to `'Yes'`.

---

## 13. SQL Execution Order
1. **FROM Triangle:** Load the table.
2. **SELECT:** For every row, retrieve the original columns and evaluate the math in the `IF()` statement to dynamically generate the fourth column.

---

## 14. Query Breakdown
* **IF(condition, true_value, false_value):** A MySQL-specific control flow function. It is much shorter and cleaner than a `CASE` statement for binary (True/False) conditions.
* **AND:** Requires all three mathematical expressions to evaluate to True.

---

## 15. Why This Solution Works
It operates purely on row-level mathematics without any need for grouping, sorting, or joining. It's essentially a logic puzzle masquerading as a SQL question.

---

## 16. Alternative Solution
Using CASE WHEN (Standard SQL)

```sql
SELECT 
    x, 
    y, 
    z, 
    CASE 
        WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM 
    Triangle;
```
* **Advantages:** `CASE WHEN` is standard SQL and will work in PostgreSQL, SQL Server, Oracle, etc., whereas `IF()` is generally specific to MySQL.
* **Disadvantages:** Slightly more verbose.

---

## 17. Time Complexity
**O(N)**. The database simply reads each row once and performs constant-time O(1) basic arithmetic. Very fast.

---

## 18. Common Mistakes
* **Using `>=` instead of `>`:** The theorem requires the sum of two sides to be *strictly greater* than the third side. If `x + y = z`, you have a flat line, not a triangle.
* **Forgetting one of the combinations:** You must check all 3 combinations (`x+y`, `x+z`, `y+z`). Checking only two will fail tests.

---

## 19. Edge Cases
* **Negative side lengths:** Geometry dictates side lengths must be positive. If the table contained negative lengths (e.g., `-5, 10, 10`), `-5+10 > 10` is `5 > 10` which is False, so it correctly fails.

---

## 20. Interview Tips
* If you write the `IF()` solution, definitely mention that you know `CASE WHEN` is the ANSI standard way to do it across all databases. Interviewers love developers who know the difference between database-specific features and universally portable SQL.

---

## 21. Similar LeetCode Problems
* 1731. The Number of Employees Which Report to Each Employee (Math in SQL)
* 1873. Calculate Special Bonus (Uses IF / CASE)

---

## 22. Key Takeaways
* Use `IF(condition, 'T', 'F')` in MySQL for clean, binary logic.
* Use `CASE WHEN ... THEN ... ELSE ... END` for complex logic or when you need cross-database portability.

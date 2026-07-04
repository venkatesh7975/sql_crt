# Problem 11 – Employee Bonus

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* LEFT JOIN
* WHERE
* OR
* IS NULL

---

## 3. Pattern
Join / Null Filtering

---

## 4. Problem Statement
We need to report the name and bonus amount of each employee who has a bonus less than 1000. If an employee did not receive any bonus, they should also be included in the report.

---

## 5. Tables

Table: Employee

| Column     | Type    |
| ---------- | ------- |
| empId      | INT     |
| name       | VARCHAR |
| supervisor | INT     |
| salary     | INT     |

* `empId` is the primary key.
* This table indicates the employee's ID, name, supervisor ID, and salary.

Table: Bonus

| Column | Type |
| ------ | ---- |
| empId  | INT  |
| bonus  | INT  |

* `empId` is the primary key and a foreign key to the `Employee` table.
* This table contains the id of an employee and their respective bonus.

---

## 6. Sample Input

Employee table:

| empId | name   | supervisor | salary |
| ----- | ------ | ---------- | ------ |
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |

Bonus table:

| empId | bonus |
| ----- | ----- |
| 2     | 500   |
| 4     | 2000  |

---

## 7. Expected Output

| name | bonus |
| ---- | ----- |
| Brad | null  |
| John | null  |
| Dan  | 500   |

*(Thomas is excluded because his bonus is 2000, which is not less than 1000.)*

---

## 8. Understanding the Question
What information is being asked? The `name` and `bonus` amount.
What columns are important? `name` (from Employee) and `bonus` (from Bonus).
What conditions matter? The bonus must be `< 1000`, OR the employee has no bonus at all (which means the bonus is `NULL`).
What should be returned? `name`, `bonus`.

---

## 9. Thinking Process
1. We need information from both tables (name from Employee, bonus from Bonus). This requires a `JOIN`.
2. Because the problem explicitly says we need to include employees who *did not receive a bonus*, we cannot use an `INNER JOIN`. An `INNER JOIN` would drop Brad and John entirely since they aren't in the Bonus table.
3. Therefore, we must use a `LEFT JOIN` starting from the `Employee` table. This ensures Brad and John are kept, and their missing bonus is filled with `NULL`.
4. Now we need to filter the results based on the condition: "bonus less than 1000". We write `WHERE bonus < 1000`.
5. **The Trap:** Just like in Problem 2 (Find Customer Referee), if we only write `WHERE bonus < 1000`, what happens to Brad and John? Their bonus is `NULL`. `NULL < 1000` evaluates to UNKNOWN (False). Brad and John would be incorrectly dropped!
6. To fix this, we must explicitly include the NULLs: `WHERE bonus < 1000 OR bonus IS NULL`.

---

## 10. Approach 1 (Optimal)
LEFT JOIN with explicit NULL handling

Attach the bonus data to all employees, then filter for those who either have a small bonus or no bonus record at all.

---

## 11. SQL Solution

```sql
-- Retrieve name and bonus for those with bonus < 1000 or no bonus
SELECT 
    e.name, 
    b.bonus
FROM 
    Employee e
LEFT JOIN 
    Bonus b 
    ON e.empId = b.empId
WHERE 
    b.bonus < 1000 
    OR b.bonus IS NULL;
```

---

## 12. Step-by-Step Dry Run
1. **LEFT JOIN:**
   * Brad (3) -> No match in Bonus. Bonus becomes `NULL`.
   * John (1) -> No match in Bonus. Bonus becomes `NULL`.
   * Dan (2) -> Match! Bonus is `500`.
   * Thomas (4) -> Match! Bonus is `2000`.
2. **WHERE clause:**
   * Brad: `NULL < 1000` (False) OR `NULL IS NULL` (True). -> **Keep**.
   * John: `NULL < 1000` (False) OR `NULL IS NULL` (True). -> **Keep**.
   * Dan: `500 < 1000` (True) OR `500 IS NULL` (False). -> **Keep**.
   * Thomas: `2000 < 1000` (False) OR `2000 IS NULL` (False). -> **Drop**.

---

## 13. SQL Execution Order
1. **FROM Employee e:** Base table selected.
2. **LEFT JOIN Bonus b:** Attach bonus data; keep all employees regardless of match.
3. **WHERE ... OR ...:** Filter the mega-table to remove high earners.
4. **SELECT e.name, b.bonus:** Output final requested columns.

---

## 14. Query Breakdown
* **LEFT JOIN:** The absolute key to this problem. Without it, the query fails on step 1.
* **b.bonus < 1000:** The standard mathematical filter.
* **OR b.bonus IS NULL:** The "catch-all" to ensure `LEFT JOIN`'s unmatched rows aren't destroyed by the `WHERE` clause.

---

## 15. Why This Solution Works
It respects the rules of 3-valued logic in SQL (True, False, Unknown) regarding `NULL` comparisons. By using `LEFT JOIN` we expose the missing data as `NULL`, and by explicitly checking for `IS NULL`, we safely rescue those rows.

---

## 16. Alternative Solution
Using `IFNULL()` or `COALESCE()`

```sql
SELECT 
    e.name, 
    b.bonus
FROM 
    Employee e
LEFT JOIN 
    Bonus b 
    ON e.empId = b.empId
WHERE 
    IFNULL(b.bonus, 0) < 1000;
```
* **Advantages:** Shorter and arguably reads slightly more like English ("If the bonus is missing, treat it as 0, then check if it's less than 1000").
* **Disadvantages:** As mentioned in previous problems, wrapping a column in a function (`IFNULL(b.bonus)`) inside a `WHERE` clause makes it *non-sargable* (indexes cannot be used). Approach 1 is fundamentally better for performance.

---

## 17. Time Complexity
**O(N)** where N is the number of employees. The `LEFT JOIN` uses an index lookup on `Bonus.empId` (since it's a primary key), making the join very fast.

---

## 18. Common Mistakes
* **Using `INNER JOIN`:** Automatically drops Brad and John.
* **Forgetting `OR bonus IS NULL`:** Drops Brad and John during the `WHERE` phase because `NULL < 1000` evaluates to Unknown.
* **Using `bonus = NULL`:** Standard beginner mistake. Nothing equals NULL. Use `IS NULL`.

---

## 19. Edge Cases
* **Negative bonuses:** Mathematically, `-500 < 1000` is True, so they are kept. (Logically unlikely in business, but syntactically sound).
* **Bonus exactly 1000:** The prompt says *less than* 1000. So exactly 1000 is correctly dropped.

---

## 20. Interview Tips
* If you see "missing data" or "did not receive" in a prompt, instantly think `LEFT JOIN`.
* If you write a `WHERE` clause filtering a column that came from the right side of a `LEFT JOIN`, instantly ask yourself: "Wait, what will this `WHERE` clause do to the `NULL`s?"

---

## 21. Similar LeetCode Problems
* 584. Find Customer Referee
* 1378. Replace Employee ID With The Unique Identifier

---

## 22. Key Takeaways
* `LEFT JOIN` preserves unmatched rows on the left.
* Any comparison operator (`<`, `>`, `=`, `!=`) against a `NULL` results in `UNKNOWN`.
* Always use `IS NULL` to explicitly target missing data.

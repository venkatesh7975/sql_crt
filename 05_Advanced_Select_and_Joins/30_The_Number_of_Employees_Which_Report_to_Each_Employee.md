# Problem 30 – The Number of Employees Which Report to Each Employee

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Self JOIN (`INNER JOIN`)
* GROUP BY
* Aggregate Functions (`COUNT`, `ROUND`, `AVG`)
* ORDER BY

---

## 3. Pattern
Self Join with Aggregation

---

## 4. Problem Statement
We need to report the IDs and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
A **manager** is an employee who has at least one other employee reporting to them.
The result must be returned ordered by `employee_id`.

---

## 5. Tables

Table: Employees

| Column      | Type    |
| ----------- | ------- |
| employee_id | INT     |
| name        | VARCHAR |
| reports_to  | INT     |
| age         | INT     |

* `employee_id` is the primary key.
* `reports_to` contains the `employee_id` of the manager. It is NULL if the employee does not report to anyone.

---

## 6. Sample Input

Employees table:

| employee_id | name    | reports_to | age |
| ----------- | ------- | ---------- | --- |
| 9           | Hercy   | null       | 43  |
| 6           | Alice   | 9          | 41  |
| 4           | Bob     | 9          | 36  |
| 2           | Winston | null       | 37  |

---

## 7. Expected Output

| employee_id | name  | reports_count | average_age |
| ----------- | ----- | ------------- | ----------- |
| 9           | Hercy | 2             | 39          |

*(Hercy (ID 9) has 2 people reporting to him: Alice (41) and Bob (36). The average age is (41 + 36) / 2 = 38.5, which rounds to 39).*

---

## 8. Understanding the Question
What information is being asked? Manager's ID, Manager's name, count of their direct reports, and the average age of those reports.
What columns are important? `employee_id`, `name`, `reports_to`, `age`.
What conditions matter? The output must only contain managers (people who have > 0 reports). Sort by `employee_id`. Round the average age to 0 decimal places.
What should be returned? `employee_id`, `name`, `reports_count`, `average_age`.

---

## 9. Thinking Process
1. Since employees and managers are in the *same table*, I need to link an employee's `reports_to` column to a manager's `employee_id` column. This requires a **Self Join**.
2. Let's create two aliases: `m` (Managers) and `e` (Employees).
3. The join condition is: `m.employee_id = e.reports_to`.
4. I want to calculate metrics *per manager*. Therefore, I must `GROUP BY m.employee_id`. I should also include `m.name` in the `GROUP BY` to satisfy strict SQL rules (since I'll be selecting it).
5. **Metric 1:** Number of direct reports. `COUNT(e.employee_id) AS reports_count`.
6. **Metric 2:** Average age of reports. `AVG(e.age)`. The prompt says "rounded to the nearest integer". So `ROUND(AVG(e.age), 0) AS average_age`.
7. Finally, sort the output by `m.employee_id` in ascending order.

---

## 10. Approach 1 (Optimal)
Self INNER JOIN and GROUP BY

Join the table to itself to establish the manager-subordinate relationship, group the data by the manager, and aggregate the subordinate data.

---

## 11. SQL Solution

```sql
-- Calculate report counts and average report age for each manager
SELECT 
    m.employee_id, 
    m.name, 
    COUNT(e.employee_id) AS reports_count, 
    ROUND(AVG(e.age), 0) AS average_age
FROM 
    Employees m
JOIN 
    Employees e 
    ON m.employee_id = e.reports_to
GROUP BY 
    m.employee_id, 
    m.name
ORDER BY 
    m.employee_id;
```

---

## 12. Step-by-Step Dry Run
1. **Self Join Setup:**
   * Employee `e` (ID 6, Alice, reports_to=9, age=41) joins with Manager `m` (ID 9, Hercy).
   * Employee `e` (ID 4, Bob, reports_to=9, age=36) joins with Manager `m` (ID 9, Hercy).
   * Employees 9 and 2 do not have a `reports_to` matching any valid ID (they are null), so they do not join as subordinates.
   * No employees report to 6, 4, or 2, so they do not join as managers.
2. **GROUP BY m.employee_id, m.name:**
   * Manager `9, Hercy` has one group containing the records of Alice and Bob.
3. **Aggregations:**
   * `COUNT(e.employee_id)` = Count of Alice and Bob = 2.
   * `AVG(e.age)` = `(41 + 36) / 2` = 38.5. `ROUND(38.5, 0)` = 39.
4. **ORDER BY:**
   * Sorted by manager's ID. (Only 9 in this case).

---

## 13. SQL Execution Order
1. **FROM Employees m JOIN Employees e:** The self-join pairs up the related rows. Unrelated rows are dropped.
2. **GROUP BY m.employee_id, m.name:** Groups the paired rows based on the manager's identity.
3. **SELECT:** Computes the count and average for each manager.
4. **ORDER BY:** Sorts the final table.

---

## 14. Query Breakdown
* **FROM Employees m JOIN Employees e:** Using `INNER JOIN` is intentional here! An `INNER JOIN` automatically drops any managers who have 0 reports, and drops any employees who don't report to anyone. This perfectly satisfies the rule "A manager is an employee who has at least one other employee reporting to them".
* **ROUND(..., 0):** The `0` specifies zero decimal places (the nearest integer). In MySQL, `ROUND(x)` without the `0` defaults to 0 decimal places, but explicitly including it is best practice.
* **GROUP BY m.employee_id, m.name:** If you `SELECT` a non-aggregated column (like `name`), you must include it in the `GROUP BY`.

---

## 15. Why This Solution Works
Self-joins are the textbook solution for hierarchical (tree) data stored in a single table, like employee-manager relationships.

---

## 16. Alternative Solution
Using a Subquery in the FROM clause

```sql
SELECT 
    e1.employee_id, 
    e1.name, 
    reports.reports_count, 
    reports.average_age
FROM 
    Employees e1
JOIN (
    SELECT 
        reports_to, 
        COUNT(employee_id) AS reports_count, 
        ROUND(AVG(age), 0) AS average_age
    FROM Employees
    WHERE reports_to IS NOT NULL
    GROUP BY reports_to
) AS reports ON e1.employee_id = reports.reports_to
ORDER BY e1.employee_id;
```
* **Advantages:** It separates the aggregation logic from the manager-lookup logic. It groups the subordinates first, then joins the result back to the table to get the manager's name.
* **Disadvantages:** Slightly more verbose than a standard self-join.

---

## 17. Time Complexity
**O(N log N)** or **O(N)**. The self-join performs a lookup for every employee's `reports_to` against the `employee_id` column. If `employee_id` is indexed (as a primary key, it is), this is extremely fast. 

---

## 18. Common Mistakes
* **Joining backwards:** Writing `ON m.reports_to = e.employee_id`. If you do this, you are treating `m` as the subordinate and `e` as the manager, but your SELECT clause assumes `m` is the manager! Always map it out mentally: `manager_id = subordinate.reports_to`.
* **Using `LEFT JOIN`:** A `LEFT JOIN` would include all employees, even those with zero reports, resulting in null/0 aggregations which breaks the prompt's rules.
* **Forgetting `m.name` in GROUP BY:** Strict SQL environments will throw an `ONLY_FULL_GROUP_BY` error.

---

## 19. Edge Cases
* **A manager reports to a higher manager:** The query handles this flawlessly. They will act as a subordinate (`e`) in one grouping, and act as a manager (`m`) in another grouping.
* **Employee age is null:** The `AVG()` function automatically ignores `NULL` values.

---

## 20. Interview Tips
* If an interviewer presents a table with an ID and a "Parent ID" (e.g., categories, employees, folders), immediately recognize it as hierarchical data requiring a **Self-Join** or a Recursive CTE.

---

## 21. Similar LeetCode Problems
* 181. Employees Earning More Than Their Managers
* 570. Managers with at Least 5 Direct Reports

---

## 22. Key Takeaways
* Use a **Self Join** (`table a JOIN table b ON a.id = b.parent_id`) to analyze hierarchical data in SQL.
* `INNER JOIN` acts as a filter, naturally discarding leaves (nodes with no children) when looking for parents.

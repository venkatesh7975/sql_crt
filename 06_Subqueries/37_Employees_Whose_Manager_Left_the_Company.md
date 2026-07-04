# Problem 37 – Employees Whose Manager Left the Company

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Subquery with `NOT IN`
* Multiple WHERE conditions
* ORDER BY

---

## 3. Pattern
Anti-Join / Subquery Filtering

---

## 4. Problem Statement
Find the IDs of the employees whose salary is strictly less than `$30000` and whose manager left the company. 
When a manager leaves the company, their information is deleted from the `Employees` table, but the reports still have their `manager_id` set to the manager that left.
Return the result table ordered by `employee_id`.

---

## 5. Tables

Table: Employees

| Column      | Type    |
| ----------- | ------- |
| employee_id | INT     |
| name        | VARCHAR |
| manager_id  | INT     |
| salary      | INT     |

* `employee_id` is the primary key.
* This table contains information about the employees, their salary, and the ID of their manager. Some employees do not have a manager (in which case `manager_id` is null).

---

## 6. Sample Input

Employees table:

| employee_id | name      | manager_id | salary |
| ----------- | --------- | ---------- | ------ |
| 3           | Mila      | 9          | 60301  |
| 12          | Antonella | null       | 31000  |
| 13          | Emery     | null       | 67084  |
| 1           | Kalel     | 11         | 21241  |
| 9           | Mikaela   | null       | 50937  |
| 11          | Joziah    | 6          | 28485  |

---

## 7. Expected Output

| employee_id |
| ----------- |
| 11          |

*(Employee 1 (Kalel) has salary < 30000, and manager_id = 11. Manager 11 exists in the table. So Kalel's manager has not left).*
*(Employee 11 (Joziah) has salary < 30000, and manager_id = 6. Manager 6 is completely missing from the table! So Joziah's manager left the company).*

---

## 8. Understanding the Question
What information is being asked? The IDs of specific employees.
What columns are important? `employee_id`, `manager_id`, `salary`.
What conditions matter? 
1. `salary < 30000`.
2. `manager_id` is not null.
3. The `manager_id` does NOT exist in the `employee_id` column of the table.
What should be returned? `employee_id`, sorted.

---

## 9. Thinking Process
1. I need to filter the `Employees` table. Let's start with the easy condition: `WHERE salary < 30000`.
2. Next condition: The manager must have left. How do I know if they left? Their ID won't exist in the table anymore.
3. I can use a subquery to get a list of all currently active employees: `SELECT employee_id FROM Employees`.
4. Then, I can check if the current row's `manager_id` is NOT in that list: `AND manager_id NOT IN (SELECT employee_id FROM Employees)`.
5. Finally, I need to order the output: `ORDER BY employee_id`.

---

## 10. Approach 1 (Optimal)
Subquery with NOT IN

Filter the table for the salary condition, and use a `NOT IN` subquery to ensure the `manager_id` does not match any existing employee ID.

---

## 11. SQL Solution

```sql
-- Find low-salary employees whose manager's ID no longer exists in the table
SELECT 
    employee_id
FROM 
    Employees
WHERE 
    salary < 30000 
    AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY 
    employee_id;
```

---

## 12. Step-by-Step Dry Run
1. **Subquery Execution:**
   * Gets all active employee IDs: `[3, 12, 13, 1, 9, 11]`.
2. **Main Query Evaluation (Row by Row):**
   * Row 3 (Mila): Salary 60k is not < 30k. (Drop)
   * Row 12 (Antonella): Salary 31k is not < 30k. (Drop)
   * Row 13 (Emery): Salary 67k is not < 30k. (Drop)
   * Row 1 (Kalel): Salary 21k < 30k (Pass). Is `manager_id` (11) NOT IN `[3, 12, 13, 1, 9, 11]`? **False.** It is in the list. (Drop)
   * Row 9 (Mikaela): Salary 50k is not < 30k. (Drop)
   * Row 11 (Joziah): Salary 28k < 30k (Pass). Is `manager_id` (6) NOT IN `[3, 12, 13, 1, 9, 11]`? **True.** (Keep)
3. **ORDER BY:**
   * Sort surviving IDs. Only `[11]` survives.

---

## 13. SQL Execution Order
1. **Subquery:** Executes and caches the list of valid employee IDs.
2. **FROM Employees:** Scans the table.
3. **WHERE:** Checks the salary and validates the `manager_id` against the cached list.
4. **SELECT:** Extracts the `employee_id`.
5. **ORDER BY:** Sorts the final result.

---

## 14. Query Breakdown
* **NOT IN (SELECT...):** The standard Anti-Join pattern in SQL. It checks if a value is entirely missing from a specified list. 
* **NULL handling:** If an employee has no manager (`manager_id IS NULL`), `NULL NOT IN (list)` evaluates to `NULL` (which acts as False in a WHERE clause). This automatically filters out people like Antonella who just don't have a manager at all.

---

## 15. Why This Solution Works
This is a textbook "Anti-Join". We are looking for orphaned records (records pointing to a foreign key that no longer exists). `NOT IN` is specifically designed for this.

---

## 16. Alternative Solution
Using a LEFT JOIN (The Anti-Join Pattern)

```sql
SELECT 
    e.employee_id
FROM 
    Employees e
LEFT JOIN 
    Employees m ON e.manager_id = m.employee_id
WHERE 
    e.salary < 30000 
    AND e.manager_id IS NOT NULL 
    AND m.employee_id IS NULL
ORDER BY 
    e.employee_id;
```
* **Advantages:** On some older database engines, `LEFT JOIN ... WHERE NULL` is faster than `NOT IN`.
* **Disadvantages:** Much longer to write. You have to explicitly check `e.manager_id IS NOT NULL`, otherwise the `LEFT JOIN` will successfully join null to null (or fail to match) and accidentally include employees who just don't have a manager.

---

## 17. Time Complexity
**O(N)**. Most modern SQL engines will optimize `NOT IN` into a Hash Anti-Join, allowing the query to run in a single pass without re-evaluating the subquery for every row.

---

## 18. Common Mistakes
* **Forgetting `salary < 30000`:** Skipping half the problem statement.
* **Using `!=` instead of `NOT IN`:** You cannot write `manager_id != (SELECT...)` because the subquery returns multiple rows. `!=` only works against a single scalar value.

---

## 19. Edge Cases
* **Employee has no manager (null):** Handled gracefully by `NOT IN`. `NULL NOT IN (...)` evaluates to UNKNOWN, which fails the `WHERE` clause condition.
* **Empty table:** Returns empty set.

---

## 20. Interview Tips
* `NOT IN` vs `NOT EXISTS`: If the subquery can return `NULL` values, `NOT IN` can break unexpectedly. In this case, `employee_id` is a primary key, so it cannot be `NULL`. Thus, `NOT IN` is perfectly safe here. Mentioning this distinction is a massive green flag for interviewers.

---

## 21. Similar LeetCode Problems
* 196. Delete Duplicate Emails
* 1084. Sales Analysis III

---

## 22. Key Takeaways
* Use `NOT IN (SELECT...)` to find orphaned records (e.g., "Find X whose Y no longer exists").
* `NULL NOT IN (anything)` evaluates to Unknown/False, safely excluding rows with `NULL` foreign keys.

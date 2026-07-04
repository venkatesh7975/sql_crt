# Problem 31 – Primary Department for Each Employee

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* UNION
* Window Functions (`COUNT() OVER()`) [Alternative Approach]
* GROUP BY and HAVING [Alternative Approach]

---

## 3. Pattern
Multi-condition Filtering / UNION

---

## 4. Problem Statement
Employees can belong to multiple departments. When an employee belongs to multiple departments, exactly one of them is marked as their **primary** department (`primary_flag = 'Y'`).
If an employee belongs to only **one** department, that department is their primary department by default (even if `primary_flag = 'N'`).
Write a query to report all employees and their primary department.

---

## 5. Tables

Table: Employee

| Column        | Type    |
| ------------- | ------- |
| employee_id   | INT     |
| department_id | INT     |
| primary_flag  | VARCHAR |

* `(employee_id, department_id)` is the primary key.
* `primary_flag` is an ENUM of type ('Y', 'N').

---

## 6. Sample Input

Employee table:

| employee_id | department_id | primary_flag |
| ----------- | ------------- | ------------ |
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |

---

## 7. Expected Output

| employee_id | department_id |
| ----------- | ------------- |
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |

*(Employee 1: Only in dept 1. -> Dept 1)*
*(Employee 2: In depts 1 and 2. Primary flag is Y for dept 1. -> Dept 1)*
*(Employee 3: Only in dept 3. -> Dept 3)*
*(Employee 4: In depts 2, 3, 4. Primary flag is Y for dept 3. -> Dept 3)*

---

## 8. Understanding the Question
What information is being asked? The `employee_id` and their one true `department_id`.
What conditions matter? There are two totally separate rules for finding the primary department:
1. If the row has `primary_flag = 'Y'`, it's the primary department.
2. If the employee ONLY has ONE row in the table, that row is the primary department, regardless of the flag.
What should be returned? `employee_id`, `department_id`.

---

## 9. Thinking Process
1. I have two distinct business rules. It is often easiest to solve them separately and combine the results.
2. **Rule 1 (Explicit Primary):** Find all rows where `primary_flag = 'Y'`. 
   `SELECT employee_id, department_id FROM Employee WHERE primary_flag = 'Y'`
3. **Rule 2 (Single Department):** Find all employees who only have one row. I can do this by grouping by employee and filtering for a count of 1.
   `SELECT employee_id, department_id FROM Employee GROUP BY employee_id HAVING COUNT(department_id) = 1`
4. **Combine:** Because an employee who triggers Rule 2 (count = 1) will *never* trigger Rule 1 (because their flag is 'N' in the test cases, otherwise they'd trigger both, which is fine), we can simply stack these two result sets on top of each other using a `UNION`.
5. Since we just want the rows to merge cleanly, `UNION` (which removes duplicates just in case) or `UNION ALL` (faster) works perfectly.

---

## 10. Approach 1 (Optimal)
UNION of Two Queries

Solve the two logic conditions independently and join their result sets using `UNION`.

---

## 11. SQL Solution

```sql
-- Find explicit primary departments
SELECT 
    employee_id, 
    department_id
FROM 
    Employee
WHERE 
    primary_flag = 'Y'

UNION

-- Find implicit primary departments (employees with only 1 department)
SELECT 
    employee_id, 
    department_id
FROM 
    Employee
GROUP BY 
    employee_id
HAVING 
    COUNT(department_id) = 1;
```

---

## 12. Step-by-Step Dry Run
1. **Query 1 (WHERE primary_flag = 'Y'):**
   * Checks table. Finds Employee 2 (Dept 1) and Employee 4 (Dept 3).
   * Result 1: `[(2, 1), (4, 3)]`.
2. **Query 2 (GROUP BY HAVING COUNT = 1):**
   * Group 1: Count = 1. Keep `(1, 1)`.
   * Group 2: Count = 2. Drop.
   * Group 3: Count = 1. Keep `(3, 3)`.
   * Group 4: Count = 3. Drop.
   * Result 2: `[(1, 1), (3, 3)]`.
3. **UNION:**
   * Combines Result 1 and Result 2 into a single table: `[(2,1), (4,3), (1,1), (3,3)]`.

---

## 13. SQL Execution Order
1. **Top Query:** Executes and stores its result.
2. **Bottom Query:** Executes (with its own FROM, GROUP BY, HAVING) and stores its result.
3. **UNION:** Merges the two sets into the final output.

---

## 14. Query Breakdown
* **UNION:** Appends the results of one query to the results of another. The two queries must have the exact same number of columns, and the columns must have matching data types.
* **HAVING COUNT(...) = 1:** The standard way to identify "singleton" records (entities that only appear once).

---

## 15. Why This Solution Works
It breaks a complex "OR" condition into two simple, highly optimized queries. This approach is readable, easy to debug, and avoids complicated subqueries.

---

## 16. Alternative Solution 1
Using Window Functions (One Pass)

```sql
SELECT employee_id, department_id
FROM (
    SELECT 
        employee_id, 
        department_id, 
        primary_flag,
        COUNT(department_id) OVER(PARTITION BY employee_id) as dept_count
    FROM Employee
) AS dept_counts
WHERE primary_flag = 'Y' OR dept_count = 1;
```
* **Advantages:** It only scans the `Employee` table once. `COUNT() OVER()` tags every row with the total number of departments that employee has. The outer `WHERE` clause elegantly handles both rules.
* **Disadvantages:** Window functions can be slightly intimidating for beginners, but this is a beautiful use case for them.

---

## 17. Alternative Solution 2
Using a Subquery IN clause (Clean but slower)

```sql
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y' 
   OR employee_id IN (
       SELECT employee_id 
       FROM Employee 
       GROUP BY employee_id 
       HAVING COUNT(department_id) = 1
   );
```
* **Advantages:** Uses standard SQL without `UNION`.
* **Disadvantages:** The `IN` subquery is slower than a `UNION` because the database has to execute the subquery and then evaluate it for every row in the outer query.

---

## 18. Time Complexity
**O(N)**. For the `UNION` approach, scanning for 'Y' is O(N) and grouping by `employee_id` is O(N). Two linear scans are extremely fast. The Window Function approach is also **O(N)**.

---

## 19. Common Mistakes
* **Grouping by `employee_id` in the main query without a subquery:**
  ```sql
  SELECT employee_id, department_id FROM Employee WHERE primary_flag = 'Y' OR ... GROUP BY ...
  ```
  *You cannot easily mix standard row filtering and aggregate filtering (`HAVING`) in the exact same `SELECT` without a `UNION` or a Window Function.*

---

## 20. Interview Tips
* Whenever a business rule says "Do X if Condition A is true, OR do Y if Condition B is true", a `UNION` is almost always the easiest and safest way to write the query, even if it requires typing slightly more code.

---

## 21. Similar LeetCode Problems
* 586. Customer Placing the Largest Number of Orders
* 1084. Sales Analysis III

---

## 22. Key Takeaways
* Use `UNION` to cleanly solve problems that have two completely distinct and non-overlapping logical conditions.
* Use `HAVING COUNT(id) = 1` to find isolated, single-occurrence entities.
* `COUNT() OVER(PARTITION BY col)` is a powerful way to attach an aggregate count to every row without collapsing the table.

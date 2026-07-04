# Problem 13 – Managers with at Least 5 Direct Reports

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* INNER JOIN / SELF JOIN
* GROUP BY
* HAVING
* Aggregate Functions (COUNT)

---

## 3. Pattern
Self Join / Grouping / Having Filtering

---

## 4. Problem Statement
We need to find the names of all managers who have at least 5 direct reports.

---

## 5. Tables

Table: Employee

| Column     | Type    |
| ---------- | ------- |
| id         | INT     |
| name       | VARCHAR |
| department | VARCHAR |
| managerId  | INT     |

* `id` is the primary key.
* Each row indicates the name of an employee, their department, and the id of their manager.
* If `managerId` is null, then the employee does not have a manager.
* No employee will be the manager of themself.

---

## 6. Sample Input

Employee table:

| id  | name  | department | managerId |
| --- | ----- | ---------- | --------- |
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |

---

## 7. Expected Output

| name |
| ---- |
| John |

*(John manages Dan, James, Amy, Anne, and Ron. That's 5 reports, so John is included.)*

---

## 8. Understanding the Question
What information is being asked? The `name` of the managers.
What columns are important? `id`, `name`, and `managerId`.
What conditions matter? The count of employees reporting to a specific manager must be `>= 5`.
What should be returned? Just the `name` column.

---

## 9. Thinking Process
1. We only have one table, but we have two "types" of people in it: Employees and Managers. To link an employee to their manager's details (like the manager's name), we must perform a **Self Join**.
2. Let's call the left table `e` (for the standard Employee) and the right table `m` (for the Manager).
3. We join them using `e.managerId = m.id`. This pairs every employee with their direct boss.
4. Now we need to count how many employees are assigned to each boss. This requires `GROUP BY m.id`. (It's safer to group by the manager's ID rather than the manager's name, because two managers might have the same name).
5. Once grouped, we count the employees: `COUNT(e.id)`.
6. We need to filter based on this aggregate count. Can we use `WHERE COUNT(e.id) >= 5`? **NO.** The `WHERE` clause evaluates *before* grouping occurs. To filter *after* grouping, we must use the `HAVING` clause.
7. Finally, we select the manager's name (`m.name`) in the `SELECT` clause.

---

## 10. Approach 1 (Optimal)
Self Join with GROUP BY and HAVING

Join the employees to their managers, bucket the records by manager, and filter out any bucket that doesn't contain at least 5 employees.

---

## 11. SQL Solution

```sql
-- Retrieve names of managers with >= 5 direct reports
SELECT 
    m.name
FROM 
    Employee e
JOIN 
    Employee m 
    ON e.managerId = m.id
GROUP BY 
    m.id, 
    m.name
HAVING 
    COUNT(e.id) >= 5;
```

---

## 12. Step-by-Step Dry Run
1. **JOIN `e` and `m`:**
   * e(Dan) points to m(John).
   * e(James) points to m(John).
   * e(Amy) points to m(John).
   * e(Anne) points to m(John).
   * e(Ron) points to m(John).
2. **GROUP BY `m.id`, `m.name`:**
   * A single bucket is created for Manager `101 (John)`.
3. **HAVING `COUNT(e.id) >= 5`:**
   * John's bucket has 5 employee IDs inside it.
   * `5 >= 5` is True. Keep John's bucket.
4. **SELECT:**
   * Extract `m.name` (John) from the surviving buckets.

---

## 13. SQL Execution Order
1. **FROM e JOIN m:** Creates mega-rows linking subordinates to their bosses.
2. **GROUP BY:** Organizes these mega-rows into piles (one pile per boss).
3. **HAVING:** Throws away any pile that is too small.
4. **SELECT:** Picks the required label (`name`) from the remaining piles.

---

## 14. Query Breakdown
* **Self Join (`e` and `m`):** Standard technique for hierarchical data (like org charts).
* **GROUP BY m.id, m.name:** We group by `id` to ensure unique managers are isolated. We include `name` because standard SQL requires selected non-aggregate columns to be in the `GROUP BY` list.
* **HAVING:** The only way to filter based on the result of an aggregate function like `COUNT`, `SUM`, or `AVG`.

---

## 15. Why This Solution Works
It correctly separates the logic of linking the hierarchy (JOIN) from the logic of counting and filtering the hierarchy (GROUP BY / HAVING). 

---

## 16. Alternative Solution
Using a Subquery and `IN`

```sql
SELECT name 
FROM Employee 
WHERE id IN (
    SELECT managerId 
    FROM Employee 
    GROUP BY managerId 
    HAVING COUNT(id) >= 5
);
```
* **Advantages:** Extremely readable. It reads just like English: "Select names where the ID is in the list of managers who have >= 5 reports."
* **Disadvantages:** Depending on the database version, `IN` subqueries can sometimes be slower than an `INNER JOIN`. However, in modern MySQL, the optimizer executes both identically. This is an excellent alternative.

---

## 17. Time Complexity
**O(N)** where N is the number of rows. The database scans the table, uses the primary key index for the join, and performs a rapid hash-based grouping.

---

## 18. Common Mistakes
* **Using `WHERE` instead of `HAVING`:** `WHERE COUNT(id) >= 5` will throw a syntax error. `WHERE` filters rows *before* aggregation. `HAVING` filters groups *after* aggregation.
* **Grouping by Manager Name instead of ID:** If there are two managers named "John Smith", `GROUP BY m.name` will combine their reports together! Always group by Primary Keys.
* **Getting the JOIN backwards:** `ON m.managerId = e.id` would look for people who the *manager* reports to, which is backwards. Always trace the logic: "The employee's managerId must equal the manager's actual id".

---

## 19. Edge Cases
* **A manager has exactly 5 reports:** Handled correctly by `>=`.
* **No managers have 5 reports:** Returns an empty set.
* **A manager manages themselves:** The prompt promises this won't happen, but if it did, the logic still works.

---

## 20. Interview Tips
* This is the quintessential `HAVING` clause interview question.
* It is also the quintessential `Self Join` interview question.
* Mastering this exact query template will solve dozens of similar questions ("users with at least 3 orders", "products bought by at least 10 people", etc.).

---

## 21. Similar LeetCode Problems
* 570. Managers with at Least 5 Direct Reports (This one!)
* 1112. Highest Grade For Each Student

---

## 22. Key Takeaways
* **Self Joins** map hierarchical data.
* Use **`HAVING`**, not `WHERE`, to filter on aggregate functions (like `COUNT`, `AVG`).
* Always `GROUP BY` an ID, not a Name, to prevent merging distinct individuals who share a name.

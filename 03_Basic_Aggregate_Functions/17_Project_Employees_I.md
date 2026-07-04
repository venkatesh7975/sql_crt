# Problem 17 – Project Employees I

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* INNER JOIN
* GROUP BY
* Aggregate Functions (`AVG`)
* ROUND()

---

## 3. Pattern
Join with Aggregation

---

## 4. Problem Statement
We need to calculate the average `experience_years` of all employees working on each project. The average should be rounded to 2 decimal places.

---

## 5. Tables

Table: Project

| Column      | Type |
| ----------- | ---- |
| project_id  | INT  |
| employee_id | INT  |

* `(project_id, employee_id)` is the primary key.
* This table lists which employees are assigned to which projects.

Table: Employee

| Column           | Type    |
| ---------------- | ------- |
| employee_id      | INT     |
| name             | VARCHAR |
| experience_years | INT     |

* `employee_id` is the primary key.
* This table contains information about the employees.

---

## 6. Sample Input

Project table:

| project_id  | employee_id |
| ----------- | ----------- |
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |

Employee table:

| employee_id | name   | experience_years |
| ----------- | ------ | ---------------- |
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 1                |
| 4           | Doe    | 2                |

---

## 7. Expected Output

| project_id  | average_years |
| ----------- | ------------- |
| 1           | 2.00          |
| 2           | 2.50          |

*(Project 1: Khaled(3) + Ali(2) + John(1) = 6 / 3 = 2.00)*
*(Project 2: Khaled(3) + Doe(2) = 5 / 2 = 2.50)*

---

## 8. Understanding the Question
What information is being asked? The `project_id` and the average `experience_years`.
What columns are important? `project_id` (from Project) and `experience_years` (from Employee).
What conditions matter? Calculate the average *per project*. Round to 2 decimals.
What should be returned? `project_id`, `average_years`.

---

## 9. Thinking Process
1. I have project assignments in one table and employee details in another. I must join them to see the experience years of the people on the projects.
2. The common key is `employee_id`. Since an employee assigned to a project must exist in the Employee table, an `INNER JOIN` is perfectly fine.
3. The prompt asks for an aggregate calculation "per project". This is a massive clue to use `GROUP BY project_id`.
4. The calculation is a simple average of the experience years. I'll use `AVG(experience_years)`.
5. I need to format the result using `ROUND(..., 2)`.
6. Alias the column as `average_years`.

---

## 10. Approach 1 (Optimal)
INNER JOIN and GROUP BY

Join the tables, bucket the rows by project ID, and apply the `AVG` function to the experience column.

---

## 11. SQL Solution

```sql
-- Calculate average experience per project, rounded to 2 decimals
SELECT 
    p.project_id, 
    ROUND(AVG(e.experience_years), 2) AS average_years
FROM 
    Project p
JOIN 
    Employee e 
    ON p.employee_id = e.employee_id
GROUP BY 
    p.project_id;
```

---

## 12. Step-by-Step Dry Run
1. **JOIN Phase:**
   * Project 1, Emp 1 -> Exp: 3
   * Project 1, Emp 2 -> Exp: 2
   * Project 1, Emp 3 -> Exp: 1
   * Project 2, Emp 1 -> Exp: 3
   * Project 2, Emp 4 -> Exp: 2
2. **GROUP BY `project_id`:**
   * Project 1 bucket: [3, 2, 1]
   * Project 2 bucket: [3, 2]
3. **AVG() & ROUND():**
   * Project 1: `AVG(3,2,1)` = `2.0`. `ROUND(2.0, 2)` = `2.00`.
   * Project 2: `AVG(3,2)` = `2.5`. `ROUND(2.5, 2)` = `2.50`.

---

## 13. SQL Execution Order
1. **FROM Project p JOIN Employee e:** Combine the tables.
2. **GROUP BY p.project_id:** Segregate the combined rows into project buckets.
3. **SELECT:** Calculate the average for each bucket and format it.

---

## 14. Query Breakdown
* **JOIN:** Standard inner join. We only care about employees actually assigned to projects.
* **AVG(e.experience_years):** Mathematically identical to `SUM(e.experience_years) / COUNT(e.experience_years)`.
* **ROUND(val, 2):** Ensures the result has exactly two decimal places.

---

## 15. Why This Solution Works
This is a textbook application of relational database concepts: link a junction table (Project) to a dimension table (Employee), and aggregate the metrics across a specific dimension.

---

## 16. Alternative Solution
Using a Correlated Subquery in the SELECT clause

```sql
SELECT 
    DISTINCT project_id, 
    ROUND(
        (SELECT AVG(experience_years) 
         FROM Employee e 
         WHERE e.employee_id = p.employee_id), 
    2) AS average_years
FROM 
    Project p;
```
* **Advantages:** None really in this specific case.
* **Disadvantages:** Correlated subqueries execute once for *every single row* in the outer query. If there are 10,000 assignments in `Project`, it runs 10,000 separate `SELECT AVG` queries. The `JOIN` approach is vastly superior for performance.

---

## 17. Time Complexity
**O(N)** where N is the number of rows in the `Project` table. The `JOIN` is an O(1) primary key lookup into the `Employee` table, and grouping is highly optimized.

---

## 18. Common Mistakes
* **Grouping by employee_id:** This calculates the average experience for each employee (which is just their own experience). You must group by what you want the output to be "per" (per project -> group by project).
* **Forgetting `ROUND`:** LeetCode will reject `2.5` if it expects `2.50`.

---

## 19. Edge Cases
* **Project with 1 employee:** Average is just that person's experience. Handled correctly.
* **Employee assigned to multiple projects:** Handled correctly (Khaled is in both projects in the sample, and his experience counts towards both averages).

---

## 20. Interview Tips
* This is a "warm-up" question. You should be able to write this in under 2 minutes.
* Be careful with aliases; using `p` and `e` makes the query much easier to read for the interviewer.

---

## 21. Similar LeetCode Problems
* 1068. Product Sales Analysis I
* 1251. Average Selling Price

---

## 22. Key Takeaways
* `AVG()` is a built-in aggregate function that saves you from writing `SUM()/COUNT()`.
* When a question asks for a metric "for each [X]", you almost always `GROUP BY [X]`.

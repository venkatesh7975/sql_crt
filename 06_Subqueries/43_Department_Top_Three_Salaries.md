# Problem 43 – Department Top Three Salaries

---

## 1. Difficulty
Hard

---

## 2. SQL Concepts Tested
* SELECT
* Window Functions (`DENSE_RANK() OVER()`)
* JOIN
* Subqueries / Derived Tables

---

## 3. Pattern
Top-N per Group (Ranking)

---

## 4. Problem Statement
A company's executives want to see who earns the most money in each department. 
A **high earner** is an employee who has a salary in the **top three unique salaries** for that department.
Write a SQL query to find the employees who are high earners in each of the departments. Return the result table in any order.

---

## 5. Tables

Table: Employee

| Column       | Type    |
| ------------ | ------- |
| id           | INT     |
| name         | VARCHAR |
| salary       | INT     |
| departmentId | INT     |

* `id` is the primary key.

Table: Department

| Column | Type    |
| ------ | ------- |
| id     | INT     |
| name   | VARCHAR |

* `id` is the primary key.

---

## 6. Sample Input

Employee table:

| id | name  | salary | departmentId |
| -- | ----- | ------ | ------------ |
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |

Department table:

| id | name  |
| -- | ----- |
| 1  | IT    |
| 2  | Sales |

---

## 7. Expected Output

| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

*(IT Dept Salaries: Max (90k, rank 1), Joe & Randy (85k, rank 2), Will (70k, rank 3), Janet (69k, rank 4). Ranks 1, 2, and 3 are returned, which includes 4 people due to the tie).*
*(Sales Dept Salaries: Henry (80k, rank 1), Sam (60k, rank 2). Both are returned).*

---

## 8. Understanding the Question
What information is being asked? The Department Name, Employee Name, and Salary for the top earners.
What columns are important? `e.name`, `e.salary`, `d.name`.
What conditions matter?
1. The grouping is *per department*.
2. We want the top *three* salaries.
3. Crucially, it says "top three *unique* salaries". If two people make the same amount (like Joe and Randy at 85k), they occupy the *same rank* (Rank 2). The person below them (Will) is Rank 3, not Rank 4.
What should be returned? `Department`, `Employee`, `Salary`.

---

## 9. Thinking Process
1. I need to join the `Employee` and `Department` tables so I have access to both the employee details and the department name.
2. I need to assign a numerical "Rank" to each employee's salary.
3. Because I need to rank them *within* their department, I must partition the ranking: `PARTITION BY d.name` or `d.id`.
4. The ranking needs to be based on salary descending: `ORDER BY e.salary DESC`.
5. Which Ranking function do I use?
   * `ROW_NUMBER()`: Gives 1, 2, 3, 4. (Fails because Joe and Randy would get 2 and 3, knocking Will out of the top 3).
   * `RANK()`: Gives 1, 2, 2, 4. (Fails because it skips Rank 3 after a tie, knocking Will out).
   * `DENSE_RANK()`: Gives 1, 2, 2, 3, 4. (Perfect! It assigns identical ranks to ties and does NOT skip the next number).
6. So, `DENSE_RANK() OVER(PARTITION BY d.id ORDER BY e.salary DESC) AS rnk`.
7. I'll put this joined and ranked data into a Subquery/CTE.
8. Finally, I will filter the outer query `WHERE rnk <= 3`.

---

## 10. Approach 1 (Optimal)
DENSE_RANK() Window Function

Use a derived table to assign a dense rank to every employee based on their salary within their department, then filter for ranks 1, 2, and 3.

---

## 11. SQL Solution

```sql
-- Find the top 3 unique salaries per department using Dense Rank
SELECT 
    Department, 
    Employee, 
    Salary
FROM (
    SELECT 
        d.name AS Department, 
        e.name AS Employee, 
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY d.id ORDER BY e.salary DESC) AS rnk
    FROM 
        Employee e
    JOIN 
        Department d ON e.departmentId = d.id
) AS RankedSalaries
WHERE 
    rnk <= 3;
```

---

## 12. Step-by-Step Dry Run
1. **Inner Query (JOIN + DENSE_RANK):**
   * IT Dept (id 1): 
     * Max (90k) -> Rank 1
     * Joe (85k) -> Rank 2
     * Randy (85k) -> Rank 2
     * Will (70k) -> Rank 3
     * Janet (69k) -> Rank 4
   * Sales Dept (id 2):
     * Henry (80k) -> Rank 1
     * Sam (60k) -> Rank 2
2. **Outer Query (WHERE rnk <= 3):**
   * IT: Keeps Max, Joe, Randy, and Will. (Janet is dropped).
   * Sales: Keeps Henry, Sam.
3. **Outer Query SELECT:**
   * Returns the beautifully formatted names and salaries.

---

## 13. SQL Execution Order
1. **Subquery FROM & JOIN:** Merges Employee and Department tables.
2. **Subquery SELECT (Window):** Physically sorts the virtual table into department chunks, sorts those chunks by salary, and assigns the dense integers.
3. **Outer FROM:** Loads the ranked virtual table.
4. **Outer WHERE:** Drops any row with a rank >= 4.
5. **Outer SELECT:** Returns the final columns.

---

## 14. Query Breakdown
* **DENSE_RANK():** One of the three sibling ranking functions. It explicitly solves the "unique salaries" requirement of the prompt.
* **PARTITION BY d.id:** This tells the window function to reset the counter back to 1 every time it encounters a new department.
* **Derived Table (`AS RankedSalaries`):** You cannot put window functions in a `WHERE` clause. You must execute them in a `SELECT`, wrap them in a subquery, and *then* filter them in the outer query.

---

## 15. Why This Solution Works
Window functions were invented to solve "Top N per Group" problems. Before Window Functions, this problem was a nightmare requiring highly unoptimized Correlated Subqueries.

---

## 16. Alternative Solution
Using a Correlated Subquery (Slower, Pre-Window Function Era)

```sql
SELECT 
    d.name AS Department, 
    e1.name AS Employee, 
    e1.salary AS Salary
FROM 
    Employee e1
JOIN 
    Department d ON e1.departmentId = d.id
WHERE 3 > (
    SELECT COUNT(DISTINCT e2.salary)
    FROM Employee e2
    WHERE e2.salary > e1.salary 
    AND e1.departmentId = e2.departmentId
);
```
* **Advantages:** Works on completely outdated databases.
* **Disadvantages:** Mathematically horrible. For every single employee (e1), it runs a brand new subquery to count how many distinct salaries in their department are larger than theirs. If less than 3 are larger, they must be in the top 3! It is **O(N^2)** and will time out on massive datasets.

---

## 17. Time Complexity
**O(N log N)**. The Window Function approach sorts the data by department and salary, which takes O(N log N) time. This is vastly superior to the O(N^2) correlated subquery approach.

---

## 18. Common Mistakes
* **Using `RANK()` instead of `DENSE_RANK()`:** The most common mistake. `RANK()` leaves gaps after ties. In the sample, Joe and Randy tie for Rank 2. `RANK()` would assign Will Rank 4. Because `4 <= 3` is false, Will would be incorrectly excluded from the output!
* **Trying to filter the Window Function directly:**
  ```sql
  SELECT ... WHERE DENSE_RANK(...) <= 3
  ```
  *Invalid syntax in SQL. Window functions evaluate after the WHERE clause. You must use a subquery.*

---

## 19. Edge Cases
* **Department has fewer than 3 employees:** Works perfectly. The ranks will just be 1 and 2, which are both `<= 3`.
* **Employees have no department:** Because it's an `INNER JOIN`, they are safely ignored.

---

## 20. Interview Tips
* If you get a "Top N per Group" question (Top 3 salaries per dept, Top 5 products per category), immediately say "I'm going to use a Window Function with `DENSE_RANK` and a `PARTITION BY`". The interviewer will immediately know you understand modern SQL analytics.

---

## 21. Similar LeetCode Problems
* 184. Department Highest Salary (Easier version of this problem)
* 1112. Highest Grade For Each Student

---

## 22. Key Takeaways
* **Top-N Per Group:** `DENSE_RANK() OVER(PARTITION BY category ORDER BY value DESC)`.
* `ROW_NUMBER`: 1, 2, 3, 4 (No ties allowed).
* `RANK`: 1, 2, 2, 4 (Ties allowed, skips next number).
* `DENSE_RANK`: 1, 2, 2, 3 (Ties allowed, never skips numbers).

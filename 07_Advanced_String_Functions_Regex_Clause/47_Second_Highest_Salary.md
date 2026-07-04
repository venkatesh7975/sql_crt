# Problem 47 – Second Highest Salary

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Aggregate Functions (`MAX`)
* Subqueries
* Handling `NULL` values
* DISTINCT / ORDER BY / LIMIT / OFFSET [Alternative Approach]

---

## 3. Pattern
Nth Highest / Subquery Filtering

---

## 4. Problem Statement
Write a SQL query to report the **second highest salary** from the `Employee` table. 
If there is no second highest salary, the query should report `null`.

---

## 5. Tables

Table: Employee

| Column | Type |
| ------ | ---- |
| id     | INT  |
| salary | INT  |

* `id` is the primary key.
* Each row contains information about the salary of an employee.

---

## 6. Sample Input

Employee table (Example 1):

| id | salary |
| -- | ------ |
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |

Employee table (Example 2):

| id | salary |
| -- | ------ |
| 1  | 100    |

---

## 7. Expected Output

Expected Output (Example 1):

| SecondHighestSalary |
| ------------------- |
| 200                 |

Expected Output (Example 2):

| SecondHighestSalary |
| ------------------- |
| null                |

*(In Ex 1, the highest is 300, the second highest is 200).*
*(In Ex 2, there is only one salary, so there is no second highest. Must return null).*

---

## 8. Understanding the Question
What information is being asked? A single scalar value: the second highest unique salary.
What columns are important? `salary`.
What conditions matter? 
1. We are looking for the *unique* highest. If two people make 300, and one makes 200, the second highest is 200 (not 300).
2. If there aren't at least two unique salaries in the entire table, the result must be an explicit `NULL`.
What should be returned? `SecondHighestSalary`.

---

## 9. Thinking Process
1. How do I find the absolute highest salary? `SELECT MAX(salary) FROM Employee`.
2. How do I find the second highest? It is simply the highest salary *excluding* the absolute highest salary.
3. I can write a query to find the max salary: `SELECT MAX(salary) FROM Employee WHERE salary < ...`
4. Less than what? Less than the absolute maximum!
5. `WHERE salary < (SELECT MAX(salary) FROM Employee)`.
6. **Wait, what about the NULL requirement?** 
   * If there is only one row in the table (e.g., 100).
   * The subquery returns `100`.
   * The main query looks for `MAX(salary) WHERE salary < 100`. 
   * It finds no rows. 
   * What does `MAX()` return when it evaluates an empty set? **It returns NULL!**
   * This perfectly satisfies the edge case requirement without needing any complex `IFNULL` or `CASE` logic.

---

## 10. Approach 1 (Optimal)
Nested MAX() Aggregate Functions

Find the maximum salary that is strictly less than the global maximum salary.

---

## 11. SQL Solution

```sql
-- Find the maximum salary that is smaller than the absolute maximum salary
SELECT 
    MAX(salary) AS SecondHighestSalary
FROM 
    Employee
WHERE 
    salary < (SELECT MAX(salary) FROM Employee);
```

---

## 12. Step-by-Step Dry Run
1. **Example 1 (100, 200, 300):**
   * Subquery `SELECT MAX(salary)` returns `300`.
   * Main query evaluates: `SELECT MAX(salary) FROM Employee WHERE salary < 300`.
   * Salaries `< 300` are `[100, 200]`.
   * `MAX(100, 200)` returns **200**.
2. **Example 2 (100):**
   * Subquery `SELECT MAX(salary)` returns `100`.
   * Main query evaluates: `SELECT MAX(salary) FROM Employee WHERE salary < 100`.
   * Salaries `< 100` are `[]` (Empty set).
   * `MAX(Empty Set)` returns **NULL**.

---

## 13. SQL Execution Order
1. **Subquery:** Scans the table to find the absolute maximum value.
2. **FROM Employee:** Scans the table again.
3. **WHERE:** Filters out any row that is equal to (or greater than) the maximum.
4. **SELECT MAX():** Calculates the maximum of the surviving rows and handles empty sets by returning NULL.

---

## 14. Query Breakdown
* **MAX() on an empty set:** This is a fundamental property of aggregate functions in SQL (except `COUNT`). If you `SUM()`, `AVG()`, or `MAX()` zero rows, the database engine yields `NULL`. Understanding this prevents you from writing overly defensive code.

---

## 15. Why This Solution Works
It relies on standard ANSI SQL behavior and uses highly optimized aggregate functions, avoiding sorting entirely.

---

## 16. Alternative Solution 1
Using LIMIT and OFFSET (The "Pagination" approach)

```sql
SELECT (
    SELECT DISTINCT salary 
    FROM Employee 
    ORDER BY salary DESC 
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```
* **Advantages:** This scales to the "Nth Highest Salary" perfectly. If you want the 5th highest, you just change it to `OFFSET 4`.
* **Disadvantages:** Why is it wrapped in a `SELECT ( ... ) AS` block? Because if you just ran the inner query and the table only had 1 row, `LIMIT 1 OFFSET 1` would return **Zero Rows** (an empty grid), not a grid containing the word `NULL`. Wrapping it in a scalar SELECT statement forces MySQL to project a `NULL` if the inner query returns empty.

---

## 17. Alternative Solution 2
Using DENSE_RANK() (Window Function)

```sql
SELECT MAX(salary) AS SecondHighestSalary
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) as rnk
    FROM Employee
) as ranked
WHERE rnk = 2;
```
* **Advantages:** Extremely scalable.
* **Disadvantages:** Slightly overkill for just finding the "Second" highest, but it's the professional way to do it for complex reporting.

---

## 18. Time Complexity
**O(N)**. The `MAX(salary) < MAX(salary)` approach scans the table twice. If there is an index on `salary`, finding the max is **O(1)**, making the entire query execute in microseconds. The `ORDER BY` approach is **O(N log N)** due to sorting.

---

## 19. Common Mistakes
* **Using `LIMIT 1 OFFSET 1` without a wrapper:** As explained in the alternative solution, this fails the edge case where the table is too small, returning an empty set instead of an explicit `NULL` row.
* **Forgetting `DISTINCT` in the LIMIT approach:** If the salaries are `[300, 300, 200]`, sorting and taking the second row (`OFFSET 1`) will return `300` again.

---

## 20. Interview Tips
* The "Nth Highest Salary" is arguably **the most famous SQL interview question of all time**.
* Always start by writing the `MAX() < MAX()` solution because it's elegant and performant. 
* Immediately follow up by saying, "If you wanted the 5th highest salary, I wouldn't nest 5 subqueries. Instead, I would use `DENSE_RANK() OVER(ORDER BY salary DESC)` and filter for `rank = 5`." This guarantees you pass the interview.

---

## 21. Similar LeetCode Problems
* 177. Nth Highest Salary (Same problem, but parameterized)
* 184. Department Highest Salary

---

## 22. Key Takeaways
* `MAX()` evaluated against zero rows returns `NULL`.
* To find the Second Highest X, find the `MAX(X) WHERE X < (SELECT MAX(X))`.
* To find the Nth Highest X, use `DENSE_RANK()` or `LIMIT 1 OFFSET (N-1)`.
* Wrapping a query in `SELECT (...) AS name` forces an empty result set to manifest as a `NULL` scalar value.

# Introduction to Window Functions

---

## 1. The Problem with GROUP BY

We know that Aggregate Functions (`SUM`, `AVG`) combined with `GROUP BY` are incredibly powerful. 
However, `GROUP BY` comes with a massive penalty: **it collapses the rows.**

If you have a table of 1,000 employees and you `GROUP BY department`, you get a result set of maybe 5 rows (one for each department). 
**What if you want to keep the original 1,000 rows, but you STILL want to calculate the department averages alongside them?**

For decades, developers solved this by doing a `GROUP BY` in a subquery, and then `JOIN`ing the result back to the original table. It was slow and clunky.

Enter **Window Functions**.

---

## 2. What is a Window Function?

A Window Function performs a calculation across a set of table rows that are related to the current row, **but it DOES NOT collapse the rows.**

It looks out a "window" at the surrounding data, calculates a result, and pastes that result right next to the current row.

---

## 3. The OVER() Clause

The `OVER()` clause is the magic keyword that turns a normal aggregate function into a Window Function. 
If you add `OVER()` to an aggregate, it stops collapsing rows.

### Example: The Total Company Salary
```sql
SELECT 
    first_name, 
    salary,
    -- This calculates the sum of ALL salaries without collapsing the rows!
    SUM(salary) OVER() AS total_company_salary 
FROM employees;
```
*Result:* If there are 1,000 employees, this returns 1,000 rows. Every single row will have a column showing the exact same `total_company_salary`.

---

## 4. The PARTITION BY Clause (The Window's "GROUP BY")

`OVER()` looks at the entire table. But usually, you want to calculate data within specific categories (like a `GROUP BY`).
Inside the `OVER()` clause, you use **`PARTITION BY`**.

### Example: Average Salary per Department
```sql
SELECT 
    first_name, 
    department,
    salary,
    -- This calculates the average salary specifically for the employee's department
    AVG(salary) OVER(PARTITION BY department) AS dept_avg_salary,
    
    -- We can even do math using the window function result!
    salary - AVG(salary) OVER(PARTITION BY department) AS diff_from_dept_avg
FROM employees;
```
**How it works:** 
The database looks at Alice in the IT department. It "partitions" (fences off) all the IT rows, calculates the average just for them, and writes it next to Alice. 
Then it looks at Bob in HR, fences off the HR rows, calculates the HR average, and writes it next to Bob.
**Crucially, Alice and Bob still have their own individual rows.**

---

## 5. Interview Tips
*   **The Difference:** "What is the difference between `GROUP BY` and `PARTITION BY`?"
    *   **Answer:** "`GROUP BY` aggregates data and collapses the result set into a single row per group. `PARTITION BY` is used inside a Window Function to aggregate data *without* collapsing the rows, retaining the original row-level granularity."
*   **The Math Test:** Interviewers love asking you to calculate the percentage of total revenue a specific order represents.
    *   **Answer:** `SELECT order_id, revenue, (revenue / SUM(revenue) OVER()) * 100 AS pct_of_total FROM orders;`

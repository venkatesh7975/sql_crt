# Correlated Subqueries

---

## 1. Uncorrelated vs Correlated

In the previous chapter, we looked at **Uncorrelated Subqueries**. 
An Uncorrelated Subquery is entirely independent. You can highlight just the inner query, run it by itself, and it will work perfectly. The database runs it once, caches the result, and feeds it to the outer query.

A **Correlated Subquery** is completely different, and computationally much heavier.

---

## 2. What is a Correlated Subquery?

A Correlated Subquery **references a column from the outer query.** 

Because it relies on data from the outer query, the inner query *cannot* be run independently. Furthermore, **the database must execute the inner query over and over again—once for every single row evaluated by the outer query.**

### Example: Finding Employees Above their Department's Average
We want to find employees who make more money than the average salary of *their specific department*.

```sql
SELECT 
    e1.first_name, 
    e1.salary, 
    e1.department_id
FROM 
    employees e1
WHERE 
    e1.salary > (
        -- This subquery references 'e1' from the outer query!
        SELECT AVG(e2.salary) 
        FROM employees e2 
        WHERE e2.department_id = e1.department_id
    );
```

### How this executes:
1.  The outer query looks at Row 1 (Alice, IT Department, Salary $80k).
2.  The inner query runs: `SELECT AVG(salary) FROM employees WHERE department_id = 'IT'`. It returns $75k.
3.  Outer query evaluates: Is 80k > 75k? Yes. Keep Alice.
4.  Outer query looks at Row 2 (Bob, HR Department, Salary $50k).
5.  **The inner query runs AGAIN:** `SELECT AVG(salary) FROM employees WHERE department_id = 'HR'`. It returns $55k.
6.  Outer query evaluates: Is 50k > 55k? No. Discard Bob.

*(Notice how the inner query has to be constantly recalculated because the `department_id` keeps changing based on the outer row).*

---

## 3. EXISTS (The Most Common Correlated Subquery)

As covered in the Filtering chapter, the `EXISTS` operator almost always utilizes a Correlated Subquery.

```sql
-- Find customers who have made at least one purchase
SELECT c.customer_name 
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.id -- Correlated link!
);
```

---

## 4. Interview Tips
*   **Performance Danger:** "Why are Correlated Subqueries considered slow?"
    *   **Answer:** "Because they run row-by-row. If the outer query has 1 million rows, the inner query must be executed 1 million separate times (N+1 query problem). An Uncorrelated Subquery only executes once."
*   **The Rewrite:** Interviewers will often ask you to rewrite a Correlated Subquery using a `JOIN` to improve performance. 
    *   *The Employees above average rewrite:* 
    ```sql
    SELECT e.first_name, e.salary, e.department_id
    FROM employees e
    JOIN (
        SELECT department_id, AVG(salary) as dept_avg 
        FROM employees 
        GROUP BY department_id
    ) avg_table ON e.department_id = avg_table.department_id
    WHERE e.salary > avg_table.dept_avg;
    ```

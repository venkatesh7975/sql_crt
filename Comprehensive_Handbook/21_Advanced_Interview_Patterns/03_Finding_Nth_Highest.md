# Finding the Nth Highest Value

---

## 1. The Most Asked Question in SQL History

"Write a SQL query to find the 2nd highest salary in the `employees` table."

This is, without exaggeration, the single most frequently asked SQL interview question of the last 20 years. Every developer must know how to solve it in multiple ways.

---

## 2. Solution 1: LIMIT and OFFSET (The Easy Way)

The simplest way to find the Nth highest value is to sort the data in descending order, skip the first `N-1` rows using `OFFSET`, and grab exactly 1 row using `LIMIT 1`.

### Finding the 2nd Highest
```sql
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 1 OFFSET 1;
```
*(We use `DISTINCT` because if the top two employees both make $100k, we don't want the 2nd highest salary to also report as $100k. We want the next distinct value).*

### The Flaw
What if there is only 1 employee in the company? The query above will return an empty result set. Many interviewers will specify: "If there is no 2nd highest salary, return NULL." 
To fix this, you must wrap the entire query in an `IFNULL()` or a subquery.

```sql
-- Safe from empty result sets
SELECT (
    SELECT DISTINCT salary 
    FROM employees 
    ORDER BY salary DESC 
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```

---

## 3. Solution 2: MAX() Subquery (The Old School Way)

Before `LIMIT` was universally supported, this was the standard way to answer the question. It proves you understand how to use nested subqueries.

**Logic:** The 2nd highest salary is simply the maximum salary *that is strictly less than* the absolute maximum salary.

```sql
SELECT MAX(salary) 
FROM employees 
WHERE salary < (SELECT MAX(salary) FROM employees);
```
*(This handles the "Return NULL if it doesn't exist" requirement automatically, because `MAX()` on an empty set returns `NULL`).*

---

## 4. Solution 3: DENSE_RANK() (The Professional Way)

If the interviewer asks for the 2nd highest salary, `LIMIT` is fine. 
But what if they ask for "The 2nd highest salary **in every department**"?

`LIMIT` completely fails here. You cannot use `LIMIT` per group. 
You must use a Window Function. This is the solution that data engineers and analysts use in production code.

```sql
WITH RankedSalaries AS (
    SELECT 
        department_id,
        salary,
        DENSE_RANK() OVER(
            PARTITION BY department_id 
            ORDER BY salary DESC
        ) as rnk
    FROM employees
)
SELECT department_id, salary 
FROM RankedSalaries 
WHERE rnk = 2;
```
*(We use `DENSE_RANK` instead of `ROW_NUMBER` to properly handle ties, ensuring we actually get the 2nd distinct salary amount).*

---

## 5. Interview Tips
*   **The Progression:** A good interviewer will ask the question in stages.
    1.  "Find the 2nd highest salary." -> You write the `MAX` subquery or `LIMIT` approach.
    2.  "What if I want the 5th highest?" -> You change `LIMIT 1 OFFSET 4`.
    3.  "What if I want the 5th highest *per department*?" -> You wipe the board and write the `DENSE_RANK()` CTE approach.
*   **Always clarify ties:** Before you write any code, ask the interviewer: "If the top two salaries are both $100k, and the third is $90k, do you consider $100k to be both the 1st and 2nd highest, or is $90k the 2nd highest?" (This determines if you need `DISTINCT` / `DENSE_RANK()`).

# READ Operations (Intermediate) - 10 Practice Questions

---

## The Database Schema
For all exercises in this section, assume the following tables exist:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10,2)
);

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
```

---

## Questions

### Q21: Basic Aggregation
Write a query to calculate the total number of employees in the company, and the average salary across all employees.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    COUNT(*) AS total_employees, 
    AVG(salary) AS average_salary 
FROM employees;
```
</details>

---

### Q22: GROUP BY
Write a query to find the average salary for *each* `department_id`.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    department_id, 
    AVG(salary) AS avg_dept_salary
FROM employees
GROUP BY department_id;
```
</details>

---

### Q23: HAVING Clause
Write a query to find the average salary for each `department_id`, BUT only return departments where the average salary is strictly greater than $80,000.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    department_id, 
    AVG(salary) AS avg_dept_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 80000;
```
</details>

---

### Q24: GROUP BY Multiple Columns
Imagine the `employees` table also had a `job_title` column. Write a query to find the total headcount (COUNT) broken down by BOTH `department_id` and `job_title`.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    department_id, 
    job_title, 
    COUNT(*) AS headcount
FROM employees
GROUP BY department_id, job_title;
```
</details>

---

### Q25: INNER JOIN
Write a query to retrieve the employee's `first_name` alongside their actual `dept_name` (not just the ID).
<details>
<summary>View Solution</summary>

```sql
SELECT 
    e.first_name, 
    d.dept_name
FROM employees e
INNER JOIN departments d 
  ON e.department_id = d.dept_id;
```
</details>

---

### Q26: LEFT JOIN (Finding Orphans)
Write a query to list ALL departments (even if they have no employees). Include the `dept_name` and the employee's `first_name`. If a department has no employees, the first name should be NULL.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    d.dept_name, 
    e.first_name
FROM departments d
LEFT JOIN employees e 
  ON d.dept_id = e.department_id;
```
</details>

---

### Q27: Aggregation + JOIN
Write a query to find the total number of employees in each department. The output should display the `dept_name` (not the ID) and the `headcount`.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    d.dept_name, 
    COUNT(e.emp_id) AS headcount
FROM departments d
LEFT JOIN employees e 
  ON d.dept_id = e.department_id
GROUP BY d.dept_name;
```
</details>

---

### Q28: Conditional Aggregation (CASE within SUM)
Write a query that returns one single row containing: the total company payroll (SUM of salary), the total payroll for department 1, and the total payroll for department 2. (You must use `CASE` statements to solve this).
<details>
<summary>View Solution</summary>

```sql
SELECT 
    SUM(salary) AS total_company_payroll,
    SUM(CASE WHEN department_id = 1 THEN salary ELSE 0 END) AS dept_1_payroll,
    SUM(CASE WHEN department_id = 2 THEN salary ELSE 0 END) AS dept_2_payroll
FROM employees;
```
</details>

---

### Q29: Simple CASE Expression
Write a query to retrieve the employee `first_name` and a new column called `salary_tier`. If the salary is > 100000, it should say 'High'. If > 50000, it should say 'Medium'. Otherwise, 'Low'.
<details>
<summary>View Solution</summary>

```sql
SELECT 
    first_name,
    CASE 
        WHEN salary > 100000 THEN 'High'
        WHEN salary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_tier
FROM employees;
```
</details>

---

### Q30: Subquery in the WHERE clause
Write a query to find the names of all employees who make MORE than the average salary of the entire company.
<details>
<summary>View Solution</summary>

```sql
SELECT first_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```
</details>

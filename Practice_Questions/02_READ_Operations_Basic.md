# READ Operations (Basic) - 10 Practice Questions

---

## The Database Schema
For all exercises in this section, assume the following table structure exists:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);
```

---

## Questions

### Q11: Select All Columns
Write a query to retrieve every column and every row from the `employees` table.
<details>
<summary>View Solution</summary>

```sql
SELECT * FROM employees;
```
</details>

---

### Q12: Select Specific Columns
Write a query to retrieve only the `first_name`, `last_name`, and `salary` of all employees.
<details>
<summary>View Solution</summary>

```sql
SELECT first_name, last_name, salary 
FROM employees;
```
</details>

---

### Q13: Basic Filtering (Equality)
Write a query to find all employees who work in the 'Sales' department.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE department = 'Sales';
```
</details>

---

### Q14: Filtering with Numbers
Write a query to retrieve all employees who make strictly more than $75,000 per year.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE salary > 75000;
```
</details>

---

### Q15: Multiple Conditions (AND / OR)
Write a query to find employees who work in the 'IT' department AND make more than $80,000.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE department = 'IT' 
  AND salary > 80000;
```
</details>

---

### Q16: The IN Operator
Write a query to find all employees who work in either 'HR', 'Finance', or 'Marketing'. Do not use the `OR` keyword.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE department IN ('HR', 'Finance', 'Marketing');
```
</details>

---

### Q17: The BETWEEN Operator
Write a query to find all employees whose salary is between $50,000 and $60,000 (inclusive). Do not use the `>=` or `<=` operators.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE salary BETWEEN 50000 AND 60000;
```
</details>

---

### Q18: Pattern Matching (LIKE)
Write a query to find all employees whose `last_name` starts with the letter 'S'.
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE last_name LIKE 'S%';
```
</details>

---

### Q19: Handling NULLs
Write a query to find all employees who currently do NOT have a manager (their `manager_id` is empty).
<details>
<summary>View Solution</summary>

```sql
SELECT * 
FROM employees 
WHERE manager_id IS NULL;
-- NOTE: manager_id = NULL will NOT work!
```
</details>

---

### Q20: Sorting and Limiting (Pagination)
Write a query to find the 5 highest-paid employees in the company. Return their first name and salary.
<details>
<summary>View Solution</summary>

```sql
SELECT first_name, salary 
FROM employees 
ORDER BY salary DESC 
LIMIT 5;
```
</details>

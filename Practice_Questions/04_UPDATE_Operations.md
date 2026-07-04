# UPDATE Operations - 10 Practice Questions

---

## The Database Schema
For all exercises in this section, assume the following table structure exists:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    performance_rating INT -- (1 to 5)
);

CREATE TABLE department_budgets (
    dept_name VARCHAR(50) PRIMARY KEY,
    annual_budget DECIMAL(12,2)
);
```

---

## Questions

### Q31: Basic Single Row Update
Employee ID 105 got married and changed her first name to "Mary-Jane". Write a query to update her `first_name`.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET first_name = 'Mary-Jane'
WHERE emp_id = 105;
```
</details>

---

### Q32: Updating Multiple Columns
Employee ID 200 was promoted. Write a query to change his `department` to 'Management' AND increase his `salary` to 120000.00 in a single query.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET 
    department = 'Management',
    salary = 120000.00
WHERE emp_id = 200;
```
</details>

---

### Q33: Updating Multiple Rows (IN clause)
The company is dissolving the 'Temp' department. Write a query to move all employees in the 'Temp' and 'Contractor' departments into the 'Unassigned' department.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET department = 'Unassigned'
WHERE department IN ('Temp', 'Contractor');
```
</details>

---

### Q34: Mathematical Updates (Relative Updates)
The 'IT' department is getting a blanket 5% raise. Write a query to increase the salary of every IT employee by 5%. (Do not hardcode salaries).
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET salary = salary * 1.05
WHERE department = 'IT';
```
</details>

---

### Q35: Mathematical Updates (Absolute Updates)
Every employee with a performance rating of 5 is getting a flat $2,000 bonus added to their base salary. Write the query.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET salary = salary + 2000.00
WHERE performance_rating = 5;
```
</details>

---

### Q36: Conditional Updates (UPDATE with CASE)
The CEO wants to adjust salaries based on performance in a single query to prevent locking the table multiple times.
If performance_rating = 5, give a 10% raise.
If performance_rating = 1, give a 5% pay cut (multiply by 0.95).
Leave everyone else alone.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET salary = CASE 
    WHEN performance_rating = 5 THEN salary * 1.10
    WHEN performance_rating = 1 THEN salary * 0.95
    ELSE salary 
END;
```
</details>

---

### Q37: UPDATE JOIN (Updating based on another table)
You need to reduce the salary of all employees in the 'Sales' department by 10%, BUT only if the Sales department's `annual_budget` in the `department_budgets` table is currently less than $100,000. 
<details>
<summary>View Solution</summary>

```sql
UPDATE employees e
INNER JOIN department_budgets b ON e.department = b.dept_name
SET e.salary = e.salary * 0.90
WHERE e.department = 'Sales' 
  AND b.annual_budget < 100000;
```
</details>

---

### Q38: Using LIMIT in an UPDATE
You need to fix a data entry error. Change the department to 'Marketing' for any 10 employees currently in the 'Unassigned' department. (You don't care which 10).
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET department = 'Marketing'
WHERE department = 'Unassigned'
LIMIT 10;
```
</details>

---

### Q39: Updating to NULL
Employee ID 305 was fired. Instead of deleting his record, HR requested that you wipe out his salary data. Write a query to set his salary to NULL.
<details>
<summary>View Solution</summary>

```sql
UPDATE employees
SET salary = NULL
WHERE emp_id = 305;
```
</details>

---

### Q40: The Danger of UPDATE (Conceptual)
What happens if you run the following query? `UPDATE employees SET performance_rating = 3;`
<details>
<summary>View Solution</summary>

Because there is no `WHERE` clause, the database will overwrite the `performance_rating` for **every single row in the entire table** to 3. This is a catastrophic data loss event if run accidentally.
</details>

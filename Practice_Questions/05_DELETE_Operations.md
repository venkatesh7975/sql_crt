# DELETE Operations - 10 Practice Questions

---

## The Database Schema
For all exercises in this section, assume the following table structure exists:

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

CREATE TABLE inactive_users (
    emp_id INT PRIMARY KEY
);
```

---

## Questions

### Q41: Basic Single Row Delete
Employee ID 999 has left the company. Write a query to delete their record.
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE emp_id = 999;
```
</details>

---

### Q42: Multi-Row Delete (IN clause)
Employees 101, 105, and 108 were all laid off. Write a single query to delete all three.
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE emp_id IN (101, 105, 108);
```
</details>

---

### Q43: Delete by Range
Write a query to delete all employees who were hired before January 1, 2010.
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE hire_date < '2010-01-01';
```
</details>

---

### Q44: Delete with Multiple Conditions
Write a query to delete any employee in the 'Temp' department who makes more than $50,000.
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE department = 'Temp' 
  AND salary > 50000;
```
</details>

---

### Q45: Delete using a Subquery
Write a query to delete all employees whose `emp_id` exists in the `inactive_users` table. (Use a subquery).
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE emp_id IN (
    SELECT emp_id FROM inactive_users
);
```
</details>

---

### Q46: Delete using a JOIN
Rewrite the previous query (deleting employees found in `inactive_users`) using a `JOIN` instead of a subquery. This is often required in MySQL for performance.
<details>
<summary>View Solution</summary>

```sql
DELETE e 
FROM employees e
INNER JOIN inactive_users i ON e.emp_id = i.emp_id;
```
</details>

---

### Q47: Delete with LIMIT
You have a script that deletes old logs from the `employees` table (assume it's a massive table). To prevent locking the database for 10 minutes, write a query to delete employees hired before 2000, but only delete 1,000 rows at a time.
<details>
<summary>View Solution</summary>

```sql
DELETE FROM employees
WHERE hire_date < '2000-01-01'
LIMIT 1000;
```
</details>

---

### Q48: Delete Duplicates (Keeping the Lowest ID)
A bug caused duplicate rows to be inserted. The `first_name` and `last_name` are identical, but they have different `emp_id`s. Write a query to delete the duplicates, keeping only the row with the lowest `emp_id`.
<details>
<summary>View Solution</summary>

```sql
DELETE e1 
FROM employees e1
INNER JOIN employees e2 
WHERE e1.first_name = e2.first_name 
  AND e1.last_name = e2.last_name
  AND e1.emp_id > e2.emp_id;
```
*Note: This joins the table to itself. If John is ID 5 and ID 10, the query matches them, sees 10 > 5, and deletes row 10.*
</details>

---

### Q49: The Danger of DELETE (Conceptual)
What happens if you run the following query? `DELETE FROM employees;`
<details>
<summary>View Solution</summary>

Because there is no `WHERE` clause, it will systematically delete every single row in the table, one by one. It will log every deletion, which takes a massive amount of time and transaction log space for a large table.
</details>

---

### Q50: TRUNCATE vs DELETE
If you truly wanted to empty the entire `employees` table instantly, what command should you use instead of `DELETE FROM employees;`, and why?
<details>
<summary>View Solution</summary>

```sql
TRUNCATE TABLE employees;
```
You should use `TRUNCATE` because it is a DDL command that drops and recreates the table. It is virtually instantaneous, does not fill up the transaction log, and resets the `AUTO_INCREMENT` counter back to 1. `DELETE` is a DML command that removes rows individually.
</details>

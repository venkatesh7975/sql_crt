# CREATE Operations (INSERT) - 10 Practice Questions

---

## The Database Schema
For all exercises in this section, assume the following table structure exists:

```sql
CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50) DEFAULT 'Unassigned',
    salary DECIMAL(10,2) DEFAULT 0.00,
    hire_date DATE
);

CREATE TABLE new_hires (
    id INT PRIMARY KEY,
    f_name VARCHAR(50),
    l_name VARCHAR(50),
    dept VARCHAR(50)
);
```

---

## Questions

### Q1: Basic Single Row Insert
Write a query to insert a new employee named "John Doe" with the email "john.doe@company.com". Leave all other columns to their default values.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@company.com');
```
*Note: Because `emp_id` is AUTO_INCREMENT, and `department`/`salary` have defaults, we only need to provide the required columns.*
</details>

---

### Q2: Insert Fully Specified Row
Write a query to insert "Jane Smith", email "jane@company.com", into the 'IT' department, with a salary of 85000.00, hired on '2023-01-15'.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, department, salary, hire_date)
VALUES ('Jane', 'Smith', 'jane@company.com', 'IT', 85000.00, '2023-01-15');
```
</details>

---

### Q3: Multi-Row Insert
Write a single query to insert three employees at once:
1. "Alice Bob", alice@comp.com, HR
2. "Charlie Day", charlie@comp.com, Sales
3. "Eve Adams", eve@comp.com, IT
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, department)
VALUES 
    ('Alice', 'Bob', 'alice@comp.com', 'HR'),
    ('Charlie', 'Day', 'charlie@comp.com', 'Sales'),
    ('Eve', 'Adams', 'eve@comp.com', 'IT');
```
</details>

---

### Q4: Handling Duplicate Keys (INSERT IGNORE)
You are importing a list of emails. Some might already exist in the database (which will violate the UNIQUE constraint on the `email` column). Write a query to insert "John Doe" (john.doe@company.com) but silently ignore the error if the email already exists.
<details>
<summary>View Solution</summary>

```sql
INSERT IGNORE INTO employees (first_name, last_name, email)
VALUES ('John', 'Doe', 'john.doe@company.com');
```
</details>

---

### Q5: Handling Duplicate Keys (ON DUPLICATE KEY UPDATE)
You are importing an employee record: "Jane Smith", jane@company.com, Salary: 90000.00. 
Write a query that inserts this record. If the email already exists, it should simply update her salary to 90000.00 instead of failing.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, salary)
VALUES ('Jane', 'Smith', 'jane@company.com', 90000.00)
ON DUPLICATE KEY UPDATE salary = 90000.00;
```
</details>

---

### Q6: Insert via SELECT (Copying Data)
You have a table called `new_hires` populated by the HR software. Write a query to copy all records from `new_hires` into the `employees` table. (Map `f_name` to `first_name`, `l_name` to `last_name`, and `dept` to `department`). Generate a fake email by concatenating the first and last name.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, department, email)
SELECT 
    f_name, 
    l_name, 
    dept,
    CONCAT(f_name, '.', l_name, '@company.com')
FROM new_hires;
```
</details>

---

### Q7: Insert with Default Keyword
Write a query to insert "Mike Ross" (mike@company.com), but explicitly force the `department` and `salary` columns to use their defined DEFAULT values using the `DEFAULT` keyword in the `VALUES` clause.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, department, salary)
VALUES ('Mike', 'Ross', 'mike@company.com', DEFAULT, DEFAULT);
```
</details>

---

### Q8: Insert with Subquery Calculation
Write a query to insert a new employee "Frank Castle" (frank@company.com) into the 'Security' department. Instead of hardcoding his salary, set his salary to be exactly equal to the current highest salary in the entire company.
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, department, salary)
VALUES (
    'Frank', 
    'Castle', 
    'frank@company.com', 
    'Security', 
    (SELECT MAX(salary) FROM employees AS temp)
);
```
*Note: In MySQL, you must alias the subquery table (`AS temp`) if you are querying the same table you are inserting into, otherwise it throws a "Table is specified twice" error.*
</details>

---

### Q9: Insert with Date Functions
Write a query to insert "Diana Prince" (diana@company.com). Set her `hire_date` to exactly exactly exactly right now (the current system date).
<details>
<summary>View Solution</summary>

```sql
INSERT INTO employees (first_name, last_name, email, hire_date)
VALUES ('Diana', 'Prince', 'diana@company.com', CURRENT_DATE());
-- CURDATE() is also acceptable.
```
</details>

---

### Q10: Creating a Table From Another Table (CTAS)
Write a query to completely backup the `employees` table into a brand new table called `employees_backup_2023`. The new table should be created and populated in a single command.
<details>
<summary>View Solution</summary>

```sql
CREATE TABLE employees_backup_2023 AS
SELECT * FROM employees;
```
</details>

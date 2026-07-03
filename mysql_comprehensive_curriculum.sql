-- =================================================================================
-- COMPREHENSIVE MYSQL PRACTICE SCRIPT
-- Covers all core MySQL query concepts for learning and interviews.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- 1. DDL (Data Definition Language)
-- ---------------------------------------------------------------------------------
-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS practice_db;
USE practice_db;

-- ALTER DATABASE (Example: Changing character set)
ALTER DATABASE practice_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- DROP DATABASE (Uncomment to execute)
-- DROP DATABASE practice_db;

-- CREATE TABLE with Constraints (PRIMARY KEY, NOT NULL, UNIQUE, DEFAULT, CHECK, AUTO_INCREMENT)
CREATE TABLE Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(50) DEFAULT 'Headquarters',
    budget DECIMAL(15, 2) CHECK (budget > 0)
);

CREATE TABLE Employees (
    emp_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    dept_id INT,
    manager_id INT,
    PRIMARY KEY (emp_id),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE SET NULL,
    FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

-- ALTER TABLE (Add column, Drop column, Modify column, Rename column)
ALTER TABLE Employees ADD COLUMN phone_number VARCHAR(20);
ALTER TABLE Employees MODIFY COLUMN salary DECIMAL(12, 2) DEFAULT 0.00;
ALTER TABLE Employees CHANGE COLUMN phone_number contact_number VARCHAR(20);
ALTER TABLE Employees DROP COLUMN contact_number;

-- RENAME TABLE
RENAME TABLE Departments TO Company_Departments;
RENAME TABLE Company_Departments TO Departments;

-- TRUNCATE TABLE (Removes all rows but keeps structure)
-- TRUNCATE TABLE Employees;

-- DROP TABLE
-- DROP TABLE Employees;


-- ---------------------------------------------------------------------------------
-- 2. DML (Data Manipulation Language)
-- ---------------------------------------------------------------------------------
-- INSERT
INSERT INTO Departments (dept_name, location, budget) VALUES 
('HR', 'New York', 500000.00),
('Engineering', 'San Francisco', 2000000.00),
('Marketing', 'London', 800000.00),
('Sales', 'Chicago', 1500000.00);

INSERT INTO Employees (first_name, last_name, email, hire_date, salary, dept_id, manager_id) VALUES
('John', 'Doe', 'john.doe@email.com', '2020-01-15', 75000.00, 1, NULL),
('Jane', 'Smith', 'jane.smith@email.com', '2020-02-20', 120000.00, 2, NULL),
('Mike', 'Johnson', 'mike.j@email.com', '2021-03-10', 95000.00, 2, 2),
('Emily', 'Davis', 'emily.d@email.com', '2021-06-01', 65000.00, 3, NULL),
('Sarah', 'Wilson', 'sarah.w@email.com', '2022-01-15', 85000.00, 4, NULL),
('David', 'Brown', 'david.b@email.com', '2022-05-20', 90000.00, 2, 2);

-- INSERT IGNORE (Ignores errors like duplicate keys)
INSERT IGNORE INTO Departments (dept_name, budget) VALUES ('HR', 100000.00); -- Will be ignored due to UNIQUE constraint

-- REPLACE INTO (Deletes and re-inserts if unique key conflicts)
REPLACE INTO Departments (dept_id, dept_name, location, budget) VALUES (1, 'Human Resources', 'New York', 600000.00);

-- CREATE a temporary table for INSERT INTO SELECT
CREATE TABLE Archived_Employees (emp_id INT, full_name VARCHAR(100));

-- INSERT INTO SELECT
INSERT INTO Archived_Employees (emp_id, full_name)
SELECT emp_id, CONCAT(first_name, ' ', last_name) FROM Employees WHERE salary < 80000;

-- UPDATE
UPDATE Employees SET salary = salary * 1.10 WHERE dept_id = 2;

-- DELETE
DELETE FROM Employees WHERE emp_id = 999; -- Doesn't exist, just an example


-- ---------------------------------------------------------------------------------
-- 3. DQL (Data Query Language) & 6. SQL Clauses & 7. Operators
-- ---------------------------------------------------------------------------------
-- SELECT, DISTINCT, AS (Alias)
SELECT DISTINCT dept_id AS Department_ID FROM Employees;

-- Arithmetic Operators (+, -, *, /, %)
SELECT emp_id, salary, salary * 0.10 AS bonus, salary % 1000 AS remainder FROM Employees;

-- Comparison (=, !=, <>, >, <, >=, <=) & Logical Operators (AND, OR, NOT)
SELECT * FROM Employees WHERE (salary >= 80000 AND dept_id = 2) OR NOT last_name = 'Doe';

-- Special Operators (IN, NOT IN, BETWEEN, LIKE, IS NULL, EXISTS)
SELECT * FROM Employees WHERE dept_id IN (1, 3);
SELECT * FROM Employees WHERE salary BETWEEN 70000 AND 100000;
SELECT * FROM Employees WHERE last_name LIKE 'D%' OR last_name LIKE '%n';
SELECT * FROM Employees WHERE manager_id IS NULL;

-- ORDER BY, LIMIT, OFFSET
SELECT * FROM Employees ORDER BY salary DESC LIMIT 3 OFFSET 1; -- Gets 2nd, 3rd, 4th highest salaries

-- Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
SELECT COUNT(*) AS total_emps, SUM(salary) AS total_payroll, AVG(salary) AS avg_salary, MAX(salary) AS highest, MIN(salary) AS lowest FROM Employees;

-- GROUP BY & HAVING
SELECT dept_id, COUNT(*) AS emp_count, AVG(salary) AS avg_dept_salary
FROM Employees
GROUP BY dept_id
HAVING emp_count > 1;

-- ---------------------------------------------------------------------------------
-- JOINS
-- ---------------------------------------------------------------------------------
-- INNER JOIN
SELECT e.first_name, d.dept_name 
FROM Employees e INNER JOIN Departments d ON e.dept_id = d.dept_id;

-- LEFT JOIN
SELECT e.first_name, d.dept_name 
FROM Employees e LEFT JOIN Departments d ON e.dept_id = d.dept_id;

-- RIGHT JOIN
SELECT e.first_name, d.dept_name 
FROM Employees e RIGHT JOIN Departments d ON e.dept_id = d.dept_id;

-- CROSS JOIN
SELECT e.first_name, d.dept_name FROM Employees e CROSS JOIN Departments d;

-- SELF JOIN
SELECT e1.first_name AS Employee, e2.first_name AS Manager
FROM Employees e1 LEFT JOIN Employees e2 ON e1.manager_id = e2.emp_id;

-- ---------------------------------------------------------------------------------
-- SUBQUERIES & SET OPERATORS
-- ---------------------------------------------------------------------------------
-- Scalar Subquery
SELECT first_name, salary FROM Employees WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Correlated Subquery (finds employees who earn more than the average of their own department)
SELECT first_name, salary, dept_id 
FROM Employees e1
WHERE salary > (SELECT AVG(salary) FROM Employees e2 WHERE e1.dept_id = e2.dept_id);

-- Nested Subquery (IN / ANY / ALL)
SELECT dept_name FROM Departments WHERE dept_id IN (SELECT DISTINCT dept_id FROM Employees WHERE salary > 90000);
SELECT first_name FROM Employees WHERE salary > ALL (SELECT salary FROM Employees WHERE dept_id = 3);
SELECT first_name FROM Employees WHERE salary > ANY (SELECT salary FROM Employees WHERE dept_id = 1);

-- EXISTS
SELECT dept_name FROM Departments d WHERE EXISTS (SELECT 1 FROM Employees e WHERE e.dept_id = d.dept_id AND salary > 100000);

-- Set Operators (UNION, UNION ALL)
SELECT first_name AS name FROM Employees WHERE dept_id = 2
UNION
SELECT dept_name AS name FROM Departments;


-- ---------------------------------------------------------------------------------
-- 4. TCL (Transaction Control Language)
-- ---------------------------------------------------------------------------------
SET AUTOCOMMIT = 0; -- Turn off autocommit
START TRANSACTION;
UPDATE Employees SET salary = salary - 1000 WHERE emp_id = 1;
SAVEPOINT sp1;
UPDATE Employees SET salary = salary + 1000 WHERE emp_id = 2;
ROLLBACK TO sp1; -- Undoes the second update
COMMIT; -- Saves the first update
SET AUTOCOMMIT = 1;


-- ---------------------------------------------------------------------------------
-- 5. DCL (Data Control Language)
-- ---------------------------------------------------------------------------------
-- (These are commented out so they don't break execution if permissions are missing)
-- CREATE USER 'student_user'@'localhost' IDENTIFIED BY 'password123';
-- GRANT SELECT, INSERT ON practice_db.* TO 'student_user'@'localhost';
-- SHOW GRANTS FOR 'student_user'@'localhost';
-- REVOKE INSERT ON practice_db.* FROM 'student_user'@'localhost';
-- DROP USER 'student_user'@'localhost';


-- ---------------------------------------------------------------------------------
-- 8. Built-in Functions
-- ---------------------------------------------------------------------------------
-- String Functions
SELECT CONCAT(first_name, ' ', last_name) AS full_name, LENGTH(first_name), UPPER(last_name), LOWER(first_name), SUBSTRING(email, 1, 5), TRIM('  hello  '), REPLACE(email, '@email.com', '@company.com') FROM Employees;

-- Numeric Functions
SELECT ROUND(salary, 1), FLOOR(salary), CEIL(salary), ABS(-10), MOD(10, 3) FROM Employees;

-- Date & Time Functions
SELECT NOW(), CURDATE(), CURTIME(), DATEDIFF(CURDATE(), hire_date) AS days_worked, DATE_ADD(hire_date, INTERVAL 1 YEAR) AS anniversary, DATE_SUB(CURDATE(), INTERVAL 1 MONTH), DATE_FORMAT(hire_date, '%W, %M %d, %Y') FROM Employees;

-- Conditional Functions
SELECT first_name, salary, IF(salary > 80000, 'High', 'Low') AS income_level FROM Employees;
SELECT first_name, IFNULL(manager_id, 'No Manager') FROM Employees;
SELECT first_name, COALESCE(manager_id, dept_id, 0) AS first_non_null FROM Employees;

SELECT first_name, salary,
    CASE 
        WHEN salary > 100000 THEN 'Executive'
        WHEN salary BETWEEN 70000 AND 100000 THEN 'Senior'
        ELSE 'Junior'
    END AS employee_level
FROM Employees;


-- ---------------------------------------------------------------------------------
-- 9. Advanced Query Topics
-- ---------------------------------------------------------------------------------
-- Common Table Expressions (CTE)
WITH Dept_Avg AS (
    SELECT dept_id, AVG(salary) AS avg_sal FROM Employees GROUP BY dept_id
)
SELECT e.first_name, e.salary, d.avg_sal 
FROM Employees e JOIN Dept_Avg d ON e.dept_id = d.dept_id WHERE e.salary > d.avg_sal;

-- Recursive CTE (Generates numbers 1 to 5)
WITH RECURSIVE NumberCounter AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM NumberCounter WHERE n < 5
)
SELECT * FROM NumberCounter;

-- Window Functions
SELECT first_name, salary, dept_id,
    ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS row_num,
    RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS sal_rank,
    DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS dense_sal_rank,
    LEAD(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS next_lower_salary,
    LAG(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS previous_higher_salary
FROM Employees;

-- Views
CREATE VIEW High_Earners_View AS
SELECT first_name, last_name, salary FROM Employees WHERE salary > 90000;
-- SELECT * FROM High_Earners_View;
-- DROP VIEW High_Earners_View;

-- Indexes
CREATE INDEX idx_last_name ON Employees(last_name);
-- DROP INDEX idx_last_name ON Employees;

-- Stored Procedures
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN p_dept_id INT)
BEGIN
    SELECT * FROM Employees WHERE dept_id = p_dept_id;
END //
DELIMITER ;
-- CALL GetEmployeesByDept(2);
-- DROP PROCEDURE GetEmployeesByDept;

-- Functions
DELIMITER //
CREATE FUNCTION GetAnnualBonus(p_salary DECIMAL(10,2)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE bonus DECIMAL(10,2);
    SET bonus = p_salary * 0.10;
    RETURN bonus;
END //
DELIMITER ;
-- SELECT first_name, salary, GetAnnualBonus(salary) AS bonus FROM Employees;
-- DROP FUNCTION GetAnnualBonus;

-- Triggers
CREATE TABLE Employee_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    action VARCHAR(50),
    action_timestamp DATETIME
);

DELIMITER //
CREATE TRIGGER Before_Employee_Delete
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (emp_id, action, action_timestamp) 
    VALUES (OLD.emp_id, 'DELETED', NOW());
END //
DELIMITER ;
-- DELETE FROM Employees WHERE emp_id = 4;
-- SELECT * FROM Employee_Audit;
-- DROP TRIGGER Before_Employee_Delete;

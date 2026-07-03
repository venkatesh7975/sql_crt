-- =================================================================================
-- SQL PRACTICE SCRIPT FOR STUDENTS
-- =================================================================================
-- This script contains DDL (table creation), DML (data insertion), and 
-- a wide variety of practice queries ranging from basic to advanced.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- PART 1: DDL (Data Definition Language) - Create Tables
-- ---------------------------------------------------------------------------------

-- Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    HireDate DATE,
    JobTitle VARCHAR(50),
    Salary DECIMAL(10, 2),
    ManagerID INT,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- Create Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Budget DECIMAL(12, 2)
);

-- Create Employee_Projects mapping table (Many-to-Many relationship)
CREATE TABLE Employee_Projects (
    EmployeeID INT,
    ProjectID INT,
    Role VARCHAR(50),
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- ---------------------------------------------------------------------------------
-- PART 2: DML (Data Manipulation Language) - Insert Sample Data
-- ---------------------------------------------------------------------------------

-- Insert Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(10, 'Administration', 'New York'),
(20, 'Marketing', 'London'),
(30, 'Purchasing', 'New York'),
(40, 'Human Resources', 'London'),
(50, 'IT', 'San Francisco'),
(60, 'Sales', 'San Francisco');

-- Insert Employees
-- (ManagerID is NULL for top-level managers)
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, PhoneNumber, HireDate, JobTitle, Salary, ManagerID, DepartmentID) VALUES
(100, 'Steven', 'King', 'sking@company.com', '515.123.4567', '2010-06-17', 'President', 24000.00, NULL, 10),
(101, 'Neena', 'Kochhar', 'nkochhar@company.com', '515.123.4568', '2011-09-21', 'VP Administration', 17000.00, 100, 10),
(102, 'Lex', 'De Haan', 'ldehaan@company.com', '515.123.4569', '2012-01-13', 'VP Marketing', 17000.00, 100, 20),
(103, 'Alexander', 'Hunold', 'ahunold@company.com', '590.423.4567', '2015-01-03', 'IT Manager', 9000.00, 102, 50),
(104, 'Bruce', 'Ernst', 'bernst@company.com', '590.423.4568', '2016-05-21', 'Programmer', 6000.00, 103, 50),
(105, 'David', 'Austin', 'daustin@company.com', '590.423.4569', '2017-06-25', 'Programmer', 4800.00, 103, 50),
(106, 'Valli', 'Pataballa', 'vpatabal@company.com', '590.423.4560', '2018-02-05', 'Programmer', 4800.00, 103, 50),
(107, 'Diana', 'Lorentz', 'dlorentz@company.com', '590.423.5567', '2019-02-07', 'IT Support', 4200.00, 103, 50),
(108, 'Nancy', 'Greenberg', 'ngreenbe@company.com', '515.124.4569', '2015-08-17', 'Finance Manager', 12000.00, 101, 30),
(109, 'Daniel', 'Faviet', 'dfaviet@company.com', '515.124.4169', '2016-08-16', 'Accountant', 9000.00, 108, 30),
(110, 'John', 'Chen', 'jchen@company.com', '515.124.4269', '2017-09-28', 'Accountant', 8200.00, 108, 30),
(111, 'Ismael', 'Sciarra', 'isciarra@company.com', '515.124.4369', '2018-09-30', 'Accountant', 7700.00, 108, 30),
(112, 'Jose Manuel', 'Urman', 'jmorman@company.com', '515.124.4469', '2019-03-07', 'Accountant', 7800.00, 108, 30),
(113, 'Luis', 'Popp', 'lpopp@company.com', '515.124.4567', '2019-12-07', 'Accountant', 6900.00, 108, 30),
(114, 'Den', 'Raphaely', 'draphael@company.com', '515.127.4561', '2020-12-07', 'Purchasing Manager', 11000.00, 100, 30),
(115, 'Alexander', 'Khoo', 'akhoo@company.com', '515.127.4562', '2021-05-18', 'Purchasing Clerk', 3100.00, 114, 30),
(116, 'Shelli', 'Baida', 'sbaida@company.com', '515.127.4563', '2021-12-24', 'Purchasing Clerk', 2900.00, 114, 30),
(117, 'Sigal', 'Tobias', 'stobias@company.com', '515.127.4564', '2022-07-24', 'Purchasing Clerk', 2800.00, 114, 30),
(118, 'Guy', 'Himuro', 'ghimuro@company.com', '515.127.4565', '2022-11-15', 'Purchasing Clerk', 2600.00, 114, 30),
(119, 'Karen', 'Colmenares', 'kcolmena@company.com', '515.127.4566', '2023-08-10', 'Purchasing Clerk', 2500.00, 114, 30),
(120, 'Matthew', 'Weiss', 'mweiss@company.com', '650.123.1234', '2018-07-18', 'HR Manager', 8000.00, 100, 40),
(121, 'Adam', 'Fripp', 'afripp@company.com', '650.123.2234', '2019-04-10', 'HR Representative', 8200.00, 120, 40),
(122, 'Payam', 'Kaufling', 'pkauflin@company.com', '650.123.3234', '2019-05-01', 'HR Representative', 7900.00, 120, 40),
(123, 'Shanta', 'Vollman', 'svollman@company.com', '650.123.4234', '2021-10-10', 'HR Representative', 6500.00, 120, 40);

-- Insert Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, Budget) VALUES
(1, 'ERP Implementation', '2023-01-15', '2024-06-30', 500000.00),
(2, 'Website Redesign', '2023-03-01', '2023-09-30', 150000.00),
(3, 'Cloud Migration', '2023-06-01', '2024-12-31', 800000.00),
(4, 'New HR System', '2024-01-15', '2024-10-31', 250000.00),
(5, 'Sales Mobile App', '2024-02-01', '2024-08-31', 120000.00);

-- Insert Employee_Projects mapping
INSERT INTO Employee_Projects (EmployeeID, ProjectID, Role, HoursWorked) VALUES
(103, 1, 'Project Manager', 500),
(104, 1, 'Lead Developer', 450),
(105, 1, 'Developer', 400),
(102, 2, 'Project Sponsor', 50),
(106, 2, 'Developer', 300),
(107, 2, 'Tester', 250),
(103, 3, 'Project Manager', 600),
(104, 3, 'Architect', 550),
(105, 3, 'Developer', 500),
(120, 4, 'Project Manager', 300),
(121, 4, 'Business Analyst', 400),
(106, 4, 'Developer', 350),
(102, 5, 'Project Sponsor', 40),
(104, 5, 'Lead Developer', 200),
(107, 5, 'Tester', 150);

-- =================================================================================
-- PART 3: PRACTICE QUERIES
-- =================================================================================
-- Students should try to write the queries based on the comments before 
-- looking at the solution.
-- =================================================================================

-- ---------------------------------------------------------------------------------
-- SECTION A: BASIC SELECT & FILTERING (WHERE)
-- ---------------------------------------------------------------------------------

-- 1. Retrieve all columns from the Employees table.
SELECT * FROM Employees;

-- 2. Retrieve only the FirstName, LastName, and Email of all employees.
SELECT FirstName, LastName, Email FROM Employees;

-- 3. Find all employees who work in Department 50 (IT).
SELECT * FROM Employees WHERE DepartmentID = 50;

-- 4. Find all employees whose Salary is greater than 8000.
SELECT FirstName, LastName, Salary FROM Employees WHERE Salary > 8000;

-- 5. Find all employees who were hired after '2019-01-01'.
SELECT FirstName, LastName, HireDate FROM Employees WHERE HireDate > '2019-01-01';

-- 6. Find all employees in Department 30 whose Salary is between 5000 and 10000.
SELECT FirstName, LastName, DepartmentID, Salary 
FROM Employees 
WHERE DepartmentID = 30 AND Salary BETWEEN 5000 AND 10000;

-- 7. Find all employees whose LastName starts with 'K'.
SELECT FirstName, LastName FROM Employees WHERE LastName LIKE 'K%';

-- 8. Find all employees who do not have a manager (ManagerID is NULL).
SELECT FirstName, LastName FROM Employees WHERE ManagerID IS NULL;

-- 9. List all unique Job Titles found in the Employees table.
SELECT DISTINCT JobTitle FROM Employees;

-- 10. List employees sorted by Salary in descending order, then by LastName in ascending order.
SELECT FirstName, LastName, Salary 
FROM Employees 
ORDER BY Salary DESC, LastName ASC;

-- ---------------------------------------------------------------------------------
-- SECTION B: AGGREGATION & GROUPING (GROUP BY, HAVING)
-- ---------------------------------------------------------------------------------

-- 11. Find the total number of employees in the company.
SELECT COUNT(*) AS TotalEmployees FROM Employees;

-- 12. Find the highest, lowest, and average salary of all employees.
SELECT MAX(Salary) AS HighestSalary, MIN(Salary) AS LowestSalary, AVG(Salary) AS AverageSalary 
FROM Employees;

-- 13. Count how many employees are in each department.
SELECT DepartmentID, COUNT(*) AS EmployeeCount 
FROM Employees 
GROUP BY DepartmentID;

-- 14. Calculate the total salary paid to employees in each department.
SELECT DepartmentID, SUM(Salary) AS TotalSalary 
FROM Employees 
GROUP BY DepartmentID;

-- 15. Find the average salary for each Job Title.
SELECT JobTitle, AVG(Salary) AS AvgSalary 
FROM Employees 
GROUP BY JobTitle;

-- 16. Find departments that have more than 3 employees. (Requires HAVING)
SELECT DepartmentID, COUNT(*) AS EmployeeCount 
FROM Employees 
GROUP BY DepartmentID 
HAVING COUNT(*) > 3;

-- 17. Find the average salary by department, but only for departments where the average salary is greater than 7000.
SELECT DepartmentID, AVG(Salary) AS AverageSalary 
FROM Employees 
GROUP BY DepartmentID 
HAVING AVG(Salary) > 7000;

-- ---------------------------------------------------------------------------------
-- SECTION C: JOINS
-- ---------------------------------------------------------------------------------

-- 18. Retrieve the FirstName, LastName, and DepartmentName for all employees. (INNER JOIN)
SELECT e.FirstName, e.LastName, d.DepartmentName 
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 19. Retrieve employees and their department names, including employees who might not be assigned to a department. (LEFT JOIN)
SELECT e.FirstName, e.LastName, d.DepartmentName 
FROM Employees e
LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 20. Find all employees located in 'New York'.
SELECT e.FirstName, e.LastName, d.Location 
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Location = 'New York';

-- 21. List the EmployeeName and their Manager's Name. (SELF JOIN)
SELECT e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName, 
       m.FirstName AS ManagerFirstName, m.LastName AS ManagerLastName
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- 22. List all Projects and the total hours worked on each project.
SELECT p.ProjectName, SUM(ep.HoursWorked) AS TotalHours
FROM Projects p
JOIN Employee_Projects ep ON p.ProjectID = ep.ProjectID
GROUP BY p.ProjectID, p.ProjectName;

-- 23. List the names of employees who have worked on the 'Cloud Migration' project.
SELECT e.FirstName, e.LastName
FROM Employees e
JOIN Employee_Projects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Cloud Migration';

-- ---------------------------------------------------------------------------------
-- SECTION D: SUBQUERIES
-- ---------------------------------------------------------------------------------

-- 24. Find employees who earn more than the company's average salary.
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 25. Find the names of employees who work in the 'IT' department (using a subquery).
SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'IT');

-- 26. Find employees who have the same job title as 'David Austin'.
SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE JobTitle = (SELECT JobTitle FROM Employees WHERE FirstName = 'David' AND LastName = 'Austin')
  AND (FirstName != 'David' OR LastName != 'Austin');

-- 27. Find the department with the highest average salary.
SELECT DepartmentID, AVG(Salary) AS AvgSal
FROM Employees
GROUP BY DepartmentID
ORDER BY AvgSal DESC
LIMIT 1; -- Note: LIMIT is MySQL/PostgreSQL specific. Use TOP 1 for SQL Server or FETCH FIRST 1 ROWS ONLY for Oracle.

-- ---------------------------------------------------------------------------------
-- SECTION E: COMMON TABLE EXPRESSIONS (CTEs) & WINDOW FUNCTIONS (Advanced)
-- ---------------------------------------------------------------------------------

-- 28. Use a CTE to find employees earning more than 10000, then select their names.
WITH HighEarners AS (
    SELECT EmployeeID, FirstName, LastName, Salary
    FROM Employees
    WHERE Salary > 10000
)
SELECT FirstName, LastName FROM HighEarners;

-- 29. Rank employees within their department based on their salary (highest to lowest).
SELECT FirstName, LastName, DepartmentID, Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) as SalaryRank
FROM Employees;

-- 30. Calculate the running total of project budgets.
SELECT ProjectName, Budget,
       SUM(Budget) OVER (ORDER BY StartDate) as RunningTotalBudget
FROM Projects;

-- ---------------------------------------------------------------------------------
-- SECTION F: DML (Data Manipulation) - UPDATE & DELETE
-- ---------------------------------------------------------------------------------

-- 31. Give all employees in the IT department a 10% salary increase.
-- UPDATE Employees 
-- SET Salary = Salary * 1.10 
-- WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'IT');

-- 32. Update the end date of the 'Website Redesign' project to '2023-11-30'.
-- UPDATE Projects 
-- SET EndDate = '2023-11-30' 
-- WHERE ProjectName = 'Website Redesign';

-- 33. Delete all projects that have ended before 2024.
-- (Careful: This might fail due to foreign key constraints in Employee_Projects. 
--  You would need to delete the related records in Employee_Projects first.)
-- DELETE FROM Employee_Projects WHERE ProjectID IN (SELECT ProjectID FROM Projects WHERE EndDate < '2024-01-01');
-- DELETE FROM Projects WHERE EndDate < '2024-01-01';

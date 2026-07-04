## Challenge 1: Third Highest Salary
**Difficulty:** Medium
**Description:** Write a SQL query to get the third highest salary from the `Employee` table. If there is no third highest salary, return `NULL`. The query should effectively sort and identify the unique salaries.

**Schema Setup:**
```sql
CREATE TABLE Employee (
    Id INT, 
    Salary INT
);

INSERT INTO Employee (Id, Salary) VALUES 
(1, 100), 
(2, 200), 
(3, 300), 
(4, 300), 
(5, 400);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedSalaries AS (
    SELECT 
        Salary, 
        DENSE_RANK() OVER(ORDER BY Salary DESC) as rnk
    FROM Employee
)
SELECT MAX(Salary) AS ThirdHighestSalary
FROM RankedSalaries
WHERE rnk = 3;
```
**Explanation:** `DENSE_RANK()` is used here to rank salaries sequentially without skipping any ranks when duplicates are encountered. We wrap this in a CTE, and then we filter for the third rank. `MAX()` ensures that if the rank doesn't exist, we safely return `NULL`.
</details>

---

## Challenge 2: Department Top Three Salaries
**Difficulty:** Hard
**Description:** A company's executives are interested in seeing who earns the most money in each of the company's departments. Write a SQL query to find employees who earn the top three salaries in each of the company's departments.

**Schema Setup:**
```sql
CREATE TABLE Department (
    Id INT, 
    Name VARCHAR(50)
);

CREATE TABLE Employee (
    Id INT, 
    Name VARCHAR(50), 
    Salary INT, 
    DepartmentId INT
);

INSERT INTO Department (Id, Name) VALUES 
(1, 'IT'), 
(2, 'Sales');

INSERT INTO Employee (Id, Name, Salary, DepartmentId) VALUES 
(1, 'Joe', 85000, 1), 
(2, 'Henry', 80000, 2), 
(3, 'Sam', 60000, 2), 
(4, 'Max', 90000, 1), 
(5, 'Janet', 69000, 1), 
(6, 'Randy', 85000, 1), 
(7, 'Will', 70000, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedEmployees AS (
    SELECT 
        d.Name AS Department,
        e.Name AS Employee,
        e.Salary,
        DENSE_RANK() OVER(PARTITION BY d.Id ORDER BY e.Salary DESC) as rnk
    FROM Employee e
    JOIN Department d ON e.DepartmentId = d.Id
)
SELECT Department, Employee, Salary
FROM RankedEmployees
WHERE rnk <= 3;
```
**Explanation:** We use `DENSE_RANK()` combined with a `PARTITION BY` on the department ID. This generates a rank for each employee's salary within their specific department. The outer query then filters for ranks 1, 2, and 3, securing the top three earners across all departments.
</details>

---

## Challenge 3: Median Employee Salary
**Difficulty:** Hard
**Description:** Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in median functions.

**Schema Setup:**
```sql
CREATE TABLE Employee (
    Id INT, 
    Company VARCHAR(50), 
    Salary INT
);

INSERT INTO Employee (Id, Company, Salary) VALUES 
(1, 'A', 2341), (2, 'A', 341), (3, 'A', 15), (4, 'A', 15314), (5, 'A', 451), (6, 'A', 513), 
(7, 'B', 15), (8, 'B', 13), (9, 'B', 1156), (10, 'B', 1345), (11, 'B', 1221), (12, 'B', 234), 
(13, 'C', 2345), (14, 'C', 2645), (15, 'C', 2645), (16, 'C', 2652), (17, 'C', 65);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedSalaries AS (
    SELECT 
        Id,
        Company,
        Salary,
        ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Salary ASC, Id ASC) as rn,
        COUNT(Id) OVER(PARTITION BY Company) as cnt
    FROM Employee
)
SELECT Id, Company, Salary
FROM RankedSalaries
WHERE rn BETWEEN cnt / 2.0 AND (cnt / 2.0) + 1;
```
**Explanation:** To find the median, we give each salary an ascending `ROW_NUMBER` and get the total count `cnt` of employees in that company. The mathematical trick `rn BETWEEN cnt / 2.0 AND (cnt / 2.0) + 1` correctly pinpoints the exact median bounds. It works smoothly for both even and odd total counts.
</details>

---

## Challenge 4: Average Salary: Departments VS Company
**Difficulty:** Hard
**Description:** Given two tables, write a query to display the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary for each pay month.

**Schema Setup:**
```sql
CREATE TABLE Salary (
    id INT, 
    employee_id INT, 
    amount INT, 
    pay_date DATE
);

CREATE TABLE Employee (
    employee_id INT, 
    department_id INT
);

INSERT INTO Salary (id, employee_id, amount, pay_date) VALUES 
(1, 1, 9000, '2017-03-31'), 
(2, 2, 6000, '2017-03-31'), 
(3, 3, 10000, '2017-03-31'), 
(4, 1, 7000, '2017-02-28'), 
(5, 2, 6000, '2017-02-28'), 
(6, 3, 8000, '2017-02-28');

INSERT INTO Employee (employee_id, department_id) VALUES 
(1, 1), 
(2, 2), 
(3, 2);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH DeptAvg AS (
    SELECT 
        DATE_FORMAT(s.pay_date, '%Y-%m') as pay_month,
        e.department_id,
        AVG(s.amount) as dept_avg
    FROM Salary s
    JOIN Employee e ON s.employee_id = e.employee_id
    GROUP BY DATE_FORMAT(s.pay_date, '%Y-%m'), e.department_id
),
CompAvg AS (
    SELECT 
        DATE_FORMAT(pay_date, '%Y-%m') as pay_month,
        AVG(amount) as comp_avg
    FROM Salary
    GROUP BY DATE_FORMAT(pay_date, '%Y-%m')
)
SELECT 
    d.pay_month,
    d.department_id,
    CASE 
        WHEN d.dept_avg > c.comp_avg THEN 'higher'
        WHEN d.dept_avg < c.comp_avg THEN 'lower'
        ELSE 'same'
    END AS comparison
FROM DeptAvg d
JOIN CompAvg c ON d.pay_month = c.pay_month
ORDER BY d.pay_month DESC, d.department_id;
```
**Explanation:** We create two CTEs. The first aggregates the average salary grouped by department and pay month. The second aggregates the average salary for the whole company grouped purely by pay month. We then join the two CTEs on the pay month and compare their averages using a `CASE` statement.
</details>

---

## Challenge 5: Get the Second Most Recent Activity
**Difficulty:** Hard
**Description:** Write a SQL query to show the second most recent activity of each user. If the user only has one activity, return that one. A user cannot perform more than one activity at the same time.

**Schema Setup:**
```sql
CREATE TABLE UserActivity (
    username VARCHAR(50), 
    activity VARCHAR(50), 
    startDate DATE, 
    endDate DATE
);

INSERT INTO UserActivity (username, activity, startDate, endDate) VALUES 
('Alice', 'Travel', '2020-02-12', '2020-02-20'), 
('Alice', 'Dancing', '2020-02-21', '2020-02-23'), 
('Alice', 'Travel', '2020-02-24', '2020-02-28'), 
('Bob', 'Travel', '2020-02-11', '2020-02-18');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedActivities AS (
    SELECT 
        username,
        activity,
        startDate,
        endDate,
        ROW_NUMBER() OVER(PARTITION BY username ORDER BY startDate DESC) as rn,
        COUNT(activity) OVER(PARTITION BY username) as cnt
    FROM UserActivity
)
SELECT username, activity, startDate, endDate
FROM RankedActivities
WHERE rn = 2 OR cnt = 1;
```
**Explanation:** A combined use of `ROW_NUMBER()` (to sort each user's activities from newest to oldest) and `COUNT()` window function (to count how many activities the user has) solves this problem elegantly. The WHERE clause catches users whose target row is their 2nd most recent activity, OR catching the one and only activity if they have just one.
</details>

---

## Challenge 6: Tournament Winners
**Difficulty:** Hard
**Description:** Write a SQL query to find the winner in each group. The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest `player_id` wins.

**Schema Setup:**
```sql
CREATE TABLE Players (
    player_id INT, 
    group_id INT
);

CREATE TABLE Matches (
    match_id INT, 
    first_player INT, 
    second_player INT, 
    first_score INT, 
    second_score INT
);

INSERT INTO Players (player_id, group_id) VALUES 
(10, 2), (15, 1), (25, 1), (30, 1), (40, 3), (45, 1), (50, 2);

INSERT INTO Matches (match_id, first_player, second_player, first_score, second_score) VALUES 
(1, 15, 45, 3, 0), 
(2, 30, 25, 1, 2), 
(3, 30, 15, 2, 0), 
(4, 40, 20, 5, 2), 
(5, 35, 50, 1, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH PlayerScores AS (
    SELECT first_player AS player_id, first_score AS score FROM Matches
    UNION ALL
    SELECT second_player AS player_id, second_score AS score FROM Matches
),
AggregatedScores AS (
    SELECT player_id, SUM(score) as total_score
    FROM PlayerScores
    GROUP BY player_id
),
RankedPlayers AS (
    SELECT 
        p.group_id,
        p.player_id,
        COALESCE(a.total_score, 0) as total_score,
        ROW_NUMBER() OVER(
            PARTITION BY p.group_id 
            ORDER BY COALESCE(a.total_score, 0) DESC, p.player_id ASC
        ) as rn
    FROM Players p
    LEFT JOIN AggregatedScores a ON p.player_id = a.player_id
)
SELECT group_id, player_id
FROM RankedPlayers
WHERE rn = 1;
```
**Explanation:** Because a player can be listed as a `first_player` or a `second_player`, we `UNION ALL` these sources to normalize the scores. Next, we aggregate all scores per player. Finally, we rank the players by group using `ROW_NUMBER()`, taking special care to handle score ties by sorting by `player_id ASC`.
</details>

---

## Challenge 7: Project Employees III
**Difficulty:** Medium
**Description:** Write an SQL query that reports the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years for that project.

**Schema Setup:**
```sql
CREATE TABLE Project (
    project_id INT, 
    employee_id INT
);

CREATE TABLE Employee (
    employee_id INT, 
    name VARCHAR(50), 
    experience_years INT
);

INSERT INTO Project (project_id, employee_id) VALUES 
(1, 1), (1, 2), (1, 3), (2, 1), (2, 4);

INSERT INTO Employee (employee_id, name, experience_years) VALUES 
(1, 'Khaled', 3), (2, 'Ali', 2), (3, 'John', 3), (4, 'Doe', 2);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedExperience AS (
    SELECT 
        p.project_id,
        p.employee_id,
        RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) as rnk
    FROM Project p
    JOIN Employee e ON p.employee_id = e.employee_id
)
SELECT project_id, employee_id
FROM RankedExperience
WHERE rnk = 1;
```
**Explanation:** `RANK()` is chosen over `ROW_NUMBER()` because the problem explicitly states that in the event of a tie we need to report ALL matching employees. `RANK()` applies the exact same rank to multiple rows if they share identical values.
</details>

---

## Challenge 8: Game Play Analysis III
**Difficulty:** Medium
**Description:** Write a SQL query to report for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date.

**Schema Setup:**
```sql
CREATE TABLE Activity (
    player_id INT, 
    device_id INT, 
    event_date DATE, 
    games_played INT
);

INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES 
(1, 2, '2016-03-01', 5), 
(1, 2, '2016-05-02', 6), 
(1, 3, '2017-06-25', 1), 
(3, 1, '2016-03-02', 0), 
(3, 4, '2018-07-03', 5);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    player_id, 
    event_date,
    SUM(games_played) OVER(
        PARTITION BY player_id 
        ORDER BY event_date
    ) as games_played_so_far
FROM Activity;
```
**Explanation:** This is a classic rolling aggregation. The window function `SUM()` combined with an `ORDER BY` clause inside the `OVER()` function automatically acts as a rolling cumulative sum. As we sort sequentially by date for each player, it adds all the preceding rows to the current row.
</details>

---

## Challenge 9: Find the Quiet Students in All Exams
**Difficulty:** Hard
**Description:** A "quiet" student is one who took at least one exam and did not score the highest or the lowest score on ANY of the exams they took. Write an SQL query to report the students (student_id, student_name) being quiet in all exams.

**Schema Setup:**
```sql
CREATE TABLE Student (
    student_id INT, 
    student_name VARCHAR(50)
);

CREATE TABLE Exam (
    exam_id INT, 
    student_id INT, 
    score INT
);

INSERT INTO Student (student_id, student_name) VALUES 
(1, 'Daniel'), (2, 'Jade'), (3, 'Stella'), (4, 'Jonathan'), (5, 'Will');

INSERT INTO Exam (exam_id, student_id, score) VALUES 
(10, 1, 70), (10, 2, 80), (10, 3, 90), 
(20, 1, 80), 
(30, 1, 70), (30, 3, 80), (30, 4, 90), 
(40, 1, 60), (40, 2, 70), (40, 4, 80);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedScores AS (
    SELECT 
        exam_id,
        student_id,
        score,
        RANK() OVER(PARTITION BY exam_id ORDER BY score DESC) as rank_highest,
        RANK() OVER(PARTITION BY exam_id ORDER BY score ASC) as rank_lowest
    FROM Exam
),
NoisyStudents AS (
    SELECT DISTINCT student_id
    FROM RankedScores
    WHERE rank_highest = 1 OR rank_lowest = 1
)
SELECT s.student_id, s.student_name
FROM Student s
JOIN Exam e ON s.student_id = e.student_id
WHERE s.student_id NOT IN (SELECT student_id FROM NoisyStudents)
GROUP BY s.student_id, s.student_name
ORDER BY s.student_id;
```
**Explanation:** The first CTE finds both the highest rank and lowest rank using normal `RANK()` for every student inside an exam. Any student that ever hits rank 1 (either highest or lowest) in any exam gets added to the `NoisyStudents` list. In the final query, we check that they participated in at least one exam (via `JOIN`) and aren't in the `NoisyStudents` list.
</details>

---

## Challenge 10: Active Businesses
**Difficulty:** Medium
**Description:** An active business is a business that has more than one event type such that their event occurrences are strictly greater than the average occurrences of that event type among all businesses. Write a SQL query to find all active businesses.

**Schema Setup:**
```sql
CREATE TABLE Events (
    business_id INT, 
    event_type VARCHAR(50), 
    occurrences INT
);

INSERT INTO Events (business_id, event_type, occurrences) VALUES 
(1, 'reviews', 7), 
(3, 'reviews', 3), 
(1, 'ads', 11), 
(2, 'ads', 7), 
(3, 'ads', 6), 
(1, 'page views', 3), 
(2, 'page views', 12);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH EventAvg AS (
    SELECT 
        event_type, 
        AVG(occurrences) as avg_occ
    FROM Events
    GROUP BY event_type
)
SELECT e.business_id
FROM Events e
JOIN EventAvg a ON e.event_type = a.event_type
WHERE e.occurrences > a.avg_occ
GROUP BY e.business_id
HAVING COUNT(e.event_type) > 1;
```
**Explanation:** We start by aggregating the average occurrences globally across each `event_type`. We then `JOIN` this average back to our `Events` table, allowing us to evaluate if a business exceeded the global average on a row-by-row basis. Finally, filtering out those who passed the test by grouping them and leveraging `HAVING COUNT > 1` secures businesses that succeeded in more than one distinct event category.
</details>

---

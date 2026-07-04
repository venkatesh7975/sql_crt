# Advanced Business Logic SQL Challenges

## Challenge 1: Trips and Users (Cancellation Rate)
**Difficulty:** Hard
**Description:** Calculate the cancellation rate of unbanned users (both client and driver) each day between '2023-10-01' and '2023-10-03'. The cancellation rate is computed by dividing the number of canceled requests made by unbanned users by the total number of requests made by unbanned users on that day. Return the result rounded to 2 decimal places.

**Schema Setup:**
```sql
CREATE TABLE Users (
    users_id INT,
    banned VARCHAR(10),
    role VARCHAR(10)
);

CREATE TABLE Trips (
    id INT,
    client_id INT,
    driver_id INT,
    city_id INT,
    status VARCHAR(50),
    request_at DATE
);

INSERT INTO Users VALUES (1, 'No', 'client'), (2, 'Yes', 'client'), (3, 'No', 'client'), (4, 'No', 'client'), (10, 'No', 'driver'), (11, 'No', 'driver'), (12, 'No', 'driver'), (13, 'No', 'driver');
INSERT INTO Trips VALUES (1, 1, 10, 1, 'completed', '2023-10-01'), (2, 2, 11, 1, 'cancelled_by_driver', '2023-10-01'), (3, 3, 12, 6, 'completed', '2023-10-01'), (4, 4, 13, 6, 'cancelled_by_client', '2023-10-01'), (5, 1, 10, 1, 'completed', '2023-10-02'), (6, 2, 11, 6, 'completed', '2023-10-02'), (7, 3, 12, 6, 'completed', '2023-10-02'), (8, 2, 12, 12, 'completed', '2023-10-03'), (9, 3, 10, 12, 'completed', '2023-10-03'), (10, 4, 13, 12, 'cancelled_by_driver', '2023-10-03');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    request_at AS Day,
    ROUND(
        SUM(IF(status != 'completed', 1, 0)) / COUNT(*), 
    2) AS 'Cancellation Rate'
FROM Trips t
JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No'
JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
WHERE request_at BETWEEN '2023-10-01' AND '2023-10-03'
GROUP BY request_at;
```
**Explanation:** By joining the `Trips` table twice to the `Users` table (once for clients and once for drivers), we can filter out any trips where either the client or the driver was banned. The `IF` function within the `SUM` helps us easily count the non-completed (canceled) trips and compute the ratio.
</details>

---

## Challenge 2: Game Play Analysis (Next Day Retention)
**Difficulty:** Medium
**Description:** Write a query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. You need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

**Schema Setup:**
```sql
CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT
);

INSERT INTO Activity VALUES (1, 2, '2023-03-01', 5), (1, 2, '2023-03-02', 6), (2, 3, '2023-06-25', 1), (3, 1, '2023-03-02', 0), (3, 4, '2023-07-03', 5);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH FirstLogin AS (
    SELECT player_id, MIN(event_date) as first_date
    FROM Activity
    GROUP BY player_id
)
SELECT 
    ROUND(
        COUNT(a.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 
    2) AS fraction
FROM FirstLogin f
LEFT JOIN Activity a 
ON f.player_id = a.player_id AND a.event_date = DATE_ADD(f.first_date, INTERVAL 1 DAY);
```
**Explanation:** First, we identify the exact first login date for each player using `MIN(event_date)`. Then, we perform a left join with the `Activity` table to see if that specific player has a corresponding record for exactly one day after their initial login date (`DATE_ADD`). Finally, we calculate the fraction based on the count of retained players.
</details>

---

## Challenge 3: Median Employee Salary
**Difficulty:** Hard
**Description:** Find the median salary of each company. The median is the value separating the higher half from the lower half of a data sample. If there is an even number of observations, the median is the average of the two middle values. Return the id, company, and salary, and order by company and salary.

**Schema Setup:**
```sql
CREATE TABLE Employee (
    id INT,
    company VARCHAR(50),
    salary INT
);

INSERT INTO Employee VALUES (1, 'A', 2341), (2, 'A', 341), (3, 'A', 15), (4, 'A', 15314), (5, 'A', 451), (6, 'A', 513), (7, 'B', 15), (8, 'B', 13), (9, 'B', 1154), (10, 'B', 1345), (11, 'B', 1221), (12, 'B', 234), (13, 'C', 2345), (14, 'C', 2645), (15, 'C', 2645), (16, 'C', 2652), (17, 'C', 65);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedSalaries AS (
    SELECT 
        id, 
        company, 
        salary,
        ROW_NUMBER() OVER (PARTITION BY company ORDER BY salary ASC, id ASC) as rnk,
        COUNT(id) OVER (PARTITION BY company) as cnt
    FROM Employee
)
SELECT id, company, salary
FROM RankedSalaries
WHERE rnk BETWEEN cnt/2.0 AND cnt/2.0 + 1
ORDER BY company, salary;
```
**Explanation:** We assign a unique `ROW_NUMBER` to each salary per company, ordered ascendingly, while also determining the total `COUNT` of employees per company using window functions. The median values naturally fall between `cnt / 2.0` and `(cnt / 2.0) + 1` regardless of whether the count is even or odd, making filtering extremely straightforward.
</details>

---

## Challenge 4: Human Traffic of Stadium
**Difficulty:** Hard
**Description:** Write a query to display the records with three or more rows with consecutive `id`s, and where the number of people is greater than or equal to 100 for each. Return the result table ordered by `visit_date` in ascending order.

**Schema Setup:**
```sql
CREATE TABLE Stadium (
    id INT,
    visit_date DATE,
    people INT
);

INSERT INTO Stadium VALUES (1, '2023-01-01', 10), (2, '2023-01-02', 109), (3, '2023-01-03', 150), (4, '2023-01-04', 99), (5, '2023-01-05', 145), (6, '2023-01-06', 1455), (7, '2023-01-07', 199), (8, '2023-01-08', 188);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH GroupedStadium AS (
    SELECT 
        id, visit_date, people,
        id - ROW_NUMBER() OVER(ORDER BY id) as grp
    FROM Stadium
    WHERE people >= 100
),
CountedStadium AS (
    SELECT 
        id, visit_date, people,
        COUNT(id) OVER(PARTITION BY grp) as cnt
    FROM GroupedStadium
)
SELECT id, visit_date, people
FROM CountedStadium
WHERE cnt >= 3
ORDER BY visit_date ASC;
```
**Explanation:** This is a classic "gaps and islands" problem. By filtering for `people >= 100` and subtracting a sequential `ROW_NUMBER()` from the `id`, consecutive records will be grouped into the same `grp` identifier. We then use a window function to count how many records share the same `grp`, and filter for counts of 3 or more.
</details>

---

## Challenge 5: Report Contiguous Dates of State
**Difficulty:** Hard
**Description:** A system runs a task every day. Each task is either a success or a failure. Write a query to find the start date, end date, and state for each continuous sequence of identical states. Order the result by `start_date`.

**Schema Setup:**
```sql
CREATE TABLE Tasks (
    task_id INT,
    state VARCHAR(20),
    task_date DATE
);

INSERT INTO Tasks VALUES (1, 'success', '2023-01-01'), (2, 'success', '2023-01-02'), (3, 'fail', '2023-01-03'), (4, 'fail', '2023-01-04'), (5, 'fail', '2023-01-05'), (6, 'success', '2023-01-06');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedTasks AS (
    SELECT 
        state,
        task_date,
        DATE_SUB(task_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY state ORDER BY task_date) DAY) as grp
    FROM Tasks
)
SELECT 
    MIN(task_date) AS start_date,
    MAX(task_date) AS end_date,
    state
FROM RankedTasks
GROUP BY state, grp
ORDER BY start_date;
```
**Explanation:** We use another variant of the "gaps and islands" technique. Subtracting the `ROW_NUMBER` (partitioned by state) as days from the actual `task_date` yields a constant anchor date (`grp`) for consecutive sequences of the same state. Grouping by both `state` and this `grp` anchor lets us extract the `MIN` and `MAX` dates for the contiguous span.
</details>

---

## Challenge 6: Department Top Three Salaries
**Difficulty:** Hard
**Description:** A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department. Write a query to find the employees who are high earners in each of the departments.

**Schema Setup:**
```sql
CREATE TABLE Department (
    id INT,
    name VARCHAR(50)
);
CREATE TABLE Employee (
    id INT,
    name VARCHAR(50),
    salary INT,
    departmentId INT
);

INSERT INTO Department VALUES (1, 'IT'), (2, 'Sales');
INSERT INTO Employee VALUES (1, 'Joe', 85000, 1), (2, 'Henry', 80000, 2), (3, 'Sam', 60000, 2), (4, 'Max', 90000, 1), (5, 'Janet', 69000, 1), (6, 'Randy', 85000, 1), (7, 'Will', 70000, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedEmployees AS (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) as rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM RankedEmployees
WHERE rnk <= 3;
```
**Explanation:** The `DENSE_RANK()` window function provides a ranking without gaps, meaning tied salaries receive the same rank, and the next lowest salary receives the subsequent integer rank. By partitioning on `departmentId`, we can cleanly filter out anyone not within the top 3 ranks per department.
</details>

---

## Challenge 7: Exchange Seats
**Difficulty:** Medium
**Description:** Write a query to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped. The output should be ordered by id in ascending order.

**Schema Setup:**
```sql
CREATE TABLE Seat (
    id INT,
    student VARCHAR(50)
);

INSERT INTO Seat VALUES (1, 'Abbot'), (2, 'Doris'), (3, 'Emerson'), (4, 'Green'), (5, 'Jeames');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    CASE 
        WHEN id % 2 != 0 AND id = (SELECT COUNT(*) FROM Seat) THEN id
        WHEN id % 2 != 0 THEN id + 1
        ELSE id - 1
    END AS id,
    student
FROM Seat
ORDER BY id;
```
**Explanation:** This relies on simple arithmetic evaluation within a `CASE` statement. If an ID is odd and happens to be the last seat in the table (which we find via a subquery), it remains unchanged. For all other odd IDs, we add 1. For all even IDs, we subtract 1.
</details>

---

## Challenge 8: Page Recommendations
**Difficulty:** Medium
**Description:** Write a query to recommend pages to the user with `user_id = 1` based on the pages that their friends liked. It should not recommend pages the user has already liked. Return the distinct page IDs.

**Schema Setup:**
```sql
CREATE TABLE Friendship (
    user1_id INT,
    user2_id INT
);
CREATE TABLE Likes (
    user_id INT,
    page_id INT
);

INSERT INTO Friendship VALUES (1, 2), (1, 3), (1, 4), (2, 3), (2, 4), (2, 5), (6, 1);
INSERT INTO Likes VALUES (1, 88), (2, 23), (3, 24), (4, 56), (5, 11), (6, 33), (2, 77), (3, 77), (6, 88);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Friends AS (
    SELECT user2_id AS friend_id FROM Friendship WHERE user1_id = 1
    UNION
    SELECT user1_id AS friend_id FROM Friendship WHERE user2_id = 1
)
SELECT DISTINCT page_id AS recommended_page
FROM Likes
WHERE user_id IN (SELECT friend_id FROM Friends)
AND page_id NOT IN (SELECT page_id FROM Likes WHERE user_id = 1);
```
**Explanation:** The friendship table requires checking both columns (`user1_id` and `user2_id`) for mutual directionality, which is best solved cleanly with a `UNION` CTE. Once the full list of friends is gathered, we select the unique pages they've liked that do not appear in the subquery of pages already liked by `user_id = 1`.
</details>

---

## Challenge 9: Tournament Winners
**Difficulty:** Hard
**Description:** The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest `player_id` wins. Write a query to find the winner in each group.

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

INSERT INTO Players VALUES (15, 1), (25, 1), (30, 1), (45, 1), (10, 2), (35, 2), (50, 2), (20, 3), (40, 3);
INSERT INTO Matches VALUES (1, 15, 45, 3, 0), (2, 30, 25, 1, 2), (3, 30, 15, 2, 0), (4, 40, 20, 5, 2), (5, 35, 50, 1, 1);
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
    SELECT p.group_id, p.player_id, COALESCE(SUM(ps.score), 0) AS total_score
    FROM Players p
    LEFT JOIN PlayerScores ps ON p.player_id = ps.player_id
    GROUP BY p.group_id, p.player_id
),
RankedScores AS (
    SELECT group_id, player_id, 
           ROW_NUMBER() OVER (PARTITION BY group_id ORDER BY total_score DESC, player_id ASC) as rnk
    FROM AggregatedScores
)
SELECT group_id, player_id
FROM RankedScores
WHERE rnk = 1;
```
**Explanation:** Points must be extracted twice using `UNION ALL` (once for `first_player` and once for `second_player`) to get a cohesive list of all scores per player. We then aggregate these scores. Finally, applying `ROW_NUMBER` partitioned by `group_id` allows us to break ties easily by sorting first on `total_score DESC` and then on `player_id ASC`. 
</details>

---

## Challenge 10: Find the Quiet Students in All Exams
**Difficulty:** Hard
**Description:** A "quiet" student is one who took at least one exam and didn't score the highest or lowest score in any of their exams. Write an SQL query to report the student IDs and names of the quiet students.

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

INSERT INTO Student VALUES (1, 'Daniel'), (2, 'Jade'), (3, 'Stella'), (4, 'Jonathan'), (5, 'Will');
INSERT INTO Exam VALUES (10, 1, 70), (10, 2, 80), (10, 3, 90), (20, 1, 80), (30, 1, 70), (30, 3, 80), (30, 4, 90), (40, 1, 60), (40, 2, 70), (40, 4, 80);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH ExamExtremes AS (
    SELECT 
        exam_id, 
        student_id, 
        score,
        MAX(score) OVER(PARTITION BY exam_id) as max_score,
        MIN(score) OVER(PARTITION BY exam_id) as min_score
    FROM Exam
),
ExtremeFlags AS (
    SELECT 
        student_id,
        SUM(IF(score = max_score OR score = min_score, 1, 0)) as extreme_count
    FROM ExamExtremes
    GROUP BY student_id
)
SELECT s.student_id, s.student_name
FROM Student s
JOIN ExtremeFlags e ON s.student_id = e.student_id
WHERE e.extreme_count = 0
ORDER BY s.student_id;
```
**Explanation:** We use window functions (`MAX` and `MIN`) scoped to each `exam_id` to evaluate the boundaries of every test. In the subsequent CTE, we assign a flag of `1` whenever a student's score touches either extreme. A simple inner join against the `Student` table filtering for `extreme_count = 0` guarantees the student participated in an exam and managed to remain "quiet" every time.
</details>

---

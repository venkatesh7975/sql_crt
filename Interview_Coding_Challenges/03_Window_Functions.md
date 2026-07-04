# 03 - Window Functions

## Challenge 1: Consecutive Numbers
**Difficulty:** Medium
**Description:** Write a SQL query to find all numbers that appear at least three times consecutively in the `Logs` table.

**Schema Setup:**
```sql
CREATE TABLE Logs (id INT, num INT);
INSERT INTO Logs VALUES 
(1, 1), (2, 1), (3, 1), (4, 2), 
(5, 1), (6, 2), (7, 2);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH NumberLags AS (
    SELECT num,
           LAG(num, 1) OVER (ORDER BY id) AS prev_1,
           LAG(num, 2) OVER (ORDER BY id) AS prev_2
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM NumberLags
WHERE num = prev_1 AND num = prev_2;
```
**Explanation:** By using the `LAG()` window function, we can look at the previous row's and the second previous row's numbers. If the current number matches both `LAG` values, it means the number has appeared three times consecutively.
</details>

---

## Challenge 2: Exchange Seats
**Difficulty:** Medium
**Description:** Write an SQL query to swap the seat `id` of every two consecutive students. If the number of students is odd, the `id` of the last student is not swapped.

**Schema Setup:**
```sql
CREATE TABLE Seat (id INT, student VARCHAR(255));
INSERT INTO Seat VALUES 
(1, 'Abbot'), (2, 'Doris'), (3, 'Emerson'), 
(4, 'Green'), (5, 'Jeames');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    CASE 
        WHEN MOD(id, 2) != 0 AND LEAD(id) OVER (ORDER BY id) IS NOT NULL THEN id + 1
        WHEN MOD(id, 2) = 0 THEN id - 1
        ELSE id
    END AS id, 
    student
FROM Seat
ORDER BY id;
```
**Explanation:** We use a `CASE` statement with `MOD(id, 2)` to determine if a seat ID is odd or even. For odd IDs with a valid following row (using `LEAD()`), we increment the ID by 1. For even IDs, we decrement by 1. The last odd ID remains unchanged.
</details>

---

## Challenge 3: Department Top Three Salaries
**Difficulty:** Hard
**Description:** A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department. Write an SQL query to find the employees who are high earners in each of the departments.

**Schema Setup:**
```sql
CREATE TABLE Department (id INT, name VARCHAR(255));
CREATE TABLE Employee (id INT, name VARCHAR(255), salary INT, departmentId INT);

INSERT INTO Department VALUES (1, 'IT'), (2, 'Sales');
INSERT INTO Employee VALUES 
(1, 'Joe', 85000, 1), (2, 'Henry', 80000, 2), 
(3, 'Sam', 60000, 2), (4, 'Max', 90000, 1), 
(5, 'Janet', 69000, 1), (6, 'Randy', 85000, 1), 
(7, 'Will', 70000, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedSalaries AS (
    SELECT d.name AS Department, 
           e.name AS Employee, 
           e.salary AS Salary,
           DENSE_RANK() OVER (PARTITION BY d.id ORDER BY e.salary DESC) as rnk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM RankedSalaries
WHERE rnk <= 3;
```
**Explanation:** `DENSE_RANK()` assigns ranks to unique salary values within each department (`PARTITION BY d.id`) in descending order. By filtering for ranks `<= 3`, we accurately retrieve the top three salaries, tying employees correctly.
</details>

---

## Challenge 4: Running Total for Different Genders
**Difficulty:** Medium
**Description:** Write an SQL query to find the running total of scores for each gender ordered by day.

**Schema Setup:**
```sql
CREATE TABLE Scores (player_name VARCHAR(255), gender VARCHAR(255), day DATE, score_points INT);
INSERT INTO Scores VALUES 
('Aron', 'F', '2020-01-01', 17), 
('Alice', 'F', '2020-01-07', 23), 
('Bajrang', 'M', '2020-01-07', 7), 
('Khali', 'M', '2019-12-25', 11), 
('Slammer', 'M', '2019-12-30', 13), 
('Joe', 'M', '2019-12-31', 3), 
('Jose', 'M', '2019-12-18', 2), 
('Priya', 'F', '2019-12-31', 23);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT gender, day, 
       SUM(score_points) OVER (PARTITION BY gender ORDER BY day) AS total
FROM Scores
ORDER BY gender, day;
```
**Explanation:** The `SUM()` window function coupled with `ORDER BY day` naturally behaves as a running total. We partition by `gender` to maintain separate running sums for males and females.
</details>

---

## Challenge 5: Moving Average of Sales (Restaurant Growth)
**Difficulty:** Medium
**Description:** You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day). Compute the moving average of how much the customer paid in a 7-day window (i.e., current day + 6 days before). 

**Schema Setup:**
```sql
CREATE TABLE Customer (customer_id INT, name VARCHAR(255), visited_on DATE, amount INT);
INSERT INTO Customer VALUES 
(1, 'Jhon', '2019-01-01', 100), (2, 'Daniel', '2019-01-02', 110), 
(3, 'Jade', '2019-01-03', 120), (4, 'Khaled', '2019-01-04', 130), 
(5, 'Winston', '2019-01-05', 110), (6, 'Elvis', '2019-01-06', 140), 
(7, 'Anna', '2019-01-07', 150), (8, 'Maria', '2019-01-08', 80), 
(9, 'Jaze', '2019-01-09', 110), (1, 'Jhon', '2019-01-10', 130), 
(3, 'Jade', '2019-01-10', 150);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH DailySum AS (
    SELECT visited_on, SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
),
MovingStats AS (
    SELECT visited_on, 
           SUM(daily_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
           ROUND(AVG(daily_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount,
           ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM DailySum
)
SELECT visited_on, amount, average_amount
FROM MovingStats
WHERE rn >= 7;
```
**Explanation:** We first aggregate total sales per day. Then we use window functions with a `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` frame to calculate the 7-day rolling sum and average. The `ROW_NUMBER` filter ensures we only display rows that have a full 7-day history.
</details>

---

## Challenge 6: Human Traffic of Stadium
**Difficulty:** Hard
**Description:** Write an SQL query to display the records with three or more rows with consecutive `id`s, and where the number of people is greater than or equal to 100 for each. Return the result table ordered by `visit_date` in ascending order.

**Schema Setup:**
```sql
CREATE TABLE Stadium (id INT, visit_date DATE, people INT);
INSERT INTO Stadium VALUES 
(1, '2017-01-01', 10), (2, '2017-01-02', 109), 
(3, '2017-01-03', 150), (4, '2017-01-04', 99), 
(5, '2017-01-05', 145), (6, '2017-01-06', 1455), 
(7, '2017-01-07', 199), (8, '2017-01-09', 188);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Filtered AS (
    SELECT id, visit_date, people,
           id - ROW_NUMBER() OVER(ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
),
GroupCounts AS (
    SELECT grp, COUNT(*) as cnt
    FROM Filtered
    GROUP BY grp
)
SELECT f.id, f.visit_date, f.people
FROM Filtered f
JOIN GroupCounts g ON f.grp = g.grp
WHERE g.cnt >= 3
ORDER BY f.visit_date;
```
**Explanation:** A classic gap-and-island problem. By taking the difference between the `id` and a `ROW_NUMBER()` applied *after* filtering for `people >= 100`, consecutive `id`s will fall into the same `grp`. We can then filter out groups containing fewer than 3 records.
</details>

---

## Challenge 7: Find the Quiet Students in All Exams
**Difficulty:** Hard
**Description:** A "quiet" student is one who took at least one exam and did not score the highest or lowest among all students in any of those exams. Write an SQL query to report the students who are quiet. 

**Schema Setup:**
```sql
CREATE TABLE Student (student_id INT, student_name VARCHAR(255));
CREATE TABLE Exam (exam_id INT, student_id INT, score INT);

INSERT INTO Student VALUES 
(1, 'Daniel'), (2, 'Jade'), (3, 'Stella'), 
(4, 'Jonathan'), (5, 'Will');
INSERT INTO Exam VALUES 
(10, 1, 70), (10, 2, 80), (10, 3, 90), 
(20, 1, 80), (30, 1, 70), (30, 3, 80), 
(30, 4, 90), (40, 1, 60), (40, 2, 70), (40, 4, 80);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedExams AS (
    SELECT exam_id, student_id, score,
           RANK() OVER (PARTITION BY exam_id ORDER BY score DESC) as rank_desc,
           RANK() OVER (PARTITION BY exam_id ORDER BY score ASC) as rank_asc
    FROM Exam
),
NoisyStudents AS (
    SELECT DISTINCT student_id
    FROM RankedExams
    WHERE rank_desc = 1 OR rank_asc = 1
)
SELECT DISTINCT s.student_id, s.student_name
FROM Student s
JOIN Exam e ON s.student_id = e.student_id
WHERE s.student_id NOT IN (SELECT student_id FROM NoisyStudents)
ORDER BY s.student_id;
```
**Explanation:** Using `RANK()` ascending and descending per exam identifies the highest and lowest scores (`rank = 1`). We identify "noisy" students who hit these edges. We exclude these students while ensuring the remaining students took at least one exam (via `JOIN Exam`).
</details>

---

## Challenge 8: Report Contiguous Dates
**Difficulty:** Hard
**Description:** A system tracks tasks. Every task is either "succeeded" or "failed". Write an SQL query to generate a report of periods of continuous states, finding the start and end dates of each period.

**Schema Setup:**
```sql
CREATE TABLE Tasks (date DATE, state ENUM('succeeded', 'failed'));
INSERT INTO Tasks VALUES 
('2019-01-01', 'succeeded'), ('2019-01-02', 'succeeded'), 
('2019-01-03', 'succeeded'), ('2019-01-04', 'failed'), 
('2019-01-05', 'failed'), ('2019-01-06', 'succeeded');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH GroupedTasks AS (
    SELECT state, date,
           DATE_SUB(date, INTERVAL ROW_NUMBER() OVER (PARTITION BY state ORDER BY date) DAY) as grp
    FROM Tasks
)
SELECT state AS period_state, 
       MIN(date) AS start_date, 
       MAX(date) AS end_date
FROM GroupedTasks
GROUP BY state, grp
ORDER BY start_date;
```
**Explanation:** Another gap-and-island application. By subtracting the partitioned `ROW_NUMBER()` from the `date`, dates that increment by exactly one day will map back to the same anchor date (`grp`). We then aggregate the minimum and maximum dates within each group.
</details>

---

## Challenge 9: Year-on-Year Growth Rate
**Difficulty:** Hard
**Description:** Write an SQL query to calculate the year-on-year (YoY) growth rate for total spend for each product. The rate should be rounded to 2 decimal places. 

**Schema Setup:**
```sql
CREATE TABLE User_Spend (transaction_id INT, product_id INT, spend_date DATETIME, spend_amount DECIMAL(10,2));
INSERT INTO User_Spend VALUES 
(1, 1, '2019-01-01 10:00:00', 100.50), 
(2, 1, '2020-01-01 10:00:00', 150.75), 
(3, 2, '2019-05-15 12:00:00', 200.00), 
(4, 2, '2020-05-15 12:00:00', 300.00), 
(5, 2, '2021-05-15 12:00:00', 250.00);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH YearlySpend AS (
    SELECT product_id, 
           YEAR(spend_date) as yr, 
           SUM(spend_amount) as total_spend
    FROM User_Spend
    GROUP BY product_id, YEAR(spend_date)
),
LaggedSpend AS (
    SELECT product_id, yr, 
           total_spend AS curr_year_spend,
           LAG(total_spend, 1) OVER (PARTITION BY product_id ORDER BY yr) AS prev_year_spend
    FROM YearlySpend
)
SELECT product_id, 
       yr AS spend_year, 
       curr_year_spend, 
       prev_year_spend,
       ROUND(IFNULL(curr_year_spend - prev_year_spend, 0) / prev_year_spend * 100, 2) AS yoy_rate
FROM LaggedSpend
ORDER BY product_id, yr;
```
**Explanation:** We first aggregate spend to a yearly level. We then use `LAG()` partitioned by `product_id` to grab the previous year's total spend alongside the current year's total. Finally, we calculate the percentage difference in the outer query.
</details>

---

## Challenge 10: Median Employee Salary
**Difficulty:** Hard
**Description:** Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL mathematical functions like median.

**Schema Setup:**
```sql
CREATE TABLE Employee (id INT, company VARCHAR(255), salary INT);
INSERT INTO Employee VALUES 
(1, 'A', 2341), (2, 'A', 341), (3, 'A', 15), 
(4, 'A', 15314), (5, 'A', 451), (6, 'A', 513), 
(7, 'B', 15), (8, 'B', 13), (9, 'B', 1154), 
(10, 'B', 1345), (11, 'B', 1221), (12, 'B', 234), 
(13, 'C', 2345), (14, 'C', 2645), (15, 'C', 2645), 
(16, 'C', 2652), (17, 'C', 65);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH RankedSalaries AS (
    SELECT id, company, salary,
           ROW_NUMBER() OVER (PARTITION BY company ORDER BY salary ASC, id ASC) AS rn,
           COUNT(*) OVER (PARTITION BY company) AS cnt
    FROM Employee
)
SELECT id, company, salary
FROM RankedSalaries
WHERE rn BETWEEN cnt / 2.0 AND cnt / 2.0 + 1;
```
**Explanation:** By generating a sequential row number sorted by salary, alongside the total count of rows within the same partition, the mathematical property of the median allows us to pinpoint the middle element(s). When total count is even, it returns 2 rows; when odd, it gracefully narrows down to a single center row due to `/ 2.0` floating arithmetic bounds.
</details>

---

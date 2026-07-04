# Complex Joins Interview Challenges

This document contains 10 advanced, LeetCode-style MySQL interview questions focused on complex joins (e.g., self joins, cross joins, and multiple table joins).

---

## Challenge 1: Rising Temperature
**Difficulty:** Medium
**Description:** Write an SQL query to find all dates' `id` with higher temperatures compared to its previous dates (yesterday).

**Schema Setup:**
```sql
CREATE TABLE Weather (
    id INT,
    recordDate DATE,
    temperature INT
);

INSERT INTO Weather (id, recordDate, temperature) VALUES
(1, '2015-01-01', 10),
(2, '2015-01-02', 25),
(3, '2015-01-03', 20),
(4, '2015-01-04', 30);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT w1.id
FROM Weather w1
JOIN Weather w2
  ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature;
```
**Explanation:** A self-join is used to pair each date record (`w1`) with the record from the previous day (`w2`). The `DATEDIFF` function guarantees the relationship is exactly one day apart, and the `WHERE` clause filters for rows where the current day's temperature is strictly greater than yesterday's.
</details>

---

## Challenge 2: Managers with at Least 5 Direct Reports
**Difficulty:** Medium
**Description:** Write an SQL query to report the names of managers who have at least five direct reports.

**Schema Setup:**
```sql
CREATE TABLE Employee (
    id INT,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

INSERT INTO Employee (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT e1.name
FROM Employee e1
JOIN Employee e2
  ON e1.id = e2.managerId
GROUP BY e1.id, e1.name
HAVING COUNT(e2.id) >= 5;
```
**Explanation:** We self-join the `Employee` table, connecting managers (`e1`) with their direct reports (`e2`). Grouping by the manager's ID and name allows us to count the number of reports using `HAVING COUNT >= 5`.
</details>

---

## Challenge 3: Students and Examinations
**Difficulty:** Medium
**Description:** Write an SQL query to find the number of times each student attended each exam. Return the result table ordered by `student_id` and `subject_name`. Note that if a student never took a particular exam, the count should be 0.

**Schema Setup:**
```sql
CREATE TABLE Students (student_id INT, student_name VARCHAR(20));
CREATE TABLE Subjects (subject_name VARCHAR(20));
CREATE TABLE Examinations (student_id INT, subject_name VARCHAR(20));

INSERT INTO Students VALUES (1, 'Alice'), (2, 'Bob'), (13, 'John'), (6, 'Alex');
INSERT INTO Subjects VALUES ('Math'), ('Physics'), ('Programming');
INSERT INTO Examinations VALUES 
(1, 'Math'), (1, 'Physics'), (1, 'Programming'), (2, 'Math'), 
(1, 'Physics'), (1, 'Math'), (13, 'Math'), (13, 'Programming'), 
(13, 'Physics'), (2, 'Math'), (1, 'Math');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    s.student_id, 
    s.student_name, 
    sub.subject_name, 
    COUNT(e.student_id) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
```
**Explanation:** The `CROSS JOIN` creates a Cartesian product of all students and all subjects, giving a base matrix of every possible exam a student could take. The `LEFT JOIN` brings in actual exam attendances. Using `COUNT(e.student_id)` correctly handles `NULL` values, leaving a count of 0 where no exams were attended.
</details>

---

## Challenge 4: Average Time of Process per Machine
**Difficulty:** Medium
**Description:** There is a factory website with several machines running roughly the same number of processes. Write an SQL query to find the average time each machine takes to complete a process (the 'end' timestamp minus the 'start' timestamp). The result should be rounded to 3 decimal places.

**Schema Setup:**
```sql
CREATE TABLE Activity (
    machine_id INT,
    process_id INT,
    activity_type ENUM('start', 'end'),
    timestamp FLOAT
);

INSERT INTO Activity VALUES
(0, 0, 'start', 0.712), (0, 0, 'end', 1.520),
(0, 1, 'start', 3.140), (0, 1, 'end', 4.120),
(1, 0, 'start', 0.550), (1, 0, 'end', 1.550),
(1, 1, 'start', 0.430), (1, 1, 'end', 1.420),
(2, 0, 'start', 4.100), (2, 0, 'end', 4.512),
(2, 1, 'start', 2.500), (2, 1, 'end', 5.000);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    a1.machine_id, 
    ROUND(AVG(a2.timestamp - a1.timestamp), 3) AS processing_time
FROM Activity a1
JOIN Activity a2
  ON a1.machine_id = a2.machine_id
  AND a1.process_id = a2.process_id
  AND a1.activity_type = 'start'
  AND a2.activity_type = 'end'
GROUP BY a1.machine_id;
```
**Explanation:** The table is joined against itself to bring the 'start' and 'end' activities of the same process ID and machine ID onto the same row. By subtracting the timestamps, we get the time for each process, which we then aggregate using `AVG()` per machine.
</details>

---

## Challenge 5: Confirmation Rate
**Difficulty:** Medium
**Description:** The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. For users who didn't request any messages, the rate is 0. Find the confirmation rate of each user, rounded to two decimal places.

**Schema Setup:**
```sql
CREATE TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (user_id INT, time_stamp DATETIME, action ENUM('confirmed', 'timeout'));

INSERT INTO Signups VALUES 
(3, '2020-03-21 10:16:13'), (7, '2020-01-04 13:57:59'), 
(2, '2020-07-29 23:09:44'), (6, '2020-12-09 10:39:37');
INSERT INTO Confirmations VALUES 
(3, '2021-01-06 03:30:46', 'timeout'), (3, '2021-07-14 14:00:00', 'timeout'), 
(7, '2021-06-12 11:57:29', 'confirmed'), (7, '2021-06-13 12:58:28', 'confirmed'), 
(7, '2021-06-14 13:59:27', 'confirmed'), (2, '2021-01-22 00:00:00', 'confirmed'), 
(2, '2021-02-28 23:59:59', 'timeout');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT 
    s.user_id, 
    ROUND(AVG(IF(c.action = 'confirmed', 1, 0)), 2) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
  ON s.user_id = c.user_id
GROUP BY s.user_id;
```
**Explanation:** Using a `LEFT JOIN` ensures users with no confirmation attempts are kept in the results (with `NULL` values for `action`). The `AVG` function natively handles the total count of rows per user, while `IF(action = 'confirmed', 1, 0)` generates a 1 for successes and 0 for timeouts/nulls, accurately yielding the proportion.
</details>

---

## Challenge 6: Trips and Users
**Difficulty:** Hard
**Description:** The cancellation rate is computed by dividing the number of canceled requests (by client or driver) with unbanned users by the total number of requests with unbanned users on that day. Find the cancellation rate each day between '2013-10-01' and '2013-10-03', rounded to two decimal points. Both the client and the driver must be unbanned.

**Schema Setup:**
```sql
CREATE TABLE Trips (
    id INT, client_id INT, driver_id INT, city_id INT,
    status ENUM('completed', 'cancelled_by_driver', 'cancelled_by_client'), 
    request_at DATE
);
CREATE TABLE Users (
    users_id INT, banned VARCHAR(50), role ENUM('client', 'driver', 'partner')
);

INSERT INTO Users VALUES 
(1, 'No', 'client'), (2, 'Yes', 'client'), (3, 'No', 'client'), (4, 'No', 'client'), 
(10, 'No', 'driver'), (11, 'No', 'driver'), (12, 'No', 'driver'), (13, 'No', 'driver');
INSERT INTO Trips VALUES 
(1, 1, 10, 1, 'completed', '2013-10-01'), (2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'), 
(3, 3, 12, 6, 'completed', '2013-10-01'), (4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'), 
(5, 1, 10, 1, 'completed', '2013-10-02'), (6, 2, 11, 6, 'completed', '2013-10-02'), 
(7, 3, 12, 6, 'completed', '2013-10-02'), (8, 2, 12, 12, 'completed', '2013-10-03'), 
(9, 3, 10, 12, 'completed', '2013-10-03'), (10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT
    t.request_at AS Day,
    ROUND(SUM(IF(t.status != 'completed', 1, 0)) / COUNT(*), 2) AS 'Cancellation Rate'
FROM Trips t
JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No'
JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at;
```
**Explanation:** We enforce the "unbanned" constraint directly through two `INNER JOIN` clauses—one for the client and one for the driver. This safely drops trips where either party is banned. We then aggregate conditionally using `SUM(IF(...)) / COUNT(*)` to find the cancellation percentage.
</details>

---

## Challenge 7: Sales Person
**Difficulty:** Medium
**Description:** Write an SQL query to report the names of all the salespersons who did not have any orders related to the company with the name "RED".

**Schema Setup:**
```sql
CREATE TABLE SalesPerson (sales_id INT, name VARCHAR(255), salary INT, commission_rate INT, hire_date DATE);
CREATE TABLE Company (com_id INT, name VARCHAR(255), city VARCHAR(255));
CREATE TABLE Orders (order_id INT, order_date DATE, com_id INT, sales_id INT, amount INT);

INSERT INTO SalesPerson VALUES 
(1, 'John', 100000, 6, '2006-04-01'), (2, 'Amy', 12000, 5, '2010-05-01'), 
(3, 'Mark', 65000, 12, '2008-12-25'), (4, 'Pam', 25000, 25, '2005-01-01'), 
(5, 'Alex', 50000, 10, '2007-02-03');
INSERT INTO Company VALUES 
(1, 'RED', 'Boston'), (2, 'ORANGE', 'New York'), 
(3, 'YELLOW', 'Boston'), (4, 'GREEN', 'Austin');
INSERT INTO Orders VALUES 
(1, '2014-01-01', 3, 4, 10000), (2, '2014-02-01', 4, 5, 5000), 
(3, '2014-03-01', 1, 1, 50000), (4, '2014-04-01', 1, 4, 25000);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT name
FROM SalesPerson
WHERE sales_id NOT IN (
    SELECT o.sales_id
    FROM Orders o
    JOIN Company c ON o.com_id = c.com_id
    WHERE c.name = 'RED'
);
```
**Explanation:** Instead of relying entirely on a complex `LEFT JOIN` chain that might bloat, a highly effective technique is combining a subquery `JOIN` with a `NOT IN` exclusion. The subquery quickly gathers all `sales_id`s tied to a "RED" order, and the main query isolates whoever is left.
</details>

---

## Challenge 8: Tree Node
**Difficulty:** Medium
**Description:** Each row of a table contains information about the id of a node and the id of its parent node in a tree. Write an SQL query to report the type of each node in the tree. Types are 'Root', 'Leaf', or 'Inner'.

**Schema Setup:**
```sql
CREATE TABLE Tree (id INT, p_id INT);
INSERT INTO Tree VALUES (1, NULL), (2, 1), (3, 1), (4, 2), (5, 2);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT DISTINCT t1.id,
       CASE
           WHEN t1.p_id IS NULL THEN 'Root'
           WHEN t2.id IS NOT NULL THEN 'Inner'
           ELSE 'Leaf'
       END AS type
FROM Tree t1
LEFT JOIN Tree t2
  ON t1.id = t2.p_id;
```
**Explanation:** While a nested subquery approach is possible, doing a self `LEFT JOIN` represents relationships visually in standard SQL. `t1` represents the node in question, and `t2` represents potential children. If `t1.p_id` is null, it's a Root. If `t2.id` matches, the node acts as a parent (so it's Inner). If neither matches, it has no children, making it a Leaf.
</details>

---

## Challenge 9: Consecutive Available Seats
**Difficulty:** Medium
**Description:** Find all consecutive available seats in the cinema. Return the `seat_id` in ascending order. Note that the `seat_id` is an auto-increment integer, and `free` is a boolean indicating if a seat is available.

**Schema Setup:**
```sql
CREATE TABLE Cinema (seat_id INT, free BOOL);
INSERT INTO Cinema VALUES (1, 1), (2, 0), (3, 1), (4, 1), (5, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT DISTINCT c1.seat_id
FROM Cinema c1
JOIN Cinema c2
  ON ABS(c1.seat_id - c2.seat_id) = 1
WHERE c1.free = 1 AND c2.free = 1
ORDER BY c1.seat_id;
```
**Explanation:** A self-join maps `c1` with `c2` on the condition that their seat IDs are exactly 1 apart (`ABS = 1`). By asserting both `c1.free` and `c2.free` equal 1, we isolate contiguous free seats. `DISTINCT` eliminates duplicates when a seat is surrounded by free seats on both sides.
</details>

---

## Challenge 10: Investments in 2016
**Difficulty:** Medium
**Description:** Write a query to print the sum of all total investment values in 2016 (`tiv_2016`), rounded to a scale of 2 decimal places, for all policyholders who:
1. Have the same `tiv_2015` value as one or more other policyholders.
2. Are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).

**Schema Setup:**
```sql
CREATE TABLE Insurance (pid INT, tiv_2015 FLOAT, tiv_2016 FLOAT, lat FLOAT, lon FLOAT);
INSERT INTO Insurance VALUES 
(1, 10, 5, 10, 10), (2, 20, 20, 20, 20), 
(3, 10, 30, 20, 20), (4, 10, 40, 40, 40);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
SELECT ROUND(SUM(i1.tiv_2016), 2) AS tiv_2016
FROM Insurance i1
JOIN (
    SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(*) > 1
) t2 ON i1.tiv_2015 = t2.tiv_2015
JOIN (
    SELECT lat, lon FROM Insurance GROUP BY lat, lon HAVING COUNT(*) = 1
) t3 ON i1.lat = t3.lat AND i1.lon = t3.lon;
```
**Explanation:** We use derived tables (`JOIN` via inline subqueries) to create isolated lists of matching criteria. `t2` gathers all `tiv_2015` values that appear multiple times. `t3` gathers all unique `lat, lon` combinations. An `INNER JOIN` forces the principal rows in `i1` to strictly meet both complex conditions before finally summing up `tiv_2016`.
</details>

---

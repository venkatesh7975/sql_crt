# Gaps and Islands

## Challenge 1: Human Traffic of Stadium
**Difficulty:** Hard
**Description:** Write a query to display the records with three or more rows with consecutive `id`s, where the number of people is greater than or equal to 100 for each. Return the result table ordered by `visit_date` in ascending order.

**Schema Setup:**
```sql
CREATE TABLE Stadium (
    id INT,
    visit_date DATE,
    people INT
);
INSERT INTO Stadium (id, visit_date, people) VALUES
(1, '2023-01-01', 10),
(2, '2023-01-02', 109),
(3, '2023-01-03', 150),
(4, '2023-01-04', 99),
(5, '2023-01-05', 145),
(6, '2023-01-06', 1455),
(7, '2023-01-07', 199),
(8, '2023-01-08', 188);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Grouped AS (
    SELECT id, visit_date, people,
           id - ROW_NUMBER() OVER(ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
),
Counted AS (
    SELECT id, visit_date, people,
           COUNT(*) OVER(PARTITION BY grp) AS cnt
    FROM Grouped
)
SELECT id, visit_date, people
FROM Counted
WHERE cnt >= 3
ORDER BY visit_date;
```
**Explanation:** This is a classic "Islands" problem. We first filter out days with fewer than 100 people. Then, we subtract a sequential row number from the `id`. Since both `id` and the row number increment by 1 for consecutive records, their difference remains constant, identifying our "islands" of consecutive days. Finally, we count the size of each island and keep those with 3 or more.
</details>

---

## Challenge 2: Longest Winning Streak
**Difficulty:** Medium
**Description:** For each player, find their longest consecutive winning streak. If a player has never won, their streak is 0.

**Schema Setup:**
```sql
CREATE TABLE Matches (
    player_id INT,
    match_date DATE,
    result ENUM('Win', 'Draw', 'Loss')
);
INSERT INTO Matches (player_id, match_date, result) VALUES
(1, '2023-08-01', 'Win'),
(1, '2023-08-02', 'Win'),
(1, '2023-08-03', 'Loss'),
(1, '2023-08-04', 'Win'),
(2, '2023-08-01', 'Loss'),
(2, '2023-08-02', 'Loss'),
(3, '2023-08-01', 'Win'),
(3, '2023-08-02', 'Win'),
(3, '2023-08-03', 'Win');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Numbered AS (
    SELECT player_id, result,
           ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY match_date) AS rn_all,
           ROW_NUMBER() OVER(PARTITION BY player_id, result ORDER BY match_date) AS rn_result
    FROM Matches
),
StreakLengths AS (
    SELECT player_id, COUNT(*) AS streak_len
    FROM Numbered
    WHERE result = 'Win'
    GROUP BY player_id, (rn_all - rn_result)
)
SELECT m.player_id, COALESCE(MAX(s.streak_len), 0) AS max_winning_streak
FROM (SELECT DISTINCT player_id FROM Matches) m
LEFT JOIN StreakLengths s ON m.player_id = s.player_id
GROUP BY m.player_id;
```
**Explanation:** By calculating a row number partitioned by `player_id` for all matches, and another partitioned by `player_id` and `result`, the difference between these two row numbers will remain constant for consecutive matches with the same result. We then filter for 'Win' to isolate winning streaks and find the maximum length per player.
</details>

---

## Challenge 3: Consecutive Available Seats
**Difficulty:** Medium
**Description:** Find all seat IDs that are part of a sequence of 3 or more consecutive empty seats in a cinema.

**Schema Setup:**
```sql
CREATE TABLE Cinema (
    seat_id INT,
    free BOOLEAN
);
INSERT INTO Cinema (seat_id, free) VALUES
(1, 1), (2, 0), (3, 1), (4, 1), (5, 1), (6, 0), (7, 1), (8, 1), (9, 1), (10, 1);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH FreeSeats AS (
    SELECT seat_id,
           seat_id - ROW_NUMBER() OVER(ORDER BY seat_id) AS grp
    FROM Cinema
    WHERE free = 1
),
GroupCnt AS (
    SELECT seat_id, COUNT(*) OVER(PARTITION BY grp) as cnt
    FROM FreeSeats
)
SELECT seat_id
FROM GroupCnt
WHERE cnt >= 3
ORDER BY seat_id;
```
**Explanation:** We filter for available seats (`free = 1`) and use the difference between the actual `seat_id` and a generated `ROW_NUMBER()`. This difference groups adjacent available seats together. We then calculate the count of seats per group using a window function and filter for groups with a size of 3 or more.
</details>

---

## Challenge 4: Find Missing Sequence Ranges
**Difficulty:** Medium
**Description:** Given a table of log IDs, identify the gaps in the sequence. Return the start and end of each missing range.

**Schema Setup:**
```sql
CREATE TABLE Logs (
    log_id INT
);
INSERT INTO Logs (log_id) VALUES
(1), (2), (3), (7), (8), (10), (14);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Seq AS (
    SELECT log_id,
           LEAD(log_id) OVER(ORDER BY log_id) AS next_id
    FROM Logs
)
SELECT log_id + 1 AS start_id, next_id - 1 AS end_id
FROM Seq
WHERE next_id - log_id > 1;
```
**Explanation:** This solves the "Gaps" portion of Gaps and Islands. We use `LEAD()` to look at the next sequential `log_id`. If the difference between the next ID and the current ID is greater than 1, a gap exists. The missing sequence naturally spans from `current_id + 1` to `next_id - 1`.
</details>

---

## Challenge 5: Grouping Consecutive Statuses
**Difficulty:** Medium
**Description:** Track user subscriptions over time. Find the `start_date` and `end_date` for each continuous period a user stayed on the same subscription plan.

**Schema Setup:**
```sql
CREATE TABLE UserStatus (
    user_id INT,
    status_date DATE,
    status VARCHAR(50)
);
INSERT INTO UserStatus (user_id, status_date, status) VALUES
(1, '2023-01-01', 'Free'),
(1, '2023-01-02', 'Free'),
(1, '2023-01-03', 'Premium'),
(1, '2023-01-04', 'Premium'),
(1, '2023-01-05', 'Free'),
(2, '2023-01-01', 'Premium'),
(2, '2023-01-02', 'Premium');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH Groups AS (
    SELECT user_id, status_date, status,
           ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY status_date) -
           ROW_NUMBER() OVER(PARTITION BY user_id, status ORDER BY status_date) AS grp
    FROM UserStatus
)
SELECT user_id, status, MIN(status_date) AS start_date, MAX(status_date) AS end_date
FROM Groups
GROUP BY user_id, status, grp
ORDER BY user_id, start_date;
```
**Explanation:** Similar to finding winning streaks, we compute the difference between an overall sequential row number for the user and a status-specific row number. This groups consecutive instances of the same status. A simple `GROUP BY` gets us the start and end dates of each period.
</details>

---

## Challenge 6: Longest Login Streak
**Difficulty:** Hard
**Description:** Find the top 3 users with the longest consecutive days of logins. A user may log in multiple times a day, which still counts as a single day towards the streak.

**Schema Setup:**
```sql
CREATE TABLE Logins (
    user_id INT,
    login_date DATETIME
);
INSERT INTO Logins (user_id, login_date) VALUES
(1, '2023-10-01 08:00:00'),
(1, '2023-10-01 12:00:00'),
(1, '2023-10-02 09:00:00'),
(1, '2023-10-03 10:00:00'),
(2, '2023-10-01 18:00:00'),
(2, '2023-10-03 19:00:00'),
(3, '2023-10-01 10:00:00'),
(3, '2023-10-02 10:00:00');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH DistinctDates AS (
    SELECT DISTINCT user_id, DATE(login_date) AS login_date
    FROM Logins
),
Groups AS (
    SELECT user_id, login_date,
           DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM DistinctDates
),
Streaks AS (
    SELECT user_id, COUNT(*) AS streak_len
    FROM Groups
    GROUP BY user_id, grp
)
SELECT user_id, MAX(streak_len) AS max_streak
FROM Streaks
GROUP BY user_id
ORDER BY max_streak DESC, user_id ASC
LIMIT 3;
```
**Explanation:** We first reduce timestamps to distinct dates using `DATE()` and `DISTINCT`. We then use the date-based grouping trick: subtracting a `ROW_NUMBER()` representing days from the actual `login_date`. Consecutive dates will map to the same base anchor date (`grp`).
</details>

---

## Challenge 7: Active Users for N Consecutive Days
**Difficulty:** Medium
**Description:** Identify all users who logged in for at least 3 consecutive days.

**Schema Setup:**
```sql
CREATE TABLE UserLogins (
    user_id INT,
    login_date DATE
);
INSERT INTO UserLogins (user_id, login_date) VALUES
(1, '2023-11-01'), (1, '2023-11-02'), (1, '2023-11-03'), (1, '2023-11-05'),
(2, '2023-11-01'), (2, '2023-11-03'), (2, '2023-11-04'),
(3, '2023-11-01'), (3, '2023-11-02'), (3, '2023-11-03'), (3, '2023-11-04');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH DistinctLogins AS (
    SELECT DISTINCT user_id, login_date
    FROM UserLogins
),
Grouped AS (
    SELECT user_id,
           DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM DistinctLogins
)
SELECT DISTINCT user_id
FROM Grouped
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;
```
**Explanation:** This relies on the same date arithmetic anchor technique as Challenge 6 (`DATE_SUB` with `ROW_NUMBER()`). If the count of rows matching the same anchor date group for a given user is at least 3, they hit the streak criteria.
</details>

---

## Challenge 8: Inventory Out-of-Stock Islands
**Difficulty:** Hard
**Description:** Identify the `start_date` and `end_date` for periods where a product was out of stock (quantity = 0) for 3 or more consecutive days.

**Schema Setup:**
```sql
CREATE TABLE Inventory (
    product_id INT,
    record_date DATE,
    quantity INT
);
INSERT INTO Inventory (product_id, record_date, quantity) VALUES
(1, '2023-12-01', 50),
(1, '2023-12-02', 0),
(1, '2023-12-03', 0),
(1, '2023-12-04', 0),
(1, '2023-12-05', 10),
(2, '2023-12-01', 0),
(2, '2023-12-02', 0),
(2, '2023-12-03', 5);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH ZeroStock AS (
    SELECT product_id, record_date,
           DATE_SUB(record_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY record_date) DAY) AS grp
    FROM Inventory
    WHERE quantity = 0
),
StockPeriods AS (
    SELECT product_id, MIN(record_date) AS start_date, MAX(record_date) AS end_date, COUNT(*) AS days_out_of_stock
    FROM ZeroStock
    GROUP BY product_id, grp
)
SELECT product_id, start_date, end_date
FROM StockPeriods
WHERE days_out_of_stock >= 3
ORDER BY product_id, start_date;
```
**Explanation:** By pre-filtering for `quantity = 0`, we only evaluate out-of-stock records. Subtracting the row number from `record_date` successfully groups contiguous out-of-stock periods, allowing us to find periods lasting $\geq 3$ days.
</details>

---

## Challenge 9: Longest Continuous Work Period
**Difficulty:** Medium
**Description:** Calculate the maximum number of consecutive days each project was worked on.

**Schema Setup:**
```sql
CREATE TABLE ProjectWork (
    project_id INT,
    work_date DATE
);
INSERT INTO ProjectWork (project_id, work_date) VALUES
(101, '2024-01-01'), (101, '2024-01-02'), (101, '2024-01-04'),
(102, '2024-01-01'), (102, '2024-01-02'), (102, '2024-01-03'), (102, '2024-01-04'),
(103, '2024-01-05');
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH DistinctDates AS (
    SELECT DISTINCT project_id, work_date
    FROM ProjectWork
),
Groups AS (
    SELECT project_id, work_date,
           DATE_SUB(work_date, INTERVAL ROW_NUMBER() OVER(PARTITION BY project_id ORDER BY work_date) DAY) AS grp
    FROM DistinctDates
),
Durations AS (
    SELECT project_id, COUNT(*) AS continuous_days
    FROM Groups
    GROUP BY project_id, grp
)
SELECT project_id, MAX(continuous_days) AS longest_continuous_days
FROM Durations
GROUP BY project_id;
```
**Explanation:** We ensure dates are distinct per project first. Grouping by the difference of `work_date` and the sequence number provides continuous work blocks. The maximum count across blocks gives the longest duration per project.
</details>

---

## Challenge 10: Consecutive Declining Stock Prices
**Difficulty:** Hard
**Description:** A stock is in a "decline streak" if its price is strictly lower than the previous trading day's price. Find periods where a stock experienced a decline streak for 3 or more consecutive trading days. Return the stock ID, the start date of the streak (the first day the price dropped), the end date, and the length of the streak. Keep in mind that trading days may not be continuous calendar days (e.g., weekends).

**Schema Setup:**
```sql
CREATE TABLE StockPrices (
    stock_id INT,
    trade_date DATE,
    price DECIMAL(10,2)
);
INSERT INTO StockPrices (stock_id, trade_date, price) VALUES
(1, '2024-02-01', 100.00),
(1, '2024-02-02', 98.00), 
(1, '2024-02-05', 97.00), 
(1, '2024-02-06', 95.00), 
(1, '2024-02-07', 99.00),
(2, '2024-02-01', 50.00),
(2, '2024-02-02', 48.00),
(2, '2024-02-05', 49.00);
```

<details>
<summary>View Solution</summary>

**Optimal Solution:**
```sql
WITH TradeIndexes AS (
    SELECT stock_id, trade_date, price,
           LAG(price) OVER(PARTITION BY stock_id ORDER BY trade_date) AS prev_price,
           ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY trade_date) AS rn
    FROM StockPrices
),
Decreases AS (
    SELECT stock_id, trade_date, rn,
           rn - ROW_NUMBER() OVER(PARTITION BY stock_id ORDER BY trade_date) AS grp
    FROM TradeIndexes
    WHERE prev_price IS NOT NULL AND price < prev_price
),
StreakCounts AS (
    SELECT stock_id, MIN(trade_date) AS start_decrease_date, MAX(trade_date) AS end_decrease_date, COUNT(*) AS decrease_streak
    FROM Decreases
    GROUP BY stock_id, grp
)
SELECT stock_id, start_decrease_date, end_decrease_date, decrease_streak
FROM StreakCounts
WHERE decrease_streak >= 3
ORDER BY stock_id, start_decrease_date;
```
**Explanation:** Because trading days have gaps (like weekends), subtracting days from a date won't work perfectly here. Instead, we assign a sequential integer `rn` to all valid trading days. We then filter out records where the price didn't decrease. A secondary `ROW_NUMBER()` applied only to the decreases, subtracted from the baseline `rn`, neatly groups consecutive declines regardless of real-world calendar gaps.
</details>

---

# Problem 10 – Average Time of Process per Machine

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* SELF JOIN
* GROUP BY
* ROUND()
* Aggregate Functions (AVG)

---

## 3. Pattern
Self Join / Conditional Aggregation

---

## 4. Problem Statement
We need to calculate the average time it takes for each machine to complete a process. 
A process consists of a "start" timestamp and an "end" timestamp. The time taken is `end - start`. 
Output the `machine_id` and the average time rounded to 3 decimal places.

---

## 5. Tables

Table: Activity

| Column        | Type  |
| ------------- | ----- |
| machine_id    | INT   |
| process_id    | INT   |
| activity_type | ENUM  |
| timestamp     | FLOAT |

* `(machine_id, process_id, activity_type)` is the primary key.
* `activity_type` is an ENUM ('start', 'end').
* `timestamp` represents the current time in seconds.

---

## 6. Sample Input

Activity table:

| machine_id | process_id | activity_type | timestamp |
| ---------- | ---------- | ------------- | --------- |
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |

---

## 7. Expected Output

| machine_id | processing_time |
| ---------- | --------------- |
| 0          | 0.894           |
| 1          | 1.000           |

*(Machine 0: Process 0 took 1.520-0.712=0.808. Process 1 took 4.120-3.140=0.980. Avg: (0.808+0.980)/2 = 0.894.)*

---

## 8. Understanding the Question
What information is being asked? The average processing time per machine.
What columns are important? `machine_id`, `process_id`, `activity_type`, `timestamp`.
What conditions matter? The process time is `timestamp (end) - timestamp (start)` for the *same* machine and the *same* process.
What should be returned? `machine_id`, and `processing_time` (rounded to 3 decimals).

---

## 9. Thinking Process
1. I have "start" times and "end" times as separate rows in the same table. To do math on them (end - start), I need them on the *same* row.
2. This requires a **Self Join**. I will join the `Activity` table to itself.
3. Let `a1` be the "start" row and `a2` be the "end" row.
4. How do they link? They must have the same `machine_id` AND the same `process_id`.
5. I also need to strictly specify that `a1` is the start and `a2` is the end: `a1.activity_type = 'start' AND a2.activity_type = 'end'`.
6. Now that they are joined, the duration of one process is `a2.timestamp - a1.timestamp`.
7. The prompt asks for the *average* per machine. This means I must `GROUP BY machine_id` and apply the `AVG()` function to my duration calculation.
8. Finally, I need to wrap that average in `ROUND(..., 3)`.

---

## 10. Approach 1 (Optimal)
Self Join + Group By

Align the start and end records next to each other using a self join, calculate the difference, group by the machine, and average the results.

---

## 11. SQL Solution

```sql
-- Calculate average processing time per machine, rounded to 3 decimals
SELECT 
    a1.machine_id, 
    ROUND(AVG(a2.timestamp - a1.timestamp), 3) AS processing_time
FROM 
    Activity a1
JOIN 
    Activity a2 
    ON a1.machine_id = a2.machine_id 
    AND a1.process_id = a2.process_id
    AND a1.activity_type = 'start' 
    AND a2.activity_type = 'end'
GROUP BY 
    a1.machine_id;
```

---

## 12. Step-by-Step Dry Run
1. **Self Join Setup:**
   * Row: (Machine 0, Process 0, Start, 0.712) matched with (Machine 0, Process 0, End, 1.520). Difference: 0.808.
   * Row: (Machine 0, Process 1, Start, 3.140) matched with (Machine 0, Process 1, End, 4.120). Difference: 0.980.
   * Row: (Machine 1, Process 0, Start, 0.550) matched with (Machine 1, Process 0, End, 1.550). Difference: 1.000.
2. **GROUP BY machine_id:**
   * Group 0 contains diffs: [0.808, 0.980]
   * Group 1 contains diffs: [1.000]
3. **AVG() & ROUND():**
   * Group 0: `AVG` is 0.894. `ROUND(0.894, 3)` -> 0.894.
   * Group 1: `AVG` is 1.000. `ROUND(1.0, 3)` -> 1.000.

---

## 13. SQL Execution Order
1. **FROM and JOIN:** Creates mega-rows containing both the start and end data.
2. **GROUP BY:** Collects all mega-rows belonging to the same machine.
3. **SELECT:** Computes the math (`a2.timestamp - a1.timestamp`), averages it across the bucket (`AVG`), rounds it, and outputs.

---

## 14. Query Breakdown
* **Self Join (`a1`, `a2`):** Brings multi-row relational data onto a single row for easy arithmetic.
* **ON ... AND ... AND ...:** It's completely valid to have multiple conditions in an `ON` clause. This ensures we only pair exact matching processes.
* **AVG(...):** Calculates the mean of the mathematical expression inside it for the grouped set.
* **ROUND(value, 3):** Standard function to format floats to 3 decimal places.

---

## 15. Why This Solution Works
By using the join to flatten the timeline, we turn a tricky multi-row logic puzzle into simple row-level arithmetic, which aggregate functions like `AVG()` can handle natively.

---

## 16. Alternative Solution
Conditional Aggregation (Using CASE WHEN)

```sql
SELECT 
    machine_id,
    ROUND(
        SUM(CASE WHEN activity_type = 'end' THEN timestamp ELSE -timestamp END) 
        / (COUNT(DISTINCT process_id)), 
    3) AS processing_time
FROM 
    Activity
GROUP BY 
    machine_id;
```
* **Advantages:** It only scans the table once (no JOIN required), making it theoretically faster on massive datasets. It basically adds the end times and subtracts the start times.
* **Disadvantages:** The math logic `(Sum of Ends - Sum of Starts) / Count of processes` is much harder for a beginner to conceptualize and read than a simple Join. 

---

## 17. Time Complexity
**O(N^2)** worst case for the Join, but **O(N)** in practice because the primary key is `(machine_id, process_id, activity_type)`. The database does extremely fast primary key lookups to find the matching 'end' row for every 'start' row.

---

## 18. Common Mistakes
* **Forgetting to group:** If you use `AVG()` without `GROUP BY`, you will get a single row calculating the average of the entire factory, rather than per machine.
* **Joining incorrectly:** Forgetting to match on `process_id`. This would link Machine 0's Process 0 Start with Machine 0's Process 1 End! Always match all identifying keys.
* **Not rounding:** LeetCode expects exactly 3 decimal places. 

---

## 19. Edge Cases
* **Missing 'end' data:** If a process started but never ended, the `INNER JOIN` safely drops it, so it doesn't skew the average with a NULL or zero value.
* **Zero time taken:** If start and end timestamps are identical, difference is 0. Handled correctly.

---

## 20. Interview Tips
* Self Joins are the standard "clean code" answer.
* Conditional Aggregation (Alternative Solution) is the "senior performance" answer. If you can write the Self Join and verbally explain how the math in the Alternative Solution works, you will ace the interview.

---

## 21. Similar LeetCode Problems
* 1173. Immediate Food Delivery I (Similar conditional logic)
* 626. Exchange Seats

---

## 22. Key Takeaways
* When start/stop events are in different rows, a **Self Join** is the easiest way to get them onto the same row for calculation.
* `AVG()` evaluates an expression for every row in a group, sums the results, and divides by the group count.

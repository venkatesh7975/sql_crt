# Problem 35 – Last Person to Fit in the Bus

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Window Functions (`SUM() OVER()`)
* ORDER BY
* LIMIT

---

## 3. Pattern
Running Total / Cumulative Sum

---

## 4. Problem Statement
There is a queue of people waiting to board a bus. However, the bus has a weight limit of **1000 kilograms**. We must process the people in the order defined by their `turn`.
Find the `person_name` of the **last person** that can fit on the bus without exceeding the weight limit.

---

## 5. Tables

Table: Queue

| Column      | Type    |
| ----------- | ------- |
| person_id   | INT     |
| person_name | VARCHAR |
| weight      | INT     |
| turn        | INT     |

* `person_id` is the primary key.
* `turn` determines the order of boarding (1 is first, 2 is second, etc.).
* The table contains information about the people waiting.

---

## 6. Sample Input

Queue table:

| person_id | person_name | weight | turn |
| --------- | ----------- | ------ | ---- |
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |

---

## 7. Expected Output

| person_name |
| ----------- |
| John Cena   |

*(Turn 1: Alice (250). Total = 250.*
*Turn 2: Alex (350). Total = 600.*
*Turn 3: John Cena (400). Total = 1000.*
*Turn 4: Marie (200). Total = 1200 (Too heavy).*
*John Cena is the last person to fit).*

---

## 8. Understanding the Question
What information is being asked? The name of a single person.
What columns are important? `person_name`, `weight`, `turn`.
What conditions matter? We must calculate a running total of the weight based on the `turn`. We must stop when this running total exceeds 1000. We return the last name that successfully entered.
What should be returned? `person_name`.

---

## 9. Thinking Process
1. I need a "Running Total" (Cumulative Sum) of the weight, ordered by `turn`. 
2. In modern SQL, a Running Total is trivial using Window Functions: `SUM(weight) OVER(ORDER BY turn ASC) AS running_weight`.
3. If I apply this to a subquery, I will get a table that looks exactly like the manual math I did in the Sample Input breakdown.
4. Once I have that table, I need to filter out anyone who pushed the weight over 1000. So, `WHERE running_weight <= 1000`.
5. Now I have a table of all the people who fit on the bus. I only want the *last* one.
6. To get the last one, I sort the surviving people in reverse order: `ORDER BY turn DESC`.
7. Finally, I pick the top row using `LIMIT 1`.

---

## 10. Approach 1 (Optimal)
Window Function with Cumulative Sum

Create a derived table that calculates the running sum using `OVER(ORDER BY)`, filter it for the weight limit, and take the heaviest valid row.

---

## 11. SQL Solution

```sql
-- Calculate running weight, filter for capacity, and select the final person
SELECT 
    person_name
FROM (
    SELECT 
        person_name, 
        turn, 
        SUM(weight) OVER (ORDER BY turn) AS running_weight
    FROM 
        Queue
) AS cumulative_queue
WHERE 
    running_weight <= 1000
ORDER BY 
    turn DESC
LIMIT 1;
```

---

## 12. Step-by-Step Dry Run
1. **Subquery `SUM() OVER(ORDER BY turn)`:**
   * Sorts the table by `turn`.
   * T1 Alice: 250
   * T2 Alex: 250 + 350 = 600
   * T3 John: 600 + 400 = 1000
   * T4 Marie: 1000 + 200 = 1200
   * T5 Bob: 1200 + 175 = 1375
   * T6 Winston: 1375 + 500 = 1875
2. **Outer Query `WHERE running_weight <= 1000`:**
   * Keeps Alice, Alex, and John. Drops Marie, Bob, and Winston.
3. **Outer Query `ORDER BY turn DESC`:**
   * Sorts the survivors: John (3), Alex (2), Alice (1).
4. **Outer Query `LIMIT 1`:**
   * Takes the first row of the sorted list -> `John Cena`.

---

## 13. SQL Execution Order
1. **Subquery (FROM, SELECT Window):** Sorts the data and calculates the running total step-by-step.
2. **Main FROM:** Loads the virtual table with the running totals.
3. **Main WHERE:** Discards rows over 1000.
4. **Main ORDER BY:** Sorts the remainder descending.
5. **Main LIMIT:** Extracts the single required row.
6. **Main SELECT:** Returns the person's name.

---

## 14. Query Breakdown
* **SUM(weight) OVER (ORDER BY turn):** This is the magic of Window Functions. Because there is an `ORDER BY` inside the `OVER` clause, SQL automatically evaluates the `SUM()` as a *cumulative* sum up to the current row, rather than a global sum.
* **ORDER BY turn DESC LIMIT 1:** The standard way to grab the "max" or "last" element of a dataset.

---

## 15. Why This Solution Works
Window functions are specifically engineered for running totals. Attempting to do this without them requires an N^2 Self-Join, which is mathematically abusive to the database.

---

## 16. Alternative Solution
Using a Correlated Subquery (Slower, Pre-Window Function Era)

```sql
SELECT 
    q1.person_name
FROM 
    Queue q1
WHERE 
    1000 >= (
        SELECT SUM(weight) 
        FROM Queue q2 
        WHERE q2.turn <= q1.turn
    )
ORDER BY 
    q1.turn DESC
LIMIT 1;
```
* **Advantages:** Works on ancient SQL servers (e.g., MySQL 5.7 or older) that do not support Window Functions.
* **Disadvantages:** **O(N^2)** performance. For every single person in the line, it reruns a brand new `SELECT SUM` query counting everyone before them. If 10,000 people are in line, it executes 10,000 summing subqueries!

---

## 17. Time Complexity
**O(N log N)**. Sorting the window for `turn` takes O(N log N). The cumulative sum pass is O(N). Extremely fast.

---

## 18. Common Mistakes
* **Using `MAX()` on the window function:** You cannot write `WHERE MAX(running_weight) <= 1000`. Aggregate functions cannot operate directly on the output of Window functions in the same pass. The `ORDER BY DESC LIMIT 1` pattern perfectly bypasses this issue.
* **Forgetting `ORDER BY` inside the `OVER()` clause:** If you write `SUM(weight) OVER()`, it will calculate the total weight of the entire bus queue for *every row* (1875). The `ORDER BY` is what triggers the running cumulative behavior.

---

## 19. Edge Cases
* **First person exceeds 1000kg:** The problem statement implies the test cases guarantee at least one person fits, but if the first person was 1500kg, the output would gracefully return an empty set.
* **Exactly 1000kg:** Handled perfectly by `<=`.

---

## 20. Interview Tips
* If an interviewer asks you to calculate a "Running Total", "Cumulative Sum", or "Year-To-Date (YTD) Sum", **immediately** reach for `SUM(...) OVER(ORDER BY ...)`! 

---

## 21. Similar LeetCode Problems
* 1321. Restaurant Growth (7-day moving average/sum)
* 578. Get Highest Answer Rate Question

---

## 22. Key Takeaways
* **Running Totals:** `SUM(column) OVER(ORDER BY sort_column)`.
* To find the "highest" row that satisfies a condition, filter the table, sort descending, and `LIMIT 1`.

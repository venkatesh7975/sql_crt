# Problem 38 – Exchange Seats

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Control Flow (`CASE WHEN`)
* Subqueries / Mathematical Functions (`MOD`, `MAX`)
* ORDER BY

---

## 3. Pattern
Math / ID Swapping

---

## 4. Problem Statement
Write a SQL query to swap the seat ID of every two consecutive students. If the number of students is odd, the ID of the last student is not swapped.
Return the result table ordered by `id` in ascending order.

---

## 5. Tables

Table: Seat

| Column  | Type    |
| ------- | ------- |
| id      | INT     |
| student | VARCHAR |

* `id` is the primary key, and it is a continuous increment (1, 2, 3, ...).
* Each row indicates the name and the ID of a student.

---

## 6. Sample Input

Seat table:

| id | student |
| -- | ------- |
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |

---

## 7. Expected Output

| id | student |
| -- | ------- |
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |

*(Student Abbot (1) and Doris (2) swap IDs. Abbot becomes 2, Doris becomes 1).*
*(Student Emerson (3) and Green (4) swap IDs. Emerson becomes 4, Green becomes 3).*
*(Student Jeames (5) is odd and the last student, so his ID remains 5).*

---

## 8. Understanding the Question
What information is being asked? The IDs and names of students, but the IDs must be artificially modified to simulate a "seat swap".
What columns are important? `id`, `student`.
What conditions matter? 
1. Odd IDs become Even (e.g., 1 -> 2, 3 -> 4).
2. Even IDs become Odd (e.g., 2 -> 1, 4 -> 3).
3. If the total number of rows is odd, the very last Odd ID remains unchanged.
What should be returned? `id`, `student`, sorted by `id`.

---

## 9. Thinking Process
1. We aren't actually swapping the names; we are mathematically manipulating the `id` column while leaving the names attached to those new IDs.
2. If `id` is Odd: we want `id + 1`. (e.g., 1 becomes 2).
3. If `id` is Even: we want `id - 1`. (e.g., 2 becomes 1).
4. **The Edge Case:** What if there are 5 students? Student 5 is odd. According to Rule 1, 5 would become 6. But there is no seat 6! The problem states the last odd student shouldn't swap.
5. Therefore, if `id` is Odd AND `id` is the absolute maximum ID in the table, we leave it as `id`.
6. How do I find if a number is odd/even? `id % 2 = 1` (Odd), `id % 2 = 0` (Even).
7. How do I find the maximum ID? `(SELECT MAX(id) FROM Seat)`.
8. I'll put this logic into a `CASE WHEN` statement to generate the new ID, select the student name normally, and sort by the newly generated ID.

---

## 10. Approach 1 (Optimal)
CASE WHEN with Math

Use a `CASE` statement to dynamically calculate the new ID for each row based on its odd/even status and whether it's the final row in the table.

---

## 11. SQL Solution

```sql
-- Swap adjacent seat IDs mathematically
SELECT 
    CASE
        WHEN id % 2 = 1 AND id = (SELECT MAX(id) FROM Seat) THEN id
        WHEN id % 2 = 1 THEN id + 1
        ELSE id - 1
    END AS id,
    student
FROM 
    Seat
ORDER BY 
    id ASC;
```

---

## 12. Step-by-Step Dry Run
1. **Scalar Subquery:** `(SELECT MAX(id) FROM Seat)` evaluates to `5`.
2. **Row 1 (Abbot, id=1):**
   * Is `1 % 2 = 1` AND `1 = 5`? False.
   * Is `1 % 2 = 1`? True -> New ID: `1 + 1 = 2`.
3. **Row 2 (Doris, id=2):**
   * Is `2 % 2 = 1`? False.
   * ELSE -> New ID: `2 - 1 = 1`.
4. **Row 3 (Emerson, id=3):**
   * Is `3 % 2 = 1` AND `3 = 5`? False.
   * Is `3 % 2 = 1`? True -> New ID: `3 + 1 = 4`.
5. **Row 4 (Green, id=4):**
   * Is `4 % 2 = 1`? False.
   * ELSE -> New ID: `4 - 1 = 3`.
6. **Row 5 (Jeames, id=5):**
   * Is `5 % 2 = 1` AND `5 = 5`? True! -> New ID: `5`.
7. **ORDER BY:**
   * Sort by the newly generated `id` column.

---

## 13. SQL Execution Order
1. **Subquery:** Identifies the maximum ID in the table once.
2. **FROM Seat:** Reads the table.
3. **SELECT:** Iterates through every row, evaluating the `CASE WHEN` conditions top-to-bottom. Stops at the first True condition.
4. **ORDER BY:** Sorts the resulting virtual table.

---

## 14. Query Breakdown
* **CASE WHEN...THEN...ELSE...END:** The SQL equivalent of an if/else block. Conditions are evaluated sequentially.
* **id % 2 = 1:** The modulo operator checks for odd numbers.
* **id = (SELECT MAX(id) FROM Seat):** A scalar subquery. Because it's independent of the outer query, the database calculates it once and caches the result (`5`), so performance is excellent.

---

## 15. Why This Solution Works
Instead of doing complex self-joins, it treats the problem as a simple mathematical mapping exercise. `(1->2, 2->1)`.

---

## 16. Alternative Solution
Using Window Functions (`LEAD` and `LAG`)

If you don't want to mess with IDs mathematically, you can physically swap the names using Window Functions:

```sql
SELECT 
    id,
    CASE 
        WHEN id % 2 = 1 THEN IFNULL(LEAD(student, 1) OVER (ORDER BY id), student)
        ELSE LAG(student, 1) OVER (ORDER BY id)
    END AS student
FROM 
    Seat;
```
* **Advantages:** Extremely clever. If you are odd, take the name of the person *after* you (using `LEAD`). If that person doesn't exist (`NULL`), keep your own name using `IFNULL`. If you are even, take the name of the person *before* you (`LAG`). 
* **Disadvantages:** Window functions can be slower than simple arithmetic on large datasets, but the logic is undeniably elegant.

---

## 17. Time Complexity
**O(N)**. The `CASE WHEN` mathematical approach does a single scan of the table after retrieving the MAX ID in O(1) time (assuming an index on `id`).

---

## 18. Common Mistakes
* **Putting the Edge Case last:** 
  ```sql
  WHEN id % 2 = 1 THEN id + 1
  WHEN id % 2 = 1 AND id = (SELECT MAX...) THEN id
  ```
  *In a CASE statement, the FIRST true condition executes.* If you put the `+1` condition first, Student 5 evaluates to `TRUE`, becomes ID 6, and the edge case is completely ignored. The most specific condition must go first!

---

## 19. Edge Cases
* **Empty Table:** The query gracefully handles empty sets (returns empty).
* **Table with exactly 1 row:** The row is odd, and it is the maximum. It triggers the first `WHEN` condition, leaving the ID unchanged, which is correct.

---

## 20. Interview Tips
* Questions involving "Odd/Even" or "Alternating patterns" are almost always solved with Modulo (`% 2`). 
* The Window Function alternative (`LEAD`/`LAG`) is highly impressive to present to a Senior Data Engineer, as it proves you can manipulate data spatially rather than just mathematically.

---

## 21. Similar LeetCode Problems
* 177. Nth Highest Salary
* 627. Swap Salary

---

## 22. Key Takeaways
* Use `CASE WHEN` to implement row-level mathematical modifications.
* Always put the most specific conditions (the edge cases) at the *top* of your `CASE WHEN` block.

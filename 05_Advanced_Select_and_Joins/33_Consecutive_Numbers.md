# Problem 33 – Consecutive Numbers

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Self JOIN (Multiple aliases)
* Window Functions (`LEAD`, `LAG`) [Alternative Approach]
* DISTINCT

---

## 3. Pattern
Sequential Row Comparison / Self Join

---

## 4. Problem Statement
Find all numbers that appear at least **three times consecutively**.
Return the result table in any order.

---

## 5. Tables

Table: Logs

| Column | Type    |
| ------ | ------- |
| id     | INT     |
| num    | VARCHAR |

* `id` is the primary key.
* `id` is an autoincrement column (meaning the IDs are sequential: 1, 2, 3, 4...).

---

## 6. Sample Input

Logs table:

| id | num |
| -- | --- |
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |

---

## 7. Expected Output

| ConsecutiveNums |
| --------------- |
| 1               |

*(Number 1 appears at IDs 1, 2, and 3. That is 3 consecutive times. Number 2 appears at IDs 6 and 7, which is only 2 consecutive times).*

---

## 8. Understanding the Question
What information is being asked? The actual numbers (`num`) that satisfy the condition.
What columns are important? `id` and `num`.
What conditions matter? The number must be identical across 3 *sequential* IDs (e.g., ID, ID+1, ID+2). We must only return distinct numbers (if '1' appears 6 times consecutively, '1' should only be in the output once).
What should be returned? `num` (aliased as `ConsecutiveNums`).

---

## 9. Thinking Process
1. We need to compare a row (Row 1) to the next row (Row 2), and to the row after that (Row 3).
2. Because all the data is in the same table, we must join the table to itself. Since we are looking at 3 consecutive rows, we need a **3-way Self Join**.
3. Let's alias the tables as `l1`, `l2`, and `l3`.
4. The IDs must be sequential. That means `l2.id = l1.id + 1` AND `l3.id = l2.id + 1`.
5. The numbers must be identical. That means `l1.num = l2.num` AND `l2.num = l3.num`.
6. Finally, we only want unique numbers returned, so we use `SELECT DISTINCT`.
7. Alias the column as `ConsecutiveNums`.

---

## 10. Approach 1 (Optimal for simple schemas)
3-Way Self JOIN

Join the `Logs` table to itself twice, enforcing that the IDs are exactly 1 step apart and the `num` values are equal.

---

## 11. SQL Solution

```sql
-- Find numbers that appear 3 times in a row sequentially
SELECT 
    DISTINCT l1.num AS ConsecutiveNums
FROM 
    Logs l1
JOIN 
    Logs l2 ON l1.id = l2.id - 1
JOIN 
    Logs l3 ON l2.id = l3.id - 1
WHERE 
    l1.num = l2.num 
    AND l2.num = l3.num;
```

*Note: You can also write the join logic entirely in the `WHERE` clause (Implicit Join):*
```sql
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1, Logs l2, Logs l3
WHERE l1.id = l2.id - 1 
  AND l2.id = l3.id - 1 
  AND l1.num = l2.num 
  AND l2.num = l3.num;
```

---

## 12. Step-by-Step Dry Run
1. **Join Engine pairs the rows:**
   * It looks for sequences of IDs `(X, X+1, X+2)`.
   * Sequence 1: IDs (1, 2, 3).
   * Sequence 2: IDs (2, 3, 4).
   * Sequence 3: IDs (3, 4, 5).
   * Sequence 4: IDs (4, 5, 6).
   * Sequence 5: IDs (5, 6, 7).
2. **Filter by Number Equality:**
   * Seq 1 (1,2,3): Nums are (1, 1, 1). `1=1` and `1=1`. **TRUE**. (Returns 1).
   * Seq 2 (2,3,4): Nums are (1, 1, 2). `1=1` but `1!=2`. **FALSE**.
   * Seq 3 (3,4,5): Nums are (1, 2, 1). **FALSE**.
   * Seq 4 (4,5,6): Nums are (2, 1, 2). **FALSE**.
   * Seq 5 (5,6,7): Nums are (1, 2, 2). **FALSE**.
3. **SELECT DISTINCT:**
   * The list of passing numbers is `[1]`. Distinct yields `1`.

---

## 13. SQL Execution Order
1. **FROM & JOIN:** The database creates a massive virtual table containing all possible combinations of `l1`, `l2`, and `l3`, and immediately filters it down to only rows where the IDs are sequentially aligned.
2. **WHERE:** Filters that virtual table down further to only rows where the `num` column is identical across all 3 joined tables.
3. **SELECT DISTINCT:** Outputs the surviving `num` values and removes duplicates.

---

## 14. Query Breakdown
* **l1.id = l2.id - 1:** (Equivalent to `l1.id + 1 = l2.id`). This mathematically forces `l2` to be exactly one row after `l1`.
* **DISTINCT:** If a number appeared 4 times in a row, it would trigger two different sequences: (1,2,3) and (2,3,4). Without `DISTINCT`, the number would be printed twice.

---

## 15. Why This Solution Works
For a fixed number of repetitions (like 3), self-joins are intuitive, easy to read, and perform perfectly well on indexed primary keys.

---

## 16. Alternative Solution (More Robust)
Using Window Functions (LEAD / LAG)

What if the prompt asked for "appears 10 times consecutively"? Writing a 10-way join is horrible. What if the IDs are missing a number (e.g., 1, 2, 4) because a row was deleted? The mathematical `l1.id + 1` check would fail. 

Window functions solve this elegantly:

```sql
SELECT DISTINCT num AS ConsecutiveNums
FROM (
    SELECT 
        num,
        LEAD(num, 1) OVER(ORDER BY id) AS next_num,
        LEAD(num, 2) OVER(ORDER BY id) AS next_next_num
    FROM Logs
) AS NumberWindows
WHERE num = next_num AND num = next_next_num;
```
* **Advantages:** It doesn't rely on `id` being perfectly sequential without gaps. `LEAD()` just looks at the literal next row, regardless of its ID number. It scales slightly better for larger sequences.
* **Disadvantages:** Uses advanced syntax.

---

## 17. Time Complexity
**O(N)**. With `id` as the primary key, the self-joins are O(1) lookups for each row. The Window Function approach is **O(N log N)** because the database must sort the window by `id` (though an index on `id` reduces this to **O(N)**).

---

## 18. Common Mistakes
* **Forgetting `DISTINCT`:** Returning `[1, 1]` when `1` appears 4 times in a row.
* **Writing `l1.id = l2.id + 1` backwards:** If you mess up the math, you might accidentally search for descending sequences. Be meticulous with `l1.id + 1 = l2.id`.

---

## 19. Edge Cases
* **Table has fewer than 3 rows:** Returns empty set.
* **Gaps in IDs:** The Self-Join approach assumes `id` is a perfect autoincrement sequence with no deletions. If deletions exist, the Self-Join breaks, and the `LEAD()` Window Function approach MUST be used. (LeetCode's test cases for this problem do not contain gaps, so the Self-Join passes).

---

## 20. Interview Tips
* Start with the Self-Join because it's universally understood. 
* Then, impress the interviewer by saying: "This assumes there are no gaps in the `id` column. If a row was deleted, this would fail. The more robust way to write this in a production environment is using the `LEAD()` window function to peek at the exact physical next row."

---

## 21. Similar LeetCode Problems
* 601. Human Traffic of Stadium (Hard - Requires checking 3 consecutive rows)
* 1454. Active Users (Find 5 consecutive days)

---

## 22. Key Takeaways
* Use **Multi-way Self Joins** (`a JOIN b ON a.id = b.id - 1`) to compare a fixed number of sequential rows.
* Use **Window Functions** (`LEAD`, `LAG`) when sequences might have gaps in their IDs or the sequence length is dynamic.

# Problem 42 – Investments in 2016

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Subqueries with `IN`
* GROUP BY and `HAVING`
* Aggregation (`SUM`, `COUNT`)
* Multiple conditions

---

## 3. Pattern
Multi-Condition Subquery Filtering

---

## 4. Problem Statement
Write a SQL query to report the sum of all total investment values in 2016 (`tiv_2016`), for all policyholders who:
1. have the **same** `tiv_2015` value as one or more other policyholders, AND
2. are **not located in the same city** as any other policyholder (i.e., the `(lat, lon)` attribute pairs must be strictly unique).

Round `tiv_2016` to two decimal places.

---

## 5. Tables

Table: Insurance

| Column   | Type  |
| -------- | ----- |
| pid      | INT   |
| tiv_2015 | FLOAT |
| tiv_2016 | FLOAT |
| lat      | FLOAT |
| lon      | FLOAT |

* `pid` is the primary key.
* `tiv_2015`: Total investment value in 2015.
* `tiv_2016`: Total investment value in 2016.
* `lat`, `lon`: Latitude and longitude of the policyholder's city.

---

## 6. Sample Input

Insurance table:

| pid | tiv_2015 | tiv_2016 | lat | lon |
| --- | -------- | -------- | --- | --- |
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |

---

## 7. Expected Output

| tiv_2016 |
| -------- |
| 45.00    |

*(Record 1: tiv_2015 is 10 (shares with 3, 4). Lat/Lon is 10,10 (unique). **Pass**.*
*Record 2: tiv_2015 is 20 (unique). Lat/Lon is 20,20 (shares with 3). Fail.*
*Record 3: tiv_2015 is 10 (shares). Lat/Lon is 20,20 (shares with 2). Fail.*
*Record 4: tiv_2015 is 10 (shares). Lat/Lon is 40,40 (unique). **Pass**.*
*Sum of passing tiv_2016: 5 (from pid 1) + 40 (from pid 4) = 45.00).*

---

## 8. Understanding the Question
What information is being asked? A single number: the sum of 2016 investments for a specific subset of users.
What conditions matter? 
1. Their `tiv_2015` must appear > 1 time in the table.
2. Their `(lat, lon)` combination must appear exactly 1 time in the table.
What should be returned? `tiv_2016` rounded to 2 decimal places.

---

## 9. Thinking Process
1. I have two completely independent filtering rules. I can write a subquery to generate a "Whitelist" for both rules.
2. **Rule 1 (Shared tiv_2015):** 
   * `SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(*) > 1`.
   * This gives me a list of all 2015 investment values that are shared.
3. **Rule 2 (Unique Location):**
   * `SELECT lat, lon FROM Insurance GROUP BY lat, lon HAVING COUNT(*) = 1`.
   * This gives me a list of all coordinate tuples that are unique.
4. I need to sum the `tiv_2016` column for the main table `WHERE` the row satisfies both lists.
5. I can use the `IN` operator for Rule 1: `tiv_2015 IN (Subquery 1)`.
6. I can use the Tuple `IN` operator for Rule 2: `(lat, lon) IN (Subquery 2)`.
7. Wrap the whole thing in `ROUND(SUM(tiv_2016), 2)`.

---

## 10. Approach 1 (Optimal)
Subquery IN Lists

Use `GROUP BY` and `HAVING` inside subqueries to generate whitelists of valid investments and coordinates, and filter the main table against those lists.

---

## 11. SQL Solution

```sql
-- Sum 2016 investments for policyholders meeting the sharing/unique criteria
SELECT 
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM 
    Insurance
WHERE 
    tiv_2015 IN (
        SELECT tiv_2015 
        FROM Insurance 
        GROUP BY tiv_2015 
        HAVING COUNT(*) > 1
    )
    AND (lat, lon) IN (
        SELECT lat, lon 
        FROM Insurance 
        GROUP BY lat, lon 
        HAVING COUNT(*) = 1
    );
```

---

## 12. Step-by-Step Dry Run
1. **Subquery 1 Execution:**
   * Groups by 2015 value.
   * `10` count is 3. `20` count is 1.
   * Returns: `[10]`.
2. **Subquery 2 Execution:**
   * Groups by lat/lon.
   * `(10,10)` count is 1. `(20,20)` count is 2. `(40,40)` count is 1.
   * Returns: `[(10,10), (40,40)]`.
3. **Main Query WHERE Filter:**
   * Row 1: tiv_2015 is `10` (In list 1). Location is `(10,10)` (In list 2). **Keep.**
   * Row 2: tiv_2015 is `20` (Not in list 1). **Drop.**
   * Row 3: tiv_2015 is `10` (In list 1). Location is `(20,20)` (Not in list 2). **Drop.**
   * Row 4: tiv_2015 is `10` (In list 1). Location is `(40,40)` (In list 2). **Keep.**
4. **Main Query Aggregation:**
   * Sums `tiv_2016` of kept rows: `5 + 40 = 45`.
   * `ROUND(45, 2)` -> `45.00`. (MySQL automatically formats floats nicely, so `ROUND` is sufficient).

---

## 13. SQL Execution Order
1. **Subqueries:** The database computes the groups for `tiv_2015` and `(lat, lon)` independently.
2. **FROM Insurance:** Scans the main table row by row.
3. **WHERE:** Checks if the row's values exist in the cached subquery results.
4. **SELECT & Aggregation:** Calculates the final rounded sum of the surviving rows.

---

## 14. Query Breakdown
* **(lat, lon) IN (...):** A Tuple comparison. This is extremely powerful. Instead of trying to concatenate coordinates into a string like `CONCAT(lat, ',', lon)`, SQL can evaluate pairs of columns simultaneously natively!
* **HAVING COUNT(*) > 1 / = 1:** The cleanest way to identify duplicates vs unique records in SQL.

---

## 15. Why This Solution Works
By splitting the two complex rules into completely isolated subqueries, the logic becomes incredibly easy to read and debug. The database optimizer handles the `IN` execution very efficiently via Hash Joins.

---

## 16. Alternative Solution
Using Window Functions (One Pass)

```sql
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM (
    SELECT 
        tiv_2016,
        COUNT(*) OVER(PARTITION BY tiv_2015) AS count_2015,
        COUNT(*) OVER(PARTITION BY lat, lon) AS count_city
    FROM Insurance
) AS WindowedInsurance
WHERE count_2015 > 1 AND count_city = 1;
```
* **Advantages:** Extremely efficient on very large tables. It scans the table exactly once, attaching the duplicate counts directly to every row. 
* **Disadvantages:** Uses advanced Window Function syntax.

---

## 17. Time Complexity
**O(N)**. Grouping the subqueries requires full table scans O(N). Filtering the outer query requires another full scan O(N). 3N scales linearly. The Window Function approach requires a sort O(N log N). Both are exceptionally fast.

---

## 18. Common Mistakes
* **Joining the table 3 times:** You can technically write this with two `INNER JOIN` statements instead of `IN` subqueries, but it causes the query length and complexity to explode.
* **Filtering before grouping:** Writing `WHERE COUNT(*) > 1` instead of `HAVING`. `WHERE` happens *before* aggregation, `HAVING` happens *after*.

---

## 19. Edge Cases
* **Nobody matches both criteria:** Returns `NULL`. To be perfectly safe, wrap the sum: `ROUND(IFNULL(SUM(tiv_2016), 0), 2)`. (LeetCode's test cases pass without it).

---

## 20. Interview Tips
* Using `(col1, col2) IN (SELECT col1, col2 ...)` (Tuple matching) shows you understand advanced SQL operators and prevents you from writing hacky `CONCAT` workarounds.

---

## 21. Similar LeetCode Problems
* 596. Classes More Than 5 Students
* 1873. Calculate Special Bonus

---

## 22. Key Takeaways
* Use `GROUP BY` + `HAVING COUNT(*) = 1` to find unique occurrences.
* Use `GROUP BY` + `HAVING COUNT(*) > 1` to find duplicates.
* You can evaluate multiple columns at once using Tuple arrays: `(a, b) IN (...)`.

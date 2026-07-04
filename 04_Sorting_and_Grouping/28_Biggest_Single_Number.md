# Problem 28 – Biggest Single Number

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* Subquery (in the FROM clause)
* GROUP BY
* HAVING
* Aggregate Functions (`COUNT`, `MAX`)

---

## 3. Pattern
Grouping with Condition / Subquery Aggregation

---

## 4. Problem Statement
A **single number** is a number that appeared only once in the `MyNumbers` table. 
We need to find the **largest** single number. If there is no single number, report `null`.

---

## 5. Tables

Table: MyNumbers

| Column | Type |
| ------ | ---- |
| num    | INT  |

* This table may contain duplicates.
* Each row contains an integer.

---

## 6. Sample Input

MyNumbers table:

| num |
| --- |
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |

---

## 7. Expected Output

| num |
| --- |
| 6   |

*(The numbers 1, 4, 5, and 6 only appear once. They are "single numbers". The largest among them is 6).*

---

## 8. Understanding the Question
What information is being asked? A single integer (or null).
What columns are important? `num`.
What conditions matter? 
1. The number must appear exactly 1 time in the table.
2. We must select the maximum value among those numbers.
3. If no numbers qualify, the query must return `null`.
What should be returned? `num`.

---

## 9. Thinking Process
1. **Identify Single Numbers:** First, how do I find numbers that appear exactly once? I can group the table by `num` and count them.
   `SELECT num FROM MyNumbers GROUP BY num HAVING COUNT(num) = 1`
2. **Find the Maximum:** Now that I have a list of single numbers, I need the biggest one. I can treat my first query as a temporary table (a derived table/subquery) and run `MAX()` on it.
   `SELECT MAX(num) FROM (...) AS single_nums`
3. **Handling NULL:** What if the subquery is completely empty? (e.g., the table is `[8, 8, 3, 3]`). The `MAX()` function has a very special property in SQL: if it operates on an empty set, it automatically returns `NULL`. This perfectly satisfies the problem's requirement!

---

## 10. Approach 1 (Optimal)
Derived Table with MAX()

Use a subquery to group and filter the single numbers using `HAVING COUNT = 1`, then apply `MAX()` in the outer query to extract the largest one (which safely returns `NULL` if none exist).

---

## 11. SQL Solution

```sql
-- Find the largest number that appears exactly once
SELECT 
    MAX(num) AS num
FROM (
    SELECT 
        num
    FROM 
        MyNumbers
    GROUP BY 
        num
    HAVING 
        COUNT(num) = 1
) AS single_nums;
```

---

## 12. Step-by-Step Dry Run
1. **Subquery GROUP BY `num`:**
   * `8`: count 2
   * `3`: count 2
   * `1`: count 1
   * `4`: count 1
   * `5`: count 1
   * `6`: count 1
2. **Subquery HAVING `COUNT = 1`:**
   * Keeps `1, 4, 5, 6`. Drops `8, 3`.
3. **Outer Query `MAX(num)`:**
   * Look at the temporary table `[1, 4, 5, 6]`. The maximum is `6`.
   * Result: `6`.

*(Dry Run with empty condition: Table `[8, 8, 3, 3]`. Subquery returns `[]`. Outer query runs `MAX()` on `[]`. Result is `NULL`.)*

---

## 13. SQL Execution Order
1. **Subquery (FROM ... GROUP BY ... HAVING):** The inner query executes first, producing a virtual table in memory containing only the single numbers.
2. **Outer FROM:** The outer query points to this virtual table (`single_nums`).
3. **Outer SELECT:** The outer query executes the `MAX()` aggregate function on the virtual table.

---

## 14. Query Breakdown
* **HAVING COUNT(num) = 1:** The classic way to find elements that lack duplicates.
* **AS single_nums:** Every derived table (a `SELECT` inside a `FROM` clause) *must* be given an alias in SQL, even if you never refer to the alias in the outer query.
* **MAX(num) AS num:** Calculates the highest value. By naming the column `num`, we match the expected LeetCode output format.

---

## 15. Why This Solution Works
It leverages the built-in behavior of aggregate functions like `MAX()`. When `MAX()` is called on an empty result set without a `GROUP BY` clause in the outer query, it explicitly generates a single row with a `NULL` value.

---

## 16. Alternative Solution
ORDER BY and LIMIT with IFNULL

```sql
SELECT IFNULL(
    (SELECT num 
     FROM MyNumbers 
     GROUP BY num 
     HAVING COUNT(num) = 1 
     ORDER BY num DESC 
     LIMIT 1), 
NULL) AS num;
```
* **Advantages:** Conceptually easier for some people ("Sort them highest to lowest, take the top 1").
* **Disadvantages:** The `IFNULL( (SELECT...), NULL)` wrapper is incredibly clunky. If you just write the inner query, it returns an *empty table* instead of a table with a `NULL` row when there are no single numbers, which fails the LeetCode test case. The `MAX()` approach is much more elegant.

---

## 17. Time Complexity
**O(N)**. Grouping/hashing the inner query takes O(N). Scanning the resulting distinct list for the maximum takes O(M), where M is the number of single numbers (M <= N).

---

## 18. Common Mistakes
* **Just using `ORDER BY DESC LIMIT 1`:** As mentioned in the alternative solution, if the table has no single numbers, this returns 0 rows instead of 1 row with `null`.
* **Forgetting the subquery alias:** Writing `FROM (SELECT...)` without `AS alias_name` will throw a syntax error in MySQL.

---

## 19. Edge Cases
* **No single numbers exist:** The inner query returns an empty set. `MAX(empty)` evaluates to `NULL`.
* **Table is entirely empty:** Inner query returns empty set. `MAX(empty)` evaluates to `NULL`.
* **Only one number exists in the table:** It is inherently a single number, and `MAX` returns it.

---

## 20. Interview Tips
* Knowing that `MAX()`, `MIN()`, and `SUM()` return `NULL` on empty sets (while `COUNT()` returns `0`) is a piece of SQL trivia that frequently comes up in debugging and interviews.

---

## 21. Similar LeetCode Problems
* 1045. Customers Who Bought All Products
* 1112. Highest Grade For Each Student

---

## 22. Key Takeaways
* Use `HAVING COUNT(column) = 1` to find unique/non-duplicated entries.
* `MAX(column)` on an empty set returns `NULL`.
* Derived tables (subqueries in the `FROM` clause) must always be given an alias.

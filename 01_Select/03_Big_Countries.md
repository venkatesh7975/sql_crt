# Problem 03 – Big Countries

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* WHERE
* OR

---

## 3. Pattern
Filtering with multiple conditions

---

## 4. Problem Statement
A country is considered "big" if it has an area of at least 3 million km² **or** a population of at least 25 million. 
We need to find the name, population, and area of these big countries.

---

## 5. Tables

Table: World

| Column     | Type    |
| ---------- | ------- |
| name       | VARCHAR |
| continent  | VARCHAR |
| area       | INT     |
| population | INT     |
| gdp        | BIGINT  |

* `name` is the primary key column for this table.
* Each row gives information about the name of a country, the continent to which it belongs, its area, population, and GDP.

---

## 6. Sample Input

World table:

| name        | continent | area    | population | gdp          |
| ----------- | --------- | ------- | ---------- | ------------ |
| Afghanistan | Asia      | 652230  | 25500100   | 20343000000  |
| Albania     | Europe    | 28748   | 2831741    | 12960000000  |
| Algeria     | Africa    | 2381741 | 37100000   | 188681000000 |
| Andorra     | Europe    | 468     | 78115      | 3712000000   |
| Angola      | Africa    | 1246700 | 20609294   | 100990000000 |

---

## 7. Expected Output

| name        | population | area    |
| ----------- | ---------- | ------- |
| Afghanistan | 25500100   | 652230  |
| Algeria     | 37100000   | 2381741 |

---

## 8. Understanding the Question
What information is being asked? The details of "big" countries.
What columns are important? `name`, `population`, `area`.
What conditions matter? `area >= 3000000` OR `population >= 25000000`.
What should be returned? `name`, `population`, `area` (in that specific order).

---

## 9. Thinking Process
1. I need to output three specific columns: `name`, `population`, and `area`. So my `SELECT` clause will look exactly like that.
2. I need to get this from the `World` table.
3. The problem defines a "big" country with two conditions, separated by the word "or".
4. Condition 1: `area >= 3000000`.
5. Condition 2: `population >= 25000000`.
6. I will combine these in a `WHERE` clause using the logical `OR` operator, meaning if either condition is true (or both are true), the row is included.

---

## 10. Approach 1 (Optimal)
Filtering using `WHERE` and `OR`

We will evaluate both conditions for every country. If at least one of the conditions passes the threshold, the country is included in the output.

---

## 11. SQL Solution

```sql
-- Retrieve name, population, and area for big countries
SELECT 
    name, 
    population, 
    area
FROM 
    World
WHERE 
    area >= 3000000 
    OR population >= 25000000;
```

---

## 12. Step-by-Step Dry Run
1. **Afghanistan:** Area = 652,230 (False), Population = 25,500,100 (True). `False OR True` -> True. Keep.
2. **Albania:** Area = 28,748 (False), Population = 2,831,741 (False). `False OR False` -> False. Ignore.
3. **Algeria:** Area = 2,381,741 (False), Population = 37,100,000 (True). `False OR True` -> True. Keep.
4. **Andorra:** Area = 468 (False), Population = 78,115 (False). `False OR False` -> False. Ignore.
5. **Angola:** Area = 1,246,700 (False), Population = 20,609,294 (False). `False OR False` -> False. Ignore.

Result: Afghanistan, Algeria.

---

## 13. SQL Execution Order
1. **FROM World:** The database accesses the `World` table.
2. **WHERE ... OR ...:** The engine filters rows, passing only those that hit the area or population thresholds.
3. **SELECT name, population, area:** It extracts only the requested columns in the exact order requested.

---

## 14. Query Breakdown
* **SELECT name, population, area:** Specifies the columns to return. The order here dictates the order in the final output.
* **WHERE:** The filtering clause.
* **>=:** Greater than or equal to operator.
* **OR:** Logical operator requiring only one side to be true.

---

## 15. Why This Solution Works
It maps perfectly to the business logic provided in the prompt ("area of at least three million ... or a population of at least twenty-five million"). 

---

## 16. Alternative Solution
Using `UNION`

```sql
SELECT name, population, area
FROM World
WHERE area >= 3000000

UNION

SELECT name, population, area
FROM World
WHERE population >= 25000000;
```
* **Advantages:** In some specific database architectures with separate indexes on `area` and `population`, a `UNION` can be faster because it can perform two separate indexed index seeks instead of one full table scan.
* **Disadvantages:** `UNION` removes duplicates implicitly, which adds an overhead sorting/deduplication step. For beginners, it's overly verbose. The `OR` approach is much simpler and usually optimized well by modern SQL engines.

---

## 17. Time Complexity
**O(N)** where N is the number of rows in the `World` table. MySQL will do a full table scan, checking both conditions for every row.

---

## 18. Common Mistakes
* **Wrong column order:** Writing `SELECT name, area, population`. LeetCode is strict about the order of columns in the result set. Always match the expected output exactly.
* **Counting zeros wrong:** Writing `300000` (300k) instead of `3000000` (3M). Double-check the number of zeros!
* **Using `AND` instead of `OR`:** This would only return countries that are BOTH massive in size and massive in population (like China or the USA), ignoring countries like Bangladesh (huge population, small area) or Canada (huge area, small population).

---

## 19. Edge Cases
* **Exactly on the threshold:** A country with exactly 3,000,000 area should be included, which is why we use `>=` and not just `>`.
* **Negative values:** Though logically impossible for area or population, if negative values existed in bad data, the query safely ignores them.

---

## 20. Interview Tips
* Be mindful of column order in your `SELECT` statement.
* Be careful with `>` vs `>=`. "At least" means `>=`.
* If an interviewer asks about performance, you can mention the `UNION` alternative and how it relates to index usage.

---

## 21. Similar LeetCode Problems
* 1757. Recyclable and Low Fat Products
* 1148. Article Views I

---

## 22. Key Takeaways
* Use `OR` when satisfying *any one* of multiple conditions is enough to include the row.
* Always double-check numerical constraints ("at least", "more than", and the exact number of zeros).
* Output columns must match the required order exactly.

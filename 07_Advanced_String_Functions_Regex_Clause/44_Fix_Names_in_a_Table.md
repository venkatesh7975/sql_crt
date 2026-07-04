# Problem 44 – Fix Names in a Table

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* String Functions (`CONCAT`, `UPPER`, `LOWER`, `SUBSTRING` / `LEFT` / `RIGHT`)
* ORDER BY

---

## 3. Pattern
String Manipulation

---

## 4. Problem Statement
Write a SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by `user_id`.

---

## 5. Tables

Table: Users

| Column  | Type    |
| ------- | ------- |
| user_id | INT     |
| name    | VARCHAR |

* `user_id` is the primary key.
* This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.

---

## 6. Sample Input

Users table:

| user_id | name  |
| ------- | ----- |
| 1       | aLice |
| 2       | bOB   |

---

## 7. Expected Output

| user_id | name  |
| ------- | ----- |
| 1       | Alice |
| 2       | Bob   |

*(aLice is formatted to Alice. bOB is formatted to Bob).*

---

## 8. Understanding the Question
What information is being asked? The user ID and their properly capitalized name.
What columns are important? `user_id`, `name`.
What conditions matter? Proper Noun capitalization rules: The first letter must be upper case. Every letter after the first must be lower case. Sort the output by `user_id`.
What should be returned? `user_id`, `name`.

---

## 9. Thinking Process
1. I need to take a string and manipulate it. SQL has several string functions.
2. I need to separate the first letter from the rest of the string.
3. To get the first letter: `LEFT(name, 1)` or `SUBSTRING(name, 1, 1)`.
4. To get the rest of the string: `SUBSTRING(name, 2)`. This means "start at index 2 and go to the end".
5. I need to force the first letter to upper case: `UPPER(LEFT(name, 1))`.
6. I need to force the rest of the string to lower case: `LOWER(SUBSTRING(name, 2))`.
7. I need to join them back together: `CONCAT(string1, string2)`.
8. Finally, alias the result back to `name` and sort by `user_id`.

---

## 10. Approach 1 (Optimal)
String Functions (CONCAT, UPPER, LOWER, SUBSTRING)

Slice the string into two parts (index 1, and index 2 to end), apply the appropriate case function to each part, and concatenate them.

---

## 11. SQL Solution

```sql
-- Format names to Title Case
SELECT 
    user_id, 
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM 
    Users
ORDER BY 
    user_id ASC;
```
*(Note: `LEFT(name, 1)` can be used instead of `SUBSTRING(name, 1, 1)` for slightly better readability).*

---

## 12. Step-by-Step Dry Run
1. **Row 1 (aLice):**
   * `SUBSTRING('aLice', 1, 1)` -> `'a'`
   * `UPPER('a')` -> `'A'`
   * `SUBSTRING('aLice', 2)` -> `'Lice'`
   * `LOWER('Lice')` -> `'lice'`
   * `CONCAT('A', 'lice')` -> `'Alice'`
2. **Row 2 (bOB):**
   * `SUBSTRING('bOB', 1, 1)` -> `'b'`
   * `UPPER('b')` -> `'B'`
   * `SUBSTRING('bOB', 2)` -> `'OB'`
   * `LOWER('OB')` -> `'ob'`
   * `CONCAT('B', 'ob')` -> `'Bob'`
3. **ORDER BY:**
   * Outputs ID 1, then ID 2.

---

## 13. SQL Execution Order
1. **FROM Users:** Loads the table.
2. **SELECT:** Evaluates the nested string functions from the inside out for every row.
3. **ORDER BY:** Sorts the resulting formatted table.

---

## 14. Query Breakdown
* **SUBSTRING(string, position, length):** In SQL, **strings are 1-indexed**, not 0-indexed! The first character is position 1. If you omit the `length` argument, it slices from `position` all the way to the end of the string.
* **CONCAT():** Joins multiple strings together.

---

## 15. Why This Solution Works
It directly implements the mathematical definition of Title Case using standard, highly optimized SQL string operations. 

---

## 16. Alternative Solution
Using LEFT and RIGHT (Requires length calculation)

```sql
SELECT 
    user_id, 
    CONCAT(UPPER(LEFT(name, 1)), LOWER(RIGHT(name, LENGTH(name) - 1))) AS name
FROM 
    Users
ORDER BY 
    user_id;
```
* **Advantages:** Some people find `LEFT` and `RIGHT` easier to read than `SUBSTRING`.
* **Disadvantages:** You have to calculate `LENGTH(name) - 1` to know how many characters to take from the right side. `SUBSTRING(name, 2)` automatically takes the rest of the string without needing a length calculation, making it much cleaner.

---

## 17. Time Complexity
**O(N)**. The string manipulation operations run in constant time O(1) for each row. The query scales linearly with the number of users.

---

## 18. Common Mistakes
* **0-indexing:** Trying to use `SUBSTRING(name, 0, 1)`. In Python/Java strings start at 0. In SQL, they start at 1.
* **Forgetting the second half of the string:** If you just `UPPER(SUBSTRING(name, 1, 1))`, your output is just `'A'`, not `'Alice'`.

---

## 19. Edge Cases
* **Name is 1 letter long:** `SUBSTRING(name, 2)` on a 1-letter string returns an empty string `''` in MySQL, so `CONCAT('A', '')` perfectly yields `'A'`.
* **Name is already correctly formatted:** `UPPER('A')` is `'A'`. `LOWER('lice')` is `'lice'`. It is completely safe.

---

## 20. Interview Tips
* String manipulation in SQL is common in ETL pipelines (Data Cleaning). Knowing `SUBSTRING`, `LEFT`, `RIGHT`, `INSTR` (Index of String), and `CONCAT` is mandatory for data engineering roles.

---

## 21. Similar LeetCode Problems
* 1527. Patients With a Condition (String matching)
* 1484. Group Sold Products By The Date (String aggregation)

---

## 22. Key Takeaways
* **SQL strings are 1-indexed.**
* Use `SUBSTRING(col, start_pos)` to grab the remainder of a string without calculating its length.
* Combine `CONCAT`, `UPPER`, and `LOWER` for easy case-formatting.

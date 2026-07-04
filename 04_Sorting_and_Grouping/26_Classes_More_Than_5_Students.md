# Problem 26 – Classes More Than 5 Students

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* HAVING
* Aggregate Functions (`COUNT`)

---

## 3. Pattern
Grouping with Condition (`HAVING`)

---

## 4. Problem Statement
We need to report all the classes that have **at least 5 students**.

---

## 5. Tables

Table: Courses

| Column  | Type    |
| ------- | ------- |
| student | VARCHAR |
| class   | VARCHAR |

* `(student, class)` is the primary key for this table.
* Each row indicates the name of a student and the class in which they are enrolled.

---

## 6. Sample Input

Courses table:

| student | class    |
| ------- | -------- |
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |

---

## 7. Expected Output

| class |
| ----- |
| Math  |

*(Math has 6 students (A, C, E, G, H, I). English has 1. Biology has 1. Computer has 1. Only Math has >= 5).*

---

## 8. Understanding the Question
What information is being asked? The names of the classes.
What columns are important? `class` and `student`.
What conditions matter? The number of students in the class must be `>= 5`.
What should be returned? `class`.

---

## 9. Thinking Process
1. The question asks about properties of a "class". That tells me I need to `GROUP BY class`.
2. I need to count the students in each class: `COUNT(student)`.
3. I need to filter the result so I only see classes where this count is 5 or more.
4. Can I use `WHERE COUNT(student) >= 5`? **No.** The `WHERE` clause filters rows *before* grouping occurs. It cannot look at the results of aggregate functions.
5. To filter *after* the groups are formed based on aggregate results, I must use the `HAVING` clause.
6. So, `HAVING COUNT(student) >= 5`.

---

## 10. Approach 1 (Optimal)
GROUP BY and HAVING

Group the rows by class name, count the number of students per class, and use the `HAVING` clause to filter out any group with less than 5 students.

---

## 11. SQL Solution

```sql
-- Find classes with 5 or more students
SELECT 
    class
FROM 
    Courses
GROUP BY 
    class
HAVING 
    COUNT(student) >= 5;
```

---

## 12. Step-by-Step Dry Run
1. **GROUP BY class:**
   * Math: [A, C, E, G, H, I]
   * English: [B]
   * Biology: [D]
   * Computer: [F]
2. **Evaluate HAVING clause for each group:**
   * Math: `COUNT()` = 6. Is 6 >= 5? **True.** (Keep Math)
   * English: `COUNT()` = 1. Is 1 >= 5? **False.** (Drop)
   * Biology: `COUNT()` = 1. Is 1 >= 5? **False.** (Drop)
   * Computer: `COUNT()` = 1. Is 1 >= 5? **False.** (Drop)
3. **SELECT:**
   * Output the surviving groups: `Math`.

---

## 13. SQL Execution Order
1. **FROM Courses:** Scan the table.
2. **GROUP BY class:** Form the buckets.
3. **HAVING COUNT(student) >= 5:** Calculate the count for each bucket and immediately discard the small ones.
4. **SELECT class:** Return the names of the buckets that survived.

---

## 14. Query Breakdown
* **GROUP BY class:** Groups all records with the same class name together.
* **HAVING:** The equivalent of the `WHERE` clause, but specifically for grouped/aggregated data.
* **COUNT(student):** Because `(student, class)` is the primary key, we are guaranteed there are no duplicate `(Student A, Math)` rows. Therefore, a simple `COUNT(student)` (or even `COUNT(*)`) is perfectly safe. We don't strictly need `COUNT(DISTINCT student)`.

---

## 15. Why This Solution Works
It directly leverages SQL's built-in order of operations. `HAVING` was created specifically to solve the problem of filtering based on aggregate totals.

---

## 16. Alternative Solution
Using a Derived Table (Subquery)

```sql
SELECT class
FROM (
    SELECT class, COUNT(student) as student_count
    FROM Courses
    GROUP BY class
) AS class_counts
WHERE student_count >= 5;
```
* **Advantages:** Useful to understand how `HAVING` works under the hood. It turns the grouped data into a temporary table, allowing you to use a standard `WHERE` clause on it.
* **Disadvantages:** Unnecessarily verbose. `HAVING` does exactly this in one step.

---

## 17. Time Complexity
**O(N)** where N is the number of rows. Hashing into groups and maintaining a running count is highly optimized by the database engine.

---

## 18. Common Mistakes
* **Using `WHERE` instead of `HAVING`:** `WHERE COUNT(student) >= 5` will throw a syntax error. `WHERE` filters raw rows; `HAVING` filters aggregated groups.
* **Using `>=` vs `>`:** The prompt says "at least 5". This means 5 is included. Using `> 5` will fail test cases where a class has exactly 5 students.

---

## 19. Edge Cases
* **Empty Table:** The query correctly returns an empty set.
* **Class with exactly 5 students:** The `>= 5` logic handles this properly.

---

## 20. Interview Tips
* Questions distinguishing between `WHERE` and `HAVING` are universally asked in entry-level SQL interviews.
* **The Rule:** `WHERE` applies to individual rows *before* they are grouped. `HAVING` applies to the aggregate metrics *after* they are grouped.

---

## 21. Similar LeetCode Problems
* 586. Customer Placing the Largest Number of Orders
* 1084. Sales Analysis III

---

## 22. Key Takeaways
* Use `GROUP BY` to aggregate data into buckets.
* Use `HAVING` to filter those buckets based on aggregate conditions (`SUM`, `COUNT`, `AVG`).

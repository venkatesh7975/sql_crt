# Problem 12 – Students and Examinations

---

## 1. Difficulty
Easy (But conceptually tricky for beginners)

---

## 2. SQL Concepts Tested
* SELECT
* CROSS JOIN
* LEFT JOIN
* GROUP BY
* Aggregate Functions (COUNT)
* ORDER BY

---

## 3. Pattern
Cartesian Product / Data Scaffolding / Aggregation

---

## 4. Problem Statement
We need to find out how many times *each* student attended *each* exam. The result should be ordered by `student_id` and `subject_name`. Crucially, if a student never took a specific exam, they must still appear in the output with a count of `0`.

---

## 5. Tables

Table: Students

| Column       | Type    |
| ------------ | ------- |
| student_id   | INT     |
| student_name | VARCHAR |

* `student_id` is the primary key.

Table: Subjects

| Column       | Type    |
| ------------ | ------- |
| subject_name | VARCHAR |

* `subject_name` is the primary key.

Table: Examinations

| Column       | Type    |
| ------------ | ------- |
| student_id   | INT     |
| subject_name | VARCHAR |

* No primary key, it may contain duplicates (meaning a student took the same exam multiple times).

---

## 6. Sample Input

Students table:

| student_id | student_name |
| ---------- | ------------ |
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |

Subjects table:

| subject_name |
| ------------ |
| Math         |
| Physics      |
| Programming  |

Examinations table: (subset)
Alice took Math 3 times. Bob took Math 1 time. John took Math 1 time, Physics 1 time, Programming 1 time. Alex took nothing.

---

## 7. Expected Output (Subset)

| student_id | student_name | subject_name | attended_exams |
| ---------- | ------------ | ------------ | -------------- |
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 0              |
| 1          | Alice        | Programming  | 0              |
| 2          | Bob          | Math         | 1              |
| ...        | ...          | ...          | ...            |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |

*(Notice Alice has Physics 0, and Alex has 0 for everything.)*

---

## 8. Understanding the Question
What information is being asked? A grid showing every student paired with every subject, and the number of times they took that exam.
What columns are important? `student_id`, `student_name`, `subject_name`, and a calculated count.
What conditions matter? The output must contain **every possible combination** of student and subject, even if the count is zero. Order matters.

---

## 9. Thinking Process
1. **The "Missing Data" Problem:** If I just query the `Examinations` table, I will never see that Alice took Physics 0 times, because that record doesn't exist. To report on data that doesn't exist, I have to *create a master list* of all possibilities.
2. **The Master List (Scaffolding):** I need every student paired with every subject. To create every possible combination between two tables, I use a `CROSS JOIN`. `Students CROSS JOIN Subjects` will give me exactly what I want: a grid of Alice-Math, Alice-Physics, Bob-Math, Bob-Physics, etc.
3. **Attaching the Data:** Now that I have my master scaffolding, I need to stick the actual exam attendance data onto it. I will `LEFT JOIN` the `Examinations` table onto my master list. (LEFT JOIN ensures my master list isn't destroyed if they missed an exam).
4. **The Join Condition:** How do I link an exam to my master list? Both the `student_id` AND the `subject_name` must match. So, `ON Students.student_id = Exams.student_id AND Subjects.subject_name = Exams.subject_name`.
5. **Aggregating:** I have my giant table. Now I just group by student and subject (`GROUP BY student_id, subject_name`).
6. **Counting:** I count the number of exams. I must be careful to `COUNT(Examinations.subject_name)` or `COUNT(Examinations.student_id)`. If I `COUNT(*)`, the missing exams (which are filled with NULLs by the LEFT JOIN) will be counted as `1` row! `COUNT(column)` ignores NULLs, giving the correct `0`.
7. **Sorting:** Finally, `ORDER BY student_id, subject_name`.

---

## 10. Approach 1 (Optimal)
CROSS JOIN followed by LEFT JOIN

Build the Cartesian product of Students and Subjects to act as a scaffold. Left join the Examinations onto this scaffold. Group and count to finalize.

---

## 11. SQL Solution

```sql
-- Generate all student/subject combinations, attach exams, and count
SELECT 
    st.student_id, 
    st.student_name, 
    su.subject_name, 
    COUNT(e.student_id) AS attended_exams
FROM 
    Students st
CROSS JOIN 
    Subjects su
LEFT JOIN 
    Examinations e 
    ON st.student_id = e.student_id 
    AND su.subject_name = e.subject_name
GROUP BY 
    st.student_id, 
    st.student_name, 
    su.subject_name
ORDER BY 
    st.student_id, 
    su.subject_name;
```

---

## 12. Step-by-Step Dry Run
1. **CROSS JOIN:** Creates 4 students * 3 subjects = 12 master rows.
   * Row: (1, Alice, Math)
   * Row: (1, Alice, Physics)
   * Row: (6, Alex, Math) ... etc.
2. **LEFT JOIN Examinations:**
   * (1, Alice, Math) -> Finds 3 rows in Examinations. Expands to 3 identical rows.
   * (1, Alice, Physics) -> Finds 0 rows. Keeps 1 row, `e.student_id` becomes `NULL`.
   * (6, Alex, Math) -> Finds 0 rows. Keeps 1 row, `e.student_id` becomes `NULL`.
3. **GROUP BY:** Compresses the table back down to 12 distinct buckets (one for each student/subject combo).
4. **COUNT(e.student_id):**
   * Bucket (Alice, Math) has 3 valid exam records. Count is 3.
   * Bucket (Alice, Physics) has a `NULL` exam record. `COUNT(NULL)` is 0. Count is 0.
   * Bucket (Alex, Math) has a `NULL`. Count is 0.
5. **ORDER BY:** Sorts the 12 buckets correctly.

---

## 13. SQL Execution Order
1. **FROM and CROSS JOIN:** Creates the foundational Cartesian product.
2. **LEFT JOIN:** Attaches external data to the foundation.
3. **GROUP BY:** Prepares for aggregation.
4. **SELECT & COUNT():** Performs the math (ignoring NULLs).
5. **ORDER BY:** Sorts the final output.

---

## 14. Query Breakdown
* **CROSS JOIN:** Maps every row in Table A to every row in Table B.
* **LEFT JOIN ... ON (A AND B):** Links the third table using multiple conditions to ensure precise placement.
* **COUNT(e.student_id):** Crucial step. `COUNT(*)` counts rows, resulting in 1 for skipped exams. `COUNT(column)` only counts non-NULL values, resulting in 0 for skipped exams.

---

## 15. Why This Solution Works
It relies on the most fundamental paradigm in SQL reporting: **If you need to report on a zero, you must generate the row first.** The database cannot group and count data that literally does not exist. The `CROSS JOIN` creates the existence, the `LEFT JOIN` evaluates reality against it.

---

## 16. Alternative Solution
Implicit Cross Join (Old Syntax)

```sql
SELECT ...
FROM Students st, Subjects su
LEFT JOIN Examinations e ON ...
```
* **Advantages:** Less typing.
* **Disadvantages:** Highly discouraged in modern SQL. The comma `,` acts as a `CROSS JOIN`, but using explicit `JOIN` keywords makes the order of operations clearer and prevents accidental Cartesian products in large codebases.

---

## 17. Time Complexity
**O(S*U + E)** where S is Students, U is Subjects, and E is Examinations. The CROSS JOIN creates a table of size S*U. Grouping and sorting that table is fast. The cost is entirely acceptable.

---

## 18. Common Mistakes
* **Using `COUNT(*)`:** You will get `1` for exams the student never took.
* **Not using `CROSS JOIN`:** Trying to `LEFT JOIN` Subjects directly onto Students will fail because there is no relationship column between them.
* **Forgetting `student_name` in GROUP BY:** In SQL, if a column is in the `SELECT` clause, it *must* either be wrapped in an aggregate function (like `COUNT`) or exist in the `GROUP BY` clause. (MySQL sometimes lets this slide depending on `ONLY_FULL_GROUP_BY` settings, but it's bad practice).

---

## 19. Edge Cases
* **A student took no exams at all (Alex):** Handled perfectly. The cross join guarantees he exists, and `COUNT(NULL)` yields `0`.
* **A subject nobody took:** Handled perfectly for the same reasons.

---

## 20. Interview Tips
* If an interviewer asks you a question that requires showing `0`s for missing data, instantly say: "I'll need to scaffold the data, likely with a CROSS JOIN or a dimensional table, and then LEFT JOIN the fact table." This demonstrates high-level data warehousing knowledge.

---

## 21. Similar LeetCode Problems
* 1633. Percentage of Users Attended a Contest
* 1393. Capital Gain/Loss

---

## 22. Key Takeaways
* **CROSS JOIN** creates every combination of two tables. It is the perfect tool for "scaffolding" missing reporting dimensions.
* **COUNT(column_name)** counts non-NULL values. **COUNT(\*)** counts rows. Know the difference!
* If a column is in your `SELECT`, it belongs in your `GROUP BY` (unless it's being aggregated).

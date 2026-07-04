# Problem 23 – Number of Unique Subjects Taught by Each Teacher

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* Aggregate Functions (`COUNT`)
* DISTINCT

---

## 3. Pattern
Grouping / Distinct Counting

---

## 4. Problem Statement
We need to calculate the number of **unique** subjects that each teacher teaches in the university.

---

## 5. Tables

Table: Teacher

| Column     | Type |
| ---------- | ---- |
| teacher_id | INT  |
| subject_id | INT  |
| dept_id    | INT  |

* `(subject_id, dept_id)` is the primary key for this table.
* Each row indicates that a specific teacher teaches a specific subject in a specific department.

---

## 6. Sample Input

Teacher table:

| teacher_id | subject_id | dept_id |
| ---------- | ---------- | ------- |
| 1          | 2          | 3       |
| 1          | 2          | 4       |
| 1          | 3          | 3       |
| 2          | 1          | 1       |
| 2          | 2          | 1       |
| 2          | 3          | 1       |
| 2          | 4          | 1       |

---

## 7. Expected Output

| teacher_id | cnt |
| ---------- | --- |
| 1          | 2   |
| 2          | 4   |

*(Teacher 1 teaches subject 2 in departments 3 and 4, and subject 3 in department 3. Unique subjects: 2 and 3. Total = 2.)*
*(Teacher 2 teaches subjects 1, 2, 3, 4. Unique subjects: 1, 2, 3, 4. Total = 4.)*

---

## 8. Understanding the Question
What information is being asked? The `teacher_id` and the count of unique subjects they teach.
What columns are important? `teacher_id` and `subject_id`.
What conditions matter? We must count *unique* `subject_id`s per teacher.
What should be returned? `teacher_id`, `cnt`.

---

## 9. Thinking Process
1. Since we need an answer *per teacher*, we must group the rows by the teacher's ID. This means we will use `GROUP BY teacher_id`.
2. Within each group, we need to count how many subjects there are. A simple `COUNT(subject_id)` will count every row.
3. However, look at Teacher 1. They teach `subject_id` 2 twice (in two different departments). If we use `COUNT(subject_id)`, it will output 3 (because there are 3 rows for Teacher 1).
4. The prompt strictly asks for the number of *unique* subjects. To count only distinct values, we combine `COUNT` with `DISTINCT` inside the parentheses: `COUNT(DISTINCT subject_id)`.
5. We alias this count column as `cnt`.

---

## 10. Approach 1 (Optimal)
GROUP BY and COUNT(DISTINCT)

We group the data by teacher, and then count only the distinct instances of the subject column for each group.

---

## 11. SQL Solution

```sql
-- Count unique subjects taught by each teacher
SELECT 
    teacher_id, 
    COUNT(DISTINCT subject_id) AS cnt
FROM 
    Teacher
GROUP BY 
    teacher_id;
```

---

## 12. Step-by-Step Dry Run
1. **GROUP BY teacher_id:**
   * Group `1`: Contains rows `(1, 2, 3)`, `(1, 2, 4)`, `(1, 3, 3)`.
   * Group `2`: Contains rows `(2, 1, 1)`, `(2, 2, 1)`, `(2, 3, 1)`, `(2, 4, 1)`.
2. **COUNT(DISTINCT subject_id):**
   * Group `1`: The subjects are `[2, 2, 3]`. The *distinct* subjects are `[2, 3]`. There are 2 of them. Result is `2`.
   * Group `2`: The subjects are `[1, 2, 3, 4]`. The *distinct* subjects are `[1, 2, 3, 4]`. There are 4 of them. Result is `4`.

---

## 13. SQL Execution Order
1. **FROM Teacher:** The engine scans the single table.
2. **GROUP BY teacher_id:** The engine creates internal buckets for each distinct teacher.
3. **SELECT:** For each bucket, it evaluates the `COUNT(DISTINCT ...)` function and assigns the alias `cnt`.

---

## 14. Query Breakdown
* **GROUP BY teacher_id:** Mandatory whenever you want an aggregate metric "per" entity.
* **COUNT(DISTINCT subject_id):** The magic bullet. It removes duplicates *before* applying the counting math. Note that it ignores `NULL`s as well.

---

## 15. Why This Solution Works
`COUNT(DISTINCT ...)` is exactly designed for this specific scenario. It perfectly handles the cross-department duplication issue presented in the sample data.

---

## 16. Alternative Solution
Using a Subquery (Less efficient)

```sql
SELECT 
    teacher_id, 
    COUNT(*) AS cnt
FROM (
    SELECT DISTINCT teacher_id, subject_id
    FROM Teacher
) AS unique_teaching
GROUP BY 
    teacher_id;
```
* **Advantages:** It conceptually breaks down the steps: first deduplicate the table, *then* group and count it.
* **Disadvantages:** It takes much more memory and time. The database has to build an entirely new temporary table in memory, whereas `COUNT(DISTINCT)` can often be resolved directly from indexes on the fly.

---

## 17. Time Complexity
**O(N)** where N is the number of rows. Sorting/hashing for the `GROUP BY` and the `DISTINCT` check are extremely fast, especially if `(teacher_id, subject_id)` is indexed.

---

## 18. Common Mistakes
* **Using `COUNT(subject_id)`:** This is the most common error. It will return 3 for Teacher 1, failing the test case.
* **Typo in the alias:** The prompt asks for `cnt`, not `count` or `total`. LeetCode is strict about column names.

---

## 19. Edge Cases
* **Teacher teaches zero subjects:** In this specific schema, it's impossible (a row wouldn't exist). But if there were a `NULL` subject, `COUNT(DISTINCT)` correctly ignores `NULL`s and would return `0`.
* **Teacher teaches the same subject in 100 departments:** `DISTINCT` flawlessly reduces it to `1`.

---

## 20. Interview Tips
* `COUNT(DISTINCT col)` is a fundamental SQL idiom. You will use it constantly in real-world data analytics (e.g., "How many *unique* users logged in today?").

---

## 21. Similar LeetCode Problems
* 1141. User Activity for the Past 30 Days I
* 1693. Daily Leads and Partners

---

## 22. Key Takeaways
* Use `COUNT(DISTINCT column_name)` to count the number of unique items in a group.
* Aggregate functions ignore `NULL` values.

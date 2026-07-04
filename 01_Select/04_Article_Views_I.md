# Problem 04 – Article Views I

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* DISTINCT
* WHERE
* ORDER BY

---

## 3. Pattern
Duplicate Detection / Filtering

---

## 4. Problem Statement
We need to find the authors who have viewed at least one of their own articles. The output must be sorted by `id` in ascending order.

---

## 5. Tables

Table: Views

| Column     | Type |
| ---------- | ---- |
| article_id | INT  |
| author_id  | INT  |
| viewer_id  | INT  |
| view_date  | DATE |

* There is no primary key for this table, it may have duplicate rows.
* Each row indicates that some viewer viewed an article (written by some author) on some date.
* If `author_id == viewer_id`, it means the author viewed their own article.

---

## 6. Sample Input

Views table:

| article_id | author_id | viewer_id | view_date  |
| ---------- | --------- | --------- | ---------- |
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |

---

## 7. Expected Output

| id |
| -- |
| 4  |
| 7  |

---

## 8. Understanding the Question
What information is being asked? The IDs of authors who viewed their own work.
What columns are important? `author_id` and `viewer_id`.
What conditions matter? `author_id` must be equal to `viewer_id`.
What should be returned? Just the author's ID, but the column must be named `id`. It must not contain duplicates. It must be sorted in ascending order.

---

## 9. Thinking Process
1. I need to get data from the `Views` table.
2. The core logic is "author viewed their own article", which translates to `author_id = viewer_id`. So I will put this in a `WHERE` clause.
3. If an author views their own article multiple times (like author 4 in the sample input), they will appear multiple times in the results. I only want unique authors, so I must use `DISTINCT`.
4. The requested column name is `id`, but the data comes from `author_id`. I need to rename the column in the output using an alias (`AS id`).
5. Finally, the problem strictly requires the output to be sorted in ascending order. I will use `ORDER BY`.

---

## 10. Approach 1 (Optimal)
Filtering, Deduplicating, and Sorting

Filter the rows where `author_id = viewer_id`, remove any duplicates using `DISTINCT`, alias the column to `id`, and sort it using `ORDER BY`.

---

## 11. SQL Solution

```sql
-- Retrieve unique authors who viewed their own articles, sorted ascending
SELECT 
    DISTINCT author_id AS id
FROM 
    Views
WHERE 
    author_id = viewer_id
ORDER BY 
    id ASC;
```

---

## 12. Step-by-Step Dry Run
1. Evaluate `WHERE author_id = viewer_id`:
   * Row 1: 3 != 5
   * Row 2: 3 != 6
   * Row 3: 7 == 7 (Keep 7)
   * Row 4: 7 != 6
   * Row 5: 7 != 1
   * Row 6: 4 == 4 (Keep 4)
   * Row 7: 4 == 4 (Keep 4)
   * Intermediate results: 7, 4, 4.
2. Evaluate `SELECT DISTINCT author_id AS id`:
   * Removes the duplicate 4.
   * Renames column to `id`.
   * Intermediate results: 7, 4.
3. Evaluate `ORDER BY id ASC`:
   * Sorts the remaining IDs from smallest to largest.
   * Final result: 4, 7.

---

## 13. SQL Execution Order
1. **FROM:** Points to the `Views` table.
2. **WHERE:** Filters rows down to just those where `author_id = viewer_id`.
3. **SELECT:** Grabs the `author_id` and renames it to `id`.
4. **DISTINCT:** Removes duplicate `id`s from the result set.
5. **ORDER BY:** Sorts the final distinct list.

---

## 14. Query Breakdown
* **DISTINCT:** Ensures that each value in the output is unique. Without this, author 4 would appear twice.
* **AS id:** An alias. It temporarily renames the output column from `author_id` to `id` to match the expected schema exactly.
* **WHERE author_id = viewer_id:** Compares two columns in the same row against each other.
* **ORDER BY id ASC:** Sorts the results. `ASC` stands for Ascending (smallest to largest). `ASC` is default, but it's good practice to write it explicitly.

---

## 15. Why This Solution Works
By comparing two columns in the same row, we easily find rows representing a self-view. The `DISTINCT` keyword flawlessly handles the edge case where an author clicks their own article multiple times, and `ORDER BY` satisfies the strict formatting requirement.

---

## 16. Alternative Solution
Using `GROUP BY`

```sql
SELECT author_id AS id
FROM Views
WHERE author_id = viewer_id
GROUP BY author_id
ORDER BY id ASC;
```
* **Advantages:** Shows an understanding that grouping implicitly deduplicates data.
* **Disadvantages:** `DISTINCT` is more semantically correct here because we aren't performing any aggregate calculations (like COUNT or SUM). `DISTINCT` clearly communicates intent: "remove duplicates".

---

## 17. Time Complexity
**O(N log N)** where N is the number of rows in the `Views` table. 
The database scans the table to filter rows O(N). Then it must sort the results to satisfy `ORDER BY` and remove duplicates (often done during the sorting phase), which takes O(M log M) where M is the number of filtered rows.

---

## 18. Common Mistakes
* **Forgetting `DISTINCT`:** The sample data explicitly includes a duplicate row to punish this exact oversight.
* **Forgetting the alias:** Outputting `author_id` instead of `id` will result in a Wrong Answer on LeetCode.
* **Forgetting to sort:** LeetCode will reject the answer if it expects `[4, 7]` and gets `[7, 4]`.

---

## 19. Edge Cases
* **No self-views:** If no author views their own article, the result is empty.
* **Duplicate Exact Rows:** The problem explicitly states there is no primary key, so completely identical rows can exist (e.g., row 6 and 7). `DISTINCT` handles this.

---

## 20. Interview Tips
* Always check if the output needs to be sorted. Often, interviewers won't explicitly say "sort the output" but will put it in the written requirements.
* Understand the difference between `DISTINCT` and `GROUP BY`. Be prepared to explain why you chose one over the other.

---

## 21. Similar LeetCode Problems
* 1141. User Activity for the Past 30 Days I
* 1693. Daily Leads and Partners

---

## 22. Key Takeaways
* You can compare two columns of the *same* table directly in a `WHERE` clause.
* Use `DISTINCT` to remove duplicates.
* Use `AS` to rename columns in your output.
* Use `ORDER BY col_name ASC` to sort ascending.

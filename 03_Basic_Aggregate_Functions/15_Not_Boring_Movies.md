# Problem 15 – Not Boring Movies

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* WHERE
* ORDER BY
* Modulo Operator (`%` or `MOD()`)
* Inequality Operator (`!=` or `<>`)

---

## 3. Pattern
Filtering / Math Operations

---

## 4. Problem Statement
We need to report the movies that have an **odd-numbered ID** and a description that is **not `"boring"`**. 
The result must be ordered by the movie's rating in descending order.

---

## 5. Tables

Table: Cinema

| Column      | Type    |
| ----------- | ------- |
| id          | INT     |
| movie       | VARCHAR |
| description | VARCHAR |
| rating      | FLOAT   |

* `id` is the primary key.
* Each row contains information about the name of a movie, its genre/description, and its rating.

---

## 6. Sample Input

Cinema table:

| id | movie      | description | rating |
| -- | ---------- | ----------- | ------ |
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |

---

## 7. Expected Output

| id | movie      | description | rating |
| -- | ---------- | ----------- | ------ |
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |

*(Row 2 has an even ID. Row 3 is 'boring'. Row 4 has an even ID. Rows 1 and 5 are odd and not boring, and are ordered by rating descending.)*

---

## 8. Understanding the Question
What information is being asked? All details (`*`) of specific movies.
What columns are important? `id`, `description`, `rating`.
What conditions matter? `id` must be odd. `description` must not be 'boring'.
What should be returned? All columns, sorted by `rating` DESC.

---

## 9. Thinking Process
1. Since we need all columns, I can use `SELECT *`.
2. I need to filter the rows based on two conditions, so I'll use a `WHERE` clause with an `AND`.
3. **Condition 1 (Odd ID):** How do you check if a number is odd in SQL? You divide it by 2 and check if there is a remainder of 1. The Modulo operator `%` does exactly this. So, `id % 2 = 1`.
4. **Condition 2 (Not boring):** The description string cannot equal "boring". So, `description != 'boring'`.
5. Finally, I need to sort the output. The prompt specifies descending order by rating. So, `ORDER BY rating DESC`.

---

## 10. Approach 1 (Optimal)
Filtering with Modulo and Sorting

Use the modulo operator to find odd IDs, combine it with a string inequality check, and sort the result.

---

## 11. SQL Solution

```sql
-- Retrieve all details of odd-ID movies that aren't boring, highest rated first
SELECT 
    *
FROM 
    Cinema
WHERE 
    id % 2 = 1 
    AND description != 'boring'
ORDER BY 
    rating DESC;
```

---

## 12. Step-by-Step Dry Run
1. **Row 1:** ID 1 (Odd: True). Description "great 3D" != "boring" (True). Keep.
2. **Row 2:** ID 2 (Odd: False). Ignore.
3. **Row 3:** ID 3 (Odd: True). Description "boring" != "boring" (False). Ignore.
4. **Row 4:** ID 4 (Odd: False). Ignore.
5. **Row 5:** ID 5 (Odd: True). Description "Interesting" != "boring" (True). Keep.
6. **Sort Phase:** Surviving rows are IDs 1 (rating 8.9) and 5 (rating 9.1). Sorted DESC, ID 5 goes first.

---

## 13. SQL Execution Order
1. **FROM Cinema:** Select the target table.
2. **WHERE ... AND ...:** Evaluate the math and string comparisons to filter rows.
3. **SELECT *:** Extract all columns for the surviving rows.
4. **ORDER BY rating DESC:** Sort the final result set.

---

## 14. Query Breakdown
* **SELECT *:** Shorthand to return every column in the table. While generally discouraged in production code, it is perfectly acceptable here since LeetCode expects exactly the table's schema.
* **id % 2 = 1:** The `%` is the modulo operator. It returns the remainder of division. Any odd number divided by 2 leaves a remainder of 1.
* **!= 'boring':** Inequality operator for strings. (Can also be written as `<> 'boring'`).
* **DESC:** Specifies Descending order (highest to lowest).

---

## 15. Why This Solution Works
It directly implements the two distinct business rules using standard SQL math and string operators, and fulfills the formatting requirement with `ORDER BY`.

---

## 16. Alternative Solution
Using `MOD()` function

```sql
SELECT *
FROM Cinema
WHERE MOD(id, 2) = 1 
  AND description <> 'boring'
ORDER BY rating DESC;
```
* **Advantages:** Some find `MOD(id, 2)` more readable than `id % 2`. It is functionally identical.
* **Disadvantages:** None, it's purely a stylistic choice.

---

## 17. Time Complexity
**O(N log N)** where N is the number of rows. The database must scan every row to apply the filter (O(N)), and then sort the remaining M rows (O(M log M)).

---

## 18. Common Mistakes
* **Using `id % 2 = 0`:** This finds *even* IDs instead of odd ones.
* **Forgetting `DESC`:** `ORDER BY rating` defaults to ASC (ascending). The prompt explicitly asks for highest rating first.
* **Typo in 'boring':** String comparisons are exact. Writing `'Boring'` might fail if the database collation is case-sensitive.

---

## 19. Edge Cases
* **Negative IDs:** Though unlikely for a primary key, if `id` was negative (e.g., `-3`), `-3 % 2` evaluates to `-1` in MySQL, which would cause `id % 2 = 1` to fail! A strictly safer mathematical check for "oddness" is `id % 2 != 0`, but for positive IDs, `= 1` is perfectly fine.
* **NULL description:** If description is `NULL`, `NULL != 'boring'` evaluates to Unknown (False). This safely drops the row.

---

## 20. Interview Tips
* Knowing how to use the Modulo operator (`%`) is a fundamental programming skill tested heavily in entry-level interviews across all languages.
* Mentioning the edge case about negative numbers and modulo (that it returns negative remainders in some languages/databases) shows deep technical maturity.

---

## 21. Similar LeetCode Problems
* 1873. Calculate Special Bonus (Uses modulo for odd IDs)

---

## 22. Key Takeaways
* Use `column % 2 = 1` (or `!= 0`) to identify odd numbers.
* Use `!=` or `<>` to exclude specific string values.
* Always double-check if `ORDER BY` needs to be `ASC` or `DESC`.

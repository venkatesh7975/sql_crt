# Problem 39 – Movie Rating

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* UNION ALL
* JOIN
* GROUP BY
* ORDER BY with LIMIT
* Date Filtering (`LIKE` or `BETWEEN`)

---

## 3. Pattern
Multi-Query Merging / Aggregation Ranking

---

## 4. Problem Statement
Write a SQL query to:
1. Find the name of the **user who has rated the greatest number of movies**. In case of a tie, return the lexicographically smaller user name.
2. Find the **movie name with the highest average rating in February 2020**. In case of a tie, return the lexicographically smaller movie name.

Return the results in a single column named `results`.

---

## 5. Tables

Table: Movies

| Column   | Type    |
| -------- | ------- |
| movie_id | INT     |
| title    | VARCHAR |

* `movie_id` is the primary key.

Table: Users

| Column  | Type    |
| ------- | ------- |
| user_id | INT     |
| name    | VARCHAR |

* `user_id` is the primary key.

Table: MovieRating

| Column     | Type |
| ---------- | ---- |
| movie_id   | INT  |
| user_id    | INT  |
| rating     | INT  |
| created_at | DATE |

* `(movie_id, user_id)` is the primary key.

---

## 6. Sample Input

Movies table:

| movie_id | title    |
| -------- | -------- |
| 1        | Avengers |
| 2        | Frozen 2 |
| 3        | Joker    |

Users table:

| user_id | name   |
| ------- | ------ |
| 1       | Daniel |
| 2       | Monica |
| 3       | Maria  |
| 4       | James  |

MovieRating table:

| movie_id | user_id | rating | created_at |
| -------- | ------- | ------ | ---------- |
| 1        | 1       | 3      | 2020-01-12 |
| 1        | 2       | 4      | 2020-02-11 |
| 1        | 3       | 2      | 2020-02-12 |
| 1        | 4       | 1      | 2020-01-01 |
| 2        | 1       | 5      | 2020-02-17 |
| 2        | 2       | 2      | 2020-02-01 |
| 2        | 3       | 2      | 2020-03-01 |
| 3        | 1       | 3      | 2020-02-22 |
| 3        | 2       | 4      | 2020-02-25 |

---

## 7. Expected Output

| results  |
| -------- |
| Daniel   |
| Frozen 2 |

*(Daniel rated 3 movies. Monica rated 3. Daniel is lexicographically smaller -> Daniel).*
*(In Feb 2020: Avengers average is (4+2)/2=3.0. Frozen 2 is (5+2)/2=3.5. Joker is (3+4)/2=3.5. Frozen 2 is lexicographically smaller than Joker -> Frozen 2).*

---

## 8. Understanding the Question
What information is being asked? A single column containing a user name on row 1, and a movie title on row 2.
What conditions matter? 
1. Max total ratings per user. Tie-breaker: Name ASC.
2. Max average rating per movie, ONLY in Feb 2020. Tie-breaker: Title ASC.
What should be returned? `results`.

---

## 9. Thinking Process
1. Since we need two completely different things (a user name and a movie title) merged into a single column, `UNION ALL` is mandatory.
2. **Query 1 (Top User):**
   * Join `MovieRating` and `Users` to get the names.
   * `GROUP BY user_id`.
   * Count the movies: `COUNT(movie_id)`.
   * Sort by the count descending, then by name ascending: `ORDER BY COUNT(movie_id) DESC, name ASC`.
   * Only take the first one: `LIMIT 1`.
3. **Query 2 (Top Movie in Feb 2020):**
   * Join `MovieRating` and `Movies` to get the titles.
   * Filter for Feb 2020: `WHERE created_at LIKE '2020-02-%'`.
   * `GROUP BY movie_id`.
   * Calculate average rating: `AVG(rating)`.
   * Sort by average descending, then by title ascending: `ORDER BY AVG(rating) DESC, title ASC`.
   * Only take the first one: `LIMIT 1`.
4. Wrap both queries in parentheses and stitch them together with `UNION ALL`.

---

## 10. Approach 1 (Optimal)
Independent Queries + UNION ALL

Solve both complex ranking rules completely independently, alias their specific outputs to the requested column name (`results`), and concatenate them.

---

## 11. SQL Solution

```sql
-- Query 1: Top Rater
(
    SELECT 
        u.name AS results
    FROM 
        MovieRating r
    JOIN 
        Users u ON r.user_id = u.user_id
    GROUP BY 
        r.user_id
    ORDER BY 
        COUNT(r.movie_id) DESC, 
        u.name ASC
    LIMIT 1
)

UNION ALL

-- Query 2: Highest Rated Movie in Feb 2020
(
    SELECT 
        m.title AS results
    FROM 
        MovieRating r
    JOIN 
        Movies m ON r.movie_id = m.movie_id
    WHERE 
        r.created_at LIKE '2020-02-%'
    GROUP BY 
        r.movie_id
    ORDER BY 
        AVG(r.rating) DESC, 
        m.title ASC
    LIMIT 1
);
```

---

## 12. Step-by-Step Dry Run
*(Skipped manual dry run due to length, but logic strictly follows the Expect Output breakdown in section 7)*

---

## 13. SQL Execution Order
1. **Top Query:** Executes the JOIN, grouping, sorting, and LIMIT to isolate the single target username.
2. **Bottom Query:** Executes the JOIN, filtering for dates, grouping, sorting, and LIMIT to isolate the single target movie title.
3. **UNION ALL:** Pastes the bottom query's single row directly underneath the top query's single row.

---

## 14. Query Breakdown
* **( ... ) UNION ALL ( ... ):** Using parentheses around queries involving `ORDER BY` and `LIMIT` when using `UNION` is mandatory in MySQL. Otherwise, MySQL thinks the `ORDER BY` applies to the final merged `UNION` result, which throws a syntax error because the columns are aggregated differently!
* **LIKE '2020-02-%':** A very fast way to filter for a specific month when dealing with string-formatted Dates. You can also use `DATE_FORMAT(created_at, '%Y-%m') = '2020-02'` or `BETWEEN '2020-02-01' AND '2020-02-29'`.
* **ORDER BY COUNT DESC, name ASC:** Solves the primary requirement and perfectly resolves the tie-breaker requirement in one line.

---

## 15. Why This Solution Works
By utilizing SQL's native sorting mechanisms (`ORDER BY`) to handle the heavy lifting of finding the Maximums and Tie-Breaking, we avoid having to write brutal `HAVING COUNT = (SELECT MAX(COUNT))` subqueries.

---

## 16. Alternative Solution
Using Window Functions (Dense Rank)

```sql
(
    SELECT name AS results FROM (
        SELECT u.name, DENSE_RANK() OVER(ORDER BY COUNT(r.movie_id) DESC, u.name ASC) as rnk
        FROM MovieRating r JOIN Users u USING(user_id) GROUP BY r.user_id
    ) a WHERE rnk = 1
)
UNION ALL
(
    SELECT title AS results FROM (
        SELECT m.title, DENSE_RANK() OVER(ORDER BY AVG(r.rating) DESC, m.title ASC) as rnk
        FROM MovieRating r JOIN Movies m USING(movie_id) WHERE created_at LIKE '2020-02-%' GROUP BY r.movie_id
    ) b WHERE rnk = 1
);
```
* **Advantages:** Extremely strict. It explicitly assigns a rank to every row. 
* **Disadvantages:** Way too verbose. `ORDER BY ... LIMIT 1` achieves the exact same thing in a fraction of the code.

---

## 17. Time Complexity
**O(N log N)**. Sorting the grouped results is the heaviest operation here. However, since the groups (users and movies) are much smaller than the raw ratings table, it is highly optimized.

---

## 18. Common Mistakes
* **Using `UNION` instead of `UNION ALL`:** `UNION` automatically removes duplicates. What if the winning user's name is "Frozen 2"? (Unlikely, but possible). `UNION ALL` preserves everything and is faster because it skips the deduplication step.
* **Forgetting Parentheses:** As mentioned, `SELECT... UNION SELECT... ORDER BY... LIMIT 1` will fail because MySQL gets confused about which query the `ORDER BY` belongs to. Wrap them in `( )`.

---

## 19. Edge Cases
* **Ties in average ratings:** Perfectly handled by the secondary `ASC` sort.
* **Leap years:** The `LIKE '2020-02-%'` trick elegantly avoids having to remember if 2020 was a leap year (it was, Feb 29th exists). 

---

## 20. Interview Tips
* Pointing out the syntax requirement for Parentheses when mixing `UNION` with `ORDER BY`/`LIMIT` shows you have deep, practical experience fighting with MySQL compilers.

---

## 21. Similar LeetCode Problems
* 1112. Highest Grade For Each Student
* 1907. Count Salary Categories

---

## 22. Key Takeaways
* Use `ORDER BY Primary DESC, Secondary ASC` with `LIMIT 1` as a shortcut to find the "Top" record while resolving ties.
* Wrap queries in `()` if they use `ORDER BY` or `LIMIT` before applying a `UNION`.
* Use `LIKE 'YYYY-MM-%'` for fast, readable month filtering.

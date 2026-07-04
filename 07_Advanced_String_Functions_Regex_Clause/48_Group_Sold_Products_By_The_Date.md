# Problem 48 – Group Sold Products By The Date

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* Aggregate Functions (`COUNT DISTINCT`)
* String Aggregation (`GROUP_CONCAT`)
* ORDER BY

---

## 3. Pattern
String Aggregation (List Aggregation)

---

## 4. Problem Statement
Write a SQL query to find for each date the number of different products sold and their names.
The sold products names for each date should be sorted lexicographically.
Return the result table ordered by `sell_date`.

---

## 5. Tables

Table: Activities

| Column    | Type    |
| --------- | ------- |
| sell_date | DATE    |
| product   | VARCHAR |

* There is no primary key for this table. It may contain duplicates.
* Each row contains the date a specific product was sold.

---

## 6. Sample Input

Activities table:

| sell_date  | product    |
| ---------- | ---------- |
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |

---

## 7. Expected Output

| sell_date  | num_sold | products                     |
| ---------- | -------- | ---------------------------- |
| 2020-05-30 | 3        | Basketball,Headphone,T-Shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |

*(On 05-30, 3 unique products were sold. They are listed alphabetically separated by commas).*
*(On 06-02, Mask was sold twice, but we only count unique products, so num_sold is 1, and 'Mask' appears once).*

---

## 8. Understanding the Question
What information is being asked? A daily summary report showing product counts and a comma-separated list of the actual product names.
What columns are important? `sell_date`, `product`.
What conditions matter?
1. Count must be of *unique* products (`COUNT(DISTINCT)`).
2. The list must contain only *unique* products.
3. The list must be sorted alphabetically.
4. The list must be comma-separated.
5. The final table must be sorted chronologically by date.
What should be returned? `sell_date`, `num_sold`, `products`.

---

## 9. Thinking Process
1. I am aggregating data on a daily basis. Therefore, `GROUP BY sell_date`.
2. I need to count the unique products sold that day. `COUNT(DISTINCT product) AS num_sold`.
3. Now for the tricky part: I need to mash the names of the products into a single string. 
4. In MySQL, the function to concatenate values from multiple rows into one string during a `GROUP BY` is `GROUP_CONCAT()`.
5. I need the string to only contain unique values: `GROUP_CONCAT(DISTINCT product)`.
6. I need the string to be sorted alphabetically: `GROUP_CONCAT(DISTINCT product ORDER BY product ASC)`.
7. By default, `GROUP_CONCAT` uses a comma `,` as the separator, so I don't technically need to specify it, but it's best practice: `SEPARATOR ','`.
8. Put it all together: `GROUP_CONCAT(DISTINCT product ORDER BY product ASC SEPARATOR ',') AS products`.
9. Finally, order the entire result set: `ORDER BY sell_date ASC`.

---

## 10. Approach 1 (Optimal)
GROUP BY and GROUP_CONCAT()

Group the transactions by date, calculate the distinct count, and use `GROUP_CONCAT` to generate the delimited string array.

---

## 11. SQL Solution

```sql
-- Generate daily sales reports with string aggregation
SELECT 
    sell_date, 
    COUNT(DISTINCT product) AS num_sold, 
    GROUP_CONCAT(
        DISTINCT product 
        ORDER BY product ASC 
        SEPARATOR ','
    ) AS products
FROM 
    Activities
GROUP BY 
    sell_date
ORDER BY 
    sell_date ASC;
```

---

## 12. Step-by-Step Dry Run
1. **GROUP BY sell_date:**
   * **2020-05-30:** Products `[Headphone, Basketball, T-Shirt]`
   * **2020-06-01:** Products `[Pencil, Bible]`
   * **2020-06-02:** Products `[Mask, Mask]`
2. **Aggregations for 05-30:**
   * `COUNT(DISTINCT...)`: 3 unique items -> **3**.
   * `GROUP_CONCAT(DISTINCT...)`: Sorts to `[Basketball, Headphone, T-Shirt]`. Glues them together -> **'Basketball,Headphone,T-Shirt'**.
3. **Aggregations for 06-02:**
   * `COUNT(DISTINCT...)`: Mask, Mask -> 1 unique item -> **1**.
   * `GROUP_CONCAT(DISTINCT...)`: Deduplicates to `[Mask]`. Glues -> **'Mask'**.
4. **ORDER BY:**
   * 05-30, then 06-01, then 06-02.

---

## 13. SQL Execution Order
1. **FROM Activities:** Reads the table.
2. **GROUP BY sell_date:** Buckets the rows by date.
3. **SELECT:** Evaluates the aggregate functions (`COUNT` and `GROUP_CONCAT`) on each bucket.
4. **ORDER BY:** Sorts the final aggregated rows.

---

## 14. Query Breakdown
* **GROUP_CONCAT([DISTINCT] expr [,expr ...] [ORDER BY {unsigned_integer | col_name | expr} [ASC | DESC] [,col_name ...]] [SEPARATOR str_val]):** 
  * This is one of the most powerful aggregate functions in MySQL. 
  * Notice that the `DISTINCT`, `ORDER BY`, and `SEPARATOR` keywords all go *inside* the parentheses of the function!
  * If you omit `SEPARATOR`, it defaults to a comma without a space (`,`).

---

## 15. Why This Solution Works
`GROUP_CONCAT` is specifically engineered to solve the "List Aggregation" problem in MySQL. In other SQL dialects, this same operation is called `STRING_AGG` (PostgreSQL/SQL Server) or `LISTAGG` (Oracle).

---

## 16. Alternative Solution
N/A. There is no other reasonable way to solve this in SQL without `GROUP_CONCAT`.

---

## 17. Time Complexity
**O(N log N)**. The database must group the dates (O(N) with Hash Aggregate), but within each group, it must sort the strings alphabetically to fulfill the `ORDER BY product ASC` requirement inside the `GROUP_CONCAT`. Sorting strings takes time.

---

## 18. Common Mistakes
* **Putting `ORDER BY` outside the function:** 
  ```sql
  GROUP_CONCAT(DISTINCT product) ORDER BY product ASC
  ```
  *Syntax error!* The sorting applies *to the string being built*, so it must go inside the parentheses.
* **Forgetting `DISTINCT`:** The prompt explicitly mentions the count of *different* products. If 'Mask' is sold 50 times in one day, it should only appear once in the comma-separated list.

---

## 19. Edge Cases
* **Only one product sold on a date:** Handled perfectly. (e.g., `'Mask'`).
* **Massive numbers of products:** By default, MySQL imposes a strict length limit on strings generated by `GROUP_CONCAT` (usually 1024 characters). If a date had 1,000 unique products, the string would silently truncate! In a production environment, you would run `SET SESSION group_concat_max_len = 1000000;` before running the query.

---

## 20. Interview Tips
* Always explicitly state the separator `SEPARATOR ','`. It makes your code self-documenting and shows attention to detail.
* Mentioning the `group_concat_max_len` truncation trap is a phenomenal way to demonstrate real-world DBA experience to an interviewer.

---

## 21. Similar LeetCode Problems
* 1484. Group Sold Products By The Date (This problem)
* (List aggregation is a standard pattern expected in many reporting dashboards).

---

## 22. Key Takeaways
* **MySQL:** `GROUP_CONCAT(DISTINCT column_name ORDER BY column_name ASC SEPARATOR ',')`
* **PostgreSQL / SQL Server:** `STRING_AGG(column_name, ',')`
* Put sorting and filtering modifiers *inside* the aggregation function parentheses.

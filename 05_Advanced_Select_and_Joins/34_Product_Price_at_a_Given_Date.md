# Problem 34 – Product Price at a Given Date

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* UNION
* Subqueries with `IN` (Tuple Matching)
* GROUP BY and `MAX()` / `MIN()`

---

## 3. Pattern
Temporal / Point-in-Time Query / UNION

---

## 4. Problem Statement
We need to find the prices of all products on `2019-08-16`. 
Assume the price of all products before any change is `10`.

---

## 5. Tables

Table: Products

| Column      | Type |
| ----------- | ---- |
| product_id  | INT  |
| new_price   | INT  |
| change_date | DATE |

* `(product_id, change_date)` is the primary key.
* Each row indicates that the price of some product was changed to a new price at some date.

---

## 6. Sample Input

Products table:

| product_id | new_price | change_date |
| ---------- | --------- | ----------- |
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |

---

## 7. Expected Output

| product_id | price |
| ---------- | ----- |
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |

*(Product 1's price on 08-16 was updated on 08-16 to 35).*
*(Product 2's price on 08-16 was its last update on 08-14, which was 50).*
*(Product 3 didn't receive its first price change until 08-18, so on 08-16 its price was the default 10).*

---

## 8. Understanding the Question
What information is being asked? The price of every product *exactly on* a specific date.
What conditions matter? 
1. If a product had a price change on or before `2019-08-16`, we want the most recent change.
2. If a product's *first* price change happened *after* `2019-08-16`, its price was `10`.
What should be returned? `product_id`, `price`.

---

## 9. Thinking Process
1. This is a point-in-time lookup. I have two distinct groups of products: those that changed before the deadline, and those that only changed after. I should use `UNION` to handle them separately.
2. **Group 1 (Changed before/on deadline):**
   * I need to filter the table to `change_date <= '2019-08-16'`.
   * For those rows, I need the *maximum* date per product.
   * `SELECT product_id, MAX(change_date) FROM Products WHERE change_date <= '2019-08-16' GROUP BY product_id`.
   * To get the actual price on that date, I'll use the Tuple `IN` pattern against the main table.
3. **Group 2 (Never changed before deadline):**
   * Which products are these? They are products whose absolute *minimum* `change_date` is strictly greater than `2019-08-16`.
   * I can find them with: `SELECT product_id, 10 AS price FROM Products GROUP BY product_id HAVING MIN(change_date) > '2019-08-16'`.
4. Combine Group 1 and Group 2 using `UNION`.

---

## 10. Approach 1 (Optimal)
Tuple Subquery and UNION

Solve for the products with valid historical data using a max-date tuple match, and solve for the default-price products using a minimum-date grouping. Merge them together.

---

## 11. SQL Solution

```sql
-- Find prices that were updated on or before the target date
SELECT 
    product_id, 
    new_price AS price
FROM 
    Products
WHERE 
    (product_id, change_date) IN (
        SELECT 
            product_id, 
            MAX(change_date)
        FROM 
            Products
        WHERE 
            change_date <= '2019-08-16'
        GROUP BY 
            product_id
    )

UNION

-- Find products whose very first update happened after the target date
SELECT 
    product_id, 
    10 AS price
FROM 
    Products
GROUP BY 
    product_id
HAVING 
    MIN(change_date) > '2019-08-16';
```

---

## 12. Step-by-Step Dry Run
1. **Query 1 (Before/On Target):**
   * Filter table `<= '08-16'`. Surviving rows: Prod 1 (14th, 15th, 16th), Prod 2 (14th).
   * `GROUP BY` and `MAX()`: Prod 1 max is 16th. Prod 2 max is 14th.
   * Tuple match against main table: Prod 1 on 16th returns `35`. Prod 2 on 14th returns `50`.
   * Query 1 result: `[(1, 35), (2, 50)]`.
2. **Query 2 (After Target):**
   * `GROUP BY` and `MIN()`: Prod 1 min is 14th. Prod 2 min is 14th. Prod 3 min is 18th.
   * `HAVING MIN(...) > '08-16'`: Only Prod 3 (18th > 16th) survives.
   * Query 2 result: `[(3, 10)]`.
3. **UNION:**
   * Merges into: `[(1, 35), (2, 50), (3, 10)]`.

---

## 13. SQL Execution Order
1. **Query 1 Subquery:** Executes and finds the maximum valid date for each product.
2. **Query 1 Outer:** Pulls the prices matching those dates.
3. **Query 2:** Groups the whole table to find products that had no valid dates.
4. **UNION:** Appends Query 2 to Query 1.

---

## 14. Query Breakdown
* **WHERE change_date <= '2019-08-16':** Essential step. You must discard future changes *before* taking the `MAX()`.
* **HAVING MIN(change_date) > '2019-08-16':** An elegant way to say "This product exists in the table, but all of its entries are in the future".
* **10 AS price:** Hardcoding the default value requested by the prompt.

---

## 15. Why This Solution Works
Point-in-time queries on slowly changing dimensions (SCDs) are notoriously tricky. Using `UNION` breaks the mental gymnastics into two highly logical, easy-to-read blocks.

---

## 16. Alternative Solution
Using Window Functions (`FIRST_VALUE`)

```sql
SELECT DISTINCT product_id, 
    FIRST_VALUE(new_price) OVER(
        PARTITION BY product_id 
        ORDER BY change_date DESC
    ) AS price
FROM Products
WHERE change_date <= '2019-08-16'

UNION

SELECT product_id, 10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16';
```
* **Advantages:** Avoids the correlated `IN` tuple match, which can sometimes be slow. `FIRST_VALUE` grabs the top item of an ordered window.
* **Disadvantages:** Still requires the `UNION` block to catch products that have no history before the date.

---

## 17. Time Complexity
**O(N)**. With indexes on `product_id` and `change_date`, both the `IN` subquery and the `HAVING` aggregation run blazingly fast in a single pass.

---

## 18. Common Mistakes
* **Taking `MAX` then filtering:** 
  ```sql
  SELECT product_id, MAX(change_date) FROM Products GROUP BY product_id HAVING MAX(change_date) <= '08-16'
  ```
  *This is WRONG!* If Product 1 had a change on 08-16, and another on 08-17, the `MAX` is 08-17. It would fail the `HAVING` clause, and Product 1 would vanish from your results entirely. You must filter `< 08-16` *before* grouping!

---

## 19. Edge Cases
* **Price changes exactly on target date:** Handled correctly because of `<=`.
* **Product receives multiple price changes in the future but none before:** The `HAVING MIN() >` safely collapses all future rows into a single `10` output.

---

## 20. Interview Tips
* State clearly: "When calculating Point-In-Time values, you always filter out future rows *before* taking the maximum historical date." This is a huge trap for junior developers.

---

## 21. Similar LeetCode Problems
* 1098. Unpopular Books
* 1321. Restaurant Growth

---

## 22. Key Takeaways
* **Point-in-Time Pattern:** `WHERE date <= Target GROUP BY ID SELECT MAX(date)`.
* Default/Fallback scenarios (e.g., "Assume it was X before Y") are best handled with a separate `HAVING MIN(date) > Target` query joined via `UNION`.

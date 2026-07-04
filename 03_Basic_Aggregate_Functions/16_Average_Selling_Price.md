# Problem 16 – Average Selling Price

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* LEFT JOIN
* GROUP BY
* Aggregate Functions (`SUM`)
* IFNULL() / COALESCE()
* ROUND()
* BETWEEN (Date ranges)

---

## 3. Pattern
Join with Date Range / Weighted Average Calculation

---

## 4. Problem Statement
We need to find the average selling price for each product. The `average_price` should be rounded to 2 decimal places. 
The average selling price is calculated as: `(Total Revenue of Product) / (Total Units Sold of Product)`. 
If a product has no sales, its average price should be `0`.

---

## 5. Tables

Table: Prices

| Column     | Type |
| ---------- | ---- |
| product_id | INT  |
| start_date | DATE |
| end_date   | DATE |
| price      | INT  |

* `(product_id, start_date, end_date)` is the primary key.
* This table records the price of a product during a specific time period.

Table: UnitsSold

| Column        | Type |
| ------------- | ---- |
| product_id    | INT  |
| purchase_date | DATE |
| units         | INT  |

* This table has no primary key, it can have duplicates.
* It records the date and amount of units sold for a product.

---

## 6. Sample Input

Prices table:

| product_id | start_date | end_date   | price |
| ---------- | ---------- | ---------- | ----- |
| 1          | 2019-02-17 | 2019-02-28 | 5     |
| 1          | 2019-03-01 | 2019-03-22 | 20    |
| 2          | 2019-02-01 | 2019-02-20 | 15    |
| 2          | 2019-02-21 | 2019-03-31 | 30    |
| 3          | 2019-02-01 | 2019-02-28 | 10    |

UnitsSold table:

| product_id | purchase_date | units |
| ---------- | ------------- | ----- |
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |

---

## 7. Expected Output

| product_id | average_price |
| ---------- | ------------- |
| 1          | 6.96          |
| 2          | 16.96         |
| 3          | 0.00          |

*(Product 1: (100 * 5 + 15 * 20) / (100 + 15) = 800 / 115 = 6.96)*
*(Product 3: No sales, so 0.00)*

---

## 8. Understanding the Question
What information is being asked? The `average_price` per `product_id`.
What columns are important? `price`, `units`, `start_date`, `end_date`, `purchase_date`.
What conditions matter? We must link a sale to the *correct price* based on the date the sale happened. We also must include products with zero sales.
What should be returned? `product_id`, `average_price`.

---

## 9. Thinking Process
1. We need every product to appear in the output, even if they have no sales (like Product 3). This means the `Prices` table is our base, and we must `LEFT JOIN` the `UnitsSold` table.
2. How do we link a sale to a price? They must share the same `product_id`.
3. But `product_id` isn't enough! Product 1 has two different prices depending on the date. The sale's `purchase_date` must fall *between* the price's `start_date` and `end_date`.
4. Therefore, our join condition is: `ON p.product_id = u.product_id AND u.purchase_date BETWEEN p.start_date AND p.end_date`.
5. Now we have a giant table where each sale is paired with its correct price. We group by `product_id`.
6. To calculate the average price: `SUM(price * units) / SUM(units)`.
7. What if there are no sales? `SUM(units)` will be NULL, causing division by zero or NULL results. The problem says this should be `0`. We wrap our calculation in `IFNULL(..., 0)`.
8. Round the final result to 2 decimals.

---

## 10. Approach 1 (Optimal)
LEFT JOIN with BETWEEN, followed by Aggregation

Join the sales to the prices based on ID and Date overlap. Group by product, calculate the weighted average, and handle missing sales with IFNULL.

---

## 11. SQL Solution

```sql
-- Calculate weighted average selling price per product
SELECT 
    p.product_id, 
    IFNULL(ROUND(SUM(p.price * u.units) / SUM(u.units), 2), 0) AS average_price
FROM 
    Prices p
LEFT JOIN 
    UnitsSold u 
    ON p.product_id = u.product_id 
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY 
    p.product_id;
```

---

## 12. Step-by-Step Dry Run
1. **LEFT JOIN Evaluation:**
   * Price Row: Product 1 (Feb 17 - Feb 28, $5). Match with Sale: Feb 25 (100 units).
   * Price Row: Product 1 (Mar 1 - Mar 22, $20). Match with Sale: Mar 1 (15 units).
   * Price Row: Product 3 (Feb 1 - Feb 28, $10). No matching sale. `u.units` becomes NULL.
2. **GROUP BY product_id:**
   * Product 1: Two valid rows. `SUM(5 * 100 + 20 * 15) = 800`. `SUM(100 + 15) = 115`. 
   * Product 3: One row. `SUM(10 * NULL) = NULL`. `SUM(NULL) = NULL`.
3. **Calculation & IFNULL:**
   * Product 1: `800 / 115 = 6.9565...` -> `ROUND(..., 2)` = `6.96`.
   * Product 3: `NULL / NULL = NULL`. `IFNULL(NULL, 0)` = `0`.

---

## 13. SQL Execution Order
1. **FROM Prices p:** Base table of all possible pricing periods.
2. **LEFT JOIN UnitsSold u:** Attach sales data where the product matches AND the purchase date falls within the pricing window.
3. **GROUP BY p.product_id:** Combine all periods/sales into one bucket per product.
4. **SELECT:** Execute the mathematical division, rounding, and null-checking for each bucket.

---

## 14. Query Breakdown
* **BETWEEN ... AND ...:** A clean shorthand for `purchase_date >= start_date AND purchase_date <= end_date`. Perfect for date ranges.
* **SUM(p.price * u.units):** Calculates the total revenue. Multiplication happens row-by-row before the `SUM` aggregates it.
* **IFNULL(..., 0):** This is applied to the *result* of the `ROUND(...)` to catch the `NULL` generated by Product 3. 

*(Note: In MySQL, `IFNULL(ROUND(SUM(p.price * u.units) / SUM(u.units), 2), 0)` is required over `ROUND(IFNULL(...), 2)` to strictly yield `0` instead of a potentially unformatted number, though both often pass.)*

---

## 15. Why This Solution Works
It correctly models a "Weighted Average". You cannot just `AVG(price)` because selling 1000 units at $5 matters much more than selling 1 unit at $20. By calculating `Total Revenue / Total Units`, we get the true average value of a single unit sold. The `LEFT JOIN` guarantees no product is left behind.

---

## 16. Alternative Solution
Using an INNER JOIN and a UNION (Not recommended, but educational)

```sql
SELECT product_id, ROUND(SUM(price * units) / SUM(units), 2) AS average_price
FROM Prices JOIN UnitsSold USING (product_id)
WHERE purchase_date BETWEEN start_date AND end_date
GROUP BY product_id

UNION

SELECT product_id, 0 AS average_price
FROM Prices
WHERE product_id NOT IN (SELECT product_id FROM UnitsSold);
```
* **Advantages:** Avoids `LEFT JOIN` and `IFNULL` complexity.
* **Disadvantages:** Very verbose. Requires hitting the `Prices` table twice. `LEFT JOIN` is much more elegant.

---

## 17. Time Complexity
**O(P * U)** in the worst case without indexes, but realistically **O(P + U)** with proper indexing on `product_id` and dates. The date comparison makes the join slightly heavier than a simple ID match.

---

## 18. Common Mistakes
* **Using `AVG(price)`:** Mathematically incorrect. You must calculate a weighted average.
* **Forgetting `LEFT JOIN`:** An `INNER JOIN` will drop Product 3 entirely, failing the test case.
* **Putting the date filter in the `WHERE` clause:** 
  `LEFT JOIN UnitsSold u ON p.product_id = u.product_id WHERE u.purchase_date BETWEEN...`
  If you do this, Product 3 (which has `u.purchase_date = NULL`) will fail the `WHERE` clause and be dropped! **Rule of thumb: In a LEFT JOIN, conditions on the right table must go in the `ON` clause, not the `WHERE` clause.**

---

## 19. Edge Cases
* **Products with prices but zero sales:** Handled by `LEFT JOIN` and `IFNULL`.
* **Sales exactly on start/end dates:** Handled correctly because `BETWEEN` is inclusive.

---

## 20. Interview Tips
* This question brilliantly tests if you know the difference between putting a condition in the `ON` clause versus the `WHERE` clause during a `LEFT JOIN`. 
* It also tests if you understand basic business math (weighted averages).

---

## 21. Similar LeetCode Problems
* 1193. Monthly Transactions I
* 1633. Percentage of Users Attended a Contest

---

## 22. Key Takeaways
* **Weighted Averages** are calculated as `SUM(weight * value) / SUM(weight)`.
* In a `LEFT JOIN`, conditions filtering the right-hand table MUST go in the `ON` clause. If you put them in the `WHERE` clause, you effectively turn your `LEFT JOIN` into an `INNER JOIN`.
* Use `BETWEEN` for readable date range checking.

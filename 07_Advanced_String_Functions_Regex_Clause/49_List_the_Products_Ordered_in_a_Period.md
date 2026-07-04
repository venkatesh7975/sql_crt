# Problem 49 – List the Products Ordered in a Period

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* INNER JOIN
* Date Filtering (`LIKE` / `BETWEEN` / `MONTH()`)
* GROUP BY and `HAVING`
* Aggregate Functions (`SUM`)

---

## 3. Pattern
Join with Aggregation and Date Filtering

---

## 4. Problem Statement
Write a SQL query to get the names of products that have at least **100 units** ordered in **February 2020** and their amount.
Return the result table in any order.

---

## 5. Tables

Table: Products

| Column           | Type    |
| ---------------- | ------- |
| product_id       | INT     |
| product_name     | VARCHAR |
| product_category | VARCHAR |

* `product_id` is the primary key.

Table: Orders

| Column       | Type |
| ------------ | ---- |
| product_id   | INT  |
| order_date   | DATE |
| unit         | INT  |

* There is no primary key for this table. It may have duplicate rows.
* `product_id` is a foreign key to the Products table.

---

## 6. Sample Input

Products table:

| product_id | product_name          | product_category |
| ---------- | --------------------- | ---------------- |
| 1          | Leetcode Solutions    | Book             |
| 2          | Jewels of Stringology | Book             |
| 3          | HP                    | Laptop           |
| 4          | Lenovo                | Laptop           |
| 5          | Leetcode Kit          | T-shirt          |

Orders table:

| product_id | order_date | unit |
| ---------- | ---------- | ---- |
| 1          | 2020-02-05 | 60   |
| 1          | 2020-02-10 | 70   |
| 2          | 2020-01-18 | 30   |
| 2          | 2020-02-11 | 80   |
| 3          | 2020-02-17 | 2    |
| 3          | 2020-02-24 | 3    |
| 4          | 2020-03-01 | 20   |
| 4          | 2020-03-04 | 30   |
| 4          | 2020-03-04 | 60   |
| 5          | 2020-02-25 | 50   |
| 5          | 2020-02-27 | 50   |
| 5          | 2020-03-01 | 50   |

---

## 7. Expected Output

| product_name       | unit |
| ------------------ | ---- |
| Leetcode Solutions | 130  |
| Leetcode Kit       | 100  |

*(Product 1 (Solutions) in Feb: 60 + 70 = 130. 130 >= 100. -> Pass).*
*(Product 2 (Jewels) in Feb: 80. 80 is not >= 100. -> Fail. (The 30 from Jan is ignored)).*
*(Product 3 (HP) in Feb: 2 + 3 = 5. -> Fail).*
*(Product 4 (Lenovo) in Feb: 0. -> Fail).*
*(Product 5 (Kit) in Feb: 50 + 50 = 100. 100 >= 100. -> Pass. (The 50 from Mar is ignored)).*

---

## 8. Understanding the Question
What information is being asked? Product names and their total units sold.
What columns are important? `product_name`, `unit`, `order_date`.
What conditions matter? 
1. The order date MUST be in February 2020.
2. The total sum of units for that product in that month MUST be >= 100.
What should be returned? `product_name`, `unit`.

---

## 9. Thinking Process
1. I need information from both tables (Names from `Products`, Units/Dates from `Orders`). So, I must `JOIN` them on `product_id`.
2. I only care about orders placed in February 2020. I should filter these out immediately using `WHERE order_date LIKE '2020-02-%'`.
3. I need to calculate the total units per product. So, I must `GROUP BY product_id` (and `product_name`).
4. The aggregation is `SUM(unit) AS unit`.
5. I only want to keep the groups where the total sum is at least 100. Filtering *after* aggregation requires `HAVING`.
6. Condition: `HAVING SUM(unit) >= 100`.

---

## 10. Approach 1 (Optimal)
JOIN, GROUP BY, and HAVING

Filter the raw orders for the target month first, group the surviving orders by product, sum the units, and use a `HAVING` clause to enforce the 100-unit threshold.

---

## 11. SQL Solution

```sql
-- Find products that sold 100+ units in Feb 2020
SELECT 
    p.product_name, 
    SUM(o.unit) AS unit
FROM 
    Products p
JOIN 
    Orders o ON p.product_id = o.product_id
WHERE 
    o.order_date LIKE '2020-02-%'
GROUP BY 
    p.product_id, 
    p.product_name
HAVING 
    SUM(o.unit) >= 100;
```

---

## 12. Step-by-Step Dry Run
1. **WHERE Filtering:**
   * Removes `(2, '2020-01-18', 30)`
   * Removes `(4, '2020-03-01', 20)`
   * Removes `(5, '2020-03-01', 50)`
   * ...keeps only the Feb 2020 rows.
2. **GROUP BY product_id:**
   * Product 1: units = `[60, 70]`
   * Product 2: units = `[80]`
   * Product 3: units = `[2, 3]`
   * Product 5: units = `[50, 50]`
3. **SUM(unit):**
   * P1 = 130
   * P2 = 80
   * P3 = 5
   * P5 = 100
4. **HAVING SUM >= 100:**
   * P1 (130) -> Keeps
   * P2 (80) -> Drops
   * P3 (5) -> Drops
   * P5 (100) -> Keeps

---

## 13. SQL Execution Order
1. **FROM & JOIN:** Combines the two tables.
2. **WHERE:** Discards any orders that didn't happen in Feb 2020.
3. **GROUP BY:** Buckets the remaining valid orders by product.
4. **HAVING:** Calculates the SUM for each bucket and discards buckets < 100.
5. **SELECT:** Formats the final output.

---

## 14. Query Breakdown
* **LIKE '2020-02-%':** A fast, readable way to filter for a specific year-month in MySQL.
* **HAVING vs WHERE:** You *must* filter dates in the `WHERE` clause (because dates happen at the row level), and you *must* filter the 100-unit limit in the `HAVING` clause (because the limit applies to the aggregated total, not the individual row).

---

## 15. Why This Solution Works
It follows the standard SQL pipeline: Filter Raw Data (`WHERE`) -> Aggregate (`GROUP BY`) -> Filter Aggregated Data (`HAVING`). 

---

## 16. Alternative Solution
Using Date Functions

```sql
SELECT 
    p.product_name, 
    SUM(o.unit) AS unit
FROM Products p JOIN Orders o USING(product_id)
WHERE YEAR(o.order_date) = 2020 AND MONTH(o.order_date) = 2
GROUP BY p.product_id
HAVING SUM(o.unit) >= 100;
```
* **Advantages:** Explicitly parses the date. `USING(product_id)` is a slightly shorter syntax for `ON p.id = o.id` when the column names match perfectly.
* **Disadvantages:** Applying functions like `YEAR()` and `MONTH()` to a column in a `WHERE` clause prevents the database from using an index on `order_date` (SARGable violation). `LIKE '2020-02-%'` or `BETWEEN '2020-02-01' AND '2020-02-29'` are index-friendly.

---

## 17. Time Complexity
**O(N)**. The database applies the `WHERE` filter in a single pass, joins the remaining rows (Hash Join or Nested Loop), and calculates the groups in O(N).

---

## 18. Common Mistakes
* **Filtering dates in HAVING:** 
  ```sql
  GROUP BY p.id HAVING order_date LIKE ...
  ```
  *Error!* Once you `GROUP BY product_id`, the individual `order_date` values collapse into the bucket and vanish. You cannot filter by them anymore.
* **Filtering sums in WHERE:**
  ```sql
  WHERE SUM(unit) >= 100
  ```
  *Error!* `WHERE` evaluates row-by-row before any aggregation has happened. It does not know what `SUM()` is yet.

---

## 19. Edge Cases
* **Product has exactly 100 units:** Included correctly due to `>=`.
* **Product has huge orders but in the wrong month:** The `WHERE` clause correctly intercepts and destroys them before they can bloat the sum.

---

## 20. Interview Tips
* Be prepared to explain SARGability. Why is `order_date BETWEEN '2020-02-01' AND '2020-02-29'` better than `MONTH(order_date) = 2`? Answer: "Because wrapping a column in a function blinds the database optimizer, forcing a Full Table Scan even if an index exists."

---

## 21. Similar LeetCode Problems
* 1148. Article Views I
* 1581. Customer Who Visited but Did Not Make Any Transactions

---

## 22. Key Takeaways
* Filter raw row-level data in `WHERE` (e.g., Dates, IDs).
* Filter bucket-level aggregated data in `HAVING` (e.g., SUMs, COUNTs).
* Use `LIKE 'YYYY-MM-%'` for clean, fast month filtering.

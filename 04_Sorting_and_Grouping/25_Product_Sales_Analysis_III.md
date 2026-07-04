# Problem 25 – Product Sales Analysis III

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* Subquery with `IN` (Tuple matching)
* GROUP BY and `MIN()`

---

## 3. Pattern
First-Event Filtering

---

## 4. Problem Statement
We need to select the `product_id`, `year`, `quantity`, and `price` for the **first year** of every product sold.

---

## 5. Tables

Table: Sales

| Column     | Type |
| ---------- | ---- |
| sale_id    | INT  |
| product_id | INT  |
| year       | INT  |
| quantity   | INT  |
| price      | INT  |

* `(sale_id, year)` is the primary key.
* `product_id` is a foreign key to the Product table.

Table: Product

| Column       | Type    |
| ------------ | ------- |
| product_id   | INT     |
| product_name | VARCHAR |

* `product_id` is the primary key.

---

## 6. Sample Input

Sales table:

| sale_id | product_id | year | quantity | price |
| ------- | ---------- | ---- | -------- | ----- |
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |

Product table:

| product_id | product_name |
| ---------- | ------------ |
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |

---

## 7. Expected Output

| product_id | first_year | quantity | price |
| ---------- | ---------- | -------- | ----- |
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |

*(Product 100 was sold in 2008 and 2009. The first year is 2008. We return the row for 2008.)*
*(Product 200 was sold only in 2011. The first year is 2011. We return the row for 2011.)*

---

## 8. Understanding the Question
What information is being asked? The complete sales details (quantity, price) but *only* for the first year a product was introduced.
What columns are important? `product_id`, `year`, `quantity`, `price` (from the Sales table). We actually don't even need the Product table!
What conditions matter? We must filter the `Sales` table down to the minimum `year` per `product_id`.
What should be returned? `product_id`, `first_year` (alias of year), `quantity`, `price`.

---

## 9. Thinking Process
1. I need to find the "first year" for each product. This is a classic `GROUP BY` scenario:
   `SELECT product_id, MIN(year) FROM Sales GROUP BY product_id`.
2. This gives me the exact pairs of `(product_id, year)` that represent the initial launch of every product.
3. However, I can't just add `quantity` and `price` to that `GROUP BY` query. If I group by product, how does SQL know *which* quantity to pick if there were multiple sales? 
4. The solution is to use the `GROUP BY` as a subquery. I will query the `Sales` table and filter it to only include rows where the `(product_id, year)` match the subquery results.
5. This is the exact same Tuple `IN` pattern we used in Problem 21 (Immediate Food Delivery II).
6. Alias the `year` column as `first_year` in the main query.

---

## 10. Approach 1 (Optimal)
Tuple Subquery Filtering

Use a subquery to find the minimum year per product, and then use a tuple `WHERE IN` clause to retrieve the full row details from the main table.

---

## 11. SQL Solution

```sql
-- Retrieve the full sales record for the first year of each product
SELECT 
    product_id, 
    year AS first_year, 
    quantity, 
    price
FROM 
    Sales
WHERE 
    (product_id, year) IN (
        SELECT 
            product_id, 
            MIN(year)
        FROM 
            Sales
        GROUP BY 
            product_id
    );
```

---

## 12. Step-by-Step Dry Run
1. **Subquery Execution:**
   * Group `100`: Years are 2008, 2009. Minimum is **2008**.
   * Group `200`: Year is 2011. Minimum is **2011**.
   * Subquery results: `[(100, 2008), (200, 2011)]`.
2. **Main Query Filter (WHERE IN):**
   * Row 1 (100, 2008): Match! **Keep**.
   * Row 2 (100, 2009): No match. **Drop**.
   * Row 3 (200, 2011): Match! **Keep**.
3. **Select and Alias:**
   * Output Row 1 details: `100`, `2008`, `10`, `5000`.
   * Output Row 3 details: `200`, `2011`, `15`, `9000`.

---

## 13. SQL Execution Order
1. **Subquery:** Finds the lowest year for every product ID.
2. **FROM Sales:** Looks at the main table.
3. **WHERE (...):** Discards any sales that didn't happen in a product's launch year.
4. **SELECT:** Picks the required columns and renames `year`.

---

## 14. Query Breakdown
* **(product_id, year) IN (...):** This tuple comparison guarantees we only fetch the specific year for the specific product. If we just did `WHERE year IN (SELECT MIN(year)...)`, we might accidentally include Product A's year 2 sales if Product B launched in year 2!
* **MIN(year):** Finds the earliest integer year.

---

## 15. Why This Solution Works
By separating the "find the first date" logic (subquery) from the "fetch the row data" logic (main query), we avoid all the illegal grouping errors that occur when you try to `SELECT` non-aggregated columns next to a `GROUP BY`.

---

## 16. Alternative Solution
Using Window Functions (Advanced)

```sql
WITH RankedSales AS (
    SELECT 
        product_id, 
        year, 
        quantity, 
        price,
        RANK() OVER(PARTITION BY product_id ORDER BY year ASC) as rnk
    FROM Sales
)
SELECT 
    product_id, 
    year AS first_year, 
    quantity, 
    price
FROM RankedSales
WHERE rnk = 1;
```
* **Advantages:** Very fast and clean. It avoids hitting the `Sales` table twice. `RANK()` is used instead of `ROW_NUMBER()` just in case there are multiple sales records for the same product in its first year (the problem schema allows this).
* **Disadvantages:** Uses syntax standard in analytical roles, but slightly more complex for beginners.

---

## 17. Time Complexity
**O(N)** or **O(N log N)** depending on indexing. An index on `(product_id, year)` makes the subquery practically instantaneous.

---

## 18. Common Mistakes
* **Using `GROUP BY` in the main query:** 
  ```sql
  SELECT product_id, MIN(year), quantity, price FROM Sales GROUP BY product_id
  ```
  *This is illegal in standard SQL (like PostgreSQL) because `quantity` is not grouped or aggregated. In MySQL, it might run due to `ONLY_FULL_GROUP_BY` being disabled, but it will return a random row's quantity, which is completely wrong!*

---

## 19. Edge Cases
* **Multiple sales in the first year:** The problem description implies `(sale_id, year)` is the PK, meaning a product could have multiple sales in 2008. The tuple `IN` subquery cleanly returns *all* of those rows, which perfectly satisfies the prompt.

---

## 20. Interview Tips
* This is the exact same pattern as finding the highest-paid employee per department. You cannot `SELECT` the employee name in a `GROUP BY department` query. You must use the `GROUP BY` as a subquery, or use Window Functions. Master this pattern!

---

## 21. Similar LeetCode Problems
* 1068. Product Sales Analysis I
* 1174. Immediate Food Delivery II

---

## 22. Key Takeaways
* To fetch full row details based on an aggregate condition (like `MIN` or `MAX`), use a **Tuple IN Subquery** or a **Window Function**. Do not try to jam everything into one `GROUP BY` query.

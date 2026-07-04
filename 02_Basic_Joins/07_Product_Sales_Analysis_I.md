# Problem 07 – Product Sales Analysis I

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* INNER JOIN (or JOIN)
* ON

---

## 3. Pattern
Join

---

## 4. Problem Statement
We need to report the `product_name`, `year`, and `price` for every single sale in the `Sales` table. 

---

## 5. Tables

Table: Sales

| Column      | Type  |
| ----------- | ----- |
| sale_id     | INT   |
| product_id  | INT   |
| year        | INT   |
| quantity    | INT   |
| price       | INT   |

* `(sale_id, year)` is the primary key for this table.
* `product_id` is a foreign key to the `Product` table.
* Each row shows a sale of a specific product in a specific year.

Table: Product

| Column       | Type    |
| ------------ | ------- |
| product_id   | INT     |
| product_name | VARCHAR |

* `product_id` is the primary key.
* Each row indicates the product name for a specific product ID.

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

| product_name | year | price |
| ------------ | ---- | ----- |
| Nokia        | 2008 | 5000  |
| Nokia        | 2009 | 5000  |
| Apple        | 2011 | 9000  |

*(Order does not matter)*

---

## 8. Understanding the Question
What information is being asked? The product name, the year of the sale, and the price.
What columns are important? `product_name` (from Product), `year`, and `price` (from Sales).
What conditions matter? We must output this for *each* sale in the `Sales` table.
What should be returned? `product_name`, `year`, `price`.

---

## 9. Thinking Process
1. I need to report details for every sale. The `Sales` table is my primary driver.
2. The `Sales` table has the `year` and `price`, but it only has the `product_id`. I need the actual `product_name`.
3. To get the `product_name`, I must join the `Sales` table with the `Product` table.
4. The common column linking these two tables is `product_id`.
5. Since every sale is guaranteed to have a valid `product_id` (it's a foreign key), an `INNER JOIN` is perfectly appropriate here. (A `LEFT JOIN` starting from `Sales` would also yield the same correct result).

---

## 10. Approach 1 (Optimal)
Using `INNER JOIN`

We will join the `Sales` table and the `Product` table based on the matching `product_id`.

---

## 11. SQL Solution

```sql
-- Retrieve the product name, year, and price for every sale
SELECT 
    p.product_name, 
    s.year, 
    s.price
FROM 
    Sales s
JOIN 
    Product p 
    ON s.product_id = p.product_id;
```

*(Note: `JOIN` is shorthand for `INNER JOIN` in MySQL)*

---

## 12. Step-by-Step Dry Run
1. Look at `Sales` Row 1: `product_id = 100`, `year = 2008`, `price = 5000`. Match `100` in `Product` table -> Found "Nokia". Output: (Nokia, 2008, 5000).
2. Look at `Sales` Row 2: `product_id = 100`, `year = 2009`, `price = 5000`. Match `100` in `Product` table -> Found "Nokia". Output: (Nokia, 2009, 5000).
3. Look at `Sales` Row 3: `product_id = 200`, `year = 2011`, `price = 9000`. Match `200` in `Product` table -> Found "Apple". Output: (Apple, 2011, 9000).
4. Product `300` (Samsung) has no sales, so it is naturally excluded by the `INNER JOIN` (which requires a match in both tables).

---

## 13. SQL Execution Order
1. **FROM Sales s:** MySQL identifies the first table.
2. **JOIN Product p ON ...:** MySQL identifies the second table and matches the rows where `product_id` is identical in both.
3. **SELECT ...:** MySQL extracts only the three requested columns (`product_name`, `year`, `price`) from the joined virtual table.

---

## 14. Query Breakdown
* **JOIN:** Filters and merges rows from two tables, but *only* keeps rows that have matching values in both tables.
* **ON s.product_id = p.product_id:** This dictates the rules of the match. It links the foreign key of the sales table to the primary key of the product table.
* **Aliases (s, p):** We use aliases to easily reference which table a column belongs to. It is best practice to always prefix column names with their alias in multi-table queries.

---

## 15. Why This Solution Works
Because the prompt asks for data "for each sale_id in the Sales table", the `Sales` table is our source of truth. Since every sale has a valid product, an `INNER JOIN` seamlessly attaches the product string name to the numerical product ID without losing any sales records.

---

## 16. Alternative Solution
Using a `LEFT JOIN`

```sql
SELECT 
    p.product_name, 
    s.year, 
    s.price
FROM 
    Sales s
LEFT JOIN 
    Product p 
    ON s.product_id = p.product_id;
```
* **Advantages:** It is safer in messy databases. If there is a corrupted `Sales` record pointing to a non-existent `product_id`, a `LEFT JOIN` will still show the sale (with a NULL product_name), alerting you to the data anomaly. An `INNER JOIN` would silently hide the bad sale.
* **Disadvantages:** Slightly slower in some older engines, but identical in modern MySQL if foreign keys are properly enforced.

---

## 17. Time Complexity
**O(N)** where N is the number of rows in the `Sales` table. Because `product_id` is the primary key of the `Product` table, the join lookup takes O(1) time per sale.

---

## 18. Common Mistakes
* **Using a RIGHT JOIN from Sales:** `FROM Sales s RIGHT JOIN Product p`. This is wrong because it would include "Samsung", which has NO sales, resulting in a row with `(Samsung, null, null)`. The problem strictly asks for data *for each sale*.
* **Ambiguous column names:** If both tables had a column named `year`, writing `SELECT year` would cause an error. You must write `s.year`.

---

## 19. Edge Cases
* **Multiple sales of same product:** Handled correctly (e.g., Nokia has two sales).
* **Products with no sales:** Handled correctly (ignored by INNER JOIN, which is what we want).
* **Missing product table data:** If a sale references a deleted product, INNER JOIN drops the sale. (In strict SQL, foreign key constraints prevent this from happening).

---

## 20. Interview Tips
* In an interview, mention that `INNER JOIN` is fine here because `product_id` is a foreign key, but note that `LEFT JOIN` from `Sales` is safer if data integrity isn't guaranteed.
* Always use table aliases. It shows you write robust, production-ready code.

---

## 21. Similar LeetCode Problems
* 1378. Replace Employee ID With The Unique Identifier
* 175. Combine Two Tables

---

## 22. Key Takeaways
* `JOIN` (or `INNER JOIN`) returns only the intersection where matches are found in *both* tables.
* Use table aliases (`s`, `p`) to keep queries short and prevent ambiguous column errors.

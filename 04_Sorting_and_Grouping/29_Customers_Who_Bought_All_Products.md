# Problem 29 – Customers Who Bought All Products

---

## 1. Difficulty
Medium

---

## 2. SQL Concepts Tested
* SELECT
* GROUP BY
* HAVING
* Aggregate Functions (`COUNT`, `DISTINCT`)
* Subqueries (Scalar)

---

## 3. Pattern
Grouping / Relational Division

---

## 4. Problem Statement
We need to report the customer IDs from the `Customer` table that bought **all** the products in the `Product` table.

---

## 5. Tables

Table: Customer

| Column      | Type |
| ----------- | ---- |
| customer_id | INT  |
| product_key | INT  |

* This table may contain duplicates. `customer_id` is not NULL.
* `product_key` is a foreign key to the Product table.

Table: Product

| Column      | Type |
| ----------- | ---- |
| product_key | INT  |

* `product_key` is the primary key.

---

## 6. Sample Input

Customer table:

| customer_id | product_key |
| ----------- | ----------- |
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |

Product table:

| product_key |
| ----------- |
| 5           |
| 6           |

---

## 7. Expected Output

| customer_id |
| ----------- |
| 1           |
| 3           |

*(There are exactly two products: 5 and 6. Customer 1 bought both 5 and 6. Customer 2 bought only 6. Customer 3 bought both 5 and 6. Customers 1 and 3 bought all products).*

---

## 8. Understanding the Question
What information is being asked? The IDs of specific customers.
What columns are important? `customer_id` and `product_key`.
What conditions matter? The customer must have purchased a number of *unique* products equal to the *total* number of products available in the catalogue.
What should be returned? `customer_id`.

---

## 9. Thinking Process
1. I need to evaluate customers individually. This means `GROUP BY customer_id`.
2. How many unique products did a customer buy? `COUNT(DISTINCT product_key)`.
   * Note: The prompt explicitly says the Customer table *may contain duplicates*. A customer buying product 5 twice still only counts as 1 unique product. Therefore, `DISTINCT` is absolutely required.
3. What is the target number they need to reach? It's the total number of products in the Product table. How do I get that? `SELECT COUNT(*) FROM Product`.
4. I need to filter my grouped customers against this target number. To filter groups based on aggregates, I use `HAVING`.
5. Therefore, the condition is: `HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product)`.

---

## 10. Approach 1 (Optimal)
GROUP BY with Scalar Subquery in HAVING

Count the unique products purchased by each customer, and compare it against a global count of all products using an uncorrelated scalar subquery.

---

## 11. SQL Solution

```sql
-- Find customers who purchased every single product in the catalog
SELECT 
    customer_id
FROM 
    Customer
GROUP BY 
    customer_id
HAVING 
    COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);
```

---

## 12. Step-by-Step Dry Run
1. **Scalar Subquery execution:**
   * `(SELECT COUNT(*) FROM Product)` evaluates to `2`.
2. **GROUP BY customer_id:**
   * Group `1`: Product keys `[5, 6]`
   * Group `2`: Product keys `[6]`
   * Group `3`: Product keys `[5, 6]`
3. **HAVING Condition Evaluation:**
   * Group `1`: `COUNT(DISTINCT 5, 6)` = 2. Is `2 = 2`? **True.** (Keep 1)
   * Group `2`: `COUNT(DISTINCT 6)` = 1. Is `1 = 2`? **False.** (Drop)
   * Group `3`: `COUNT(DISTINCT 5, 6)` = 2. Is `2 = 2`? **True.** (Keep 3)
4. **SELECT:**
   * Output surviving groups: `1`, `3`.

---

## 13. SQL Execution Order
1. **Subquery:** Calculates the total number of products once.
2. **FROM Customer:** Looks at the sales records.
3. **GROUP BY customer_id:** Buckets the sales by customer.
4. **HAVING ... = ...:** Computes the distinct count per bucket and checks it against the subquery result.
5. **SELECT:** Outputs the IDs of the buckets that passed the check.

---

## 14. Query Breakdown
* **COUNT(DISTINCT product_key):** Crucial to prevent false positives. If Customer 2 bought product 6 three times, `COUNT(product_key)` would be 3. If there were 3 total products, Customer 2 would falsely pass the check without `DISTINCT`.
* **(SELECT COUNT(*) FROM Product):** An Uncorrelated Scalar Subquery. It returns a single integer. Because it does not reference the outer query, the database only runs it once.

---

## 15. Why This Solution Works
This is the classic SQL solution to the "Relational Division" problem. In relational algebra, dividing a table of (Customer, Product) by a table of (Product) yields the Customers who interacted with every Product. In SQL, we solve division using `COUNT` comparisons.

---

## 16. Alternative Solution
Using a double `NOT EXISTS` (Strict Relational Division)

```sql
SELECT c1.customer_id
FROM Customer c1
WHERE NOT EXISTS (
    SELECT p.product_key
    FROM Product p
    WHERE NOT EXISTS (
        SELECT c2.product_key
        FROM Customer c2
        WHERE c2.customer_id = c1.customer_id
        AND c2.product_key = p.product_key
    )
)
GROUP BY c1.customer_id;
```
* **Advantages:** This is the mathematically pure way to write relational division in SQL. "Find customers for whom there DOES NOT EXIST a product that DOES NOT EXIST in their purchase history."
* **Disadvantages:** It is an absolute nightmare to read, write, and maintain. It's historically interesting but practically useless in modern databases compared to the `HAVING COUNT` approach.

---

## 17. Time Complexity
**O(N + P)** where N is the number of rows in `Customer` and P is the number of rows in `Product`. The subquery takes O(P) (or O(1) if table metadata is cached). Grouping and counting takes O(N).

---

## 18. Common Mistakes
* **Forgetting `DISTINCT`:** As noted in the breakdown, duplicate purchases of the same product will bloat the standard `COUNT()`, leading to false positives.
* **Joining the tables:** You do not need to `JOIN` the `Product` table. The `Customer` table already contains the foreign keys. Joining just adds unnecessary computational overhead.

---

## 19. Edge Cases
* **Zero products exist:** The subquery returns `0`. All customers with zero purchases (which is everyone in the output) mathematically satisfy `0 = 0`, but because they aren't in the `Customer` table, they won't be returned. The output is empty, which is logically sound.
* **Customer buys products not in the Product table:** The schema dictates `product_key` is a foreign key, preventing this scenario.

---

## 20. Interview Tips
* If an interviewer asks "How do you implement Relational Division in SQL?", immediately write the `HAVING COUNT(DISTINCT x) = (SELECT COUNT(x))` query. 

---

## 21. Similar LeetCode Problems
* 596. Classes More Than 5 Students
* 2084. Drop Type 1 Orders for Customers With Type 0 Orders

---

## 22. Key Takeaways
* **Relational Division** ("Find X that has ALL Y") is solved by comparing the `COUNT(DISTINCT)` of the foreign key to the `COUNT(*)` of the parent table inside a `HAVING` clause.

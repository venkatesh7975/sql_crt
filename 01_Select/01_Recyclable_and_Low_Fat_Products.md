# Problem 01 – Recyclable and Low Fat Products

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* WHERE
* AND

---

## 3. Pattern
Filtering

---

## 4. Problem Statement
We need to find the unique identifiers of products that are both low fat and recyclable.

---

## 5. Tables

Table: Products

| Column     | Type |
| ---------- | ---- |
| product_id | INT  |
| low_fats   | ENUM |
| recyclable | ENUM |

* `product_id` is the primary key for this table.
* `low_fats` is an ENUM of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
* `recyclable` is an ENUM of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.

---

## 6. Sample Input

Products table:

| product_id | low_fats | recyclable |
| ---------- | -------- | ---------- |
| 0          | Y        | N          |
| 1          | Y        | Y          |
| 2          | N        | Y          |
| 3          | Y        | Y          |
| 4          | N        | N          |

---

## 7. Expected Output

| product_id |
| ---------- |
| 1          |
| 3          |

---

## 8. Understanding the Question
What information is being asked? We need the IDs of specific products.
What columns are important? `product_id`, `low_fats`, and `recyclable`.
What conditions matter? The product must have `low_fats = 'Y'` AND `recyclable = 'Y'`.
What should be returned? Just the `product_id` column.

---

## 9. Thinking Process
1. I know I need to retrieve data from the `Products` table. This means I'll use a `SELECT` statement and a `FROM` clause.
2. I only want specific rows that meet two strict conditions. This tells me I need a `WHERE` clause.
3. Both conditions must be true at the same time: it must be low fat AND it must be recyclable. Therefore, I will combine these conditions using the logical `AND` operator.
4. The final output only requires the `product_id`, so I will specify only that column in the `SELECT` clause.

---

## 10. Approach 1 (Optimal)
Filtering with `WHERE` and `AND`

This approach simply reads the table and filters out any rows that do not have 'Y' for both `low_fats` and `recyclable`.

---

## 11. SQL Solution

```sql
-- Retrieve the product_id of products that meet both conditions
SELECT 
    product_id
FROM 
    Products
WHERE 
    low_fats = 'Y' 
    AND recyclable = 'Y';
```

---

## 12. Step-by-Step Dry Run
1. Look at row 1: `product_id` 0, `low_fats` 'Y', `recyclable` 'N'. (`'Y' = 'Y'` AND `'N' = 'Y'` -> False). Ignore.
2. Look at row 2: `product_id` 1, `low_fats` 'Y', `recyclable` 'Y'. (`'Y' = 'Y'` AND `'Y' = 'Y'` -> True). Keep `product_id` 1.
3. Look at row 3: `product_id` 2, `low_fats` 'N', `recyclable` 'Y'. (`'N' = 'Y'` AND `'Y' = 'Y'` -> False). Ignore.
4. Look at row 4: `product_id` 3, `low_fats` 'Y', `recyclable` 'Y'. (`'Y' = 'Y'` AND `'Y' = 'Y'` -> True). Keep `product_id` 3.
5. Look at row 5: `product_id` 4, `low_fats` 'N', `recyclable` 'N'. (`'N' = 'Y'` AND `'N' = 'Y'` -> False). Ignore.
Result: 1, 3.

---

## 13. SQL Execution Order
1. **FROM:** The database engine first locates the `Products` table to know where to pull the data from.
2. **WHERE:** It then goes through the rows one by one, applying the condition `low_fats = 'Y' AND recyclable = 'Y'` to filter the data.
3. **SELECT:** Finally, from the filtered rows, it extracts only the requested column: `product_id`.

This query strictly follows this standard execution order, which makes it highly efficient.

---

## 14. Query Breakdown
* **SELECT:** Determines which columns to return. We specify `product_id`.
* **FROM:** Specifies the target table, which is `Products`.
* **WHERE:** Acts as a filter. It evaluates a boolean expression for every row.
* **AND:** A logical operator that requires both conditions on its left and right sides to evaluate to TRUE for the entire expression to be TRUE.

---

## 15. Why This Solution Works
It directly targets the conditions specified in the problem statement. Because both `low_fats` and `recyclable` must be 'Y', using `AND` ensures we don't accidentally pull products that only meet one of the criteria. 

---

## 16. Alternative Solution
Using `IN` with Tuples (Less common, mostly for demonstration)
```sql
SELECT product_id
FROM Products
WHERE (low_fats, recyclable) = ('Y', 'Y');
```
* **Advantages:** Can be visually cleaner for some when comparing multiple columns to a specific set of values.
* **Disadvantages:** Less readable for beginners. The standard `AND` operator is much more universally understood and is standard SQL.

---

## 17. Time Complexity
**O(N)** where N is the number of rows in the `Products` table. The database must scan each row to check the conditions. If there is a composite index on `(low_fats, recyclable)`, the lookup could be faster, but it generally involves a full table scan since ENUMs have low cardinality (few unique values).

---

## 18. Common Mistakes
* **Using `OR` instead of `AND`:** Beginners sometimes misread the prompt and write `low_fats = 'Y' OR recyclable = 'Y'`. This returns products that are low fat but not recyclable, and vice versa.
* **Missing quotes:** Writing `low_fats = Y` instead of `low_fats = 'Y'`. In SQL, string literals and ENUM values must be enclosed in single quotes.
* **Selecting `*`:** Writing `SELECT *` returns all columns, but LeetCode strictly checks the output schema. Always select exactly what is requested.

---

## 19. Edge Cases
* **Empty table:** If the table has no rows, the query correctly returns an empty result set.
* **No matching products:** If no product satisfies both conditions, it returns an empty result set.
* **NULL values:** If an ENUM column contains NULL, the equality check `low_fats = 'Y'` evaluates to UNKNOWN (effectively False in the WHERE clause), so it safely filters out NULL rows without crashing.

---

## 20. Interview Tips
* Interviewers use this to test basic syntax and logical operators.
* Always read the schema carefully. Notice that they are ENUMs ('Y', 'N'), not booleans (TRUE/FALSE) or integers (1/0).
* When writing on a whiteboard, clearly distinguish between single quotes (strings) and backticks (column names, optional here).

---

## 21. Similar LeetCode Problems
* 584. Find Customer Referee
* 595. Big Countries
* 1148. Article Views I

---

## 22. Key Takeaways
* `WHERE` filters rows before any grouping or selecting happens.
* Use `AND` when multiple conditions must be met simultaneously.
* Always enclose string and ENUM values in single quotes in MySQL.

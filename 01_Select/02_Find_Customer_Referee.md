# Problem 02 – Find Customer Referee

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* WHERE
* OR
* IS NULL
* Inequality Operator (`!=` or `<>`)

---

## 3. Pattern
Filtering with NULL values

---

## 4. Problem Statement
We need to find the names of all customers who were **not** referred by the customer whose ID is 2.

---

## 5. Tables

Table: Customer

| Column     | Type    |
| ---------- | ------- |
| id         | INT     |
| name       | VARCHAR |
| referee_id | INT     |

* `id` is the primary key column for this table.
* Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.

---

## 6. Sample Input

Customer table:

| id | name | referee_id |
| -- | ---- | ---------- |
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |

---

## 7. Expected Output

| name |
| ---- |
| Will |
| Jane |
| Bill |
| Zack |

---

## 8. Understanding the Question
What information is being asked? The names of specific customers.
What columns are important? `name` and `referee_id`.
What conditions matter? The `referee_id` must NOT be 2. However, we must also consider customers who were not referred by anyone (where `referee_id` is NULL).
What should be returned? Just the `name` column.

---

## 9. Thinking Process
1. I need the `name` of the customers, so `SELECT name FROM Customer`.
2. I need to filter the rows based on the `referee_id`, so I will use a `WHERE` clause.
3. The obvious condition is `referee_id != 2`. 
4. **Crucial Catch:** In SQL, any comparison with a `NULL` value results in `UNKNOWN` (effectively False in a `WHERE` clause). If a customer has `referee_id = NULL`, checking `NULL != 2` evaluates to `UNKNOWN`, and that customer is skipped!
5. To fix this, I must explicitly include rows where `referee_id IS NULL`.
6. Therefore, my final condition must check for *either* `referee_id != 2` OR `referee_id IS NULL`.

---

## 10. Approach 1 (Optimal)
Filtering using `OR` and `IS NULL`

We explicitly tell MySQL to give us the rows where the `referee_id` is anything other than 2, as well as the rows where the `referee_id` is completely empty (NULL).

---

## 11. SQL Solution

```sql
-- Retrieve the name of customers not referred by customer_id = 2
SELECT 
    name
FROM 
    Customer
WHERE 
    referee_id != 2 
    OR referee_id IS NULL;
```

*(Note: You can also use `<>` instead of `!=`)*

---

## 12. Step-by-Step Dry Run
1. Row 1 (Will): `referee_id` is NULL. (`NULL != 2` is UNKNOWN) OR (`NULL IS NULL` is True). Result: True. Keep 'Will'.
2. Row 2 (Jane): `referee_id` is NULL. (`NULL != 2` is UNKNOWN) OR (`NULL IS NULL` is True). Result: True. Keep 'Jane'.
3. Row 3 (Alex): `referee_id` is 2. (`2 != 2` is False) OR (`2 IS NULL` is False). Result: False. Ignore.
4. Row 4 (Bill): `referee_id` is NULL. Result: True. Keep 'Bill'.
5. Row 5 (Zack): `referee_id` is 1. (`1 != 2` is True) OR (`1 IS NULL` is False). Result: True. Keep 'Zack'.
6. Row 6 (Mark): `referee_id` is 2. Result: False. Ignore.

Result: Will, Jane, Bill, Zack.

---

## 13. SQL Execution Order
1. **FROM:** Identifies the `Customer` table.
2. **WHERE:** Filters each row based on `referee_id != 2 OR referee_id IS NULL`.
3. **SELECT:** Extracts the `name` column from the remaining rows.

---

## 14. Query Breakdown
* **WHERE referee_id != 2:** Checks if the value exists and is strictly not equal to 2.
* **OR:** Logical operator that evaluates to True if at least one of the conditions is True.
* **IS NULL:** The only valid way in standard SQL to check if a value is absent (NULL).

---

## 15. Why This Solution Works
By using `IS NULL`, we safely catch all the users who signed up organically (without a referee). By using `!= 2`, we catch all users who were referred by someone else. Combining them with `OR` handles both mutually exclusive valid cases.

---

## 16. Alternative Solution
Using `IFNULL()` or `COALESCE()`

```sql
SELECT name
FROM Customer
WHERE IFNULL(referee_id, 0) != 2;
```
* **Advantages:** Shorter to write. `IFNULL(referee_id, 0)` converts any NULL value into a 0. Since 0 is not equal to 2, it passes the condition.
* **Disadvantages:** Using functions on columns in the `WHERE` clause usually prevents the database from using indexes (this is called non-sargable). Approach 1 is fundamentally faster and better practice.

---

## 17. Time Complexity
**O(N)** where N is the number of rows in the `Customer` table. The query performs a full table scan.

---

## 18. Common Mistakes
* **Using `= NULL` or `!= NULL`:** Beginners often write `referee_id != NULL`. In SQL, nothing equals NULL, not even NULL itself! You *must* use `IS NULL` or `IS NOT NULL`.
* **Forgetting the NULL check completely:** Writing `WHERE referee_id != 2`. This drops all organic customers because `NULL != 2` evaluates to UNKNOWN, which the `WHERE` clause filters out.

---

## 19. Edge Cases
* **Everyone referred by 2:** If every row has `referee_id = 2`, the query correctly returns an empty table.
* **No one referred by 2:** If the table has IDs 1, 3, and NULL, it will correctly return everyone.

---

## 20. Interview Tips
* This question is entirely a trick to see if you know how SQL handles `NULL` values. 
* Interviewers want to see that you immediately recognize that `<>` and `!=` fail on `NULL`.
* Mention why `IS NULL` is better for performance than using `COALESCE()` in the `WHERE` clause.

---

## 21. Similar LeetCode Problems
* 584. Find Customer Referee (This one!)
* 175. Combine Two Tables (also heavily relies on understanding NULLs from LEFT JOINS)

---

## 22. Key Takeaways
* **Never use `=` or `!=` with `NULL`.** Always use `IS NULL` or `IS NOT NULL`.
* Any arithmetic or comparison operation with a `NULL` yields `NULL` (UNKNOWN).
* Be highly cautious whenever a column is allowed to have NULLs; always ask yourself "What happens to the NULLs here?"

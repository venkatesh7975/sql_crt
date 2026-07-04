# Problem 08 – Customer Who Visited but Did Not Make Any Transactions

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* LEFT JOIN
* WHERE (IS NULL)
* GROUP BY
* Aggregate Functions (COUNT)

---

## 3. Pattern
Join / Aggregation / Finding "Orphans" (Anti-Join)

---

## 4. Problem Statement
We need to identify all customers who visited a mall but **did not** make any transactions during those visits. We also need to count how many times they made these "empty" visits.

---

## 5. Tables

Table: Visits

| Column      | Type |
| ----------- | ---- |
| visit_id    | INT  |
| customer_id | INT  |

* `visit_id` is the primary key.
* This table contains information about customers who visited the mall.

Table: Transactions

| Column         | Type |
| -------------- | ---- |
| transaction_id | INT  |
| visit_id       | INT  |
| amount         | INT  |

* `transaction_id` is the primary key.
* This table contains information about the transactions made during a specific visit.

---

## 6. Sample Input

Visits table:

| visit_id | customer_id |
| -------- | ----------- |
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |

Transactions table:

| transaction_id | visit_id | amount |
| -------------- | -------- | ------ |
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |

---

## 7. Expected Output

| customer_id | count_no_trans |
| ----------- | -------------- |
| 30          | 1              |
| 96          | 1              |
| 54          | 2              |

*(Customer 54 visited 3 times (5, 7, 8). During visit 5, they made transactions. During visits 7 and 8, they didn't. So they have 2 empty visits.)*

---

## 8. Understanding the Question
What information is being asked? The `customer_id` and a count of how many visits resulted in no transaction.
What columns are important? `customer_id` (from Visits), `visit_id` (shared), and `transaction_id` (from Transactions).
What conditions matter? A visit is "empty" if the `visit_id` exists in the `Visits` table but is completely missing from the `Transactions` table.
What should be returned? `customer_id` and the computed count as `count_no_trans`.

---

## 9. Thinking Process
1. **Finding the target rows:** I need to find visits that have *no* corresponding transaction. 
2. **The "Anti-Join" Pattern:** The best way to find records in Table A that do not exist in Table B is to do a `LEFT JOIN` from A to B, and then use a `WHERE` clause to filter for rows where B's primary key `IS NULL`. 
3. If I `LEFT JOIN` `Transactions` onto `Visits` based on `visit_id`, visits with a transaction will have transaction details. Visits *without* a transaction will have `NULL` in the `transaction_id` column.
4. I'll filter with `WHERE t.transaction_id IS NULL`. This leaves only the "empty" visits.
5. **Aggregation:** The problem asks to count these empty visits *per customer*. The phrase "per customer" strongly implies I need to `GROUP BY customer_id`.
6. To get the count, I use the aggregate function `COUNT(*)`, which counts the number of empty visits left over after grouping.
7. I will alias the count column to `count_no_trans`.

---

## 10. Approach 1 (Optimal)
LEFT JOIN with IS NULL, followed by GROUP BY (The Anti-Join)

This is a classic SQL pattern. We attempt to join the tables. The `LEFT JOIN` keeps all visits. The `WHERE ... IS NULL` drops all visits that successfully matched a transaction. Finally, we group by the customer to count their failures.

---

## 11. SQL Solution

```sql
-- Count visits with no associated transactions, grouped by customer
SELECT 
    v.customer_id, 
    COUNT(*) AS count_no_trans
FROM 
    Visits v
LEFT JOIN 
    Transactions t 
    ON v.visit_id = t.visit_id
WHERE 
    t.transaction_id IS NULL
GROUP BY 
    v.customer_id;
```

---

## 12. Step-by-Step Dry Run
1. **LEFT JOIN:**
   * Visit 1 (Cust 23) -> Matches Trans 12. (Keep, but trans_id is 12)
   * Visit 2 (Cust 9) -> Matches Trans 13. (Keep, trans_id is 13)
   * Visit 4 (Cust 30) -> **No Match**. (Keep, trans_id is NULL)
   * Visit 5 (Cust 54) -> Matches Trans 2, 3, 9.
   * Visit 6 (Cust 96) -> **No Match**. (Keep, trans_id is NULL)
   * Visit 7 (Cust 54) -> **No Match**. (Keep, trans_id is NULL)
   * Visit 8 (Cust 54) -> **No Match**. (Keep, trans_id is NULL)
2. **WHERE t.transaction_id IS NULL:**
   * Removes visits 1, 2, and 5 because they have actual `transaction_id`s.
   * Surviving rows: Visit 4 (Cust 30), Visit 6 (Cust 96), Visit 7 (Cust 54), Visit 8 (Cust 54).
3. **GROUP BY v.customer_id:**
   * Group Cust 30: [Visit 4]
   * Group Cust 96: [Visit 6]
   * Group Cust 54: [Visit 7, Visit 8]
4. **SELECT COUNT(*):**
   * Cust 30 -> 1
   * Cust 96 -> 1
   * Cust 54 -> 2

---

## 13. SQL Execution Order
1. **FROM Visits v:** Select the base table.
2. **LEFT JOIN Transactions t:** Join the transactions.
3. **WHERE t.transaction_id IS NULL:** Filter out successful visits.
4. **GROUP BY v.customer_id:** Bucket the remaining rows by customer.
5. **SELECT ... COUNT(*):** Calculate the final count for each bucket.

---

## 14. Query Breakdown
* **LEFT JOIN:** Essential here. An `INNER JOIN` would immediately discard the visits without transactions, destroying the exact data we are looking for!
* **WHERE t.transaction_id IS NULL:** The core of the "Anti-Join". It isolates the orphans.
* **GROUP BY:** Used because we need an aggregated metric (`COUNT`) *per customer*, not just a total grand sum of empty visits.
* **COUNT(*):** Counts the number of rows in each group. Because our `WHERE` clause already filtered the table to *only* contain empty visits, counting the rows counts the empty visits.

---

## 15. Why This Solution Works
It breaks the problem into two distinct logical steps that mirror human thinking: 
1. Find all the empty visits (LEFT JOIN + IS NULL).
2. Count them up for each person (GROUP BY + COUNT).

---

## 16. Alternative Solution
Using `NOT IN` with a Subquery

```sql
SELECT 
    customer_id, 
    COUNT(*) AS count_no_trans
FROM 
    Visits
WHERE 
    visit_id NOT IN (
        SELECT visit_id 
        FROM Transactions
    )
GROUP BY 
    customer_id;
```
* **Advantages:** Some find this more logically readable ("Get me visits where the visit ID is NOT IN the list of transaction visit IDs").
* **Disadvantages:** `NOT IN` can be dangerously slow on massive tables if the subquery returns `NULL` values (though here `visit_id` likely doesn't have NULLs). The `LEFT JOIN` approach is generally safer and better optimized by query engines.

---

## 17. Time Complexity
**O(V + T)** where V is the number of Visits and T is the number of Transactions. The database scans the Visits table, does an index lookup on Transactions, filters, and then hashes the results for grouping.

---

## 18. Common Mistakes
* **Using `INNER JOIN`:** As mentioned, this drops all empty visits immediately. You will get zero results.
* **Grouping by `visit_id`:** The prompt asks for the count of visits *per customer*, so you must group by `customer_id`.
* **Counting the wrong thing:** `COUNT(t.transaction_id)` will return `0` for everyone, because you just explicitly filtered for rows where `t.transaction_id IS NULL`! Use `COUNT(*)` or `COUNT(v.visit_id)`.

---

## 19. Edge Cases
* **A customer visits multiple times but *always* buys something:** They are successfully filtered out by the `WHERE` clause and won't appear in the output.
* **A customer has multiple empty visits:** `GROUP BY` correctly groups these and `COUNT(*)` sums them up (e.g., customer 54).

---

## 20. Interview Tips
* The "LEFT JOIN + IS NULL" pattern is called an **Anti-Join**. Know this term. Interviewers love it.
* Be able to explain why `COUNT(t.transaction_id)` fails in this specific query (because it ignores NULLs, and we just ensured only NULLs exist in that column!).

---

## 21. Similar LeetCode Problems
* 183. Customers Who Never Order (Exact same Anti-Join pattern)
* 577. Employee Bonus

---

## 22. Key Takeaways
* To find rows in Table A that are MISSING in Table B, use **A LEFT JOIN B WHERE B.id IS NULL**.
* Use `GROUP BY` whenever you need an aggregate metric "per" something (per customer, per day, per department).

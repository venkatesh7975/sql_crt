# Problem 46 – Delete Duplicate Emails

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* DELETE
* Self JOIN
* Inequality Operators (`>`)

---

## 3. Pattern
Self Join (Cross Table Deletion)

---

## 4. Problem Statement
Write a SQL query to **delete** all duplicate emails, keeping only one unique email with the smallest `id`.
Note that you are writing a `DELETE` statement, not a `SELECT` statement.

---

## 5. Tables

Table: Person

| Column | Type    |
| ------ | ------- |
| id     | INT     |
| email  | VARCHAR |

* `id` is the primary key.
* Each row contains an email. The emails will not contain uppercase letters.

---

## 6. Sample Input

Person table:

| id | email            |
| -- | ---------------- |
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |

---

## 7. Expected Output

| id | email            |
| -- | ---------------- |
| 1  | john@example.com |
| 2  | bob@example.com  |

*(john@example.com is repeated at ID 1 and ID 3. We must keep the smallest ID (1) and delete the larger ID (3)).*

---

## 8. Understanding the Question
What information is being asked? This is a Data Manipulation Language (DML) question. We are modifying the actual table.
What columns are important? `id`, `email`.
What conditions matter? If two rows have the exact same `email`, delete the row that has the larger `id`.
What should be returned? Nothing. The execution engine will verify the table's state after the `DELETE` completes.

---

## 9. Thinking Process
1. Since I need to compare rows within the same table to find duplicates, I must use a **Self-Join**.
2. Let's alias the table as `p1` and `p2`.
3. What makes a row a duplicate? `p1.email = p2.email`.
4. Which one do I want to delete? I want to delete the one with the larger ID. 
5. So, my join condition is: `p1.email = p2.email AND p1.id > p2.id`.
6. Whenever this condition is True, `p1` represents the duplicate record with the higher ID, and `p2` represents the original record with the smaller ID.
7. Therefore, I want to `DELETE p1`.
8. The syntax for a multi-table DELETE in MySQL is: `DELETE alias FROM table1 alias, table2 alias WHERE ...`

---

## 10. Approach 1 (Optimal)
DELETE with Self Join

Cross-join the table to itself, find matching emails where the left side has a higher ID, and delete the left side.

---

## 11. SQL Solution

```sql
-- Delete rows where the email matches another row with a smaller ID
DELETE p1 
FROM 
    Person p1, 
    Person p2 
WHERE 
    p1.email = p2.email 
    AND p1.id > p2.id;
```

---

## 12. Step-by-Step Dry Run
1. **Implicit Cross Join (p1, p2):** Creates a matrix of all combinations.
   * `(1, 1)`: John (1), John (1). Is `email = email`? Yes. Is `1 > 1`? No.
   * `(1, 2)`: John (1), Bob (2). Is `email = email`? No.
   * `(1, 3)`: John (1), John (3). Is `email = email`? Yes. Is `1 > 3`? No.
   * `(3, 1)`: John (3), John (1). Is `email = email`? Yes. Is `3 > 1`? **YES!**
2. **Execution:**
   * The condition is TRUE for `p1` = 3 and `p2` = 1.
   * The query says `DELETE p1`. 
   * Row ID 3 is physically deleted from the `Person` table.
3. **End State:**
   * The table now only contains ID 1 and ID 2.

---

## 13. SQL Execution Order
1. **FROM:** The database creates the virtual joined table `p1, p2`.
2. **WHERE:** Filters the joined table down to the rows where `p1` represents a duplicate with a larger ID.
3. **DELETE:** Executes the deletion on the targeted alias (`p1`).

---

## 14. Query Breakdown
* **DELETE p1 FROM...:** In MySQL, when you use multiple tables in a `DELETE` statement, you must specify *which* table/alias you are deleting from. Writing just `DELETE FROM p1, p2` is a syntax error.
* **p1, p2 (Implicit Join):** This is old ANSI-89 syntax, identical to `FROM Person p1 JOIN Person p2`. It is very common to see this shorthand in simple `DELETE` and `UPDATE` statements.

---

## 15. Why This Solution Works
Self-joins are incredibly efficient for finding intra-table relationships. The `p1.id > p2.id` condition elegantly ensures that for any pair of duplicates, only the one with the higher ID is targeted for deletion.

---

## 16. Alternative Solution
Using a Subquery (Standard SQL but usually causes errors in MySQL)

```sql
DELETE FROM Person 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM Person 
    GROUP BY email
);
```
* **Advantages:** This logic makes a lot of sense intuitively: "Delete anyone who isn't the minimum ID for their email group".
* **Disadvantages (MySQL Trap!):** In MySQL, **you cannot delete from a table and select from the same table in a subquery simultaneously.** The query above will throw `Error 1093: You can't specify target table 'Person' for update in FROM clause`.
* **The MySQL Workaround for the Subquery:**
  ```sql
  DELETE FROM Person WHERE id NOT IN (
      SELECT id FROM (
          SELECT MIN(id) AS id FROM Person GROUP BY email
      ) AS temp
  );
  ```
  *(Wrapping the subquery in another subquery `AS temp` forces MySQL to create a temporary table, bypassing the Error 1093 lock. However, this is incredibly ugly and slower than the Self-Join).*

---

## 17. Time Complexity
**O(N^2)** worst-case for the self-join without indexes, but realistically **O(N)** because `id` and `email` are usually indexed. The database engine optimizes the self-join very efficiently.

---

## 18. Common Mistakes
* **Trying to use `SELECT` in a `DELETE`:** Many beginners try to use a CTE (`WITH...`) or a subquery in MySQL for a `DELETE`. Due to the Error 1093 lock (you can't read from a table while you are writing to it in the same context), these will fail. **Always use Self-Joins for MySQL deletions/updates.**
* **Deleting `p2`:** Writing `DELETE p2` instead of `p1` will delete the *original* record and keep the duplicate, failing the prompt requirements.

---

## 19. Edge Cases
* **Three or more duplicates:** E.g., IDs 1, 3, 5 all have "john".
  * `(3, 1)` triggers, deleting 3.
  * `(5, 1)` triggers, deleting 5.
  * `(5, 3)` triggers, deleting 5.
  * It perfectly scales to any number of duplicates. 1 is the only one that survives.
* **No duplicates:** The `WHERE` clause never matches. 0 rows affected.

---

## 20. Interview Tips
* If you are asked to write a `DELETE` query in an interview, **always clarify the SQL dialect**. Pointing out the "MySQL Error 1093" lock regarding subqueries is a massive flex that proves deep platform-specific experience.

---

## 21. Similar LeetCode Problems
* 197. Rising Temperature (Self Join with dates)
* 1179. Reformat Department Table

---

## 22. Key Takeaways
* Use `DELETE alias FROM table1 alias, table2 alias WHERE ...` for complex deletions in MySQL.
* Use `table1.id > table2.id` to identify and drop newer duplicates while preserving the original.
* Avoid subqueries involving the target table during `DELETE`/`UPDATE` operations in MySQL to prevent locking errors.

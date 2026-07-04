# Problem 06 – Replace Employee ID With The Unique Identifier

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* LEFT JOIN
* ON

---

## 3. Pattern
Join

---

## 4. Problem Statement
We have two tables: one with employee names and IDs, and another that maps those IDs to unique identifiers. We need to display the unique identifier for each employee along with their name. If an employee doesn't have a unique identifier, we should show `null` instead.

---

## 5. Tables

Table: Employees

| Column | Type    |
| ------ | ------- |
| id     | INT     |
| name   | VARCHAR |

* `id` is the primary key for this table.
* Each row contains the ID and the name of an employee in a company.

Table: EmployeeUNI

| Column   | Type |
| -------- | ---- |
| id       | INT  |
| unique_id| INT  |

* `(id, unique_id)` is the primary key for this table.
* Each row contains the ID and the corresponding unique ID of an employee.

---

## 6. Sample Input

Employees table:

| id  | name     |
| --- | -------- |
| 1   | Alice    |
| 7   | Bob      |
| 11  | Meir     |
| 90  | Winston  |
| 3   | Jonathan |

EmployeeUNI table:

| id | unique_id |
| -- | --------- |
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |

---

## 7. Expected Output

| unique_id | name     |
| --------- | -------- |
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |

*(Order doesn't matter)*

---

## 8. Understanding the Question
What information is being asked? The `unique_id` and the `name` of all employees.
What columns are important? `unique_id` (from EmployeeUNI) and `name` (from Employees).
What conditions matter? We must include *all* employees from the `Employees` table, even if they are missing from the `EmployeeUNI` table.
What should be returned? `unique_id`, `name`.

---

## 9. Thinking Process
1. I need information from two different tables (`Employees` and `EmployeeUNI`), which means I must `JOIN` them.
2. What connects these two tables? They both share an `id` column. That will be my join condition (`ON Employees.id = EmployeeUNI.id`).
3. The prompt explicitly says: "If an employee doesn't have a unique ID, just show null". This is the definition of an Outer Join.
4. Because I want *all* rows from the `Employees` table regardless of whether there's a match in the `EmployeeUNI` table, I should use a `LEFT JOIN` and put the `Employees` table on the left side of the join.
5. The `SELECT` clause needs to pick `unique_id` from the right table and `name` from the left table.

---

## 10. Approach 1 (Optimal)
Using a `LEFT JOIN`

We take the `Employees` table as the base (the "left" table). We try to attach the `EmployeeUNI` table (the "right" table) based on the matching `id`. If no match is found, MySQL will automatically fill the right table's columns (`unique_id`) with `NULL`.

---

## 11. SQL Solution

```sql
-- Retrieve unique_id and name, keeping all employees even if unique_id is missing
SELECT 
    eu.unique_id, 
    e.name
FROM 
    Employees e
LEFT JOIN 
    EmployeeUNI eu 
    ON e.id = eu.id;
```

---

## 12. Step-by-Step Dry Run
1. Take Row 1 of Employees: `(1, Alice)`. Look in `EmployeeUNI` for `id = 1`. Not found. Attach `NULL`. Result: `(NULL, Alice)`.
2. Take Row 2 of Employees: `(7, Bob)`. Look in `EmployeeUNI` for `id = 7`. Not found. Attach `NULL`. Result: `(NULL, Bob)`.
3. Take Row 3 of Employees: `(11, Meir)`. Look in `EmployeeUNI` for `id = 11`. Found! `unique_id = 2`. Attach `2`. Result: `(2, Meir)`.
4. Take Row 4 of Employees: `(90, Winston)`. Look in `EmployeeUNI` for `id = 90`. Found! `unique_id = 3`. Attach `3`. Result: `(3, Winston)`.
5. Take Row 5 of Employees: `(3, Jonathan)`. Look in `EmployeeUNI` for `id = 3`. Found! `unique_id = 1`. Attach `1`. Result: `(1, Jonathan)`.

---

## 13. SQL Execution Order
1. **FROM Employees e:** Identify the base table and assign it the alias `e`.
2. **LEFT JOIN EmployeeUNI eu:** Prepare to join the second table with the alias `eu`.
3. **ON e.id = eu.id:** Execute the join, matching rows based on ID. Keep all unmatched rows from `e` and populate their `eu` columns with NULL.
4. **SELECT eu.unique_id, e.name:** Extract just the two required columns from the joined dataset.

---

## 14. Query Breakdown
* **FROM Employees e:** `e` is a table alias. It makes writing the query shorter and cleaner.
* **LEFT JOIN:** Ensures that every single row from the left table (`Employees`) appears in the final result at least once. If there's no matching row in the right table (`EmployeeUNI`), the right table's columns are filled with NULLs.
* **ON e.id = eu.id:** The condition dictating how the two tables link together.
* **eu.unique_id, e.name:** By prepending the table aliases to the column names, we prevent ambiguity (though technically not required here since column names are unique, it is an excellent habit).

---

## 15. Why This Solution Works
A `LEFT JOIN` perfectly translates the business requirement of "show all employees, and if they don't have this extra piece of data, just show null". An `INNER JOIN` would have incorrectly filtered out Alice and Bob.

---

## 16. Alternative Solution
Using a `RIGHT JOIN`

```sql
SELECT 
    eu.unique_id, 
    e.name
FROM 
    EmployeeUNI eu
RIGHT JOIN 
    Employees e 
    ON eu.id = e.id;
```
* **Advantages:** Produces the exact same correct output.
* **Disadvantages:** Less intuitive to read. It's an industry standard convention to prefer `LEFT JOIN` over `RIGHT JOIN` because we read left-to-right (base table first, then what we are attaching to it).

---

## 17. Time Complexity
**O(N + M)** where N is rows in `Employees` and M is rows in `EmployeeUNI`. MySQL will scan `Employees` and do an index lookup on `EmployeeUNI` (since `id` is part of the primary key). This makes the join extremely fast.

---

## 18. Common Mistakes
* **Using an `INNER JOIN` (or just `JOIN`):** This is the most common mistake. It drops Alice and Bob entirely because they have no match in `EmployeeUNI`.
* **Swapping the order of tables in a LEFT JOIN:** `FROM EmployeeUNI LEFT JOIN Employees` will output only Meir, Winston, and Jonathan. It guarantees all rows from `EmployeeUNI`, but drops unmatched rows from `Employees`.
* **Not using aliases:** While not strictly an error here, in complex queries, failing to alias can lead to `Ambiguous Column` errors if both tables have a column with the same name.

---

## 19. Edge Cases
* **Empty `EmployeeUNI` table:** The query doesn't break; every employee will simply have a `NULL` unique_id.
* **Empty `Employees` table:** Returns an empty result set (even if `EmployeeUNI` has rows, because `LEFT JOIN` respects the left table).

---

## 20. Interview Tips
* Interviewers use this problem as the most basic check to see if you understand the difference between `INNER JOIN` and `LEFT/OUTER JOIN`.
* Be prepared to articulate *why* you chose a `LEFT JOIN` ("Because the requirements state we must not lose employees who lack a unique ID...").

---

## 21. Similar LeetCode Problems
* 175. Combine Two Tables (Almost identical concept)
* 1068. Product Sales Analysis I

---

## 22. Key Takeaways
* When you need data from Table A and optionally data from Table B, use `FROM TableA LEFT JOIN TableB`.
* Always join on primary/foreign keys (in this case, `id`).
* Table aliases (like `e` and `eu`) make queries much cleaner and prevent naming collisions.

# Theoretical SQL Interview Questions

---

## 1. What is the difference between DDL, DML, and DQL?
*   **DDL (Data Definition Language):** Commands that define the database structure or schema. Examples: `CREATE`, `ALTER`, `DROP`, `TRUNCATE`. (In MySQL, DDL commands automatically commit and cannot be rolled back).
*   **DML (Data Manipulation Language):** Commands that manipulate the data *inside* the tables. Examples: `INSERT`, `UPDATE`, `DELETE`. (These can be rolled back in a transaction).
*   **DQL (Data Query Language):** The command used to retrieve data. Example: `SELECT`.

## 2. What are the ACID properties?
ACID guarantees that database transactions are processed reliably.
*   **Atomicity:** "All or nothing." If a transaction has 5 steps and step 5 fails, the entire transaction is rolled back.
*   **Consistency:** A transaction must bring the database from one valid state to another, respecting all constraints and foreign keys.
*   **Isolation:** Concurrent transactions should not interfere with each other.
*   **Durability:** Once a transaction is committed, it is written to disk and is permanent, even in the event of a power failure.

## 3. Explain Normalization and the first three Normal Forms.
Normalization is the process of reducing data redundancy and improving data integrity.
*   **1NF (First Normal Form):** Atomicity. Every cell contains a single value (no arrays/lists in a cell).
*   **2NF (Second Normal Form):** Must be 1NF. Every non-key column must depend on the *entire* primary key (eliminates partial dependencies in composite keys).
*   **3NF (Third Normal Form):** Must be 2NF. Every non-key column must depend *only* on the primary key, not on other non-key columns (eliminates transitive dependencies).

## 4. What is the difference between an INNER JOIN and a LEFT JOIN?
*   **INNER JOIN:** Returns only the rows where there is a match in *both* tables. If a row exists in the left table but has no match in the right table, it is eliminated from the results.
*   **LEFT JOIN:** Returns *all* rows from the left table. If a match is found in the right table, it stitches them together. If no match is found, it still returns the left row but fills the right columns with `NULL`.

## 5. What is the difference between a Clustered and Non-Clustered Index?
*   **Clustered Index:** Dictates the physical sorting order of the data on the hard drive. A table can only have one (usually the Primary Key). Because the data itself is the index, lookups are extremely fast.
*   **Non-Clustered (Secondary) Index:** A separate data structure (B-Tree) that contains a sorted copy of a column and pointers back to the physical rows. A table can have many non-clustered indexes.

## 6. What is the difference between TRUNCATE and DELETE?
*   **DELETE:** A DML command that removes rows one by one. It records each deletion in the transaction log and can be rolled back. It does not reset `AUTO_INCREMENT` counters. It is slower on massive tables.
*   **TRUNCATE:** A DDL command that effectively drops and recreates the table. It is incredibly fast, does not log individual row deletions, cannot be rolled back, and resets the `AUTO_INCREMENT` counter.

## 7. What is the difference between WHERE and HAVING?
*   **WHERE:** Filters raw rows *before* any grouping or aggregation takes place. You cannot use aggregate functions (like `SUM()`) in a `WHERE` clause.
*   **HAVING:** Filters the grouped buckets *after* aggregation takes place. It is designed specifically to filter based on aggregate functions.

## 8. What is a View?
A View is a virtual table based on the result-set of an SQL statement. It does not physically store data (unless it's a Materialized View). It is used to simplify complex queries, ensure consistent business logic, and restrict access to sensitive underlying data.

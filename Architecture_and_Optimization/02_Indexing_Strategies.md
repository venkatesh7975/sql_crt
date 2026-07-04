# Indexing Strategies Guide

Indexes are specialized data structures that improve the speed of data retrieval operations on a database table at the cost of additional storage space and decreased write performance (INSERT, UPDATE, DELETE).

Understanding indexing is the single most important skill for a backend engineer dealing with databases.

---

## The B-Tree (Balanced Tree)

The vast majority of indexes in relational databases (including MySQL's InnoDB) use the **B-Tree** (specifically B+Tree) data structure.

*   **How it works:** Data is sorted in a hierarchical tree. To find a specific row out of a billion rows, the engine doesn't scan top to bottom (O(N) time). Instead, it traverses the tree, eliminating half the dataset with every step, finding the row in ~30 steps (O(log N) time).

---

## 1. Clustered vs Non-Clustered Indexes

### Clustered Index (The Primary Key)
*   A clustered index dictates the **physical sorting order** of the data on the hard drive.
*   Because data can only be physically sorted one way, a table can only have **one** clustered index.
*   In MySQL (InnoDB), the `PRIMARY KEY` is automatically the clustered index.
*   **Performance:** Extremely fast for range queries (e.g., `WHERE id BETWEEN 10 AND 50`) because the data is sitting sequentially on the disk.

### Non-Clustered Index (Secondary Index)
*   A non-clustered index is a separate data structure stored away from the actual table.
*   It contains a copy of the indexed column's data, sorted, along with a pointer (usually the Primary Key) that tells the engine where to find the rest of the row in the main table.
*   You can have multiple non-clustered indexes on a table.

---

## 2. The "Table Lookup" Penalty

Imagine you have an index on `LastName`. You run this query:
```sql
SELECT FirstName, Age FROM Users WHERE LastName = 'Smith';
```

**What the engine does:**
1. It uses the `LastName` index to quickly find 'Smith' in O(log N) time.
2. The index contains the Primary Key (e.g., ID=42) for 'Smith'.
3. The engine must now take ID=42, go back to the main Clustered Index (the physical table), and perform a second search to retrieve the `FirstName` and `Age`.

This second step is called a **Table Lookup** (or Key Lookup/Bookmark Lookup). If the query returns 100,000 "Smith"s, the database has to do 100,000 individual lookups, which is incredibly slow.

---

## 3. The Covering Index (The Ultimate Optimization)

To fix the Table Lookup penalty, we can use a Covering Index. A covering index is an index that "covers" all the columns required by the query, meaning the engine never has to visit the physical table!

If we create a composite index on `(LastName, FirstName, Age)`:
```sql
CREATE INDEX idx_users_name_age ON Users (LastName, FirstName, Age);
```
When we run our query, the engine finds 'Smith' in the index, and sitting right next to it in the index structure are the `FirstName` and `Age`. It returns the data instantly without ever touching the main table.

---

## 4. Composite Indexes and the "Leftmost Prefix" Rule

A composite index is an index on multiple columns (e.g., `(A, B, C)`).

**The Leftmost Prefix Rule:** A composite index can only be used if the query filters on columns from left to right without skipping.

Given an index on `(Country, State, City)`:
*   `WHERE Country = 'USA'` -> **Uses Index**
*   `WHERE Country = 'USA' AND State = 'CA'` -> **Uses Index**
*   `WHERE Country = 'USA' AND State = 'CA' AND City = 'LA'` -> **Uses Index**
*   `WHERE State = 'CA'` -> **Index Ignored!** (Table Scan occurs because the leftmost column, Country, is missing).
*   `WHERE Country = 'USA' AND City = 'LA'` -> **Uses Index for Country only.** (It cannot use the City part because State was skipped).

---

## 5. Indexing Anti-Patterns (What NOT to do)

1.  **Indexing Every Column:** Every index slows down `INSERT`, `UPDATE`, and `DELETE` operations because the tree must be rebalanced. Indexes also consume massive amounts of disk space/RAM. Only index columns that are heavily filtered (`WHERE`), joined (`ON`), or sorted (`ORDER BY`).
2.  **Indexing Low-Cardinality Columns:** Do not index a boolean column like `IsActive` or a gender column. An index is useless if it only cuts the dataset in half; the optimizer will usually ignore it and do a full table scan anyway.
3.  **Functions on Indexed Columns:** If you wrap an indexed column in a function, the index becomes useless.
    *   *Bad:* `WHERE YEAR(CreatedDate) = 2023` (Index ignored)
    *   *Good:* `WHERE CreatedDate >= '2023-01-01' AND CreatedDate < '2024-01-01'` (Index used perfectly)

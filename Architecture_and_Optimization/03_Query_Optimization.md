# Query Optimization & Execution Plans

Writing SQL that returns the correct answer is only step one. Writing SQL that returns the answer *efficiently* at scale is what separates junior engineers from seniors.

This guide focuses on how the MySQL Query Optimizer works, how to read `EXPLAIN` plans, and how to write SARGable queries.

---

## 1. The Query Optimizer

When you submit a SQL query, it doesn't execute immediately. It goes to the **Query Optimizer**. 

The optimizer acts like a GPS mapping system. You tell it where you want to go (the `SELECT` query), and the optimizer calculates hundreds of potential execution plans, evaluating the cost of disk I/O and CPU usage based on table statistics and available indexes. It then chooses the "cheapest" path.

Sometimes, the optimizer gets it wrong. It might choose to do a Full Table Scan when an Index Seek would be 1,000x faster. Your job is to analyze *why* it made that choice.

---

## 2. Reading the `EXPLAIN` Plan

You can prepend the word `EXPLAIN` to any `SELECT`, `UPDATE`, or `DELETE` query to see the roadmap the optimizer chose.

```sql
EXPLAIN SELECT * FROM Users WHERE Email = 'test@test.com';
```

### Key Columns in the EXPLAIN Output

| Column | What it means | What you want to see |
| :--- | :--- | :--- |
| **type** | The join type / access method. This is the most important column. | `const`, `eq_ref`, `ref`, or `range`. |
| **possible_keys** | Indexes the optimizer considered using. | The name of your index. |
| **key** | The index the optimizer *actually* chose to use. | The name of your index. (If NULL, it did a table scan). |
| **rows** | Estimated number of rows it must examine to find the result. | A small number. |
| **Extra** | Additional details about execution. | `Using index` (Covering index used). You do NOT want to see `Using filesort` or `Using temporary`. |

### The `type` Column Explained (Best to Worst)
1.  **`const` / `system`**: The absolute best. The query found exactly one row via a Primary Key or Unique Index. O(1) time.
2.  **`eq_ref`**: The best possible join type. The join uses a primary key or unique index.
3.  **`ref`**: The query uses a non-unique index to find a handful of rows. Very good.
4.  **`range`**: The query uses an index to find a range of rows (e.g., `BETWEEN`, `>`, `<`). Good.
5.  **`index`**: **(Warning)** The engine scanned the entire index tree instead of traversing it. Better than scanning the table, but still slow.
6.  **`ALL`**: **(Terrible)** Full Table Scan. The database read every single row in the table from the hard drive. 

---

## 3. SARGability (Search-Argument-Able)

A query is "SARGable" if the database engine can utilize an index to execute it. If you write non-SARGable queries, the optimizer is forced to ignore your indexes and do a Full Table Scan (`type: ALL`).

### Rule 1: No Functions on the Left Side
If you manipulate the column in the `WHERE` clause, you break the index.
*   **Non-SARGable (Bad):** `WHERE UPPER(LastName) = 'SMITH'` 
    *(The engine must run the UPPER function on all 1 billion rows before it can evaluate the WHERE clause).*
*   **SARGable (Good):** `WHERE LastName = 'Smith'`
    *(MySQL is generally case-insensitive by default anyway).*

### Rule 2: No Math on the Left Side
*   **Non-SARGable (Bad):** `WHERE Salary * 1.1 > 100000`
*   **SARGable (Good):** `WHERE Salary > 100000 / 1.1`
    *(Do the math on the constant side, keep the column pure).*

### Rule 3: Avoid Leading Wildcards
B-Tree indexes are sorted alphabetically. If you know the first letter, the index can jump straight to it. If you don't, the index is useless.
*   **Non-SARGable (Bad):** `WHERE Email LIKE '%@gmail.com'` 
    *(Forces a Full Table Scan. If you need suffix searching, use a Reverse Index or Full-Text Search).*
*   **SARGable (Good):** `WHERE Email LIKE 'test@%'` 
    *(The index can easily jump to the T section).*

---

## 4. The N+1 Query Problem

This is an architectural optimization issue often caused by ORMs (Object-Relational Mappers like Hibernate, Prisma, or Entity Framework).

**The Problem:**
You want to list 100 Blog Posts and the Name of the Author for each post.
1. The ORM runs 1 query to get the posts: `SELECT * FROM Posts LIMIT 100;` (1 query).
2. As your application loops through the 100 posts to render the HTML, the ORM runs a separate query for *each* author: `SELECT * FROM Authors WHERE id = ?;` (100 queries).
3. Total queries executed for one page load: **101 queries (N+1)**.

**The Fix:**
Eager load the relationship using a `JOIN` so everything is retrieved in exactly **1 query**.
```sql
SELECT p.*, a.Name 
FROM Posts p 
INNER JOIN Authors a ON p.AuthorID = a.ID 
LIMIT 100;
```

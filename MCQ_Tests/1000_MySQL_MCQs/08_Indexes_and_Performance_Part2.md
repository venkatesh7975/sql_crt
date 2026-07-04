# MySQL 8.0 Multiple Choice Questions: Indexes and Performance (Part 2)

**Q51. What is the "Leftmost Prefix Rule" in relation to composite indexes?**
A) An index can only be used if the queries are written in a left-to-right syntax.
B) The query must filter on the columns in the exact order they were defined in the index, starting from the leftmost column.
C) The index only indexes the left side of string values.
D) It requires all indexes to be placed on the left side of a `JOIN`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The Leftmost Prefix Rule dictates that a composite index can only be utilized if the query's `WHERE` or `JOIN` clauses utilize the leading (leftmost) columns of the index without skipping any.
</details>

**Q52. Given a composite index on `(col_a, col_b, col_c)`, which of the following queries can optimally use the entire index for an index seek?**
A) `WHERE col_b = 1 AND col_c = 2`
B) `WHERE col_a = 1 AND col_c = 2`
C) `WHERE col_a = 1 AND col_b = 2 AND col_c = 3`
D) `WHERE col_c = 3`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Only C uses all columns starting from the leftmost column without gaps. A and D skip `col_a`, and B skips `col_b`, meaning B can only use `col_a` for the index seek.
</details>

**Q53. With an index on `(col_a, col_b, col_c)`, how will MySQL process the query `WHERE col_a = 1 AND col_c = 2`?**
A) It will perform a full table scan.
B) It will use `col_a` for an index seek, and then filter the resulting rows for `col_c = 2`.
C) It will use both `col_a` and `col_c` for the index seek.
D) It will fail and return a syntax error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because `col_b` is skipped, the index traverse stops at `col_a`. It will perform an index seek for `col_a = 1` and then evaluate `col_c = 2` on the matched records (potentially using Index Condition Pushdown).
</details>

**Q54. If you have an index on `(A, B)` and execute `WHERE A > 10 AND B = 5`, how is the index utilized?**
A) Both columns A and B are used for the index seek.
B) The index cannot be used at all.
C) Column A is used for a range scan, but B cannot be used for the seek because A contains a range operator.
D) The query will automatically rewrite itself to `B = 5 AND A > 10` to use both.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Once a range operator (`>`, `<`, `BETWEEN`, `LIKE`) is encountered in a composite index, the index seek stops. Subsequent columns (like B) cannot be used to narrow the search tree further.
</details>

**Q55. To optimize `WHERE dept_id = 5 AND created_at > '2023-01-01'`, what is the optimal composite index order?**
A) `(created_at, dept_id)`
B) `(dept_id, created_at)`
C) Two separate indexes on `dept_id` and `created_at`
D) It does not matter.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You should place the equality condition (`dept_id`) first, followed by the range condition (`created_at`). This allows MySQL to seek the exact `dept_id` and then scan the specific date range.
</details>

**Q56. You have a composite index on `(last_name, first_name)`. Will `ORDER BY last_name, first_name` utilize the index to avoid a sort?**
A) Yes, because the `ORDER BY` matches the index column order perfectly.
B) No, `ORDER BY` never uses indexes.
C) No, only the `WHERE` clause can use an index.
D) Yes, but only if a `LIMIT 1` is applied.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** B-Tree indexes store data in sorted order based on the key definitions. If the `ORDER BY` strictly matches the index definition (and sorting direction), MySQL can read the index sequentially and bypass a filesort.
</details>

**Q57. In MySQL 5.7, what issue occurs with `ORDER BY A ASC, B DESC` on an index `(A, B)`?**
A) The query will throw an error.
B) MySQL cannot use the index for sorting because 5.7 does not support mixed-order (descending) indexes.
C) The index will be completely dropped.
D) MySQL automatically splits the query into two queries.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Prior to MySQL 8.0, all B-Tree indexes were sorted in ascending order. Mixing `ASC` and `DESC` in an `ORDER BY` prevented the use of the index for sorting, resulting in a filesort.
</details>

**Q58. What is an "Invisible Index" in MySQL 8.0?**
A) An index hidden from the database administrator.
B) An index that takes up no physical disk space.
C) An index that the query optimizer ignores, but is still updated during DML operations.
D) An index used exclusively for temporary tables.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** An invisible index is maintained by the storage engine but hidden from the optimizer. It is useful for safely testing the impact of removing an index without actually dropping it.
</details>

**Q59. What is the primary use case for making an index invisible?**
A) To save disk space.
B) To safely test if an index can be dropped without immediately impacting application performance.
C) To speed up `INSERT` operations.
D) To hide sensitive data from users.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Dropping an index is risky if a critical query needs it. Making it invisible lets you test the performance impact; if queries slow down, you can instantly make it visible again without waiting for a rebuild.
</details>

**Q60. Which of the following indexes CANNOT be made invisible in MySQL 8.0?**
A) A standard secondary index.
B) A composite index.
C) The Primary Key index.
D) A UNIQUE index (if it is not the primary key).

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A primary key cannot be made invisible in MySQL. The optimizer heavily relies on it, and it defines the physical structure of the InnoDB table.
</details>

**Q61. What does MySQL 8.0 introduce to properly handle queries like `ORDER BY A ASC, B DESC`?**
A) R-Tree clustering
B) Descending Indexes
C) Ascending Hash Tables
D) Backward Table Scans

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0 introduces true Descending Indexes, allowing you to specify `DESC` in the `CREATE INDEX` statement, enabling optimal index utilization for mixed-order sorts.
</details>

**Q62. How does a Descending Index improve performance compared to scanning an ascending index backwards?**
A) Backward scans are completely impossible in InnoDB.
B) Forward index scans are heavily optimized in InnoDB; backward scans incur higher CPU and latency overhead.
C) Descending indexes are stored in RAM permanently.
D) Descending indexes automatically create Hash indexes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While InnoDB can scan an ascending index backward, backward scanning is notably slower than forward scanning due to the internal structure of the B+Tree and page prefetching.
</details>

**Q63. Does MySQL 8.0 support indexing the result of a function or expression directly?**
A) No, this is only supported in PostgreSQL.
B) Yes, via Functional Key Parts (Functional Indexes).
C) Yes, but only for the `LOWER()` function.
D) No, you must use a trigger to populate a separate column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0 allows creating Functional Indexes, which index the evaluated result of an expression or function, like `(LOWER(email))`.
</details>

**Q64. Which is the correct syntax for creating a functional index on the `LOWER(email)` expression in MySQL 8.0?**
A) `CREATE INDEX idx ON users LOWER(email);`
B) `CREATE INDEX idx ON users (LOWER(email));`
C) `CREATE INDEX idx ON users ((LOWER(email)));`
D) `CREATE FUNCTIONAL INDEX idx ON users (email);`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Functional indexes require an extra set of parentheses around the expression: `CREATE INDEX name ON table ((expression));`.
</details>

**Q65. What major advantage does `EXPLAIN ANALYZE` (introduced in MySQL 8.0.18) provide over standard `EXPLAIN`?**
A) It outputs the results in XML format.
B) It provides the actual execution times, exact row counts, and loops, rather than just optimizer estimates.
C) It automatically optimizes and rewrites the query.
D) It prevents the query from modifying data.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While `EXPLAIN` shows the optimizer's execution plan and estimates, `EXPLAIN ANALYZE` actually executes the query and reports real-world metrics like time spent and rows read at each step.
</details>

**Q66. Which of the following is TRUE about running `EXPLAIN ANALYZE SELECT ...`?**
A) It simulates the query without touching the data.
B) It actually executes the `SELECT` query, which can take a long time for heavy queries.
C) It can only be run on queries that execute in under 1 second.
D) It locks the entire table while running.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because `EXPLAIN ANALYZE` gathers actual execution statistics, the query must physically execute. Use with caution on production systems for slow queries.
</details>

**Q67. What is a "Multi-Valued Index" used for in MySQL 8.0?**
A) Indexing tables with multiple primary keys.
B) Indexing arrays of values within a JSON document.
C) Indexing columns that have high duplication (low cardinality).
D) Creating an index across multiple tables.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A multi-valued index is a secondary index where multiple index records can point to the same data record. It is specifically designed to index JSON arrays.
</details>

**Q68. Which function is commonly utilized in conjunction with a Multi-Valued Index to search JSON arrays?**
A) `JSON_EXTRACT()`
B) `MEMBER OF()`
C) `JSON_KEYS()`
D) `JSON_PRETTY()`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Functions like `MEMBER OF()`, `JSON_CONTAINS()`, and `JSON_OVERLAPS()` are specifically optimized to utilize Multi-Valued Indexes in MySQL 8.0.
</details>

**Q69. What does the `EXPLAIN FORMAT=TREE` output represent?**
A) The physical layout of the B-Tree index on disk.
B) A hierarchical, tree-like structure showing the order of execution and flow of rows between operations.
C) A graphical image file of the query plan.
D) A list of all tables in the database schema.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `FORMAT=TREE` provides a nested execution plan that makes it much easier to see which operations run first and how row data flows upward to the final result.
</details>

**Q70. What is the default output format for `EXPLAIN ANALYZE`?**
A) TRADITIONAL (Tabular)
B) JSON
C) TREE
D) XML

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `EXPLAIN ANALYZE` exclusively uses the `TREE` format to display the execution plan alongside actual timings and row counts.
</details>

**Q71. What exclusive metric does `EXPLAIN FORMAT=JSON` provide that the traditional tabular `EXPLAIN` does not?**
A) The names of the indexes used.
B) The exact execution time in milliseconds.
C) Detailed cost estimates (like `query_cost`, `read_cost`) computed by the optimizer.
D) The number of rows returned.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The JSON format reveals internal optimizer calculations, including the estimated cost values that led the optimizer to choose that specific plan.
</details>

**Q72. In the `EXPLAIN FORMAT=JSON` output, what does the `query_cost` value represent?**
A) The amount of RAM in bytes needed to execute the query.
B) An arbitrary metric representing the estimated computational and I/O cost of the query plan.
C) The exact execution time in milliseconds.
D) The number of temporary tables created.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `query_cost` is a unitless metric used internally by the MySQL optimizer. The optimizer evaluates multiple plans and selects the one with the lowest `query_cost`.
</details>

**Q73. What is the "Index Merge" optimization in MySQL?**
A) Merging two tables together based on their primary keys.
B) Compressing the size of an index by merging duplicate keys.
C) Using multiple secondary indexes for a single table lookup, then merging the resulting row IDs.
D) Combining a Hash index and a B-Tree index dynamically.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** If a query has `WHERE col1 = 5 OR col2 = 10` and both columns have separate indexes, MySQL can scan both indexes independently and merge (union) the matched primary keys.
</details>

**Q74. In the `Extra` column, what does `Using intersect(...)` indicate?**
A) The query performed a full table scan.
B) MySQL used the Index Merge Intersection algorithm to find rows matching conditions on multiple separate indexes (typically for `AND` conditions).
C) The table was partitioned.
D) A geographic spatial index was used.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `Using intersect` means the optimizer retrieved primary keys from multiple secondary indexes and intersected them (found the common IDs) before fetching the data rows.
</details>

**Q75. How can you strongly compel the MySQL optimizer to use a specific index named `idx_name`?**
A) `SELECT * FROM tbl COMPEL INDEX (idx_name) WHERE ...`
B) `SELECT * FROM tbl FORCE INDEX (idx_name) WHERE ...`
C) `SELECT * FROM tbl USE INDEX (idx_name) WHERE ...`
D) `SELECT * FROM tbl WITH INDEX (idx_name) WHERE ...`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `FORCE INDEX` heavily biases the optimizer to use the specified index by assigning an extremely high cost to a table scan. `USE INDEX` is just a suggestion.
</details>

**Q76. What is the primary difference between `USE INDEX` and `FORCE INDEX`?**
A) `USE INDEX` works for `SELECT`, `FORCE INDEX` works for `UPDATE`.
B) They are exact synonyms; there is no difference.
C) `USE INDEX` tells the optimizer to consider the index, but it may still choose a table scan. `FORCE INDEX` prevents a table scan unless absolutely necessary.
D) `FORCE INDEX` ignores permissions.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `USE INDEX` merely restricts the optimizer's choices to the listed indexes. If the optimizer thinks a table scan is cheaper, it will still scan. `FORCE INDEX` makes a table scan appear prohibitively expensive.
</details>

**Q77. Which index hint ensures the optimizer will NOT use a specific index?**
A) `DROP INDEX`
B) `AVOID INDEX`
C) `IGNORE INDEX`
D) `DISABLE INDEX`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `IGNORE INDEX (index_name)` hint explicitly removes the index from the optimizer's list of possible execution plans.
</details>

**Q78. In MySQL 8.0, what syntax is preferred for providing Optimizer Hints?**
A) `-- HINT: ...`
B) `# HINT: ...`
C) `/*+ ... */`
D) `// HINT: ...`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL 8.0 heavily utilizes specialized comment syntax `/*+ HINT_NAME() */` placed immediately after the `SELECT`, `INSERT`, `UPDATE`, or `DELETE` keyword to pass hints to the optimizer.
</details>

**Q79. Which optimizer hint disables the Index Merge optimization for a specific table?**
A) `/*+ NO_INDEX_MERGE(table_name) */`
B) `/*+ DISABLE_MERGE */`
C) `IGNORE INDEX MERGE`
D) `/*+ SET_MERGE(OFF) */`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `/*+ NO_INDEX_MERGE(table_name) */` prevents the optimizer from using the Index Merge strategy on the specified table, forcing it to use a single index or a table scan.
</details>

**Q80. Why is adding a redundant index (e.g., an index on `(A)` when an index on `(A, B)` already exists) generally discouraged?**
A) It will cause query syntax errors.
B) The index on `(A)` provides no new search capabilities but consumes disk space and slows down `INSERT`, `UPDATE`, and `DELETE` operations.
C) MySQL cannot start if redundant indexes are present.
D) It converts the table to read-only.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Due to the leftmost prefix rule, an index on `(A, B)` can already serve queries filtering just on `(A)`. A separate index on `(A)` is redundant and adds unnecessary write overhead.
</details>

**Q81. What is the primary negative impact of having too many indexes on a highly transactional table?**
A) `SELECT` queries become exponentially slower.
B) It slows down Data Manipulation Language (DML) operations (`INSERT`, `UPDATE`, `DELETE`) because every index tree must be synchronously updated.
C) It breaks referential integrity.
D) The database automatically drops the oldest indexes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Every time a row is modified, the database must maintain all corresponding B-Tree indexes, adding significant I/O overhead to write operations.
</details>

**Q82. When might you run `ALTER TABLE tbl ENGINE=InnoDB;` on an existing InnoDB table?**
A) To convert it to MyISAM.
B) To rebuild the table and its indexes, defragmenting disk space after a large number of `DELETE` operations.
C) To immediately drop all data.
D) To clear the Query Cache.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Running a "null" alter table command rebuilds the table and indexes from scratch, reclaiming wasted space and resolving index fragmentation. (In 8.0, `OPTIMIZE TABLE` does this implicitly).
</details>

**Q83. When storing a standard UUID (like '550e8400-e29b-41d4-a716-446655440000') as a Primary Key, what is the best data type for performance?**
A) `VARCHAR(36)`
B) `TEXT`
C) `BINARY(16)`
D) `CHAR(36)`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Converting a UUID string to its raw 128-bit byte format using `UUID_TO_BIN()` and storing it as `BINARY(16)` drastically reduces the primary key size, which saves space in both the clustered index and all secondary indexes.
</details>

**Q84. Why are purely random UUIDs bad for InnoDB Clustered Index (Primary Key) insertion performance?**
A) They cannot be indexed.
B) They cause massive index fragmentation and frequent page splits because inserts occur randomly across the B-Tree rather than sequentially at the end.
C) They exceed the max key length.
D) They are rejected by the MySQL optimizer.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB clustered indexes physically sort data by the PK. Random values mean data is constantly squeezed into existing, full leaf pages, causing expensive page splits and random disk I/O.
</details>

**Q85. Why is it highly recommended to create indexes on Foreign Key columns?**
A) It is explicitly required by the SQL standard.
B) It prevents cascading updates/deletes from locking the entire child table or causing full table scans when the parent row is modified.
C) It automatically joins the tables.
D) MySQL drops foreign keys without an index.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When you delete a parent record, MySQL must check the child table. Without an index on the foreign key column, MySQL must perform a full table scan on the child table for every deleted parent record.
</details>

**Q86. Why is a generic `SELECT COUNT(*) FROM table;` often slower in InnoDB compared to MyISAM?**
A) InnoDB has a bug with the `COUNT` function.
B) MyISAM caches the total row count in the table metadata, while InnoDB must traverse an index to count rows due to MVCC (Multi-Version Concurrency Control).
C) InnoDB only counts distinct values.
D) MyISAM does not support `COUNT(*)`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because of transaction isolation and MVCC, different transactions might "see" a different number of rows in InnoDB. Thus, it cannot keep a single global row count and must dynamically count the rows.
</details>

**Q87. When executing `SELECT COUNT(*) FROM table` in InnoDB, which index does the optimizer typically choose to scan?**
A) The Clustered Index (Primary Key).
B) The smallest available secondary index.
C) The Full-Text index.
D) It always performs a table scan.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because any index contains exactly one entry per row, InnoDB will scan the physically smallest secondary index available to satisfy the `COUNT(*)` to minimize disk I/O.
</details>

**Q88. How can you optimize a deep pagination query like `SELECT * FROM tbl ORDER BY id LIMIT 1000000, 10`?**
A) Use `LIMIT 10 OFFSET 1000000`.
B) Drop the Primary Key.
C) Use a Deferred Join: `SELECT * FROM tbl JOIN (SELECT id FROM tbl ORDER BY id LIMIT 1000000, 10) AS sub ON tbl.id = sub.id`.
D) Change the storage engine to MEMORY.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The deferred join forces MySQL to scan the lightweight index to find the 10 specific IDs, and only then performs 10 random lookups into the clustered index to fetch the full rows, avoiding 1,000,000 data page lookups.
</details>

**Q89. What is Index Condition Pushdown (ICP)?**
A) A feature that pushes data to remote servers.
B) An optimization where MySQL evaluates parts of the `WHERE` condition at the storage engine level (using the index) before fetching the full row data.
C) Pushing index creation to a background thread.
D) Compressing index data automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ICP pushes conditions down to the storage engine. The engine filters out index tuples that don't match the condition, drastically reducing the number of full data rows it must read from the clustered index.
</details>

**Q90. In an `EXPLAIN` plan, what indicates that Index Condition Pushdown (ICP) is being used?**
A) `Using filesort`
B) `Using temporary`
C) `Using index condition`
D) `Using MRR`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `Extra` column displays `Using index condition` when ICP is successfully applied to a query.
</details>

**Q91. Can Index Condition Pushdown (ICP) be used for a clustered index (Primary Key) lookup in InnoDB?**
A) Yes, always.
B) No, ICP is only applicable to secondary indexes.
C) Yes, but only for `VARCHAR` columns.
D) No, ICP only applies to Hash indexes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Since the clustered index already contains the full row data in its leaf nodes, fetching the "rest of the row" costs nothing. Therefore, the concept of "pushing down" the condition before row fetch does not apply to clustered indexes in InnoDB.
</details>

**Q92. What is Multi-Range Read (MRR) optimization?**
A) Reading multiple tables simultaneously.
B) Caching `SELECT` results in memory.
C) Sorting secondary index records by their Primary Key before doing clustered index lookups to convert random disk I/O into sequential I/O.
D) Reading data from multiple hard drives in a RAID array.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MRR collects the primary keys found in a secondary index scan, sorts them in a buffer, and then fetches the data rows from the clustered index sequentially, greatly reducing disk head movement on HDDs.
</details>

**Q93. What is a "Prefix Index"?**
A) An index on the first table created in a database.
B) An index created on only the first N characters of a string column (e.g., `VARCHAR`, `TEXT`).
C) An index that stores data before the main row data.
D) A temporary index used during server startup.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** For long string columns, indexing the entire string wastes space. A Prefix Index only indexes the first few characters (e.g., `CREATE INDEX idx ON tbl (col(10))`), saving space while maintaining high selectivity.
</details>

**Q94. What is a major limitation of a Prefix Index?**
A) It cannot be used for `ORDER BY` operations or as a Covering Index.
B) It requires the column to be a `CHAR` data type.
C) It slows down `INSERT` operations by 50%.
D) It can only be 1 byte long.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Because the prefix index does not contain the full string value, MySQL cannot use it to confidently sort data (`ORDER BY`) or satisfy a query completely from the index (Covering Index).
</details>

**Q95. Which of the following columns is the POOREST candidate for a B-Tree index?**
A) A `user_id` column used heavily in `JOIN`s.
B) A `created_at` timestamp used for range queries.
C) An `is_active` boolean column where 99% of the values are `1`.
D) An `email` address column used for user login lookups.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `is_active` column has terrible selectivity. A query looking for `is_active = 1` will return almost the whole table, causing the optimizer to ignore the index and perform a table scan anyway.
</details>

**Q96. What happens to the indexes on a table when the table is dropped via `DROP TABLE`?**
A) They remain orphaned on the disk.
B) They are automatically dropped along with the table.
C) They are moved to the `mysql.indexes` system table.
D) You must manually drop them first, or the `DROP TABLE` command fails.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Indexes are tied directly to the table structure. When a table is dropped, the storage engine automatically removes all associated data and indexes.
</details>

**Q97. How can you view statistics on how frequently specific indexes are being used in MySQL?**
A) Run `SHOW INDEX STATISTICS;`
B) Query the `performance_schema.table_io_waits_summary_by_index_usage` table.
C) Look in the `error.log` file.
D) Query `information_schema.PROCESSLIST`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The Performance Schema contains highly detailed statistics, including `table_io_waits_summary_by_index_usage`, which tracks read/write activity for every index, helping identify unused indexes.
</details>

**Q98. What is the benefit of running the `OPTIMIZE TABLE` command?**
A) It updates the optimizer cost model automatically.
B) It rewrites your SQL queries to be faster.
C) It rebuilds the table and indexes, reclaiming unused space and defragmenting the data file.
D) It upgrades the table to the latest MySQL version.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `OPTIMIZE TABLE` essentially recreates the table, dropping fragmented space left behind by frequent `DELETE` or `UPDATE` operations, and re-sorting the clustered index.
</details>

**Q99. In MySQL 8.0, how are `NULL` values treated within a UNIQUE index?**
A) A UNIQUE index can only contain one `NULL` value.
B) `NULL` values are completely prohibited in UNIQUE indexes.
C) Multiple `NULL` values are permitted because `NULL` is never considered equal to another `NULL`.
D) `NULL` values are automatically converted to empty strings.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL, `NULL` represents an unknown value. Standard SQL rules dictate that `NULL != NULL`. Therefore, a UNIQUE index permits multiple rows containing `NULL` without throwing a duplicate key error.
</details>

**Q100. If an execution plan shows a `type` of `range`, what does this imply?**
A) The query scans the entire table checking for a range.
B) The query uses an index to retrieve rows within a given range (e.g., using `=`, `<>`, `>`, `>=`, `<`, `<=`, `IS NULL`, `<=>`, `BETWEEN`, `LIKE`, or `IN()`).
C) The optimizer decided to skip index usage because the range is too large.
D) The server is clustered across a range of nodes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `range` type indicates an index range scan. It uses the index to find a specific starting point and scans the index consecutively until the end of the range is reached.
</details>

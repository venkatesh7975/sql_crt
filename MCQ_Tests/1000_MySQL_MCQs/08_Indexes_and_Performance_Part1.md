# MySQL 8.0 Multiple Choice Questions: Indexes and Performance (Part 1)

**Q1. What is the default index type used by the InnoDB storage engine in MySQL?**
A) Hash
B) B-Tree (B+Tree)
C) R-Tree
D) Full-Text

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB uses B+Tree as its default index structure, which is highly efficient for both point lookups and range queries.
</details>

**Q2. What is the average time complexity for searching a record in a B-Tree index?**
A) O(1)
B) O(N)
C) O(log N)
D) O(N log N)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A B-Tree index maintains a balanced hierarchical structure, allowing search operations to be completed in O(log N) time complexity.
</details>

**Q3. In the context of a B-Tree index, what does the "B" stand for?**
A) Binary
B) Balanced
C) Block
D) Basic

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The "B" in B-Tree stands for Balanced. It is a self-balancing tree data structure that keeps data sorted and allows for predictable search times.
</details>

**Q4. How are the leaf nodes structured in InnoDB's B+Tree implementation to optimize range queries?**
A) They are completely isolated from each other.
B) They are linked via a single-direction linked list.
C) They are linked via a doubly linked list.
D) They are stored in an unorganized heap.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In InnoDB's B+Tree, leaf nodes are linked using a doubly linked list, allowing fast sequential access in both forward and backward directions for range scans.
</details>

**Q5. Where is the actual row data stored in an InnoDB clustered index?**
A) In the root node
B) In the intermediate/branch nodes
C) In the leaf nodes
D) In a separate data file linked by pointers

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In a clustered index, the leaf nodes contain the actual row data. The primary key automatically serves as the clustered index in InnoDB.
</details>

**Q6. What does the leaf node of a secondary (non-clustered) index contain in InnoDB?**
A) A physical pointer to the disk block
B) The actual row data
C) The primary key value of the corresponding row
D) A hash of the data row

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Secondary indexes in InnoDB store the primary key value in their leaf nodes, which is then used to look up the full row in the clustered index.
</details>

**Q7. What is the maximum prefix length for a B-Tree index key in InnoDB using the default `DYNAMIC` or `COMPRESSED` row format?**
A) 767 bytes
B) 1000 bytes
C) 3072 bytes
D) 65535 bytes

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In MySQL 8.0 with default InnoDB row formats (DYNAMIC or COMPRESSED), the maximum index key prefix length is 3072 bytes.
</details>

**Q8. Which of the following operations is a B-Tree index NOT highly optimized for?**
A) Exact match lookups (`=`)
B) Range queries (`BETWEEN`, `>`, `<`)
C) Finding the minimum or maximum value
D) Full wildcard string matching (`LIKE '%value%'`)

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** A B-Tree index cannot be used if a wildcard string search starts with a wildcard (`%`), as the tree traversal requires knowing the prefix of the value.
</details>

**Q9. What typically happens when a new row is inserted, and a B-Tree index leaf node becomes completely full?**
A) The row is discarded.
B) The node undergoes a "page split", dividing its data into two nodes.
C) The entire tree is instantly rebuilt.
D) The database throws an Out of Memory error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** When a page is full and a new record must be inserted, the B-Tree performs a page split, moving some records to a new page to maintain balance.
</details>

**Q10. Why is inserting monotonically increasing primary keys (like `AUTO_INCREMENT`) generally faster in InnoDB?**
A) It prevents random disk I/O and reduces B-Tree page splits.
B) It disables secondary index generation.
C) It automatically converts the index to a Hash index.
D) It compresses the data automatically.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Sequential inserts append data to the end of the B-Tree, significantly reducing random I/O and page splits compared to inserting random values (like UUIDs).
</details>

**Q11. Which MySQL storage engine supports native, explicit Hash indexes?**
A) InnoDB
B) MyISAM
C) MEMORY
D) CSV

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The MEMORY and NDB Cluster storage engines support explicit native Hash indexes. InnoDB does not support explicit Hash indexes (only the internal Adaptive Hash Index).
</details>

**Q12. What is the average time complexity for an exact match lookup using a Hash index?**
A) O(log N)
B) O(N)
C) O(1)
D) O(N^2)

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Hash indexes compute a hash of the search key to find the exact memory location, resulting in a highly efficient O(1) time complexity for exact matches.
</details>

**Q13. Which of the following query operators can effectively utilize a Hash index?**
A) `>`
B) `<`
C) `BETWEEN`
D) `=`

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Hash indexes only support exact match lookups (`=`, `IN`, `<=>`). They do not support range queries.
</details>

**Q14. What is the InnoDB Adaptive Hash Index (AHI)?**
A) A user-created Hash index for fast lookups.
B) An in-memory hash table built automatically by InnoDB for frequently accessed B-Tree pages.
C) A backup mechanism for the primary key.
D) A feature that hashes passwords for security.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The AHI is an internal feature where InnoDB automatically monitors index searches and builds in-memory hash indexes for frequently accessed pages to speed up lookups.
</details>

**Q15. What happens if you try to explicitly create a `HASH` index on an InnoDB table using `CREATE INDEX ... USING HASH`?**
A) The query fails with a syntax error.
B) A native Hash index is successfully created.
C) MySQL silently converts it to a B-Tree index.
D) The table is automatically converted to the MEMORY engine.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB does not support user-defined Hash indexes. If you specify `USING HASH`, InnoDB silently ignores it and creates a B-Tree index instead.
</details>

**Q16. Can a Hash index be used to optimize an `ORDER BY` clause?**
A) Yes, always.
B) Yes, if the query includes a `LIMIT`.
C) No, because Hash indexes do not store elements in a sorted order.
D) No, because `ORDER BY` is only for clustered indexes.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Hash functions randomize the distribution of data, so elements are not stored in any sorted sequence. Thus, they cannot be used to avoid sorting operations.
</details>

**Q17. Can a Hash index be used for partial key matching (e.g., matching only the first column of a two-column index)?**
A) Yes, just like B-Tree indexes.
B) Yes, if the first column is numeric.
C) No, a Hash index requires the full key to compute the hash value.
D) No, composite Hash indexes are not allowed in MySQL.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** To find a match in a Hash index, the entire index key must be provided to compute the same hash value. Leftmost prefixing does not apply.
</details>

**Q18. When does the performance of a Hash index severely degrade?**
A) When there is a high rate of hash collisions (many duplicate values).
B) When the table has no primary key.
C) When the table has fewer than 10,000 rows.
D) When the memory buffer is flushed to disk.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** High hash collisions mean multiple keys map to the same hash bucket, forcing the database to linearly scan a linked list within that bucket, degrading performance to O(N).
</details>

**Q19. How can you disable the InnoDB Adaptive Hash Index in MySQL 8.0 if it causes heavy latch contention?**
A) `SET GLOBAL innodb_adaptive_hash_index = OFF;`
B) `DROP INDEX ahi ON innodb_tables;`
C) `ALTER TABLE tbl DISABLE HASH;`
D) It cannot be disabled in MySQL 8.0.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The AHI can be disabled dynamically by setting the system variable `innodb_adaptive_hash_index` to `OFF`.
</details>

**Q20. If you do not specify an index type when creating an index on a MEMORY table, which type is used by default?**
A) B-Tree
B) Hash
C) R-Tree
D) Full-Text

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The MEMORY storage engine uses Hash indexes by default, though it also supports B-Tree indexes if explicitly requested.
</details>

**Q21. What does the term "SARGable" mean in database performance tuning?**
A) Sequential And Random Gathering
B) Search Argument Able
C) System Architecture Re-generation
D) Standard Algorithm Routine

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SARGable stands for "Search Argument Able", meaning the database engine can utilize an index to execute the query instead of performing a table scan.
</details>

**Q22. Which of the following `WHERE` clauses is SARGable (assuming `last_name` is indexed)?**
A) `WHERE UPPER(last_name) = 'SMITH'`
B) `WHERE REVERSE(last_name) = 'htims'`
C) `WHERE last_name = 'Smith'`
D) `WHERE LEFT(last_name, 3) = 'Smi'`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Applying a function to the indexed column (`UPPER`, `REVERSE`, `LEFT`) generally prevents the optimizer from using the index, rendering it non-SARGable. Only C compares the raw column to a literal.
</details>

**Q23. Which `LIKE` condition is SARGable?**
A) `LIKE '%smith'`
B) `LIKE '%smith%'`
C) `LIKE 'smith%'`
D) `LIKE '_mith'`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A trailing wildcard (`smith%`) allows the B-Tree index to match the known prefix. Leading wildcards (`%` or `_`) prevent index traversal because the starting characters are unknown.
</details>

**Q24. Is a mathematical operation on an indexed column SARGable? (e.g., `WHERE salary * 2 > 100000`)**
A) Yes, MySQL calculates the result during the index traversal.
B) No, performing arithmetic on the column prevents index usage.
C) Yes, if the index is a Hash index.
D) No, unless it is an equality check.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Modifying the column side of an equation prevents index usage. It should be rewritten to isolate the column: `WHERE salary > 100000 / 2`.
</details>

**Q25. How should you rewrite `WHERE YEAR(order_date) = 2023` to make it SARGable?**
A) `WHERE order_date = '2023'`
B) `WHERE order_date >= '2023-01-01' AND order_date <= '2023-12-31'`
C) `WHERE DATE_FORMAT(order_date, '%Y') = '2023'`
D) `WHERE order_date LIKE '2023%'`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** B converts the condition into a pure range comparison against the raw `order_date` column, allowing the optimizer to use an index on `order_date`.
</details>

**Q26. Does MySQL allow the use of indexes for `IS NULL` checks?**
A) Yes, MySQL indexes `NULL` values and can use an index for `IS NULL` queries.
B) No, `NULL` values are excluded from indexes in MySQL.
C) Yes, but only on primary keys.
D) No, `IS NULL` always triggers a full table scan.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Unlike some other database systems, MySQL's B-Tree indexes store `NULL` values, and the optimizer can efficiently resolve `IS NULL` using an index.
</details>

**Q27. You have a `VARCHAR(50)` indexed column named `phone_number`. Why might `WHERE phone_number = 1234567890` trigger a full table scan?**
A) Numbers cannot be searched in a `VARCHAR` column.
B) The index is ignored due to implicit type conversion (casting string to integer).
C) The number is too large for a `VARCHAR(50)`.
D) B-Tree indexes do not support numbers.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Providing a numeric literal against a string column causes MySQL to implicitly convert the string column to numbers for comparison, nullifying SARGability and bypassing the index.
</details>

**Q28. Which of the following query types allows the query optimizer to perform an Index Seek?**
A) A non-SARGable query
B) A SARGable query
C) A query using a leading wildcard
D) A query selecting all rows without a WHERE clause

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** SARGable queries are structured in a way that allows the optimizer to perform an efficient index seek (traversing the tree) rather than scanning the table.
</details>

**Q29. What happens if a query uses the `!=` or `<>` operator on an indexed column?**
A) It always performs an exact index seek.
B) It results in an error.
C) It often results in a full table scan or index scan, as it must read all rows except the match.
D) It converts the query to a Hash index automatically.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Inequality operators (`!=`, `<>`) generally match a massive portion of the dataset. Because reading most of the table via random I/O (index lookups) is expensive, the optimizer typically degrades to a full table scan.
</details>

**Q30. You want to match names that sound like "John" using the `SOUNDEX()` function. Can `WHERE SOUNDEX(first_name) = SOUNDEX('John')` use an index on `first_name`?**
A) Yes, if the index is a Full-Text index.
B) No, because wrapping `first_name` in a function breaks SARGability.
C) Yes, `SOUNDEX` is explicitly optimized by B-Tree indexes.
D) Yes, if the column is a `CHAR` data type.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Using `SOUNDEX()` on the column changes its value before evaluation, meaning MySQL must calculate the soundex of every row, preventing index use. (A generated column index could solve this).
</details>

**Q31. In a MySQL `EXPLAIN` plan, which `type` indicates that a full table scan is being performed?**
A) `index`
B) `ALL`
C) `range`
D) `ref`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ALL` join type indicates a full table scan, meaning MySQL must examine every row in the table from start to finish.
</details>

**Q32. What does the `type` of `const` or `system` mean in an `EXPLAIN` output?**
A) The table has zero rows.
B) The query uses a non-unique index.
C) The table has at most one matching row, fetched using a primary key or unique index.
D) The query is using a constant expression that cannot be optimized.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `const` indicates that MySQL can evaluate the row early and treat it as a constant because it was matched exactly on a Primary Key or Unique Index.
</details>

**Q33. What information does the `possible_keys` column provide in the `EXPLAIN` output?**
A) The indexes that MySQL actually decided to use.
B) The indexes that the optimizer considered utilizing to find rows in the table.
C) The primary keys of the joined tables.
D) The list of all indexes present on the table.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `possible_keys` lists the indexes the MySQL query optimizer deemed potentially applicable to the query. 
</details>

**Q34. In an `EXPLAIN` plan, what does the `key` column represent?**
A) The primary key of the table.
B) The index that MySQL actually decided to use for the query.
C) The number of key comparisons made.
D) A boolean indicating if an index was used.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While `possible_keys` shows what could be used, the `key` column displays the specific index the optimizer ultimately selected. If `NULL`, no index was used.
</details>

**Q35. What does the `rows` column represent in a MySQL `EXPLAIN` output?**
A) The exact number of rows that will be returned by the query.
B) The number of rows in the entire table.
C) The optimizer's estimate of the number of rows it must examine to execute the query.
D) The maximum number of rows allowed by the `LIMIT` clause.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `rows` is an estimate (based on index statistics) of how many rows MySQL believes it must examine, not the final result set size.
</details>

**Q36. What does an `EXPLAIN` type of `ref` signify?**
A) A unique index lookup.
B) A non-unique index or a left-most prefix of an index is being used to find rows.
C) A full index scan.
D) An external reference to another database.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `ref` indicates that an index is being used, but it is not unique (or it's a composite index prefix). It may return multiple rows matching the lookup value.
</details>

**Q37. What does the `filtered` column in `EXPLAIN` indicate?**
A) The estimated percentage of table rows that will be filtered out by table conditions.
B) The exact number of rows removed by the `WHERE` clause.
C) The estimated percentage of the examined rows that will satisfy the query condition.
D) The ratio of indexed columns to total columns.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The `filtered` column shows an estimated percentage of rows (from the `rows` column) that match the condition. 100% means no additional filtering was needed beyond the index.
</details>

**Q38. In the `Extra` column of an `EXPLAIN` result, what does `Using index` mean?**
A) The query is using an index to sort the data.
B) The query is a Covering Index scan; the data was retrieved entirely from the index tree without looking up the actual data rows.
C) MySQL created a temporary index to resolve the query.
D) The query is using the primary key.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `Using index` signifies a Covering Index. The index contains all the columns requested by the query, eliminating the need to read the table data (the clustered index).
</details>

**Q39. What does `Using filesort` imply in the `EXPLAIN` `Extra` column?**
A) MySQL is sorting data by reading and writing files to the disk exclusively.
B) MySQL cannot use an index to resolve an `ORDER BY` and must perform a separate sorting operation (which may happen in memory or on disk).
C) The table data is stored sequentially in a file.
D) The query is fetching data from a `FILE` storage engine.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `Using filesort` means MySQL must do an extra pass to sort the result set because the requested order did not match the index order. It does not strictly mean it hit the disk; small sorts happen in memory.
</details>

**Q40. When `EXPLAIN` shows `Using temporary` in the `Extra` column, what is happening?**
A) MySQL is using a temporary index structure.
B) MySQL has to create a temporary table to hold intermediate results, typically to resolve `GROUP BY` or `ORDER BY`.
C) The query is reading from a `#temp` table.
D) The memory buffer is temporarily full.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `Using temporary` indicates that MySQL must create an internal temporary table (in memory or on disk) while processing the query, which can be a performance bottleneck.
</details>

**Q41. In what scenario is the query optimizer most likely to choose a Full Table Scan (type `ALL`) over an Index Seek?**
A) When retrieving a single row by primary key.
B) When the query estimates it will return a very large percentage of the table's rows.
C) When the index is a clustered index.
D) When the table has more than 10 million rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If an index seek requires reading a large portion of the table, the random I/O generated by fetching rows from the clustered index is more expensive than simply reading the table sequentially (Full Table Scan).
</details>

**Q42. Why might a full table scan be faster than an index seek on a very small table (e.g., 50 rows)?**
A) Small tables cannot have indexes.
B) Index pages are heavily compressed on small tables.
C) The overhead of traversing the index tree and looking up the data page exceeds the cost of just reading the single data page directly.
D) B-Tree indexes are disabled for tables under 100 rows.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** For very small tables, the entire table data fits on one or two pages. Scanning those pages sequentially is cheaper than parsing the index tree and making secondary lookups.
</details>

**Q43. What is an Index Seek (or Index Lookup)?**
A) Scanning the entire leaf level of an index.
B) Searching linearly through a table to find an index.
C) Traversing the B-Tree structure from the root node down to the leaf node to find a specific key value.
D) Creating an index dynamically during query execution.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** An Index Seek specifically involves traversing the tree structure to quickly pinpoint the leaf node containing the desired value.
</details>

**Q44. How does a Full Index Scan (EXPLAIN type `index`) differ from a Full Table Scan (EXPLAIN type `ALL`)?**
A) There is no difference; they are synonymous.
B) A full index scan reads all index entries sequentially instead of reading the table's data pages.
C) A full index scan is faster because it uses multiple CPU threads.
D) A full table scan only reads the primary keys.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `type: index` means the query engine scans the entire index tree instead of the data pages. It is generally faster than `ALL` if the index is smaller than the full table, especially if it's a covering index.
</details>

**Q45. Why is a secondary index lookup often associated with random I/O in InnoDB?**
A) Secondary indexes are stored in a randomized order.
B) The secondary index only provides the Primary Key, requiring a separate lookup in the clustered index (data pages) which may be scattered on disk.
C) InnoDB uses Hash functions for secondary indexes.
D) Disk drives randomize block access for secondary indexes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Once the secondary index yields a Primary Key, the engine must perform a "bookmark lookup" to the clustered index to fetch the rest of the row, leading to random disk I/O if pages are not in memory.
</details>

**Q46. What does creating a "Covering Index" prevent?**
A) Deadlocks during `INSERT` operations.
B) Page splits in the root node.
C) Lookups to the clustered index (table data), eliminating random I/O.
D) Full index scans.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A covering index includes all the columns needed for a `SELECT` query, meaning the secondary index has everything required, completely bypassing the clustered index lookup.
</details>

**Q47. If an indexed column has a low cardinality (e.g., a "gender" column with only 3 distinct values), how might the optimizer handle a `WHERE` condition on it?**
A) It will perform an extremely fast index seek.
B) It will likely ignore the index and perform a full table scan due to low selectivity.
C) It will throw an index optimization error.
D) It will automatically convert the index to a Hash index.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Low cardinality indexes have poor selectivity. Querying for a value might return 33% of the table. The optimizer determines that a sequential table scan is cheaper than millions of random I/O index lookups.
</details>

**Q48. How is "Selectivity" defined in the context of indexes?**
A) The number of columns in an index.
B) The size of the index divided by the size of the table.
C) The number of distinct values in the indexed column(s) divided by the total number of rows.
D) The number of queries that use the index.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Selectivity is the ratio of unique values to total rows. A highly selective index (like an Email address or UUID) is very efficient for lookups.
</details>

**Q49. In InnoDB, why is scanning the clustered index functionally equivalent to a Full Table Scan?**
A) Because clustered indexes do not have leaf nodes.
B) Because InnoDB ignores clustered indexes during `SELECT` queries.
C) Because the clustered index leaf nodes physically contain the entire table row data.
D) Because clustered indexes are Hash-based.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In InnoDB, the table IS the clustered index. Scanning the leaf level of the clustered index means scanning every row of data in the table.
</details>

**Q50. An index seek on a composite index `(col_a, col_b, col_c)` can only be optimally performed if the `WHERE` clause adheres to which rule?**
A) The Highest Cardinality rule.
B) The Leftmost Prefix rule.
C) The Rightmost Suffix rule.
D) The Covering rule.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To traverse a composite B-Tree index, the query must use the columns starting from the leftmost side (`col_a`, then `col_b`, etc.) without skipping columns.
</details>

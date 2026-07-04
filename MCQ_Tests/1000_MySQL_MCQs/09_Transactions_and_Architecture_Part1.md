# MySQL 8.0 Transactions and Architecture - Part 1

**Q1. Which of the following best describes the 'Atomicity' property in MySQL's ACID model?**
A) Transactions can be broken down into smaller, independent sub-transactions that commit separately.
B) All operations within a transaction are completed successfully, or none of them are applied to the database.
C) Data is always written to disk immediately after every individual statement.
D) Transactions do not interfere with each other during concurrent execution.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Atomicity ensures that a transaction is treated as a single, indivisible logical unit of work.
</details>

**Q2. What does 'Consistency' ensure in the context of MySQL transactions?**
A) Data read by a transaction is always the most recent data written.
B) A transaction brings the database from one valid state to another valid state, maintaining all constraints and rules.
C) Concurrent transactions execute serially.
D) Transactions survive system crashes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Consistency means that after a transaction completes, all database rules like foreign keys and constraints are intact.
</details>

**Q3. In MySQL InnoDB, which ACID property ensures that the uncommitted changes of one transaction are hidden from other concurrent transactions?**
A) Atomicity
B) Consistency
C) Isolation
D) Durability

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Isolation prevents transactions from interfering with each other's uncommitted data.
</details>

**Q4. How does InnoDB primarily guarantee the 'Durability' property of ACID in MySQL?**
A) By keeping all data in the buffer pool indefinitely.
B) By writing changes to the redo log and flushing them to disk upon commit.
C) By locking all tables during a transaction.
D) By disabling caching at the OS level.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Durability is ensured by the redo log (Write-Ahead Logging), which guarantees data survives crashes.
</details>

**Q5. Which MySQL storage engine provides full support for ACID-compliant transactions?**
A) MyISAM
B) MEMORY
C) ARCHIVE
D) InnoDB

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** InnoDB is the default MySQL storage engine and provides full ACID compliant transaction support.
</details>

**Q6. If a power failure occurs immediately after a COMMIT command completes in an InnoDB database, what guarantees the data is saved?**
A) Atomicity
B) Consistency
C) Isolation
D) Durability

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Durability guarantees that once a transaction has been committed, it will remain committed even in the case of a system failure.
</details>

**Q7. Which ACID property is directly violated if a 'Dirty Read' occurs?**
A) Atomicity
B) Consistency
C) Isolation
D) Durability

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** A dirty read happens when a transaction reads uncommitted data from another transaction, violating Isolation.
</details>

**Q8. Which MySQL component is largely responsible for enforcing the Atomicity of a transaction when a ROLLBACK occurs?**
A) Redo log
B) Undo log
C) Binary log
D) General query log

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The undo log contains the necessary information to reverse modifications made by uncommitted transactions, ensuring Atomicity.
</details>

**Q9. In an InnoDB cluster or replication setup, what log helps ensure Consistency across different nodes?**
A) Undo log
B) Redo log
C) Binary log (Binlog)
D) Error log

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The Binary log contains events that describe database changes and is used for replication to ensure consistency across nodes.
</details>

**Q10. What does the `innodb_flush_log_at_trx_commit` variable control regarding ACID properties?**
A) It strictly controls Atomicity.
B) It dictates the level of Durability vs Performance.
C) It enforces the Isolation level.
D) It manages Consistency constraint checks.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This variable determines how often redo logs are flushed to disk, balancing strict Durability with I/O performance.
</details>

**Q11. Which SQL command is used to explicitly start a new transaction in MySQL?**
A) START TRANSACTION
B) BEGIN WORK
C) BEGIN
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** `START TRANSACTION`, `BEGIN`, and `BEGIN WORK` are all valid syntax to initiate a transaction in MySQL.
</details>

**Q12. By default, how does MySQL handle transactions for individual DML statements if no explicit `START TRANSACTION` is issued?**
A) It waits for an explicit COMMIT.
B) It rolls back the statement automatically.
C) It operates in autocommit mode, committing each statement immediately.
D) It groups them into batches of 100.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL has autocommit enabled by default, meaning every single SQL statement is treated as a separate, self-committing transaction.
</details>

**Q13. How can you disable autocommit mode for the current session?**
A) SET SESSION autocommit = 0;
B) SET GLOBAL autocommit = OFF;
C) DISABLE AUTOCOMMIT;
D) START TRANSACTION disables it permanently.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `SET SESSION autocommit = 0;` disables autocommit for the current session until it is re-enabled.
</details>

**Q14. What happens if you execute a DDL statement (like `ALTER TABLE`) inside an active transaction?**
A) The DDL statement is rolled back when the transaction is rolled back.
B) The active transaction is implicitly committed before the DDL statement executes.
C) MySQL throws a syntax error.
D) The DDL statement waits until the transaction is explicitly committed.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DDL statements cause an implicit commit in MySQL, immediately saving any pending transaction data.
</details>

**Q15. Which of the following commands will NOT cause an implicit commit?**
A) CREATE TABLE
B) TRUNCATE TABLE
C) INSERT INTO
D) DROP DATABASE

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `INSERT INTO` is a DML statement and does not cause an implicit commit, unlike DDL statements.
</details>

**Q16. What does the `COMMIT` command do?**
A) Reverts all changes made in the current transaction.
B) Saves all changes made in the current transaction permanently to the database.
C) Restarts the transaction from the beginning.
D) Unlocks all tables for read-only access.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `COMMIT` finalizes the transaction, making all data modifications permanent and visible to other transactions.
</details>

**Q17. If a transaction encounters an error halfway through a series of INSERT statements, what happens by default?**
A) The entire transaction is rolled back automatically.
B) The successful INSERTs remain uncommitted, and you must explicitly ROLLBACK or COMMIT.
C) The successful INSERTs are automatically committed.
D) MySQL retries the failed statement automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Unless the error is a deadlock or lock wait timeout, InnoDB generally does not roll back the entire transaction automatically; the application must issue a ROLLBACK.
</details>

**Q18. What is a 'Savepoint' in MySQL transactions?**
A) A complete backup of the database taken during a transaction.
B) A named marker within a transaction that allows partial rollback to that specific point.
C) A lock placed on a row to prevent other transactions from modifying it.
D) A temporary table used to store intermediate transaction results.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Savepoints allow you to roll back part of a transaction without aborting the entire transaction.
</details>

**Q19. How do you create a savepoint named 'sp1' in MySQL?**
A) CREATE SAVEPOINT sp1;
B) SAVEPOINT sp1;
C) BEGIN SAVEPOINT sp1;
D) MARK SAVEPOINT sp1;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The correct syntax is `SAVEPOINT identifier;`.
</details>

**Q20. How do you roll back a transaction to a previously created savepoint named 'sp1'?**
A) ROLLBACK TO sp1;
B) ROLLBACK SAVEPOINT sp1;
C) UNDO TO sp1;
D) REVERT TO sp1;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `ROLLBACK TO [SAVEPOINT] identifier` (or just `ROLLBACK TO sp1`) reverts changes made after the savepoint.
</details>

**Q21. What happens to savepoints created after a specific savepoint 'sp1' if you execute `ROLLBACK TO sp1;`?**
A) They are preserved and can still be rolled back to.
B) They are deleted and become invalid.
C) They are automatically committed.
D) They are converted into global variables.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Rolling back to a savepoint destroys any savepoints that were established after that savepoint.
</details>

**Q22. What command is used to remove a savepoint without rolling back the transaction?**
A) DROP SAVEPOINT sp1;
B) DELETE SAVEPOINT sp1;
C) RELEASE SAVEPOINT sp1;
D) REMOVE SAVEPOINT sp1;

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `RELEASE SAVEPOINT identifier;` removes the named savepoint from the current transaction.
</details>

**Q23. Does releasing a savepoint commit the changes made up to that savepoint?**
A) Yes, it permanently saves the data.
B) No, it only destroys the savepoint marker.
C) Yes, but only for MyISAM tables.
D) No, it rolls back the changes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Releasing a savepoint merely deletes the marker; the transaction as a whole is still pending and must be committed.
</details>

**Q24. If you execute a `START TRANSACTION` command while another transaction is already active in the same session, what happens?**
A) MySQL throws an error.
B) A nested transaction is created.
C) The active transaction is implicitly committed, and a new one starts.
D) The new transaction is ignored until the first one completes.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MySQL does not support true nested transactions. Starting a new one implicitly commits the current one.
</details>

**Q25. Which variable can be checked to see if autocommit is currently enabled?**
A) @@autocommit
B) @@transaction_status
C) @@commit_mode
D) @@auto_commit_state

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** You can check the session variable using `SELECT @@autocommit;`.
</details>

**Q26. When a client disconnects from MySQL without issuing a COMMIT or ROLLBACK for an active transaction, what does MySQL do?**
A) It commits the transaction automatically.
B) It rolls back the transaction.
C) It keeps the transaction open in a 'detached' state.
D) It prompts the client to reconnect.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL automatically rolls back any active transaction when a client connection terminates ungracefully or without a commit.
</details>

**Q27. What is a key architectural difference between InnoDB and MyISAM regarding locks?**
A) InnoDB uses table-level locking, MyISAM uses row-level locking.
B) InnoDB uses row-level locking, MyISAM uses table-level locking.
C) Both use row-level locking.
D) Neither uses locking.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB's row-level locking provides high concurrency, while MyISAM locks the entire table during writes.
</details>

**Q28. Which storage engine supports Foreign Key constraints?**
A) MEMORY
B) MyISAM
C) ARCHIVE
D) InnoDB

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** InnoDB enforces referential integrity via Foreign Key constraints, which MyISAM does not support.
</details>

**Q29. If an application requires full ACID compliance and crash recovery, which storage engine is the required choice?**
A) InnoDB
B) MyISAM
C) MEMORY
D) CSV

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** InnoDB is designed for crash recovery and transaction safety, making it the standard choice for ACID requirements.
</details>

**Q30. In older versions of MySQL, MyISAM was preferred for what specific feature that InnoDB lacked (prior to MySQL 5.6)?**
A) Row-level locking
B) Foreign keys
C) Full-text search indexing
D) Spatial data types

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Before MySQL 5.6, InnoDB did not support FULLTEXT indexes, making MyISAM the primary choice for full-text search.
</details>

**Q31. How does MyISAM handle a system crash during a write operation?**
A) It automatically recovers the data using undo logs.
B) It replays the redo log to reconstruct the table.
C) It is prone to table corruption and may require manual repair (REPAIR TABLE).
D) It seamlessly ignores the failed write.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MyISAM does not have crash recovery mechanisms like transaction logs, making it vulnerable to corruption during crashes.
</details>

**Q32. Which of the following is an advantage of MyISAM over InnoDB?**
A) Better write concurrency.
B) Lower disk space and memory footprint for simple read-heavy tables.
C) Automatic crash recovery.
D) Support for savepoints.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MyISAM generally has a smaller storage footprint and lower memory overhead since it doesn't maintain transaction logs or complex buffer pools.
</details>

**Q33. Where does InnoDB store its data and indexes by default?**
A) In `.MYD` and `.MYI` files.
B) In the system tablespace (ibdata1) or file-per-table `.ibd` files.
C) Only in memory.
D) In `.frm` files.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB uses tablespaces (`ibdata1` or `.ibd`), whereas MyISAM uses `.MYD` for data and `.MYI` for indexes.
</details>

**Q34. What is the InnoDB Buffer Pool?**
A) A space on disk where temporary tables are stored.
B) A memory area where InnoDB caches table and index data as it is accessed.
C) A log file used to record long-running queries.
D) A pool of worker threads processing queries.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The Buffer Pool is a crucial memory area that caches frequently accessed data and indexes for high performance.
</details>

**Q35. Which engine supports concurrent inserts (inserting rows while SELECTs are reading the table) under certain conditions?**
A) InnoDB
B) MyISAM
C) MEMORY
D) Both A and B

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** InnoDB supports concurrent inserts naturally via MVCC and row locking, while MyISAM supports it via a feature called concurrent inserts if there are no holes in the data file.
</details>

**Q36. If a table consists entirely of static, read-only data, which engine historically provided slightly faster read performance for simple queries?**
A) InnoDB
B) MyISAM
C) BLACKHOLE
D) CSV

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Due to minimal overhead, MyISAM was often slightly faster for pure read-only, non-concurrent workloads, though InnoDB has closed this gap in modern versions.
</details>

**Q37. In MySQL 8.0, what is the default storage engine?**
A) MyISAM
B) MEMORY
C) InnoDB
D) NDBCLUSTER

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB has been the default storage engine since MySQL 5.5.
</details>

**Q38. Which engine is best suited for high-volume, concurrent read/write OLTP workloads?**
A) InnoDB
B) MyISAM
C) ARCHIVE
D) CSV

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** InnoDB's row-level locking, transactions, and MVCC make it ideal for high-concurrency OLTP environments.
</details>

**Q39. What does the `SHOW ENGINE INNODB STATUS;` command do?**
A) Changes the default engine to InnoDB.
B) Displays extensive internal information about the InnoDB engine, such as deadlocks, locks, and buffer pool usage.
C) Repairs a corrupted InnoDB table.
D) Flushes the InnoDB redo logs to disk.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** It provides a detailed snapshot of the engine's internal state, useful for performance tuning and debugging deadlocks.
</details>

**Q40. How is table metadata stored in MySQL 8.0?**
A) In `.frm` files for each table.
B) In the global Data Dictionary stored within InnoDB tables.
C) In the Windows registry or Linux `/etc/` directory.
D) In `.MYM` files.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0 eliminated `.frm` files and moved table metadata into a transactional Data Dictionary backed by InnoDB.
</details>

**Q41. What is the Doublewrite Buffer in InnoDB architecture?**
A) A buffer that writes data to two different hard drives for backup.
B) A storage area where pages are written before being written to the actual data files, preventing partial page writes during crashes.
C) A replication feature that writes to both master and slave simultaneously.
D) A buffer that caches two copies of the same index for faster lookups.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The doublewrite buffer ensures data integrity by preventing torn pages if a crash occurs midway through writing a 16KB page to disk.
</details>

**Q42. Which file extension represents a MyISAM data file?**
A) .MYI
B) .ibd
C) .MYD
D) .sdi

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `.MYD` stands for MyISAM Data. `.MYI` is the index file.
</details>

**Q43. Can a single MySQL database contain both InnoDB and MyISAM tables?**
A) No, a database must use one engine exclusively.
B) Yes, engines are specified at the table level.
C) Yes, but only in MySQL 5.7 and older.
D) No, the engine is set globally at the server level.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL's pluggable storage engine architecture allows different tables in the same database to use different storage engines.
</details>

**Q44. Which mechanism does InnoDB use to manage concurrent access to data without locking the entire table for reads?**
A) Table-level Read Locks
B) Mutexes
C) Multi-Version Concurrency Control (MVCC)
D) Spinlocks

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** MVCC allows InnoDB to present consistent snapshots of data to read operations without blocking concurrent write operations.
</details>

**Q45. If you need to convert an existing MyISAM table to InnoDB, which command should you use?**
A) CONVERT TABLE my_table TO InnoDB;
B) ALTER TABLE my_table ENGINE=InnoDB;
C) CHANGE ENGINE my_table InnoDB;
D) MODIFY TABLE my_table TYPE=InnoDB;

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The `ALTER TABLE ... ENGINE = ...` syntax changes a table's storage engine.
</details>

**Q46. What feature of InnoDB automatically optimizes query execution by building hash indexes in memory on heavily used index pages?**
A) Buffer Pool
B) Adaptive Hash Index (AHI)
C) Change Buffer
D) Doublewrite Buffer

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The Adaptive Hash Index creates memory-based hash indexes on frequently accessed B-Tree pages for O(1) lookups.
</details>

**Q47. What is the purpose of the InnoDB Change Buffer (formerly Insert Buffer)?**
A) To cache changes made to secondary indexes to reduce random I/O when the relevant pages are not in the buffer pool.
B) To cache changes to primary keys.
C) To buffer binary log events before sending them to replicas.
D) To buffer undo logs before committing.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** The Change Buffer improves write performance by deferring updates to non-unique secondary indexes until the pages are loaded into memory.
</details>

**Q48. MyISAM stores the total row count of a table in its metadata. How does InnoDB determine the table's row count for a `SELECT COUNT(*) FROM table;` query?**
A) It also reads it from metadata in O(1) time.
B) It scans the index or data pages to count the rows accurately for the current transaction's isolation level.
C) It approximates the count based on the buffer pool.
D) It relies on the operating system's file size.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because of MVCC, InnoDB does not keep a cached row count; it must scan the index to count rows visible to the specific transaction.
</details>

**Q49. What happens if a transaction in InnoDB modifies a row, but does not commit, and the system crashes?**
A) The change is permanently written and kept upon restart.
B) Crash recovery rolls back the uncommitted change using the undo log.
C) The entire table is marked as corrupted.
D) The row remains locked indefinitely after restart.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** During crash recovery, InnoDB applies redo logs to restore state, then uses undo logs to roll back any transactions that had not committed.
</details>

**Q50. Which MySQL isolation level is the default for InnoDB?**
A) READ UNCOMMITTED
B) READ COMMITTED
C) REPEATABLE READ
D) SERIALIZABLE

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** REPEATABLE READ is the default isolation level in MySQL InnoDB, preventing dirty and non-repeatable reads.
</details>

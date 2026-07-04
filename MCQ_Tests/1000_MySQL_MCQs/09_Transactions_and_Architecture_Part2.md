# MySQL 8.0 Transactions and Architecture - Part 2

**Q51. What does the READ UNCOMMITTED isolation level permit?**
A) Phantom reads only
B) Dirty reads, non-repeatable reads, and phantom reads
C) Non-repeatable reads and phantom reads
D) No anomalies

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** READ UNCOMMITTED is the lowest level and permits all concurrency anomalies, including reading uncommitted data from other transactions.
</details>

**Q52. What is a 'Dirty Read'?**
A) Reading a row that has been deleted by another committed transaction.
B) Reading uncommitted changes made by another active transaction.
C) Executing the same query twice and getting different results due to another transaction's commit.
D) Reading data from a corrupted table.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A dirty read occurs when Transaction A reads data modified by Transaction B before Transaction B has committed.
</details>

**Q53. Which isolation level prevents Dirty Reads but still allows Non-Repeatable Reads?**
A) READ UNCOMMITTED
B) READ COMMITTED
C) REPEATABLE READ
D) SERIALIZABLE

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** READ COMMITTED ensures a transaction only reads committed data, but another transaction can modify and commit changes to that data between reads, causing a non-repeatable read.
</details>

**Q54. What is a 'Non-Repeatable Read'?**
A) A transaction reads a row, and a concurrent transaction modifies or deletes that row and commits. When the first transaction reads the row again, it sees the changes.
B) A transaction reads data that has not yet been committed.
C) A transaction inserts new rows that match the WHERE clause of another transaction's query.
D) A read operation that fails due to a deadlock.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** It occurs when a transaction reads the same row twice but gets different data because another transaction committed an UPDATE or DELETE in the meantime.
</details>

**Q55. In the REPEATABLE READ isolation level in MySQL, how does InnoDB handle multiple reads of the same row within a single transaction?**
A) It establishes a lock on the row, blocking other transactions from reading.
B) It reads the most recent committed version of the row, even if modified after the transaction started.
C) It creates a snapshot at the first read, and all subsequent reads in the transaction see the data as it was at that time.
D) It forces the transaction to restart if the row is modified.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB uses MVCC to provide a consistent read view (snapshot) for the duration of the transaction in REPEATABLE READ.
</details>

**Q56. What is a 'Phantom Read'?**
A) Modifying a row that was already deleted.
B) A query returns a set of rows, but executing the same query later in the same transaction returns a different set of rows because another transaction inserted or deleted rows matching the condition.
C) A transaction reads a value that was rolled back by another transaction.
D) Reading a row that has a NULL primary key.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Phantom reads involve new "phantom" rows appearing (or rows disappearing) in result sets of range queries due to concurrent INSERTs/DELETEs.
</details>

**Q57. How does InnoDB prevent Phantom Reads in the REPEATABLE READ isolation level?**
A) By locking the entire table.
B) By using Next-Key Locks (a combination of record locks and gap locks).
C) It does not prevent Phantom Reads at all in this isolation level.
D) By disabling concurrent inserts.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Unlike the SQL standard which allows phantoms in Repeatable Read, InnoDB uses Next-Key locks to prevent other transactions from inserting into gaps, effectively preventing phantom reads.
</details>

**Q58. Which isolation level provides the highest level of data consistency by essentially executing transactions sequentially?**
A) READ UNCOMMITTED
B) READ COMMITTED
C) REPEATABLE READ
D) SERIALIZABLE

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** SERIALIZABLE is the strictest isolation level, effectively converting all plain SELECT statements into SELECT ... FOR SHARE, forcing sequential execution when conflicts occur.
</details>

**Q59. What is a significant drawback of using the SERIALIZABLE isolation level?**
A) High risk of dirty reads.
B) Massive reduction in concurrency and higher risk of deadlocks due to extensive locking.
C) It cannot be used with InnoDB.
D) Data corruption if the system crashes.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because it acquires locks on all accessed rows, it severely limits concurrent transactions from modifying data, leading to bottlenecks and deadlocks.
</details>

**Q60. How can you set the isolation level for the next transaction in the current session?**
A) SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
B) ALTER TRANSACTION LEVEL = READ COMMITTED;
C) MODIFY ISOLATION READ COMMITTED;
D) SET SESSION ISOLATION = READ COMMITTED;

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `SET TRANSACTION ISOLATION LEVEL [level]` sets the level for the next transaction. You can optionally prefix with SESSION or GLOBAL.
</details>

**Q61. What is MVCC in the context of MySQL architecture?**
A) Multi-Version Concurrency Control, a technique allowing concurrent reads and writes without locking.
B) MySQL Virtual Cluster Control, a load balancing tool.
C) Main Version Commit Control, ensuring atomicity.
D) Memory Variable Cache Controller, for buffer pool management.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** MVCC maintains multiple versions of a row to allow read operations to proceed without blocking write operations, and vice versa.
</details>

**Q62. Which two hidden columns does InnoDB add to each row to implement MVCC?**
A) ROW_ID and TRANSACTION_ID
B) DB_TRX_ID (Transaction ID) and DB_ROLL_PTR (Rollback Pointer)
C) CREATED_AT and UPDATED_AT
D) LOCK_ID and SESSION_ID

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** DB_TRX_ID indicates the last transaction that modified the row, and DB_ROLL_PTR points to the undo log record containing the previous version of the row.
</details>

**Q63. What is the role of the 'Undo Log' in MVCC?**
A) It stores the SQL statements executed for replication.
B) It stores older versions of rows, allowing transactions to reconstruct data as it existed at their start time.
C) It records crash recovery data.
D) It logs deadlocks and errors.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Undo logs provide the historical data needed for consistent reads (snapshots) and for rolling back uncommitted changes.
</details>

**Q64. What is a 'Deadlock' in MySQL?**
A) A transaction taking too long to execute and timing out.
B) A situation where two or more transactions are waiting for locks held by each other, creating a circular dependency.
C) A server crash due to memory exhaustion.
D) A locked table that prevents any queries from running.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A deadlock occurs when Transaction A waits on a lock held by B, and B waits on a lock held by A. Neither can proceed.
</details>

**Q65. How does InnoDB handle a detected deadlock?**
A) It waits indefinitely for the locks to be released.
B) It restarts both transactions.
C) It automatically detects the deadlock and rolls back one of the transactions (usually the one that modified fewer rows).
D) It crashes the database to prevent data corruption.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** InnoDB's deadlock detection mechanism automatically terminates one transaction to break the cycle and allow the other to proceed.
</details>

**Q66. What error code does MySQL return when a transaction is rolled back due to a deadlock?**
A) Error 1213 (Deadlock found when trying to get lock; try restarting transaction)
B) Error 1045 (Access denied)
C) Error 2006 (MySQL server has gone away)
D) Error 1064 (Syntax error)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Error 1213 is the standard InnoDB deadlock error.
</details>

**Q67. What happens if deadlock detection is disabled (`innodb_deadlock_detect = OFF`)?**
A) Deadlocks are impossible.
B) InnoDB relies solely on the `innodb_lock_wait_timeout` to break deadlocks by rolling back transactions that wait too long.
C) The server will hang indefinitely.
D) MySQL switches to table-level locking.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If detection is off, transactions will wait until the lock wait timeout is reached, then fail with a timeout error.
</details>

**Q68. Which of the following is a best practice for minimizing deadlocks in InnoDB?**
A) Always access tables and rows in the exact same order across all application transactions.
B) Keep transactions as long and complex as possible.
C) Use SERIALIZABLE isolation level exclusively.
D) Avoid using indexes.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Accessing resources in a consistent, defined order prevents circular wait conditions, a prerequisite for deadlocks.
</details>

**Q69. What type of lock is acquired when you execute `SELECT ... FOR UPDATE`?**
A) Shared Lock (S)
B) Exclusive Lock (X)
C) Intent Shared Lock (IS)
D) Gap Lock

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** An Exclusive Lock prevents other transactions from reading, updating, or deleting the locked rows until the transaction commits.
</details>

**Q70. What type of lock is acquired when you execute `SELECT ... FOR SHARE` (or `LOCK IN SHARE MODE`)?**
A) Shared Lock (S)
B) Exclusive Lock (X)
C) Intent Exclusive Lock (IX)
D) Metadata Lock (MDL)

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** A Shared Lock allows other transactions to read the rows but prevents them from modifying the rows until the lock is released.
</details>

**Q71. What is a 'Gap Lock' in InnoDB?**
A) A lock on an index record.
B) A lock placed on the gap between index records, or before the first/after the last index record, preventing insertions in those gaps.
C) A lock on the entire table.
D) A lock that prevents table deletion.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Gap locks are primarily used to prevent phantom reads by ensuring no new rows can be inserted into the ranges being scanned.
</details>

**Q72. In which isolation level are Gap Locks primarily active for standard queries?**
A) READ UNCOMMITTED
B) READ COMMITTED
C) REPEATABLE READ (and SERIALIZABLE)
D) They are active in all levels.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Gap locking is disabled for searches and index scans in READ COMMITTED, making it prone to phantom reads. It is heavily used in REPEATABLE READ.
</details>

**Q73. What is an 'Intention Lock' (IS or IX) in InnoDB?**
A) A lock placed on a row before it is deleted.
B) A table-level lock indicating that a transaction intends to acquire shared or exclusive row locks within that table.
C) A lock placed by the query optimizer before execution.
D) A lock indicating a transaction is about to commit.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Intention locks help InnoDB efficiently determine if a table-level lock (like ALTER TABLE) can be safely acquired without scanning all rows for existing locks.
</details>

**Q74. If Transaction A holds a Shared (S) lock on row 1, and Transaction B requests an Exclusive (X) lock on row 1, what happens?**
A) Transaction B gets the lock immediately, overriding A.
B) Transaction B is granted a Shared lock instead.
C) Transaction B must wait until Transaction A releases its Shared lock.
D) Transaction A is rolled back.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Shared locks and Exclusive locks are incompatible; the transaction requesting an X lock must wait for the S lock to be released.
</details>

**Q75. What command helps you view currently active transactions and locking information in MySQL 8.0?**
A) SELECT * FROM information_schema.innodb_trx;
B) SELECT * FROM performance_schema.data_locks;
C) SHOW ENGINE INNODB STATUS;
D) All of the above

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** All three commands can be used to diagnose active transactions and lock contention in MySQL 8.0.
</details>

**Q76. What is the 'Redo Log' primarily used for?**
A) Rolling back transactions.
B) Providing read snapshots for MVCC.
C) Crash recovery by replaying committed transactions that were not yet written to the data files.
D) Replication to slave servers.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The redo log stores physical changes to data pages, ensuring Durability in case of a crash before the buffer pool is flushed.
</details>

**Q77. How are undo logs managed in MySQL 8.0 compared to older versions?**
A) They are stored inside the ibdata1 file permanently.
B) They are stored in separate undo tablespaces that can be automatically truncated to reclaim disk space.
C) They are kept in RAM only.
D) They are written to the binary log.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL 8.0 separates undo logs into distinct tablespaces and supports automatic truncation to prevent them from growing indefinitely.
</details>

**Q78. What happens during a 'Purge' operation in InnoDB?**
A) Old redo logs are deleted.
B) The buffer pool is cleared from memory.
C) Background threads remove old undo log records and mark deleted rows for reuse once no active transaction needs to view that historical snapshot.
D) The query cache is flushed.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The purge thread cleans up old row versions and undo data that are no longer required for MVCC by any active transaction.
</details>

**Q79. What is a 'Consistent Non-Locking Read'?**
A) A read that locks all rows it encounters to ensure consistency.
B) A standard SELECT statement in InnoDB that uses MVCC to read a snapshot of the database without setting any locks.
C) A read that bypasses the buffer pool and reads directly from disk.
D) A read performed under the SERIALIZABLE isolation level.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This is the default read type for REPEATABLE READ and READ COMMITTED in InnoDB, allowing high concurrency.
</details>

**Q80. If an UPDATE statement doesn't use an index, how does InnoDB lock the rows?**
A) It only locks the rows that are updated.
B) It locks every row in the table (by locking all records it scans) because it must perform a full table scan.
C) It locks the table metadata.
D) It performs the update without any locks.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Without an index, InnoDB must scan the clustered index (table) sequentially and places a lock on every row it evaluates. The locks on non-matching rows are typically released afterward, but the scan limits concurrency heavily.
</details>

**Q81. What is the 'Clustered Index' in InnoDB?**
A) A secondary index created on multiple columns.
B) An index stored on a separate physical disk.
C) The primary key index, where the actual row data is stored in the leaf nodes of the B-tree.
D) A spatial index used for geographic data.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** In InnoDB, the table data is physically organized according to the primary key, which serves as the clustered index.
</details>

**Q82. How do secondary indexes relate to the clustered index in InnoDB?**
A) Secondary index leaf nodes contain the actual row data.
B) Secondary index leaf nodes contain a pointer to the physical disk block of the row.
C) Secondary index leaf nodes contain the primary key value of the row, which is then used to look up the full row in the clustered index.
D) Secondary indexes are independent and don't interact with the clustered index.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Secondary indexes store the primary key, requiring a "bookmark lookup" in the clustered index to retrieve non-indexed columns.
</details>

**Q83. What is an 'Index Condition Pushdown' (ICP)?**
A) Pushing the index to a slave server.
B) An optimization where the storage engine evaluates parts of the WHERE clause using index columns, reducing the number of full row lookups.
C) Compressing the index data to save space.
D) Forcing the query optimizer to use a specific index.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ICP allows InnoDB to filter out rows at the index level before retrieving the full row from the clustered index, saving I/O.
</details>

**Q84. What dictates how long a transaction will wait for a lock before giving up?**
A) `innodb_lock_wait_timeout`
B) `wait_timeout`
C) `interactive_timeout`
D) `max_execution_time`

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** This parameter defines the timeout in seconds (default 50) that an InnoDB transaction waits for a row lock.
</details>

**Q85. Does MySQL's `TRUNCATE TABLE` command operate differently under a transaction compared to `DELETE FROM`?**
A) No, both commands act the same and can be rolled back.
B) Yes, `TRUNCATE` is a DDL command, causes an implicit commit, and cannot be rolled back, while `DELETE` is DML and can be.
C) `TRUNCATE` uses row-level locking, while `DELETE` uses table-level locking.
D) `DELETE` resets the AUTO_INCREMENT counter, while `TRUNCATE` does not.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** `TRUNCATE` drops and recreates the table, which is a non-transactional DDL operation, whereas `DELETE` logs individual row deletions.
</details>

**Q86. Which tool or component handles writing dirty pages from the Buffer Pool to disk in the background?**
A) Page Cleaner threads
B) Purge threads
C) I/O threads (Read/Write)
D) Log writer thread

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Page cleaner threads flush modified (dirty) pages from the buffer pool to the data files asynchronously.
</details>

**Q87. What does the term 'Dirty Page' mean in the context of the InnoDB Buffer Pool?**
A) A page containing corrupted data.
B) A page that has been modified in memory but not yet written to disk.
C) A page containing uncommitted data.
D) A page that has been deleted.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A dirty page is an updated cache page that needs to be synchronized with the physical storage via flushing.
</details>

**Q88. If `innodb_flush_log_at_trx_commit` is set to 2, what is the behavior upon commit?**
A) The redo log buffer is written to the OS cache, and flushed to disk every second.
B) The redo log buffer is written and flushed to disk immediately (safest).
C) The redo log buffer is written to the OS cache every second.
D) No logging occurs.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Value 2 writes to the OS file system cache on commit, but syncs to disk once per second, offering better performance with a small risk of data loss on OS crash.
</details>

**Q89. How does `innodb_flush_log_at_trx_commit = 1` behave?**
A) It disables ACID properties.
B) It flushes the log buffer to the log file and syncs it to disk at each transaction commit.
C) It flushes logs only when the buffer pool is full.
D) It relies entirely on the OS cache.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** This is the default and safest setting, fully guaranteeing Durability at the cost of disk I/O overhead on every commit.
</details>

**Q90. In MySQL replication, what log must be enabled for a server to act as a Master?**
A) Undo log
B) Error log
C) Binary log (binlog)
D) Slow query log

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The binlog records all statements that change data, which replicas read and execute to stay synchronized.
</details>

**Q91. How do Transactions interact with the Binary Log?**
A) Changes are written to the binlog immediately as each statement executes.
B) Changes are buffered during the transaction and written to the binlog in one contiguous block upon commit.
C) The binlog only records DDL statements, not DML.
D) Transactions disable the binary log temporarily.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** To ensure replicas see transactions as atomic units, binlog events are cached per-session and written to the log file only at commit.
</details>

**Q92. What is Two-Phase Commit (2PC) in the context of a single MySQL instance?**
A) Requiring a user to type COMMIT twice.
B) A protocol used to coordinate the internal commit between the InnoDB storage engine and the Binary Log to ensure they remain consistent in case of a crash.
C) Committing data to two different tablespaces simultaneously.
D) A feature of the MyISAM engine.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** MySQL uses an internal XA 2PC to ensure the InnoDB redo log and the server's Binary Log are synchronized, avoiding split-brain scenarios on crash.
</details>

**Q93. What is a 'Record Lock' in InnoDB?**
A) A lock on the table metadata.
B) A lock on an index record, preventing other transactions from modifying or deleting that specific row.
C) A lock on an empty gap between rows.
D) A lock on a column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** A record lock applies to a specific index entry.
</details>

**Q94. What is a 'Next-Key Lock'?**
A) A lock placed on the next primary key value to be generated.
B) A combination of a Record Lock on an index record and a Gap Lock on the gap before that index record.
C) A lock that prevents the table from being dropped.
D) A mechanism to bypass locks for the next query.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Next-Key locks are the primary mechanism used in REPEATABLE READ to prevent phantom reads.
</details>

**Q95. If you execute `SELECT * FROM table WHERE unique_id = 5 FOR UPDATE;`, what type of lock is typically acquired?**
A) A Gap Lock on the gap before 5.
B) A Next-Key Lock.
C) A Record Lock exclusively on the index record for unique_id = 5.
D) A Table Lock.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When searching for a unique record using a unique index, InnoDB optimizes the lock down to a simple Record Lock instead of a Next-Key Lock.
</details>

**Q96. If you execute `SELECT * FROM table WHERE non_unique_column = 5 FOR UPDATE;`, what type of lock is typically acquired?**
A) Only a Record Lock.
B) A Next-Key Lock (Record Lock + Gap Lock) to prevent inserts of the value 5 by other transactions.
C) A Table Lock.
D) An Intention Shared Lock.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because the column is not unique, InnoDB must lock the matching records and the gaps around them to prevent phantom inserts.
</details>

**Q97. What does the `innodb_buffer_pool_size` parameter configure?**
A) The maximum size of an individual table.
B) The memory allocated for caching InnoDB data and indexes, critical for performance.
C) The maximum number of concurrent transactions.
D) The size of the undo log.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** It is the most important InnoDB performance tuning parameter, usually set to 50-80% of available RAM on a dedicated database server.
</details>

**Q98. What is the fundamental difference between optimistic and pessimistic locking strategies?**
A) Optimistic locking locks rows proactively, while pessimistic locking assumes no conflicts and checks upon update.
B) Pessimistic locking (like SELECT FOR UPDATE) locks rows when reading to prevent conflicts, while optimistic locking reads without locks and verifies data hasn't changed before updating.
C) Optimistic locking is used in MyISAM, pessimistic in InnoDB.
D) Optimistic locking causes deadlocks, pessimistic does not.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** InnoDB supports pessimistic locking natively. Optimistic locking is usually implemented at the application level using a version or timestamp column.
</details>

**Q99. When dealing with highly concurrent systems and deadlocks are frequent but unavoidable, what is the best application-level strategy?**
A) Disable InnoDB and switch to MyISAM.
B) Ignore deadlock errors.
C) Catch deadlock exceptions (Error 1213) in the application code and retry the transaction automatically.
D) Increase the lock wait timeout to 1 hour.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Deadlocks are a normal occurrence in highly concurrent databases; the application should be designed to gracefully catch the error and retry the transaction.
</details>

**Q100. Which system tablespace file historically contained the InnoDB data dictionary, doublewrite buffer, and undo logs (prior to MySQL 8.0)?**
A) ib_logfile0
B) my.cnf
C) ibdata1
D) auto.cnf

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** `ibdata1` is the shared system tablespace. MySQL 8.0 moved the dictionary and undo logs out of it, but it remains for the doublewrite buffer and change buffer in many setups.
</details>

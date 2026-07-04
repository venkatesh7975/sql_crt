# Optimization and Performance Cheat Sheet

---

## 1. Reading an EXPLAIN Plan

Prepend `EXPLAIN` to any `SELECT` query to see how the database optimizer intends to execute it.

```sql
EXPLAIN SELECT * FROM users WHERE email = 'test@test.com';
```

### Key Columns to Watch:
*   **`type`**: The access type.
    *   `ALL`: **Terrible.** Full Table Scan. Reading the entire hard drive.
    *   `index`: **Bad.** Full Index Scan. Scanning the whole B-Tree.
    *   `range`: **Good.** Scanning a specific chunk of the index (e.g., `BETWEEN` dates).
    *   `ref`: **Great.** Index Seek on a non-unique column.
    *   `eq_ref` / `const`: **Perfect.** Instant lookup via Primary Key or Unique Constraint.
*   **`possible_keys`**: Indexes the database *could* use.
*   **`key`**: The index the database *actually chose*. (If NULL, it's doing a full scan).
*   **`rows`**: An estimate of how many rows the database thinks it has to examine. Lower is better.

---

## 2. SARGability (Writing Index-Friendly Queries)

A query is SARGable (Search Argument Able) if the database can use an index to execute it. If you write non-SARGable queries, you force a Full Table Scan even if an index exists!

**Rule 1: No functions on the indexed column.**
*   ❌ Non-SARGable: `WHERE YEAR(created_at) = 2023`
*   ✅ SARGable: `WHERE created_at >= '2023-01-01' AND created_at < '2024-01-01'`

**Rule 2: No math on the indexed column.**
*   ❌ Non-SARGable: `WHERE salary * 1.10 > 100000`
*   ✅ SARGable: `WHERE salary > 100000 / 1.10`

**Rule 3: No leading wildcards in LIKE clauses.**
*   ❌ Non-SARGable: `WHERE last_name LIKE '%Smith'`
*   ✅ SARGable: `WHERE last_name LIKE 'Smith%'`

---

## 3. Creating and Managing Indexes

Indexes speed up read queries (`SELECT`) but slow down write queries (`INSERT`, `UPDATE`, `DELETE`) because the B-Tree must be updated on disk. Only index columns that are frequently used in `WHERE`, `JOIN`, or `ORDER BY` clauses.

```sql
-- Standard Secondary Index
CREATE INDEX idx_email ON users(email);

-- Composite Index (For queries that filter on both columns)
-- Rule of thumb: Put the most selective column first.
CREATE INDEX idx_last_first ON users(last_name, first_name);

-- Unique Index (Enforces uniqueness at the database level)
CREATE UNIQUE INDEX idx_ssn ON employees(ssn);

-- Drop Index
DROP INDEX idx_email ON users;
```

---

## 4. General Optimization Best Practices

1.  **Avoid `SELECT *`:** Only pull the columns you absolutely need to reduce network I/O and application memory usage.
2.  **Avoid The Fan-Out Trap:** Never `LEFT JOIN` multiple One-to-Many tables to the same base table without aggregating them first in a CTE. You will multiply the rows (Cartesian Explosion).
3.  **Use `UNION ALL` instead of `UNION`:** `UNION` forces a massive sorting operation to remove duplicates. If you know the data sets are mutually exclusive (or you don't care about duplicates), `UNION ALL` is instantly fast.
4.  **Use `EXISTS` instead of `IN` for subqueries:** While modern optimizers often fix this automatically, `WHERE EXISTS (SELECT 1...)` is traditionally much faster on large datasets than `WHERE id IN (SELECT id...)` because `EXISTS` can short-circuit and stop searching the moment it finds a single match.
5.  **Use Keyset Pagination:** If paginating a million rows, `LIMIT 10 OFFSET 900000` is incredibly slow because it has to read and discard 900,000 rows. Use Keyset Pagination instead: `WHERE id > 900000 LIMIT 10`.

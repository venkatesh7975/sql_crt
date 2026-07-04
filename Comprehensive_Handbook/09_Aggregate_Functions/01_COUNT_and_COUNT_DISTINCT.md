# COUNT and COUNT(DISTINCT)

---

## 1. What is an Aggregate Function?

Until now, every function we have used (like `UPPER()` or `ROUND()`) operates on a **single row** at a time. If you input 10 rows, you get 10 rows back.

**Aggregate Functions** are completely different. They take a *collection* of rows, perform a calculation across all of them, and smash them together to return a **single summarized value**.

---

## 2. The COUNT() Function

The `COUNT()` function simply counts the number of rows that match a specific criteria.

### COUNT(*) vs COUNT(column_name)
This is a critical distinction in SQL.

**`COUNT(*)`**: Counts the absolute total number of rows in the table (or the result set if there is a `WHERE` clause). It **includes** rows that have `NULL` values.
```sql
-- "How many total users exist in our database?"
SELECT COUNT(*) FROM users;
```

**`COUNT(column_name)`**: Counts the number of rows where that specific column is **NOT NULL**.
```sql
-- "How many users have provided a phone number?"
-- (If a user has a NULL phone_number, they are NOT counted).
SELECT COUNT(phone_number) FROM users;
```

---

## 3. COUNT(DISTINCT)

Often, you want to know the number of *unique* values in a column. 

If you want to know how many different cities your users live in, `COUNT(city)` might return 50,000, even if there are only 3 distinct cities in reality.

By adding the `DISTINCT` keyword *inside* the parenthesis, you force the database to deduplicate the values before counting them.

```sql
-- "How many unique cities are represented in our database?"
SELECT COUNT(DISTINCT city) FROM users;
```

---

## 4. Using COUNT with WHERE

Aggregate functions evaluate the rows *after* the `WHERE` clause has done its filtering.

```sql
-- "How many users live in New York?"
SELECT COUNT(*) 
FROM users 
WHERE city = 'New York';
```
*(Execution Order: The database finds all the 'New York' rows first, and then counts them).*

---

## 5. Interview Tips
*   **The Big Difference:** If an interviewer asks "What is the difference between `COUNT(*)` and `COUNT(name)`?", you must instantly reply: "`COUNT(*)` counts total rows including NULLs. `COUNT(name)` ignores NULLs and only counts rows where the name exists."
*   **Performance:** `COUNT(*)` is incredibly fast, especially on indexed tables (like InnoDB in MySQL), because the database engine often knows the total row count of an index without actually scanning the raw table data.

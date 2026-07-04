# NULL Handling

---

## 1. What is NULL?

In SQL, `NULL` is arguably the most misunderstood concept for beginners.

**`NULL` does NOT mean zero (0).**
**`NULL` does NOT mean an empty string ('').**

`NULL` represents **the total absence of data**. It means "Unknown", "Missing", or "Not Applicable". 
*   If a user leaves the "Middle Name" field blank on a signup form, it is `NULL`. We don't know what their middle name is.
*   If an item has not been shipped yet, its `shipped_date` is `NULL`.

---

## 2. The Golden Rule of NULL: Three-Valued Logic

In normal programming (Python, Java), logic has two states: `TRUE` or `FALSE`.
In SQL, logic has three states: `TRUE`, `FALSE`, or `UNKNOWN`.

Because `NULL` means "Unknown", **any mathematical or logical comparison against `NULL` results in `UNKNOWN` (which practically evaluates to false in a WHERE clause).**

### The Fatal Mistake
Imagine you want to find users who do *not* live in New York.
```sql
-- DANGEROUS CODE!
SELECT * FROM users WHERE city != 'New York';
```
**What happens to a user whose `city` is `NULL`?**
Does `NULL != 'New York'`? 
In SQL, comparing an "Unknown" value to 'New York' yields "Unknown". Therefore, the row is discarded. Users without a city will completely vanish from your report!

---

## 3. How to Properly Filter NULLs

You cannot use standard equality operators (`=`, `!=`, `<`, `>`) with `NULL`.
You **must** use the specialized `IS` operators.

### Checking for NULL
```sql
-- Find users who haven't entered a city
SELECT * FROM users WHERE city IS NULL;
```

### Checking for NOT NULL
```sql
-- Find users who have entered a city
SELECT * FROM users WHERE city IS NOT NULL;
```

### Fixing the Fatal Mistake
To find users who do not live in New York (including those who haven't entered a city at all):
```sql
SELECT * FROM users 
WHERE city != 'New York' OR city IS NULL;
```

---

## 4. NULL in Mathematical Operations

If you try to do math with a `NULL`, the entire calculation collapses into a black hole of `NULL`.

*   `10 + NULL` = `NULL`
*   `100 * NULL` = `NULL`
*   `CONCAT('Hello ', NULL)` = `NULL`

### How to rescue math from NULLs (COALESCE / IFNULL)
If you are adding `salary + bonus`, but some employees have a `NULL` bonus, their total compensation will display as `NULL`! We need to intercept that `NULL` and convert it to a `0`.

**In MySQL, use `IFNULL(column, fallback_value)`:**
```sql
SELECT salary + IFNULL(bonus, 0) AS total_comp FROM employees;
```

**The ANSI Standard, use `COALESCE(col1, col2, col3...)`:**
`COALESCE` goes down a list of arguments and returns the very first one that is NOT NULL.
```sql
SELECT salary + COALESCE(bonus, 0) AS total_comp FROM employees;
```

---

## 5. NULL with Aggregate Functions

Aggregate functions (`SUM`, `AVG`, `COUNT`, `MAX`, `MIN`) deal with `NULL` in a very specific, testable way: **They silently ignore them.**

Imagine a table of 3 test scores: `100`, `50`, and `NULL`.
*   `SUM(score)` = 150. (The NULL is ignored).
*   `AVG(score)` = 75. (150 / 2 valid scores. The NULL is completely excluded from the denominator).

### The COUNT() Trap
*   **`COUNT(*)`**: Counts every single row in the table, regardless of whether data is `NULL` or not. (Returns 3).
*   **`COUNT(column_name)`**: Counts only the rows where `column_name` is NOT NULL. (Returns 2).

---

## 6. Interview Tips
*   **The Equality Question:** If an interviewer asks "What does the expression `NULL = NULL` evaluate to in SQL?"
    *   **Answer:** "It evaluates to UNKNOWN, not TRUE. Because you cannot know if one unknown value equals another unknown value. You must use `IS NULL` to check for NULLs."
*   **COUNT(*) vs COUNT(col):** This is a staple question. Always clarify that `COUNT(*)` counts physical rows, while `COUNT(column)` counts non-null values in that specific column.
*   **COALESCE:** Mentioning `COALESCE` when discussing how to handle missing data in financial calculations shows senior-level foresight.

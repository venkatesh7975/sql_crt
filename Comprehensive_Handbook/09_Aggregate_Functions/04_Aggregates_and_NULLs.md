# Aggregates and NULLs

---

## 1. The Invisible Data

The interaction between Aggregate Functions and `NULL` values is one of the most frequently tested topics in SQL interviews and certifications. If you do not understand this behavior, your reporting dashboards will present fundamentally incorrect data to the business.

---

## 2. The Golden Rule

**With the sole exception of `COUNT(*)`, every single aggregate function (`SUM`, `AVG`, `MIN`, `MAX`, `COUNT(column)`) completely ignores `NULL` values as if they do not exist.**

Let's explore a `scores` table with 3 rows:
| id | student | test_score |
| :--- | :--- | :--- |
| 1 | Alice | 100 |
| 2 | Bob | 0 |
| 3 | Charlie | NULL |

### The COUNT Interaction
*   `SELECT COUNT(*) FROM scores;` -> Returns **3**. (Counts physical rows).
*   `SELECT COUNT(test_score) FROM scores;` -> Returns **2**. (Ignores Charlie's NULL).

### The SUM Interaction
*   `SELECT SUM(test_score) FROM scores;` -> Returns **100**. (100 + 0, ignores Charlie).

---

## 3. The AVG Trap (The Business Nightmare)

The way `AVG()` interacts with `NULL` is the source of countless financial reporting bugs.

Look at our table again. What is the average test score of the class?
*   Alice got 100.
*   Bob got 0.
*   Charlie was sick and missed the test (NULL).

If you run `SELECT AVG(test_score) FROM scores;`, the database does the following math:
`Total Sum (100) / Number of Non-Null Values (2) = 50`.
The database reports the class average is **50**.

**Is this correct?**
It depends entirely on the business logic!
*   If Charlie is allowed to take a makeup test later, his NULL should be ignored. The average is indeed 50.
*   If Charlie receives an automatic zero for missing the test, the denominator should be 3! The true average should be `100 / 3 = 33.33`.

### Fixing the Trap with COALESCE
If business logic dictates that `NULL` means `0`, you must force the database to treat it as a `0` *before* the `AVG()` function evaluates it.

```sql
-- Converts Charlie's NULL to 0 before averaging. 
-- Math: (100 + 0 + 0) / 3 = 33.33
SELECT AVG(COALESCE(test_score, 0)) FROM scores;
```

---

## 4. What if ALL values are NULL?

What happens if you run an aggregate function on an empty table, or a table where every single value in the column is `NULL`?

*   `COUNT()` will return **0**.
*   `SUM()`, `AVG()`, `MIN()`, and `MAX()` will return **NULL**.

This is mathematically sound. You cannot calculate the average of nothing.

---

## 5. Interview Tips
*   **The Numerator/Denominator Question:** "If I have a column with values `10`, `20`, and `NULL`, what does `AVG(column)` return?"
    *   **Answer:** "It returns 15. The `AVG` function ignores the `NULL`, summing 10+20 to get 30, and dividing by a count of 2. It does not divide by 3."
*   **Zero vs NULL:** Never confuse `0` with `NULL`. `0` is a hard integer value and aggregate functions absolutely include it in their calculations. `NULL` is the absence of data, and aggregate functions ignore it.

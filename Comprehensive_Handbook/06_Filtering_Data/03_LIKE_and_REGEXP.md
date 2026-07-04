# LIKE and REGEXP

---

## 1. The LIKE Operator

The `LIKE` operator is used in a `WHERE` clause to search for a specified pattern in a string column. It relies on two wildcard characters:
*   **`%` (Percent Sign):** Represents zero, one, or multiple characters.
*   **`_` (Underscore):** Represents exactly one single character.

### Examples using `%`
```sql
-- Starts with 'A' (e.g., 'Alice', 'Andrew')
SELECT * FROM users WHERE name LIKE 'A%';

-- Ends with 'son' (e.g., 'Jackson', 'Wilson')
SELECT * FROM users WHERE name LIKE '%son';

-- Contains 'john' anywhere in the string (e.g., 'johnny', 'elton john')
SELECT * FROM users WHERE name LIKE '%john%';
```

### Examples using `_`
```sql
-- 5 letter word starting with 'A' and ending with 'e' (e.g., 'Apple', 'Annie')
SELECT * FROM users WHERE name LIKE 'A___e';

-- Second letter is 'o' (e.g., 'Bob', 'John')
SELECT * FROM users WHERE name LIKE '_o%';
```

### Performance Warning
If you use a leading wildcard (e.g., `LIKE '%john'`), the database **cannot use an index** to search the column. It is forced to perform a Full Table Scan, reading every single row to check if the string matches. This is devastatingly slow on tables with millions of rows. 
Try to avoid leading wildcards if possible, or use specialized Full-Text Search engines (like Elasticsearch) for heavy text searching.

---

## 2. REGEXP (Regular Expressions)

While `LIKE` is great for simple patterns, it fails completely at complex pattern matching (e.g., "Find all users whose email starts with a number or contains the word 'admin' separated by a dash").

MySQL supports **Regular Expressions** via the `REGEXP` operator (or `RLIKE`).

### Common Regex Metacharacters
*   `^` : Beginning of string.
*   `$` : End of string.
*   `[abc]` : Any character listed between the brackets.
*   `[a-z]` : Any lowercase letter.
*   `[0-9]` : Any digit.
*   `|` : Logical OR.

### REGEXP Examples
```sql
-- Starts with 'A', 'B', or 'C'
SELECT * FROM users WHERE name REGEXP '^[ABC]';

-- Contains exactly 'admin' as a standalone word (word boundaries)
SELECT * FROM users WHERE name REGEXP '\\badmin\\b';

-- Ends with a number
SELECT * FROM users WHERE name REGEXP '[0-9]$';

-- Contains either 'Manager' OR 'Director'
SELECT * FROM employees WHERE title REGEXP 'Manager|Director';
```

*(Note: MySQL requires double backslashes `\\` to escape special characters like word boundaries `\b` or literal periods `\.` inside strings).*

---

## 3. Interview Tips
*   **Case Sensitivity:** In MySQL, `LIKE` and `REGEXP` are generally **case-insensitive** by default (depending on the collation, e.g., `utf8mb4_unicode_ci`). If you need a strictly case-sensitive search, you must cast the string to a binary string: `WHERE name LIKE BINARY 'A%'`.
*   **The SARGable Question:** "Why is `LIKE 'A%'` fast, but `LIKE '%A'` slow?"
    *   **Answer:** "An index is like a phone book. If I ask you to find everyone whose last name starts with 'S' (`LIKE 'S%'`), you can flip right to the 'S' section. If I ask you to find everyone whose last name ends with 'S' (`LIKE '%S'`), the alphabetical sorting is useless; you have to read every single name in the book. Therefore, leading wildcards destroy index utilization (SARGability)."

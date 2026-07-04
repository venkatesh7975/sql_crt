# ORDER BY Clause (Sorting)

---

## 1. The ORDER BY Clause

By default, when you run a `SELECT` query, a relational database does not guarantee any specific order for the returned rows. The rows are usually returned in the order they were physically inserted onto the hard drive, but even that is not guaranteed.

If you want the result set to be sorted, you must explicitly use the `ORDER BY` clause.

### Basic Syntax
```sql
SELECT * FROM users 
ORDER BY last_name;
```

---

## 2. ASC and DESC

You can control the direction of the sort using `ASC` (Ascending) or `DESC` (Descending).
*   **ASC:** Smallest to Largest (1 to 10), Oldest to Newest (Jan to Dec), Alphabetical (A to Z).
*   **DESC:** Largest to Smallest (10 to 1), Newest to Oldest (Dec to Jan), Reverse Alphabetical (Z to A).

If you do not specify a direction, **`ASC` is the default.**

```sql
-- Sort users from youngest to oldest
SELECT * FROM users ORDER BY age ASC;

-- Sort users from oldest to youngest
SELECT * FROM users ORDER BY age DESC;
```

---

## 3. Sorting by Multiple Columns

You can sort by more than one column by separating them with commas. The database will sort by the first column, and if there is a "tie" (two rows have the exact same value in the first column), it will use the second column as a tie-breaker.

**Example: A Company Directory**
We want to sort employees alphabetically by their department. If two employees are in the same department, we want them sorted alphabetically by their last name.

```sql
SELECT first_name, last_name, department 
FROM employees 
ORDER BY department ASC, last_name ASC;
```

You can even mix and match ASC and DESC!
```sql
-- Highest salaries first. 
-- If two people have the same salary, order them alphabetically.
SELECT * FROM employees 
ORDER BY salary DESC, last_name ASC;
```

---

## 4. Sorting with NULL Values

What happens if you sort a column that contains `NULL` values? Are they considered "larger" or "smaller" than real data?

In MySQL, **`NULL` is considered the smallest possible value.**
*   If you sort `ORDER BY age ASC`, the `NULL` ages will appear at the very top of the list, followed by 1, 2, 3...
*   If you sort `ORDER BY age DESC`, the `NULL` ages will appear at the very bottom of the list.

*(Note: PostgreSQL behaves exactly the opposite by default. It considers NULL the largest value. This is a common trip-up when switching database engines!)*

---

## 5. Sorting by Alias or Position

You don't always have to type out the full column name or mathematical formula in the `ORDER BY` clause.

### Sorting by Alias
If you created an alias in the `SELECT` clause, you can use it in the `ORDER BY` clause (because `ORDER BY` executes *after* the `SELECT` clause in the logical execution order).
```sql
SELECT first_name, (salary * 0.10) AS bonus 
FROM employees 
ORDER BY bonus DESC;
```

### Sorting by Column Position (Shortcut)
You can use the numerical index (starting at 1) of the columns in the `SELECT` clause.
```sql
-- This sorts by 'last_name' (the 2nd column) and then 'age' (the 3rd column)
SELECT first_name, last_name, age 
FROM users 
ORDER BY 2 ASC, 3 DESC;
```
*Warning: While handy for quick scratchpad queries, using numerical positions is considered a bad practice in production code because if someone changes the `SELECT` clause later, the sorting breaks silently.*

---

## 6. Interview Tips
*   **The Top-N Query:** "How do you find the 3rd highest salary?" This is an incredibly common interview question. To solve it, you must use `ORDER BY salary DESC` combined with the `LIMIT` and `OFFSET` clauses (covered in the next chapter).
*   **Index Utilization:** "Does `ORDER BY` hurt performance?"
    *   **Answer:** "Yes, sorting requires CPU power and memory (a 'filesort'). However, if you `ORDER BY` a column that has an Index, the database doesn't actually have to do any sorting; it just reads the index in order. Therefore, frequently sorted columns should be indexed."

# WHERE Clause and Logical Operators

---

## 1. The WHERE Clause

The `WHERE` clause is the primary tool for filtering data in SQL. It evaluates a mathematical or logical condition for every single row in a table. 
*   If the condition evaluates to `TRUE`, the row is included in the result set.
*   If the condition evaluates to `FALSE` (or `UNKNOWN` due to NULLs), the row is discarded.

### Basic Syntax
```sql
SELECT * FROM users 
WHERE age >= 18;
```

### Common Comparison Operators
*   `=` : Equal to
*   `!=` or `<>` : Not equal to
*   `>` : Greater than
*   `<` : Less than
*   `>=` : Greater than or equal to
*   `<=` : Less than or equal to

*(Note: In SQL, a single equals sign `=` is used for both comparison in a `WHERE` clause and assignment in a `SET` clause. There is no `==` operator like in Python).*

---

## 2. Logical Operators (AND, OR, NOT)

You can combine multiple conditions using logical operators.

### AND
The `AND` operator requires that **both** conditions are TRUE.
```sql
-- Find adult users living in New York
SELECT * FROM users 
WHERE age >= 18 AND city = 'New York';
```
*If a user is 25 but lives in Boston, the row is discarded.*

### OR
The `OR` operator requires that **at least one** condition is TRUE.
```sql
-- Find users who live in EITHER New York OR Boston
SELECT * FROM users 
WHERE city = 'New York' OR city = 'Boston';
```

### NOT
The `NOT` operator reverses the logic of a condition.
```sql
-- Find users who do NOT live in New York
SELECT * FROM users 
WHERE NOT city = 'New York';

-- (Equivalently: WHERE city != 'New York')
```

---

## 3. Order of Operations (PEMDAS for Logic)

What happens if you mix `AND` and `OR` in the same query?

```sql
SELECT * FROM users 
WHERE age >= 18 OR city = 'New York' AND status = 'active';
```
**How does the database evaluate this?**
Just like multiplication happens before addition in math, **`AND` happens before `OR` in SQL.**
The query above actually evaluates as:
*Find users who are (from New York AND active), OR anyone who is over 18.* 
An inactive 19-year-old from Boston would pass this filter!

### Using Parentheses (Best Practice)
Never rely on the default order of operations. Always use parentheses `()` to explicitly group your logic. It makes your code vastly more readable and prevents catastrophic bugs.

```sql
-- Find adults who are EITHER from New York or active
SELECT * FROM users 
WHERE age >= 18 AND (city = 'New York' OR status = 'active');
```

---

## 4. Interview Tips
*   **Performance:** If you have an `AND` condition, put the most restrictive condition first. The database optimizer is usually smart enough to figure it out, but logically, if condition A eliminates 99% of the rows, condition B only has to evaluate the remaining 1%.
*   **The NULL Trap:** Never forget that `WHERE age != 18` will eliminate anyone who is 18 AND anyone whose age is `NULL`. If you want to include NULLs, you must write `WHERE age != 18 OR age IS NULL`.

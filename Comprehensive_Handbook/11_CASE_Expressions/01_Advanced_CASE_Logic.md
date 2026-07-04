# Advanced CASE Logic

---

## 1. The Two Flavors of CASE

We briefly introduced the `CASE` statement in the SQL Functions chapter. It is the SQL equivalent of `if/else` logic.
However, there are actually two different ways to write a `CASE` statement: **Simple CASE** and **Searched CASE**.

---

## 2. Simple CASE (Equality Only)

The Simple CASE syntax compares a single expression against a series of values for exact equality (`=`). You cannot use greater than (`>`), less than (`<`), or `LIKE` in a Simple CASE.

### Syntax
```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE default_result
END
```

### Example
Translating numerical ratings into words.
```sql
SELECT 
    restaurant_name,
    CASE rating
        WHEN 5 THEN 'Excellent'
        WHEN 4 THEN 'Good'
        WHEN 3 THEN 'Average'
        WHEN 2 THEN 'Poor'
        WHEN 1 THEN 'Terrible'
        ELSE 'Unrated'
    END AS rating_text
FROM reviews;
```

---

## 3. Searched CASE (Complex Logic)

The Searched CASE syntax does not declare a single expression at the top. Instead, every `WHEN` clause is a completely independent boolean expression. 
This is the most powerful and common way to use `CASE` because it allows for `<`, `>`, `AND`, `OR`, `LIKE`, and checking multiple different columns at once!

### Syntax
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END
```

### Example
Categorizing users based on age ranges and active status.
```sql
SELECT 
    username,
    CASE
        WHEN age < 18 THEN 'Minor'
        WHEN age >= 18 AND status = 'inactive' THEN 'Adult (Inactive)'
        WHEN age >= 18 AND status = 'active' THEN 'Adult (Active)'
        ELSE 'Unknown'
    END AS user_segment
FROM users;
```

---

## 4. Nested CASE Statements

You can put a `CASE` statement inside another `CASE` statement. While this can make your code harder to read, it is sometimes necessary for complex, multi-tiered logic.

```sql
SELECT 
    employee_name,
    CASE 
        WHEN department = 'Sales' THEN
            CASE 
                WHEN sales_total > 100000 THEN 'Top Performer'
                ELSE 'Average Performer'
            END
        ELSE 'Not in Sales'
    END AS performance_review
FROM employees;
```

---

## 5. Interview Tips
*   **The ELSE Fallback:** "What happens if a `CASE` statement has no `ELSE` clause, and none of the `WHEN` conditions are met?"
    *   **Answer:** "It automatically returns `NULL`."
*   **Short-Circuit Evaluation:** `CASE` statements evaluate sequentially from top to bottom. As soon as a `WHEN` condition is met, it returns the result and *stops evaluating*. 
    *   *Trick Question:* `CASE WHEN age > 10 THEN 'Kid' WHEN age > 20 THEN 'Adult' END`. If `age` is 25, what does this return?
    *   *Answer:* It returns 'Kid'. Because 25 is > 10, the first condition matches, and the statement short-circuits. The second condition is never reached. Always put your most specific/restrictive conditions at the top!

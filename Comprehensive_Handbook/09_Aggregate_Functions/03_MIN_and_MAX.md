# MIN and MAX

---

## 1. Finding Extremes

The `MIN()` and `MAX()` functions are used to find the lowest and highest values in a specific column, respectively.

Unlike `SUM` and `AVG` which strictly require numerical data, `MIN` and `MAX` are incredibly versatile. They can be used on Numbers, Strings, and Dates!

---

## 2. Using MIN and MAX with Numbers

This is the most obvious use case.

```sql
-- "What is the cheapest product we sell?"
SELECT MIN(price) FROM products;

-- "What is the most expensive product we sell?"
SELECT MAX(price) FROM products;
```

---

## 3. Using MIN and MAX with Dates

When applied to dates, `MIN` finds the **oldest** date, and `MAX` finds the **newest** (most recent) date.

```sql
-- "When did our very first user register?"
SELECT MIN(created_at) FROM users;

-- "When did our most recent user register?"
SELECT MAX(created_at) FROM users;
```

---

## 4. Using MIN and MAX with Strings

When applied to strings (text), `MIN` and `MAX` rely on the alphabetical sorting of the database collation.
*   `MIN()` returns the value closest to "A".
*   `MAX()` returns the value closest to "Z".

```sql
-- Returns the first name alphabetically (e.g., 'Aaron')
SELECT MIN(first_name) FROM users;

-- Returns the last name alphabetically (e.g., 'Zane')
SELECT MAX(first_name) FROM users;
```
*(While supported, this is rarely used in real-world business logic compared to numbers and dates).*

---

## 5. The Projection Trap (Common Beginner Mistake)

A very common mistake beginners make is trying to pull *other* columns alongside an aggregate function without using a `GROUP BY`.

**The Goal:** "I want the name of the most expensive product."

**The Bad Query:**
```sql
-- THIS DOES NOT WORK THE WAY YOU EXPECT!
SELECT product_name, MAX(price) FROM products;
```
**Why it's bad:** The database smashes all the prices together into a single row to find the `MAX(price)`. But what should it do with `product_name`? In standard SQL, this query will crash. In older versions of MySQL, it would return the `MAX(price)`, but it would return a completely random `product_name`!

**The Correct Way (Using a Subquery):**
To find the *row* associated with the max value, you must use a subquery in the `WHERE` clause.
```sql
SELECT product_name, price 
FROM products 
WHERE price = (SELECT MAX(price) FROM products);
```
*(Note: If multiple products share that exact same max price, this query will correctly return all of them).*

---

## 6. Interview Tips
*   **Finding the Row for the Max Value:** If an interviewer asks you to return the employee with the highest salary, immediately write the subquery solution shown above. Do not try to `SELECT name, MAX(salary)`. 
    *   *Alternative approach:* You can also use `ORDER BY salary DESC LIMIT 1`, but you should note to the interviewer that `LIMIT 1` will fail to return ties if two employees share the exact same highest salary, whereas the `WHERE salary = (SELECT MAX...)` approach handles ties perfectly.

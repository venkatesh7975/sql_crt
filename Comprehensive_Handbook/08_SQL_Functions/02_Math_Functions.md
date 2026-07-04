# Math Functions

---

## 1. Mathematical Operations in SQL

While complex mathematics is usually handled in the backend application code (Python, Java), SQL provides a robust set of Math Functions for performing calculations directly on numerical columns (`INT`, `DECIMAL`, `FLOAT`).

This is particularly useful in reporting queries and financial dashboards.

---

## 2. Basic Arithmetic

You don't need special functions for basic math. You can use standard mathematical operators directly in the `SELECT` clause.

*   `+` (Addition)
*   `-` (Subtraction)
*   `*` (Multiplication)
*   `/` (Division)

```sql
-- Calculate a 15% tax on every order
SELECT order_total, (order_total * 0.15) AS tax_amount 
FROM orders;
```

---

## 3. Rounding Numbers

Financial data often results in long decimals (e.g., `$10.333333`). You must round them for display.

### ROUND()
Rounds a number to a specified number of decimal places based on standard rounding rules (5 and up rounds up).
```sql
-- Rounds to 2 decimal places -> 10.35
SELECT ROUND(10.345, 2); 

-- If you omit the decimal places, it rounds to the nearest whole integer -> 10
SELECT ROUND(10.345);
```

### CEILING() / CEIL()
Always rounds **UP** to the next highest whole integer, regardless of the decimal value.
```sql
-- Returns 11
SELECT CEIL(10.01);
```

### FLOOR()
Always rounds **DOWN** to the next lowest whole integer.
```sql
-- Returns 10
SELECT FLOOR(10.99);
```

---

## 4. Advanced Math Functions

### ABS()
Returns the Absolute Value (the positive version) of a number. Useful for finding the difference or distance between two numbers regardless of order.
```sql
-- Both return 5
SELECT ABS(10 - 15);
SELECT ABS(15 - 10);
```

### POWER()
Raises a number to a specific power/exponent.
```sql
-- 2 to the power of 3 (2^3) -> 8
SELECT POWER(2, 3);
```

### SQRT()
Returns the square root of a number.
```sql
-- Returns 4
SELECT SQRT(16);
```

### MOD() or `%`
Returns the remainder of a division operation (Modulo). This is a classic programming tool used to determine if a number is even or odd.
```sql
-- 10 divided by 3 has a remainder of 1. Returns 1.
SELECT MOD(10, 3);

-- Shorthand syntax using the % operator
SELECT 10 % 3;

-- Checking for Even numbers (If ID % 2 = 0, it's even)
SELECT * FROM users WHERE id % 2 = 0;
```

---

## 5. Interview Tips
*   **The Modulo Trick:** "Write a query to fetch all rows with an even ID." 
    *   **Answer:** `SELECT * FROM table WHERE MOD(id, 2) = 0;`
*   **Integer Division Warning:** In some database systems (like PostgreSQL and SQL Server), dividing two integers (e.g., `10 / 3`) will perform *Integer Division* and return `3`, truncating the decimal. MySQL, however, is user-friendly and will return `3.3333`. If you want to force integer division in MySQL, use the `DIV` operator (`10 DIV 3`).

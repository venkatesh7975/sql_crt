# Date and Time Functions

---

## 1. The Complexity of Time

Handling Dates and Times is notoriously one of the most frustrating aspects of software engineering (due to time zones, leap years, and formatting). 

SQL provides a rich set of functions to parse, format, and do math on `DATE`, `DATETIME`, and `TIMESTAMP` columns.

---

## 2. Getting the Current Date/Time

If you need to know exactly what time it is *right now* on the database server, use these functions:

### NOW() / CURRENT_TIMESTAMP()
Returns both the date and the exact time (e.g., `2023-10-25 14:30:00`).
```sql
SELECT NOW();
```

### CURDATE() / CURRENT_DATE()
Returns just the date (e.g., `2023-10-25`). Time is ignored.
```sql
SELECT CURDATE();
```

### CURTIME() / CURRENT_TIME()
Returns just the time (e.g., `14:30:00`). Date is ignored.
```sql
SELECT CURTIME();
```

---

## 3. Date Math (Adding and Subtracting)

You frequently need to look back in time (e.g., "Find all users who registered in the last 30 days") or look forward (e.g., "Find subscriptions expiring next week").

### DATE_ADD() and DATE_SUB()
These functions add or subtract a specified time `INTERVAL` from a date.

```sql
-- Add 7 days to the current date
SELECT DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- Subtract 1 month from the current date
SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Find users who logged in within the last 24 hours
SELECT * FROM users 
WHERE last_login >= DATE_SUB(NOW(), INTERVAL 24 HOUR);
```
*(Valid intervals: `DAY`, `MONTH`, `YEAR`, `HOUR`, `MINUTE`, `SECOND`, `WEEK`).*

### DATEDIFF()
Calculates the number of **days** between two dates. It subtracts the second date from the first date (`Date1 - Date2`).

```sql
-- Returns 5 (Jan 10 - Jan 05)
SELECT DATEDIFF('2023-01-10', '2023-01-05');

-- Find how many days a user has been active
SELECT user_id, DATEDIFF(CURDATE(), created_at) AS days_active 
FROM users;
```

---

## 4. Extracting Parts of a Date

Sometimes you have a full timestamp (`2023-10-25 14:30:00`), but you only care about the Year, or the Month, or the Hour.

### Standard Extractors
```sql
SELECT YEAR('2023-10-25');  -- Returns 2023
SELECT MONTH('2023-10-25'); -- Returns 10
SELECT DAY('2023-10-25');   -- Returns 25
SELECT HOUR('2023-10-25 14:30:00'); -- Returns 14
```

### EXTRACT() Function (The Standard Way)
The `EXTRACT()` function does the exact same thing but uses standard ANSI SQL syntax, making it portable to other database engines.
```sql
SELECT EXTRACT(YEAR FROM '2023-10-25');
SELECT EXTRACT(MONTH FROM '2023-10-25');
```

---

## 5. Formatting Dates for Display

### DATE_FORMAT() (MySQL Specific)
If you want to display a date as "October 25th, 2023" instead of "2023-10-25", you use `DATE_FORMAT()`. You pass the date and a format string using `%` specifiers.

```sql
-- Returns 'Oct 25, 2023'
SELECT DATE_FORMAT('2023-10-25', '%b %d, %Y');

-- Returns 'Wednesday'
SELECT DATE_FORMAT('2023-10-25', '%W');
```
*(Note: You do not need to memorize every format specifier. Developers look them up in the MySQL documentation every time they need them).*

---

## 6. Interview Tips
*   **The "Last 30 Days" Query:** This is guaranteed to come up. 
    *   **Answer:** `SELECT * FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);`
*   **Timezones:** If an interviewer asks "How should we store dates in the database?", the answer is ALWAYS: "Store everything in **UTC (Coordinated Universal Time)**. Never store local timezones in the database. The frontend application should be responsible for converting UTC to the user's local timezone for display."

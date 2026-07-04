# Consecutive Numbers and Gaps

---

## 1. The Gaps and Islands Problem

This is one of the most famous patterns in advanced SQL interviewing. It is commonly referred to as "Gaps and Islands".

*   **Islands:** Finding a continuous sequence of data (e.g., a user logging in for 3 consecutive days).
*   **Gaps:** Finding a missing sequence in data (e.g., finding the missing IDs in a sequential table, or finding days a user *didn't* log in).

---

## 2. Finding Consecutive Events (The LEAD/LAG approach)

**The Problem:** Find any user who has logged in for 3 consecutive days.

**The Table:** `logins (user_id, login_date)`

**The Solution:**
We can use `LEAD()` to look ahead 1 row and 2 rows. If the current date + 1 day equals the next row's date, AND the current date + 2 days equals the row after that... we found a 3-day streak!

```sql
WITH NextLogins AS (
    SELECT 
        user_id,
        login_date,
        LEAD(login_date, 1) OVER(PARTITION BY user_id ORDER BY login_date) AS next_day,
        LEAD(login_date, 2) OVER(PARTITION BY user_id ORDER BY login_date) AS day_after_next
    FROM logins
)
SELECT DISTINCT user_id 
FROM NextLogins
WHERE next_day = DATE_ADD(login_date, INTERVAL 1 DAY)
  AND day_after_next = DATE_ADD(login_date, INTERVAL 2 DAY);
```

---

## 3. Finding Consecutive Events (The ROW_NUMBER approach)

If an interviewer asks you to find a streak of **10 consecutive days**, writing 9 `LEAD()` statements is ridiculous. You must use the Row Number trick.

**The Trick:** 
If you have a sequence of consecutive dates, and a sequence of consecutive integers, subtracting the integer from the date will always yield the exact same "Anchor Date" for the entire streak!

1. Date: Jan 1. RowNum: 1. (Jan 1 - 1 day = Dec 31)
2. Date: Jan 2. RowNum: 2. (Jan 2 - 2 days = Dec 31)
3. Date: Jan 3. RowNum: 3. (Jan 3 - 3 days = Dec 31)

When the streak breaks, the Anchor Date changes!

```sql
WITH RankedLogins AS (
    SELECT 
        user_id,
        login_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) AS rn
    FROM logins
),
AnchorDates AS (
    SELECT 
        user_id,
        login_date,
        -- Subtract the row number from the date to find the Anchor
        DATE_SUB(login_date, INTERVAL rn DAY) AS anchor_date
    FROM RankedLogins
)
-- Now just group by the user and the anchor, and count how many rows share that anchor!
SELECT user_id, COUNT(*) as streak_length
FROM AnchorDates
GROUP BY user_id, anchor_date
HAVING COUNT(*) >= 10;
```
*(This is a Master-class level SQL query. If you can write this on a whiteboard, you will pass almost any SQL technical screen).*

---

## 4. Finding Gaps

**The Problem:** You have an `invoices` table with sequential IDs (1, 2, 3, 5, 6). Find the missing IDs (4).

**The Solution:** Use `LEAD()` to compare the current ID to the next ID. If the difference is greater than 1, there is a gap!

```sql
WITH NextIDs AS (
    SELECT 
        id,
        LEAD(id, 1) OVER(ORDER BY id) AS next_id
    FROM invoices
)
SELECT 
    id + 1 AS gap_start,
    next_id - 1 AS gap_end
FROM NextIDs
WHERE next_id - id > 1;
```
*(For the sequence 1,2,3,5,6, this query will correctly identify a gap starting at 4 and ending at 4).*

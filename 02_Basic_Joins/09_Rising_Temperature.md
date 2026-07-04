# Problem 09 – Rising Temperature

---

## 1. Difficulty
Easy

---

## 2. SQL Concepts Tested
* SELECT
* SELF JOIN
* Date Functions (`DATEDIFF` or `DATE_ADD`)

---

## 3. Pattern
Self Join / Date Manipulation

---

## 4. Problem Statement
We need to find all the IDs of dates where the temperature was strictly higher than the temperature on the previous day (yesterday).

---

## 5. Tables

Table: Weather

| Column      | Type |
| ----------- | ---- |
| id          | INT  |
| recordDate  | DATE |
| temperature | INT  |

* `id` is the primary key.
* This table contains temperature data for specific dates. There are no duplicate dates.

---

## 6. Sample Input

Weather table:

| id | recordDate | temperature |
| -- | ---------- | ----------- |
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |

---

## 7. Expected Output

| id |
| -- |
| 2  |
| 4  |

*(On 2015-01-02, temp was 25 vs 10 the day before. On 2015-01-04, temp was 30 vs 20 the day before.)*

---

## 8. Understanding the Question
What information is being asked? The `id` of specific days.
What columns are important? `id`, `recordDate`, and `temperature`.
What conditions matter? The `temperature` of Day X must be > the `temperature` of Day X-1.
What should be returned? Just the `id` of Day X.

---

## 9. Thinking Process
1. We are comparing rows *within the same table* (Day X vs Day X-1). Whenever we need to compare a table against itself, we use a **Self Join**.
2. We'll pretend there are two tables: `w1` (representing "Today") and `w2` (representing "Yesterday").
3. How do we link "Today" and "Yesterday"? We need a join condition where `w1`'s date is exactly 1 day after `w2`'s date.
4. In MySQL, we can use the `DATEDIFF(date1, date2)` function, which returns the number of days between two dates. So, `DATEDIFF(w1.recordDate, w2.recordDate) = 1`.
5. Now that "Today" and "Yesterday" are successfully linked side-by-side in one mega-row, we just apply our filter: `w1.temperature > w2.temperature`.
6. Finally, we select the `id` from the `w1` (Today) table.

---

## 10. Approach 1 (Optimal)
Self Join with `DATEDIFF()`

Join the table to itself by matching each date to the date exactly one day prior. Then filter for rows where the newer date has a higher temperature.

---

## 11. SQL Solution

```sql
-- Retrieve the IDs of days with temperatures higher than the previous day
SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2 
    ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE 
    w1.temperature > w2.temperature;
```

---

## 12. Step-by-Step Dry Run
Imagine linking `w1` and `w2` based on the 1-day difference:

1. `w1` is 2015-01-02. `w2` matches to 2015-01-01. (Diff is 1).
   * Check WHERE: `w1.temp` (25) > `w2.temp` (10). **True**. Keep ID 2.
2. `w1` is 2015-01-03. `w2` matches to 2015-01-02. (Diff is 1).
   * Check WHERE: `w1.temp` (20) > `w2.temp` (25). **False**. Ignore ID 3.
3. `w1` is 2015-01-04. `w2` matches to 2015-01-03. (Diff is 1).
   * Check WHERE: `w1.temp` (30) > `w2.temp` (20). **True**. Keep ID 4.
4. (Note: 2015-01-01 has no "yesterday" in the table, so it finds no match in the JOIN and is naturally excluded).

---

## 13. SQL Execution Order
1. **FROM Weather w1:** Set up the first instance.
2. **JOIN Weather w2 ON ...:** Set up the second instance and link rows where `w1` is exactly 1 day ahead of `w2`.
3. **WHERE w1.temperature > w2.temperature:** Filter these paired rows based on the temperature condition.
4. **SELECT w1.id:** Grab the ID of the "Today" side of the pair.

---

## 14. Query Breakdown
* **Self Join:** By aliasing the same table twice (`w1` and `w2`), we can query it as if two separate tables exist.
* **DATEDIFF(date1, date2):** Returns `date1 - date2` in days. Since we want `w1` (Today) to be later than `w2` (Yesterday), `DATEDIFF(today, yesterday)` should equal `1`.
* **w1.temperature > w2.temperature:** Our core business logic applied to the joined rows.

---

## 15. Why This Solution Works
It explicitly connects related data points across time by using mathematical date functions as the join condition, rather than traditional foreign keys.

---

## 16. Alternative Solution
Using `DATE_ADD()` or `SUBDATE()`

```sql
SELECT 
    w1.id
FROM 
    Weather w1
JOIN 
    Weather w2 
    ON w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE 
    w1.temperature > w2.temperature;
```
* **Advantages:** Functionally identical. Sometimes `DATE_ADD` can utilize indexes on `recordDate` slightly better than `DATEDIFF` depending on the database engine, because it compares a column to a calculated constant rather than applying a function to two columns.
* **Disadvantages:** Slightly more verbose syntax (`INTERVAL 1 DAY`).

---

## 17. Time Complexity
**O(N^2)** worst case if no indexes exist (nested loop join). However, with an index on `recordDate`, it operates closer to **O(N)**, doing a quick index seek to find "yesterday" for every row.

---

## 18. Common Mistakes
* **Using `id - 1`:** Beginners often try `ON w1.id = w2.id + 1`. This assumes IDs are perfectly sequential without missing days. In the real world (and in LeetCode test cases), data might jump from ID 5 (Jan 1) to ID 9 (Jan 2). Always base time calculations on actual Date columns, not primary keys!
* **Wrong DATEDIFF order:** `DATEDIFF(yesterday, today)` yields `-1`. If you get empty results, flip the arguments or check for `-1`.

---

## 19. Edge Cases
* **Missing previous day:** If a date has no record for the day before, it fails the `JOIN` condition and is safely ignored.
* **Leap years / Month rollovers:** Built-in SQL date functions (`DATEDIFF`, `DATE_ADD`) flawlessly handle Feb 28 to Mar 1 leaps. Never try to calculate date differences manually using string parsing.

---

## 20. Interview Tips
* Always stress that you cannot rely on `id` gaps for time series data. Rely on the Date columns.
* Mentioning the `DATE_ADD` index utilization advantage over `DATEDIFF` will score heavy bonus points with senior engineers.

---

## 21. Similar LeetCode Problems
* 197. Rising Temperature (This one!)
* 601. Human Traffic of Stadium (More advanced sequence tracking)

---

## 22. Key Takeaways
* **Self Joins** are perfect for comparing rows within the same table.
* Use `DATEDIFF()` or `DATE_ADD()` for finding sequential days. Never rely on sequential IDs for date logic.

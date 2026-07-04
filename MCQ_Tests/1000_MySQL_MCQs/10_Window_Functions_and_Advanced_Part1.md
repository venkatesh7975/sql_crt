**Q1. Which window function assigns a unique sequential integer to rows within a partition of a result set, starting at 1 for the first row in each partition?**
A) RANK()
B) DENSE_RANK()
C) ROW_NUMBER()
D) NTILE()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** ROW_NUMBER() assigns a unique, sequential number to each row within a partition, regardless of duplicate values.
</details>

**Q2. What happens when two rows have the same values in the ORDER BY clause of a ROW_NUMBER() function?**
A) Both rows get the same sequence number.
B) They receive consecutive numbers, but the order is non-deterministic without additional sorting criteria.
C) The query throws an error.
D) The sequence skips a number.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ROW_NUMBER() always assigns distinct numbers; if sorting columns have ties, the assignment among tied rows is arbitrary unless an additional unique column is used in ORDER BY.
</details>

**Q3. Which clause is mandatory when using the ROW_NUMBER() function?**
A) OVER(PARTITION BY ...)
B) OVER(ORDER BY ...)
C) GROUP BY
D) OVER() with no arguments

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** ROW_NUMBER() requires an OVER clause with an ORDER BY to determine the sequence in which numbers are assigned.
</details>

**Q4. Can ROW_NUMBER() be used in a WHERE clause directly to filter the top N rows?**
A) Yes, `WHERE ROW_NUMBER() OVER(...) <= N` is perfectly valid.
B) No, window functions cannot be used directly in the WHERE clause; a subquery or CTE must be used.
C) Yes, but only if the table has a primary key.
D) No, ROW_NUMBER() can only be used in the SELECT list.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Window functions are evaluated after the WHERE clause, so they must be enclosed in a subquery or CTE to filter by their results.
</details>

**Q5. In MySQL 8.0, what does `SELECT ROW_NUMBER() OVER() FROM employees;` do?**
A) Returns an error because ORDER BY is omitted.
B) Assigns a unique sequential number to every row in an arbitrary order.
C) Returns 1 for all rows.
D) Assigns row numbers based on the primary key automatically.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** While ORDER BY is typically expected for meaningful results, MySQL permits `OVER()` without it, assigning sequential numbers in whatever order rows are processed.
</details>

**Q6. What is the purpose of the PARTITION BY clause within the OVER() clause of a window function?**
A) It physically partitions the table on disk.
B) It divides the result set into partitions to which the window function is applied independently.
C) It filters out duplicate rows in the partition.
D) It sorts the result set based on the specified column.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** PARTITION BY groups the rows into partitions, and the window function resets its calculation for each new partition.
</details>

**Q7. If `PARTITION BY department_id` is used with `ROW_NUMBER()`, what is the row number of the first row in each department?**
A) 0
B) 1
C) The highest row number in the previous department + 1
D) The department_id value

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The ROW_NUMBER() function resets its count to 1 at the beginning of each new partition defined by PARTITION BY.
</details>

**Q8. Which of the following queries correctly assigns a sequential number to employees within each department based on their salary?**
A) `SELECT ROW_NUMBER() OVER(ORDER BY salary DESC PARTITION BY department_id) FROM employees;`
B) `SELECT ROW_NUMBER(department_id) OVER(ORDER BY salary DESC) FROM employees;`
C) `SELECT ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) FROM employees;`
D) `SELECT ROW_NUMBER() PARTITION BY department_id ORDER BY salary DESC FROM employees;`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Inside the OVER() clause, the PARTITION BY clause must precede the ORDER BY clause.
</details>

**Q9. Consider a CTE containing `ROW_NUMBER() OVER(PARTITION BY category ORDER BY price DESC) as rn`. How do you select the most expensive item per category?**
A) `SELECT * FROM CTE WHERE rn = MAX(rn);`
B) `SELECT * FROM CTE WHERE rn = 1;`
C) `SELECT * FROM CTE HAVING rn = 1;`
D) `SELECT TOP 1 * FROM CTE GROUP BY category;`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because the window function orders by price DESC, the most expensive item receives `rn = 1`. Filtering `WHERE rn = 1` yields the max per partition.
</details>

**Q10. What happens if you omit the PARTITION BY clause in an OVER() clause?**
A) The query fails with a syntax error.
B) The function treats the entire result set as a single partition.
C) The function partitions by the primary key.
D) The function partitions by the column used in the ORDER BY clause.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If PARTITION BY is omitted, the window function operates over all the rows returned by the query as one large partition.
</details>

**Q11. How does the RANK() function handle tied values in the ORDER BY column?**
A) It assigns them consecutive numbers.
B) It assigns them the same rank and leaves no gaps in the ranking sequence.
C) It assigns them the same rank and leaves gaps in the ranking sequence for subsequent rows.
D) It raises an error.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** RANK() provides the same rank for ties, but skips the next available ranks (e.g., if two rows share rank 1, the next row gets rank 3).
</details>

**Q12. If three rows share the highest score in a test, what rank will the RANK() function assign to the fourth highest score?**
A) 2
B) 3
C) 4
D) 5

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** The three tied rows get rank 1. Ranks 2 and 3 are skipped, so the next row gets rank 4.
</details>

**Q13. In which scenario is RANK() preferred over ROW_NUMBER()?**
A) When you need an exact sequence without any duplicate values for pagination.
B) When you want ties to receive the same rank but reflect the true mathematical placement of subsequent items.
C) When you want to divide rows into equal-sized buckets.
D) When you want to ignore the ORDER BY clause entirely.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** RANK() accurately reflects competitive placement (like Olympic medals) where ties take up positional slots.
</details>

**Q14. What does the query `SELECT RANK() OVER(ORDER BY score DESC) FROM scores;` produce for scores [90, 90, 85, 80]?**
A) 1, 2, 3, 4
B) 1, 1, 2, 3
C) 1, 1, 3, 4
D) 1, 1, 2, 4

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Both 90s get rank 1. Rank 2 is skipped, so 85 gets 3, and 80 gets 4.
</details>

**Q15. Is `ORDER BY` strictly required within the `OVER()` clause when using `RANK()` in MySQL 8.0?**
A) Yes, without `ORDER BY`, `RANK()` will raise an error or assign rank 1 to all rows.
B) No, `RANK()` can rank based on table insertion order without `ORDER BY`.
C) No, it uses the primary key automatically.
D) Yes, but only if `PARTITION BY` is missing.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Without an ORDER BY, all rows are considered peers and tie for rank 1, rendering the RANK() function effectively useless for ranking purposes, though it technically executes.
</details>

**Q16. How does RANK() behave when combined with PARTITION BY?**
A) It assigns a global rank across all rows, ignoring the partition.
B) It resets the rank to 1 at the start of each new partition.
C) It computes the rank based on the partition key rather than the ORDER BY key.
D) It assigns ranks only to the first partition and NULLs to the rest.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Like all window functions, RANK() isolates its calculations to the current partition, restarting at 1 for each new partition.
</details>

**Q17. Suppose you want to find the top 2 highest paid employees in each department, allowing ties to both be included even if it means returning more than 2 employees. Which function is most appropriate?**
A) ROW_NUMBER()
B) RANK()
C) NTILE(2)
D) LAG()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** By filtering `WHERE rank <= 2`, RANK() includes all ties for 1st and 2nd place, potentially returning more than 2 rows if ties exist.
</details>

**Q18. What will be the result of `RANK() OVER(PARTITION BY department ORDER BY salary DESC)` for salaries [100, 100, 90] in IT and [120, 110, 110] in HR?**
A) IT: 1, 1, 2 | HR: 1, 2, 2
B) IT: 1, 1, 3 | HR: 1, 2, 2
C) IT: 1, 2, 3 | HR: 1, 2, 3
D) IT: 1, 1, 3 | HR: 1, 2, 3

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** In IT, the 100s tie for 1, rank 2 is skipped, so 90 is 3. In HR, 120 is 1, and the 110s tie for 2.
</details>

**Q19. Can a query have multiple window functions with different PARTITION BY clauses in the same SELECT statement?**
A) No, all window functions in a SELECT must share the exact same OVER() clause.
B) Yes, you can define different partitions for different window functions in the same query.
C) Yes, but only if they are the same type of window function (e.g., both RANK()).
D) No, multiple PARTITION BY clauses cause a table scan error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** You can specify completely independent OVER() clauses for multiple window functions within a single SELECT statement.
</details>

**Q20. If all rows in a partition have the exact same value for the ORDER BY column, what will RANK() return for that partition?**
A) It assigns sequential numbers 1, 2, 3, etc.
B) It assigns 1 to all rows in the partition.
C) It assigns 0 to all rows.
D) It assigns NULL to all rows.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Since all rows tie, they all receive the same rank of 1.
</details>

**Q21. What is the primary difference between RANK() and DENSE_RANK()?**
A) DENSE_RANK() allows partition by, while RANK() does not.
B) RANK() leaves gaps in the ranking sequence on ties, while DENSE_RANK() leaves no gaps.
C) RANK() leaves no gaps, while DENSE_RANK() leaves gaps.
D) DENSE_RANK() is only available for numerical columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** After a tie, DENSE_RANK() assigns the next consecutive integer, ensuring no gaps in the rank values.
</details>

**Q22. For scores [90, 90, 85, 80], what will `DENSE_RANK() OVER(ORDER BY score DESC)` produce?**
A) 1, 2, 3, 4
B) 1, 1, 3, 4
C) 1, 1, 2, 3
D) 1, 1, 2, 4

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Both 90s get dense rank 1. The next distinct value, 85, gets dense rank 2, and 80 gets 3.
</details>

**Q23. If you want to find the employee with the second highest salary, and multiple employees might share the highest salary, which function guarantees you can filter `WHERE rank = 2`?**
A) RANK()
B) DENSE_RANK()
C) ROW_NUMBER()
D) PERCENT_RANK()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** With RANK(), if two people tie for first, the next rank is 3, so `rank = 2` would return nothing. DENSE_RANK() guarantees the next salary down gets rank 2.
</details>

**Q24. In a table of 10 rows, if all rows have the same value in the ORDER BY column, what is the maximum value returned by DENSE_RANK()?**
A) 10
B) 1
C) 2
D) NULL

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because all rows tie, they all receive a DENSE_RANK of 1, making 1 the maximum value.
</details>

**Q25. Which of the following functions is deterministic if the ORDER BY column has duplicates and no additional unique columns are provided?**
A) ROW_NUMBER()
B) RANK()
C) DENSE_RANK()
D) Both RANK() and DENSE_RANK()

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** For ties, RANK() and DENSE_RANK() always assign the same value to all tied rows, making their output deterministic. ROW_NUMBER() assigns arbitrary distinct numbers to ties.
</details>

**Q26. You want to assign a unique ID (1, 2, 3...) to every row in a result set purely for display purposes, regardless of duplicate values in other columns. Which function should you use?**
A) RANK()
B) DENSE_RANK()
C) ROW_NUMBER()
D) NTILE()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** ROW_NUMBER() is the only ranking function that guarantees a unique, gapless sequence of integers within a partition or result set.
</details>

**Q27. Given values [10, 20, 20, 30], which function produces [1, 2, 2, 3] when ordered ascending?**
A) RANK()
B) DENSE_RANK()
C) ROW_NUMBER()
D) None of the above

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** 10 is 1, 20 ties for 2. DENSE_RANK() assigns 3 to the next value (30). RANK() would assign 4 to the value 30.
</details>

**Q28. Which function would you use to divide a result set into 4 equal groups?**
A) RANK()
B) DENSE_RANK()
C) ROW_NUMBER()
D) NTILE(4)

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** NTILE(N) distributes the rows in an ordered partition into N roughly equal number of groups.
</details>

**Q29. True or False: ROW_NUMBER(), RANK(), and DENSE_RANK() all require an OVER() clause.**
A) True
B) False
C) True for ROW_NUMBER() only
D) True for RANK() and DENSE_RANK() only

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** All window functions in SQL require the OVER() clause to define the window (partition and ordering).
</details>

**Q30. If you use `DENSE_RANK() OVER (ORDER BY salary DESC)` and the salaries are [100, 90, 90, 80], what is the DENSE_RANK of the salary 80?**
A) 2
B) 3
C) 4
D) 5

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** 100 -> 1, 90 -> 2, 90 -> 2, 80 -> 3.
</details>

**Q31. What is the primary purpose of the LEAD() window function?**
A) To access data from a previous row in the same result set.
B) To access data from a subsequent row in the same result set without using a self-join.
C) To calculate the running total of a column.
D) To find the maximum value in a partition.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LEAD() provides access to a row at a given physical offset that follows the current row.
</details>

**Q32. What is the default offset for the LEAD() function if not explicitly specified?**
A) 0
B) 1
C) -1
D) The last row in the partition

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** If no offset is provided, LEAD() looks at the immediately following row (offset of 1).
</details>

**Q33. What does LEAD() return if the specified offset goes beyond the last row of the partition?**
A) It throws an out-of-bounds error.
B) It wraps around to the first row of the partition.
C) It returns NULL or the specified default value.
D) It returns the value of the current row.

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** When there is no subsequent row to access, LEAD() returns NULL by default, unless a third parameter (default value) is provided.
</details>

**Q34. Which syntax correctly retrieves the salary of the next employee ordered by hire date?**
A) `LEAD(salary) OVER(ORDER BY hire_date)`
B) `LEAD(salary, 1) OVER(ORDER BY hire_date)`
C) `NEXT_VALUE(salary) OVER(ORDER BY hire_date)`
D) Both A and B are correct

<details>
<summary>View Answer</summary>

**Answer:** D
**Explanation:** Both A and B do the same thing, as the default offset for LEAD is 1.
</details>

**Q35. How many arguments can the LEAD() function take in MySQL 8.0?**
A) 1 (the expression)
B) 2 (expression and offset)
C) 3 (expression, offset, and default value)
D) Any number of arguments

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LEAD(expr, [offset], [default]) can take up to three arguments.
</details>

**Q36. You want to calculate the difference between the current day's revenue and the next day's revenue. Which expression achieves this?**
A) `revenue - LAG(revenue) OVER(ORDER BY date)`
B) `revenue - LEAD(revenue) OVER(ORDER BY date)`
C) `LEAD(revenue) - revenue`
D) `revenue - NEXT(revenue) OVER(ORDER BY date)`

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LEAD() gets the next day's revenue, so `revenue - LEAD(...)` computes current minus next.
</details>

**Q37. What happens if you use `LEAD(score, 2, 0)` on the last row of a result set?**
A) It returns NULL.
B) It returns 0.
C) It returns the score of the second row in the table.
D) It throws an error.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Because there is no row 2 positions ahead of the last row, it returns the provided default value, which is 0.
</details>

**Q38. How does `LEAD()` behave when `PARTITION BY department` is included in the OVER() clause?**
A) It fetches the next row from the entire result set, regardless of department.
B) It fetches the next row only if it belongs to the same department; otherwise, it returns the default value (or NULL).
C) It raises an error because LEAD cannot be partitioned.
D) It skips over departments.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Window boundaries confine the function to the current partition. LEAD() will not cross into the next partition.
</details>

**Q39. Is the `ORDER BY` clause mandatory in the `OVER()` clause for the `LEAD()` function?**
A) Yes, without an ordering, the concept of a "next" row is undefined and usually throws an error or yields unpredictable results depending on the SQL mode.
B) No, it automatically orders by the primary key.
C) No, it works perfectly fine without ORDER BY.
D) Yes, but only if an offset greater than 1 is used.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** While MySQL might technically permit an empty OVER() for some functions, LEAD/LAG require ORDER BY to logically define the sequence of rows. Without it, the result is non-deterministic.
</details>

**Q40. You have sales data by month. You want to show the current month's sales alongside the sales from 3 months ahead. Which function call is correct?**
A) `LEAD(sales, 3) OVER(ORDER BY month)`
B) `LEAD(sales, 1, 3) OVER(ORDER BY month)`
C) `LAG(sales, -3) OVER(ORDER BY month)`
D) Both A and C

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** `LEAD(sales, 3)` fetches the value 3 rows ahead based on the ORDER BY month. MySQL does not support negative offsets in LAG.
</details>

**Q41. What is the primary purpose of the LAG() window function?**
A) To retrieve data from the subsequent row.
B) To retrieve data from a preceding row in the same result set.
C) To calculate a moving average.
D) To delay the execution of the query.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LAG() allows you to look back at previous rows (e.g., the immediately preceding row) within a partition.
</details>

**Q42. Which function is the exact opposite of LAG()?**
A) FIRST_VALUE()
B) ROW_NUMBER()
C) LEAD()
D) PRIOR()

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** LEAD() looks forward, while LAG() looks backward.
</details>

**Q43. You need to calculate the month-over-month sales growth: `(Current Month Sales - Previous Month Sales)`. Which window function should you use to get the previous month's sales?**
A) LEAD()
B) LAG()
C) FIRST_VALUE()
D) NTH_VALUE()

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** LAG() is specifically designed to fetch values from preceding rows, which perfectly suits getting the "previous" month's data.
</details>

**Q44. What does `LAG(salary, 1, 50000) OVER (ORDER BY hire_date)` return for the very first row in the result set?**
A) NULL
B) 50000
C) The salary of the first row
D) An error

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Since there is no preceding row for the first row, LAG() returns the provided default value, which is 50000.
</details>

**Q45. If the offset is not provided in a LAG() function call (e.g., `LAG(column_name)`), what is the default offset?**
A) 0
B) 1
C) -1
D) It must be provided; there is no default.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Like LEAD(), the default offset for LAG() is 1, pointing to the immediately preceding row.
</details>

**Q46. Consider `LAG(revenue) OVER(PARTITION BY region ORDER BY year)`. What happens when it processes the first year for the 'North' region?**
A) It fetches the revenue from the last year of the previous region in the overall sort order.
B) It returns NULL because LAG cannot cross partition boundaries.
C) It returns the average revenue of the 'North' region.
D) It returns the current row's revenue.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Window boundaries prevent functions like LAG and LEAD from fetching data from outside the current partition.
</details>

**Q47. Can you use `LAG()` in the `WHERE` clause of a SELECT statement to filter records directly?**
A) Yes, e.g., `WHERE LAG(sales) OVER(...) > 100`
B) No, window functions cannot appear in the WHERE clause directly.
C) Yes, provided that `GROUP BY` is not used.
D) No, LAG() can only be used in `ORDER BY`.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** Window functions are calculated after the WHERE clause. To filter based on LAG(), you must wrap the query in a CTE or subquery.
</details>

**Q48. Which expression accurately replicates `LAG(score, 2) OVER(ORDER BY test_date)` using LEAD?**
A) `LEAD(score, 2) OVER(ORDER BY test_date DESC)`
反
B) `LEAD(score, -2) OVER(ORDER BY test_date)`
C) `LEAD(score, 2) OVER(ORDER BY test_date ASC)`
D) It cannot be replicated with LEAD.

<details>
<summary>View Answer</summary>

**Answer:** A
**Explanation:** Reversing the sort order (from ASC to DESC) makes LEAD (which looks forward in the new order) behave like LAG in the original order.
</details>

**Q49. Which arguments in `LAG(expr, offset, default)` must be literal integers in MySQL?**
A) `expr`
B) `offset` must be a non-negative integer.
C) `default` must be an integer.
D) All arguments must be columns.

<details>
<summary>View Answer</summary>

**Answer:** B
**Explanation:** The offset determines the number of rows to look back and must be a non-negative integer literal or expression that evaluates to one.
</details>

**Q50. A table `events` has columns `id`, `event_time`, and `status`. You want to find the time difference between the current event and the immediately preceding event. Which query snippet is correct?**
A) `TIMEDIFF(event_time, LAG(event_time) OVER (ORDER BY event_time))`
B) `event_time - LEAD(event_time) OVER (ORDER BY event_time DESC)`
C) Both A and B can conceptually yield the correct time difference (ignoring strict return type formatting of TIMEDIFF vs numeric math).
D) `DATEDIFF(LAG(event_time) OVER (ORDER BY event_time), event_time)`

<details>
<summary>View Answer</summary>

**Answer:** C
**Explanation:** Both LAG with ORDER BY ASC and LEAD with ORDER BY DESC refer to the immediately preceding chronogical event. A uses TIMEDIFF on LAG, B subtracts LEAD with DESC order.
</details>

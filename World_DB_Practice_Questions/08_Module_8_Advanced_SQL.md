# Module 8 – Advanced SQL (MySQL 8.0+)

---

## Question 48

### Difficulty
Hard

### SQL Concepts Covered
* CASE
* GROUP BY
* Conditional Aggregation (Pivot Table)

### Objective
Pivot rows into columns.

### Problem Statement
Generate a report showing the total number of countries in the database, broken down by how many are Republics vs Monarchy vs Everything Else. Return exactly one row with three columns: `TotalRepublics`, `TotalMonarchies`, `TotalOther`.

### Tables Used
* `country`

### Hint
Use `SUM()` combined with a `CASE` statement. When the `GovernmentForm` contains 'Republic', return 1, else 0.

### Expected Learning Outcome
Mastering Conditional Aggregation (Pivoting).

### Solution (MySQL)
```sql
SELECT 
    SUM(CASE WHEN GovernmentForm LIKE '%Republic%' THEN 1 ELSE 0 END) AS TotalRepublics,
    SUM(CASE WHEN GovernmentForm LIKE '%Monarchy%' THEN 1 ELSE 0 END) AS TotalMonarchies,
    SUM(CASE WHEN GovernmentForm NOT LIKE '%Republic%' AND GovernmentForm NOT LIKE '%Monarchy%' THEN 1 ELSE 0 END) AS TotalOther
FROM country;
```

### Explanation
* `CASE WHEN ... THEN 1 ELSE 0 END`: For every row, this evaluates to either 1 or 0.
* `SUM(...)`: By summing the 1s and 0s, we effectively count how many rows met the condition, but we do it across multiple columns simultaneously, without needing a `GROUP BY`.

### Dry Run
1. 'United States' (Federal Republic). Republic evaluates to 1. Monarchy 0. Other 0.
2. 'United Kingdom' (Constitutional Monarchy). Republic 0. Monarchy 1. Other 0.
3. `SUM` adds up all the 1s in column 1, then column 2, then column 3.

### SQL Execution Order
1. FROM
2. SELECT (CASE logic evaluated, then SUM applied)

### Alternative Solution
N/A

### Common Mistakes
* Using `COUNT()` instead of `SUM()`. `COUNT(0)` still counts as 1 row! If you want to use `COUNT`, you must write: `COUNT(CASE WHEN ... THEN 1 ELSE NULL END)` because `COUNT` ignores NULLs.

### Interview Tip
Conditional Aggregation is the secret to building Pivot Tables in SQL. If an interviewer asks you to turn rows (Jan, Feb, Mar) into columns (`Jan_Rev`, `Feb_Rev`, `Mar_Rev`), this `SUM(CASE...)` pattern is exactly what they are looking for.

### Related Concepts
* Pivot Tables

---

## Question 49

### Difficulty
Hard

### SQL Concepts Covered
* Window Functions: `ROW_NUMBER()`
* `OVER()`
* `PARTITION BY`

### Objective
Assign a sequential integer to rows within a partition.

### Problem Statement
For *each* Continent, find the 3 most populated countries. Output the Continent, Country Name, Population, and their Rank (1, 2, or 3) within that continent.

### Tables Used
* `country`

### Hint
You cannot use `LIMIT 3` because that restricts the whole query to 3 rows, not 3 rows *per continent*. You must use a Window Function inside a CTE.

### Expected Learning Outcome
Mastering `ROW_NUMBER() OVER(PARTITION BY ...)`.

### Solution (MySQL)
```sql
WITH RankedCountries AS (
    SELECT 
        Continent,
        Name,
        Population,
        ROW_NUMBER() OVER(PARTITION BY Continent ORDER BY Population DESC) AS Rnk
    FROM country
)
SELECT 
    Continent, 
    Name, 
    Population, 
    Rnk
FROM RankedCountries
WHERE Rnk <= 3;
```

### Explanation
* `ROW_NUMBER()`: Assigns a unique integer to each row.
* `PARTITION BY Continent`: Resets the counter back to 1 every time the Continent changes.
* `ORDER BY Population DESC`: Ensures that row 1 goes to the most populated country.
* The `WHERE Rnk <= 3` *must* be done in an outer query (or CTE) because window functions are evaluated in the `SELECT` clause, meaning they cannot be filtered by a `WHERE` clause in the same query block.

### Dry Run
1. CTE processes 'North America'. Sorts by Pop. USA is #1. Mexico #2. Canada #3. Cuba #4.
2. CTE processes 'South America'. Brazil #1. Colombia #2...
3. Outer query runs. Sees Cuba (Rnk 4). Discards. Sees USA (Rnk 1). Keeps.

### SQL Execution Order
1. CTE FROM, SELECT (Window Functions)
2. Outer FROM
3. Outer WHERE
4. Outer SELECT

### Alternative Solution
```sql
-- Using DENSE_RANK()
DENSE_RANK() OVER(PARTITION BY Continent ORDER BY Population DESC)
```
*Pros/Cons:* `ROW_NUMBER` guarantees sequential numbers (1, 2, 3, 4) even if populations tie. `DENSE_RANK` will assign the same number to ties (1, 1, 2, 3). For finding the "Top 3", `DENSE_RANK` is often preferred because if two countries tie for 1st, the third country is correctly ranked 2nd.

### Common Mistakes
* Trying to put `WHERE ROW_NUMBER() <= 3` in the main query. (Syntax error).

### Interview Tip
The "Top N per Group" problem is arguably the most common advanced SQL interview question. If you see "per category", "per department", or "per continent", immediately write `OVER(PARTITION BY...)`.

### Related Concepts
* CTEs
* Window Functions

---

## Question 50

### Difficulty
Hard

### SQL Concepts Covered
* Window Functions: `RANK()` vs `DENSE_RANK()`

### Objective
Understand tie-breaking in window functions.

### Problem Statement
Rank all countries globally by their `LifeExpectancy` (highest life expectancy is rank 1). 
Show the Country Name, LifeExpectancy, `RANK()`, and `DENSE_RANK()`. Observe what happens when two countries tie. (Exclude NULL life expectancies).

### Tables Used
* `country`

### Hint
Since we are ranking globally, you don't need a `PARTITION BY`, only an `ORDER BY` inside the `OVER()` clause.

### Expected Learning Outcome
Understanding the exact difference between `RANK` and `DENSE_RANK`.

### Solution (MySQL)
```sql
SELECT 
    Name,
    LifeExpectancy,
    RANK() OVER(ORDER BY LifeExpectancy DESC) AS StandardRank,
    DENSE_RANK() OVER(ORDER BY LifeExpectancy DESC) AS DenseRank
FROM country
WHERE LifeExpectancy IS NOT NULL;
```

### Explanation
* Both functions rank the rows. If Andorra and Macau both have an 83.5 life expectancy, they both tie for Rank 1.
* The difference happens on the *next* row (San Marino, 81.1).
* `RANK()` skips numbers for ties. (1, 1, **3**).
* `DENSE_RANK()` never skips numbers. (1, 1, **2**).

### Dry Run
1. Andorra (83.5) -> StandardRank: 1, DenseRank: 1
2. Macau (83.5) -> StandardRank: 1, DenseRank: 1
3. San Marino (81.1) -> StandardRank: 3, DenseRank: 2
4. Japan (80.7) -> StandardRank: 4, DenseRank: 3

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT (Window functions execute here)
4. ORDER BY (Implicitly handled by the window function's OVER clause, though you can add an explicit ORDER BY to the query if desired).

### Alternative Solution
N/A

### Common Mistakes
* Thinking `ROW_NUMBER()` handles ties. It doesn't; it arbitrarily assigns 1 and 2 to Andorra and Macau, which is mathematically unfair if their values are identical.

### Interview Tip
"Explain the difference between ROW_NUMBER, RANK, and DENSE_RANK."
Answer: "ROW_NUMBER gives 1,2,3,4. RANK gives 1,1,3,4 (skips). DENSE_RANK gives 1,1,2,3 (no gaps)."

### Related Concepts
* Tie-Breaking Strategies

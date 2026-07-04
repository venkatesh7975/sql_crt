# Module 4 – Aggregate Functions

---

## Question 26

### Difficulty
Easy

### SQL Concepts Covered
* Aggregate Functions: `COUNT()`

### Objective
Count rows in a table.

### Problem Statement
Find the total number of cities in the `city` table.

### Tables Used
* `city`

### Hint
Use the aggregation function that literally counts things.

### Expected Learning Outcome
Basic usage of `COUNT(*)`.

### Solution (MySQL)
```sql
SELECT 
    COUNT(*) AS TotalCities 
FROM city;
```

### Explanation
* `COUNT(*)`: Counts every single row in the table, regardless of whether the rows contain `NULL` values.

### Dry Run
1. Engine scans the table index.
2. Counts exactly 4,079 rows.
3. Returns a single row with the value 4079.

### SQL Execution Order
1. FROM
2. SELECT (Aggregation occurs)

### Alternative Solution
```sql
SELECT COUNT(1) AS TotalCities FROM city;
```
*Pros/Cons:* Functionally identical to `COUNT(*)`. Modern database optimizers treat them as the exact same thing. `COUNT(*)` is the ANSI standard.

### Common Mistakes
* Assuming `COUNT(*)` and `COUNT(column_name)` are the same thing. (See next question).

### Interview Tip
Interviewers will often ask: "Which is faster: COUNT(*) or COUNT(1)?" The answer for modern databases is: "They are exactly the same. The optimizer rewrites them to the same execution plan."

### Related Concepts
* Table Metadata (Fast counting in MyISAM/InnoDB)

---

## Question 27

### Difficulty
Medium

### SQL Concepts Covered
* `COUNT(column)` vs `COUNT(*)`

### Objective
Understand how aggregates handle NULL values.

### Problem Statement
Find the total number of countries in the database, and the total number of countries that have a recorded `IndepYear`. (Output both numbers in a single row).

### Tables Used
* `country`

### Hint
`COUNT(*)` counts physical rows. `COUNT(column_name)` only counts rows where that specific column is NOT NULL.

### Expected Learning Outcome
Mastering the NULL-ignoring behavior of aggregate functions.

### Solution (MySQL)
```sql
SELECT 
    COUNT(*) AS TotalCountries,
    COUNT(IndepYear) AS CountriesWithIndepYear
FROM country;
```

### Explanation
* `COUNT(*)`: Counts all 239 countries.
* `COUNT(IndepYear)`: Evaluates the `IndepYear` column for every row. If it finds a `NULL`, it does *not* increment the counter.

### Dry Run
1. Scan 'USA' (IndepYear 1776). `COUNT(*)` +1. `COUNT(IndepYear)` +1.
2. Scan 'Antarctica' (IndepYear NULL). `COUNT(*)` +1. `COUNT(IndepYear)` +0.

### SQL Execution Order
1. FROM
2. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Believing `COUNT(column_name)` is faster than `COUNT(*)`. It is actually slower, because the database has to physically inspect every row to check if the column is NULL, whereas `COUNT(*)` can often just read the table's metadata index.

### Interview Tip
"What is the difference between COUNT(*) and COUNT(col)?" is a guaranteed interview question. Answer: "COUNT(*) counts rows. COUNT(col) counts non-null values."

### Related Concepts
* Aggregate NULL Handling

---

## Question 28

### Difficulty
Medium

### SQL Concepts Covered
* Aggregate Functions: `SUM()`, `AVG()`

### Objective
Perform mathematical aggregations on a dataset.

### Problem Statement
Calculate the total global population (sum of all country populations) and the average population of a country.

### Tables Used
* `country`

### Hint
Use the sum and average aggregate functions.

### Expected Learning Outcome
Basic usage of `SUM` and `AVG`.

### Solution (MySQL)
```sql
SELECT 
    SUM(Population) AS TotalGlobalPopulation,
    AVG(Population) AS AverageCountryPopulation
FROM country;
```

### Explanation
* `SUM(Population)`: Adds up the population of all 239 rows.
* `AVG(Population)`: Calculates the mean. Mathematically, it is `SUM(Population) / COUNT(Population)`.

### Dry Run
1. Engine reads all Populations.
2. Adds them together (Total).
3. Divides the Total by the count of non-null populations (Average).

### SQL Execution Order
1. FROM
2. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Forgetting that `AVG()` completely ignores `NULL` values. If a country has a NULL population, it acts as if that country doesn't exist for the denominator. If you want to treat NULLs as 0, you must do `AVG(COALESCE(Population, 0))`.

### Interview Tip
Always mention the `NULL` denominator trap when discussing `AVG()`. It shows extreme attention to detail.

### Related Concepts
* COALESCE()

---

## Question 29

### Difficulty
Easy

### SQL Concepts Covered
* Aggregate Functions: `MIN()`, `MAX()`

### Objective
Find the boundaries of a dataset.

### Problem Statement
Find the smallest surface area and the largest surface area among all countries.

### Tables Used
* `country`

### Hint
Use the minimum and maximum aggregate functions.

### Expected Learning Outcome
Using `MIN` and `MAX`.

### Solution (MySQL)
```sql
SELECT 
    MIN(SurfaceArea) AS SmallestArea,
    MAX(SurfaceArea) AS LargestArea
FROM country;
```

### Explanation
* `MIN()`: Scans the column and returns the absolute lowest value.
* `MAX()`: Scans the column and returns the absolute highest value.

### Dry Run
1. Engine scans `SurfaceArea`.
2. Lowest found is 0.40 (Holy See).
3. Highest found is 17075400.00 (Russian Federation).

### SQL Execution Order
1. FROM
2. SELECT

### Alternative Solution
```sql
-- To find the max:
SELECT SurfaceArea FROM country ORDER BY SurfaceArea DESC LIMIT 1;
```
*Pros/Cons:* While `ORDER BY ... LIMIT 1` works, using `MAX()` is syntactically cleaner when you just need the aggregate value. However, if you *also* needed the Name of the country, `ORDER BY ... LIMIT 1` is superior.

### Common Mistakes
* Trying to do `SELECT Name, MAX(SurfaceArea) FROM country`. This is an invalid query in standard SQL because you cannot mix an unaggregated column (`Name`) with an aggregated column (`MAX`) without a `GROUP BY`.

### Interview Tip
`MIN` and `MAX` are highly optimized if the column has a B-Tree index. The database just jumps to the very first or very last leaf node of the index, taking O(1) time.

### Related Concepts
* B-Tree Indexes (First/Last Nodes)

---

## Question 30

### Difficulty
Medium

### SQL Concepts Covered
* Aggregate Functions: `COUNT(DISTINCT)`

### Objective
Count unique occurrences within a column.

### Problem Statement
How many *unique* regions are there in the `country` table? (Return a single number).

### Tables Used
* `country`

### Hint
Combine the function that counts with the keyword that removes duplicates.

### Expected Learning Outcome
Mastering `COUNT(DISTINCT)`.

### Solution (MySQL)
```sql
SELECT 
    COUNT(DISTINCT Region) AS UniqueRegionsCount
FROM country;
```

### Explanation
* `DISTINCT Region`: First, compiles a unique list of all regions (removes duplicates).
* `COUNT(...)`: Second, counts how many items are in that unique list.

### Dry Run
1. 'Caribbean', 'Caribbean', 'Western Europe'...
2. DISTINCT creates: ['Caribbean', 'Western Europe']
3. COUNT calculates the length of that list: 25.

### SQL Execution Order
1. FROM
2. SELECT (DISTINCT evaluated, then COUNT evaluated)

### Alternative Solution
```sql
SELECT COUNT(*) 
FROM (
    SELECT DISTINCT Region FROM country
) AS subquery;
```
*Pros/Cons:* This is an old-school way of doing it before `COUNT(DISTINCT)` was heavily optimized. Today, `COUNT(DISTINCT)` is the standard and preferred method.

### Common Mistakes
* Writing `DISTINCT COUNT(Region)`. This counts all regions (say, 239), and then applies DISTINCT to the number 239, returning 239. The `DISTINCT` must go *inside* the parenthesis.

### Interview Tip
`COUNT(DISTINCT)` can be a performance killer on massive tables (billions of rows) because it often requires a temporary hash table in memory to track uniqueness. 

### Related Concepts
* HyperLogLog (Approximating distinct counts for Big Data)

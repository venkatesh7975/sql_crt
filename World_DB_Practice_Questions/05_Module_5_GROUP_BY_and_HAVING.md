# Module 5 – GROUP BY & HAVING

---

## Question 31

### Difficulty
Medium

### SQL Concepts Covered
* GROUP BY
* COUNT()

### Objective
Aggregate data into buckets.

### Problem Statement
Find the total number of countries in each Continent. Return the Continent name and the country count.

### Tables Used
* `country`

### Hint
You need to put all the countries into "buckets" based on their continent, and then count how many items are in each bucket.

### Expected Learning Outcome
Mastering the fundamental `GROUP BY` clause.

### Solution (MySQL)
```sql
SELECT 
    Continent, 
    COUNT(*) AS TotalCountries
FROM country
GROUP BY Continent;
```

### Explanation
* `GROUP BY Continent`: The database takes all 239 rows and collapses them down into 7 distinct rows (one for each continent).
* `COUNT(*)`: Instead of counting the whole table, it counts the number of original rows that were squashed into each continent bucket.

### Dry Run
1. Engine groups rows: ['North America', 'North America'...] becomes 1 bucket.
2. It counts the original rows in the 'North America' bucket (37).
3. Output: North America, 37.

### SQL Execution Order
1. FROM
2. GROUP BY
3. SELECT (Aggregates evaluated per group)

### Alternative Solution
N/A

### Common Mistakes
* Forgetting `GROUP BY Continent`. If you `SELECT Continent, COUNT(*) FROM country` without a `GROUP BY`, MySQL will either throw an error (if `ONLY_FULL_GROUP_BY` is enabled) or return a random continent next to the total count of 239.

### Interview Tip
The Golden Rule of Aggregation: Any column in your `SELECT` clause that is NOT wrapped in an aggregate function (like `SUM` or `COUNT`) MUST be included in your `GROUP BY` clause.

### Related Concepts
* Aggregate Functions
* ONLY_FULL_GROUP_BY Mode

---

## Question 32

### Difficulty
Medium

### SQL Concepts Covered
* GROUP BY
* SUM()
* ORDER BY

### Objective
Sort aggregated groups.

### Problem Statement
Find the total population of each Region. Return the Region and the total population, sorted from the most populated region to the least populated.

### Tables Used
* `country`

### Hint
Group by the region, sum up the populations, and then order by that sum.

### Expected Learning Outcome
Combining `GROUP BY` with `ORDER BY`.

### Solution (MySQL)
```sql
SELECT 
    Region, 
    SUM(Population) AS RegionalPopulation
FROM country
GROUP BY Region
ORDER BY RegionalPopulation DESC;
```

### Explanation
* `SUM(Population)`: Calculates the total population inside each Region bucket.
* `ORDER BY RegionalPopulation DESC`: Sorts the resulting grouped rows based on the calculated sum.

### Dry Run
1. Groups rows by Region (e.g., 'Eastern Asia').
2. Sums populations for 'Eastern Asia' -> 1507328000.
3. Groups and sums all others.
4. Sorts the final list descending by the sum. Eastern Asia is #1.

### SQL Execution Order
1. FROM
2. GROUP BY
3. SELECT (Aliases assigned here)
4. ORDER BY (Can use aliases assigned in SELECT)

### Alternative Solution
N/A

### Common Mistakes
* Writing `ORDER BY Population DESC`. You must order by the aggregated `SUM(Population)` or the alias `RegionalPopulation`. Ordering by the raw `Population` column doesn't make sense after the rows have been collapsed.

### Interview Tip
Interviewers love asking how SQL execution order works. Notice that `ORDER BY` executes *after* `SELECT`, which is why `ORDER BY` is allowed to use the alias `RegionalPopulation`. `WHERE` cannot use aliases because it executes *before* `SELECT`.

### Related Concepts
* Execution Order vs Syntax Order

---

## Question 33

### Difficulty
Medium

### SQL Concepts Covered
* Multiple GROUP BY columns

### Objective
Create nested aggregation buckets.

### Problem Statement
Find the total number of cities in each Country, broken down further by District. Return the CountryCode, District, and the count of cities.

### Tables Used
* `city`

### Hint
You can group by more than one column. This creates a bucket for every unique combination of those columns.

### Expected Learning Outcome
Mastering multi-column `GROUP BY`.

### Solution (MySQL)
```sql
SELECT 
    CountryCode, 
    District, 
    COUNT(*) AS CityCount
FROM city
GROUP BY CountryCode, District;
```

### Explanation
* `GROUP BY CountryCode, District`: First, it groups all rows by `CountryCode` (e.g., 'USA'). Then, *within* that bucket, it creates smaller sub-buckets for every `District` (e.g., 'California', 'Texas').

### Dry Run
1. Engine finds all 'USA' rows.
2. Inside 'USA', it finds 'California', 'Texas', etc.
3. Creates a row for 'USA' + 'California'. `COUNT(*)` = 68.
4. Creates a row for 'USA' + 'Texas'. `COUNT(*)` = 72.

### SQL Execution Order
1. FROM
2. GROUP BY
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Forgetting to include one of the non-aggregated columns in the `GROUP BY`. If you `SELECT CountryCode, District...` you MUST `GROUP BY CountryCode, District`.

### Interview Tip
Multi-column grouping is essential for hierarchical data (Year/Month, Country/State, Category/Subcategory).

### Related Concepts
* ROLLUP (Used to get subtotals across multiple group by columns).

---

## Question 34

### Difficulty
Hard

### SQL Concepts Covered
* GROUP BY
* HAVING

### Objective
Filter data *after* it has been aggregated.

### Problem Statement
Find all Regions that have a total population greater than 100,000,000. Return the Region and the total population.

### Tables Used
* `country`

### Hint
You cannot use `WHERE` to filter on a `SUM()`. You need a different clause designed for groups.

### Expected Learning Outcome
Mastering the `HAVING` clause.

### Solution (MySQL)
MySQL allows using column aliases in the `HAVING` clause (unlike standard SQL), making it cleaner:
```sql
SELECT 
    Region, 
    SUM(Population) AS TotalPopulation
FROM country
GROUP BY Region
HAVING TotalPopulation > 100000000;
```
*(Standard SQL approach: `HAVING SUM(Population) > 100000000`)*

### Explanation
* `WHERE`: Filters raw rows *before* grouping.
* `HAVING`: Filters the grouped buckets *after* the `GROUP BY` and aggregations have occurred.

### Dry Run
1. Groups into Regions.
2. Sums populations. 'Caribbean' = 38M. 'Eastern Asia' = 1.5B.
3. `HAVING` checks the sums. 'Caribbean' (38M) is < 100M. The entire grouped row is discarded.
4. 'Eastern Asia' (1.5B) is > 100M. The row is kept.

### SQL Execution Order
1. FROM
2. GROUP BY
3. HAVING (Filters the groups)
4. SELECT

### Alternative Solution
```sql
SELECT * FROM (
    SELECT Region, SUM(Population) AS TotalPopulation
    FROM country
    GROUP BY Region
) AS Subquery
WHERE TotalPopulation > 100000000;
```
*Pros/Cons:* Using a CTE or Subquery to aggregate first and then filter in the outer `WHERE` clause achieves the same result, but `HAVING` is specifically designed for this and requires less code.

### Common Mistakes
* Trying to write `WHERE SUM(Population) > 100000000`. This will crash the query because `WHERE` runs before `SUM` exists.

### Interview Tip
"What is the difference between WHERE and HAVING?" is perhaps the most famous SQL interview question of all time. You must be able to articulate that `WHERE` filters rows before grouping, and `HAVING` filters groups after grouping.

### Related Concepts
* Query Execution Order

---

## Question 35

### Difficulty
Hard

### SQL Concepts Covered
* WHERE + GROUP BY + HAVING

### Objective
Combine pre-aggregation filtering with post-aggregation filtering.

### Problem Statement
Look ONLY at countries in the 'Europe' continent. Find the average LifeExpectancy for each Region within Europe. Finally, only return the Regions where that average LifeExpectancy is strictly greater than 75 years.

### Tables Used
* `country`

### Hint
You will need a `WHERE`, a `GROUP BY`, and a `HAVING`.

### Expected Learning Outcome
Mastering the complete pipeline of filtering -> grouping -> filtering.

### Solution (MySQL)
```sql
SELECT 
    Region, 
    AVG(LifeExpectancy) AS AvgLifeExpectancy
FROM country
WHERE Continent = 'Europe'
GROUP BY Region
HAVING AvgLifeExpectancy > 75;
```

### Explanation
* `WHERE Continent = 'Europe'`: First, throws away the rest of the world. (Pre-filter).
* `GROUP BY Region`: Takes the remaining European countries and buckets them by Region (Southern Europe, Western Europe, etc.).
* `HAVING AvgLifeExpectancy > 75`: Throws away any European regions that have a low average life expectancy. (Post-filter).

### Dry Run
1. Evaluates all countries. Discards USA, Brazil, Japan... Keeps France, Spain, Poland...
2. Groups the European countries by Region.
3. Calculates average life expectancy for each European Region.
4. Checks the averages. Eastern Europe average is 69.9. Discarded. Western Europe is 78.3. Kept.

### SQL Execution Order
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Putting `Continent = 'Europe'` in the `HAVING` clause. (e.g. `HAVING Continent = 'Europe' AND AVG(Life) > 75`). While MySQL sometimes allows this loosely, it is terrible for performance because it forces the database to group the *entire world* first, and then discard 90% of the buckets, instead of discarding the rows *before* the expensive grouping operation.

### Interview Tip
Always filter out as much data as possible using `WHERE` *before* hitting the `GROUP BY`. This reduces the amount of memory needed for the grouping operation (Hash Aggregation).

### Related Concepts
* Hash Aggregation Optimization

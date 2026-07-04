# Module 6 – JOINS

---

## Question 36

### Difficulty
Easy

### SQL Concepts Covered
* INNER JOIN
* Table Aliasing

### Objective
Combine data from two related tables based on a foreign key.

### Problem Statement
Retrieve the Name of every city and the Name of the country it belongs to. Return columns `CityName` and `CountryName`.

### Tables Used
* `city`
* `country`

### Hint
The `city` table has a `CountryCode` column. The `country` table has a `Code` column. Link them together.

### Expected Learning Outcome
Mastering basic `INNER JOIN` syntax.

### Solution (MySQL)
```sql
SELECT 
    ci.Name AS CityName, 
    co.Name AS CountryName
FROM city ci
INNER JOIN country co 
    ON ci.CountryCode = co.Code;
```

### Explanation
* `INNER JOIN`: Stitches rows from `city` to rows in `country` where the `ON` condition is met. If a match is not found, the row is discarded.
* `ci` and `co`: Table aliases. They save you from typing `city.Name` and `country.Name`.

### Dry Run
1. Engine reads 'Kabul' from `city`. Its CountryCode is 'AFG'.
2. It looks in `country` for Code = 'AFG'. Finds 'Afghanistan'.
3. Output: 'Kabul', 'Afghanistan'.

### SQL Execution Order
1. FROM (and JOIN)
2. SELECT

### Alternative Solution
```sql
-- Implicit Join (Old School - Pre-ANSI 1992)
SELECT ci.Name, co.Name
FROM city ci, country co
WHERE ci.CountryCode = co.Code;
```
*Pros/Cons:* Never use the implicit comma-join syntax in modern SQL. It makes it extremely difficult to distinguish between join logic and filtering logic. Always use explicit `INNER JOIN ... ON`.

### Common Mistakes
* Ambiguous column names. If you just write `SELECT Name...`, the database throws an error because both tables have a `Name` column. You must prefix it: `ci.Name`.

### Interview Tip
If an interviewer asks "What happens if a city has a NULL CountryCode?", the answer is: "An INNER JOIN will drop that city from the results completely, because NULL = NULL evaluates to Unknown (False)."

### Related Concepts
* ANSI SQL-92 Join Syntax

---

## Question 37

### Difficulty
Medium

### SQL Concepts Covered
* LEFT JOIN
* IS NULL

### Objective
Find orphaned records or data that exists in one table but not another.

### Problem Statement
Find all countries that do NOT have a capital city listed in the database. Return the country Name.

### Tables Used
* `country`
* `city`

### Hint
The `country` table has a `Capital` column, which corresponds to the `ID` column in the `city` table. Use a `LEFT JOIN` and check for `NULL`s on the right side.

### Expected Learning Outcome
Mastering the Anti-Join pattern using `LEFT JOIN`.

### Solution (MySQL)
```sql
SELECT 
    co.Name 
FROM country co
LEFT JOIN city ci 
    ON co.Capital = ci.ID
WHERE ci.ID IS NULL;
```

### Explanation
* `LEFT JOIN`: Takes ALL countries from the left table. If they have a matching capital city on the right, it stitches the data. If they don't, it fills the city columns with `NULL`.
* `WHERE ci.ID IS NULL`: After the join completes, this filters the result set to keep *only* the rows where the stitch failed (i.e., countries with no capital).

### Dry Run
1. Left Join: USA has Capital ID 3813 (Washington). Row stitched.
2. Left Join: Antarctica has Capital ID NULL. City columns filled with NULL.
3. Where filter: Throws away USA. Keeps Antarctica.

### SQL Execution Order
1. FROM (and JOIN)
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name 
FROM country 
WHERE Capital IS NULL;
```
*Pros/Cons:* In this specific database schema, this alternative query works perfectly and is much faster. However, the `LEFT JOIN ... IS NULL` pattern is required if the `Capital` column didn't exist and you had to rely on a mapping table.

### Common Mistakes
* Using `INNER JOIN`. An `INNER JOIN` destroys the rows that don't match, making it impossible to find them.

### Interview Tip
The `LEFT JOIN ... WHERE right_table.id IS NULL` is called an "Anti-Join". It is a fundamental interview pattern used to find users who never logged in, customers who never bought anything, etc.

### Related Concepts
* Anti-Joins
* NOT EXISTS

---

## Question 38

### Difficulty
Medium

### SQL Concepts Covered
* Multiple Table JOIN

### Objective
Join more than two tables together.

### Problem Statement
Retrieve the Name of the city, the Name of the country it belongs to, and the official language spoken in that country. Only include official languages (`IsOfficial = 'T'`).

### Tables Used
* `city`
* `country`
* `countrylanguage`

### Hint
You need to join `city` -> `country` on CountryCode/Code, and then join `country` -> `countrylanguage` on Code/CountryCode.

### Expected Learning Outcome
Chaining multiple `INNER JOIN` clauses.

### Solution (MySQL)
```sql
SELECT 
    ci.Name AS CityName,
    co.Name AS CountryName,
    cl.Language
FROM city ci
INNER JOIN country co 
    ON ci.CountryCode = co.Code
INNER JOIN countrylanguage cl 
    ON co.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T';
```

### Explanation
* You can chain as many `INNER JOIN` clauses as you need. The database engine creates a massive virtual table containing the combined rows before applying the `WHERE` clause.

### Dry Run
1. Matches City 'New York' (USA) to Country 'United States'.
2. Matches 'United States' to CountryLanguage 'English' (IsOfficial = T).
3. Matches 'United States' to CountryLanguage 'Spanish' (IsOfficial = F).
4. `WHERE` filter discards the Spanish row.

### SQL Execution Order
1. FROM (and JOINS)
2. WHERE
3. SELECT

### Alternative Solution
```sql
-- You can put the filtering condition inside the ON clause:
INNER JOIN countrylanguage cl 
    ON co.Code = cl.CountryCode AND cl.IsOfficial = 'T'
```
*Pros/Cons:* For `INNER JOIN`, putting the filter in `ON` vs `WHERE` is functionally identical and the optimizer treats them the same. For `LEFT JOIN`, they behave completely differently.

### Common Mistakes
* Getting lost in aliases. Always use clear aliases like `ci`, `co`, `cl` and apply them to *every* column in your `SELECT` clause to avoid ambiguity.

### Interview Tip
Interviewers will look at how you structure your joins. Put the base table (the one you are logically selecting from, like `city`) first, and join the lookup tables (`country`, `language`) afterwards.

### Related Concepts
* Join chaining

---

## Question 39

### Difficulty
Hard

### SQL Concepts Covered
* JOIN + GROUP BY + Aggregation

### Objective
Aggregate data across multiple joined tables.

### Problem Statement
Find the total population of all cities in each Country. Return the Country Name and the total city population. Sort from highest city population to lowest.

### Tables Used
* `country`
* `city`

### Hint
Join the tables first. Then Group By the Country Name. Then sum the city population.

### Expected Learning Outcome
Combining the concepts from Module 5 and Module 6.

### Solution (MySQL)
```sql
SELECT 
    co.Name AS CountryName, 
    SUM(ci.Population) AS TotalCityPopulation
FROM country co
INNER JOIN city ci 
    ON co.Code = ci.CountryCode
GROUP BY co.Name
ORDER BY TotalCityPopulation DESC;
```

### Explanation
* First, the `JOIN` stitches every single city to its parent country.
* Second, the `GROUP BY` collapses all those rows into buckets based on the `CountryName`.
* Third, `SUM(ci.Population)` adds up the populations of the cities inside each bucket.

### Dry Run
1. Stitches 'New York', 'Los Angeles', 'Chicago' to 'United States'.
2. Groups them all into the 'United States' bucket.
3. Sums 8M + 3.6M + 2.8M...
4. Sorts the final output.

### SQL Execution Order
1. FROM (and JOIN)
2. GROUP BY
3. SELECT
4. ORDER BY

### Alternative Solution
N/A

### Common Mistakes
* `GROUP BY ci.Name` (Grouping by city name). This breaks the query because we want the sum per *country*, not per city.

### Interview Tip
This pattern (Join -> Group -> Aggregate) is the most common SQL pattern in the real world for generating reports (e.g., Join Orders to Users -> Group by User -> Sum Order Totals).

### Related Concepts
* The Fan-Out Trap (Cartesian Explosion) - See next question.

---

## Question 40

### Difficulty
Hard

### SQL Concepts Covered
* Aggregate with JOIN
* Handling Fan-Out / Cartesian Explosions

### Objective
Identify and fix the Fan-Out trap.

### Problem Statement
We want to find the total country population for the 'USA' and the total number of languages spoken there. 
If we run this query:
```sql
SELECT co.Name, co.Population, COUNT(cl.Language)
FROM country co
INNER JOIN countrylanguage cl ON co.Code = cl.CountryCode
WHERE co.Code = 'USA'
GROUP BY co.Name, co.Population;
```
It correctly reports 12 languages, but if we change `COUNT(cl.Language)` to `COUNT(ci.Name)` and add a join to `city`, the counts go crazy. Why? How do you fix it to show Country, Population, Count of Cities, and Count of Languages?

### Tables Used
* `country`
* `city`
* `countrylanguage`

### Hint
You are joining a 1-to-Many table (Cities) and another 1-to-Many table (Languages) to the same base table (Country). This causes a Cartesian explosion. You must pre-aggregate or use `COUNT(DISTINCT)`.

### Expected Learning Outcome
Mastering Cartesian Explosions (Fan-Out Traps).

### Solution (MySQL)
**The COUNT(DISTINCT) approach:**
```sql
SELECT 
    co.Name,
    co.Population AS CountryPopulation,
    COUNT(DISTINCT ci.ID) AS CityCount,
    COUNT(DISTINCT cl.Language) AS LanguageCount
FROM country co
LEFT JOIN city ci ON co.Code = ci.CountryCode
LEFT JOIN countrylanguage cl ON co.Code = cl.CountryCode
WHERE co.Code = 'USA'
GROUP BY co.Name, co.Population;
```

### Explanation
* If the USA has 274 cities and 12 languages, joining them all together creates a massive virtual table of 274 * 12 = 3,288 rows!
* If you just do `COUNT(ci.ID)`, it will return 3,288.
* By doing `COUNT(DISTINCT ci.ID)`, you force it to only count unique city IDs, bypassing the explosion of duplicated rows.

### Dry Run
1. 'New York' is stitched to 'English', 'Spanish', 'French', etc. (12 rows for New York).
2. 'Los Angeles' is stitched to 'English', 'Spanish', etc. (12 rows).
3. `COUNT(DISTINCT city.ID)` looks at the 3,288 rows, finds the 274 unique city IDs, and returns 274.

### SQL Execution Order
1. FROM (and JOINS)
2. WHERE
3. GROUP BY
4. SELECT (DISTINCT evaluated here)

### Alternative Solution
```sql
-- Pre-Aggregation (Faster and safer for massive tables)
WITH CityCounts AS (
    SELECT CountryCode, COUNT(*) AS CityCount FROM city GROUP BY CountryCode
),
LangCounts AS (
    SELECT CountryCode, COUNT(*) AS LangCount FROM countrylanguage GROUP BY CountryCode
)
SELECT co.Name, co.Population, c.CityCount, l.LangCount
FROM country co
LEFT JOIN CityCounts c ON co.Code = c.CountryCode
LEFT JOIN LangCounts l ON co.Code = l.CountryCode
WHERE co.Code = 'USA';
```
*Pros/Cons:* The CTE pre-aggregation approach is vastly superior in production because it entirely prevents the Cartesian explosion from happening in memory.

### Common Mistakes
* Not realizing that joining multiple 1-to-Many tables multiplies the rows together.

### Interview Tip
If an interviewer gives you a query where the `SUM()` or `COUNT()` is suddenly 10x higher than it should be, immediately say "Cartesian Explosion / Fan-Out" and fix it with `COUNT(DISTINCT)` or pre-aggregation.

### Related Concepts
* Cartesian Products
* CTE Pre-Aggregation

---

## Question 41

### Difficulty
Medium

### SQL Concepts Covered
* SELF JOIN

### Objective
Join a table to itself.

### Problem Statement
Find pairs of countries that became independent in the *exact same year*. Return Country A's Name, Country B's Name, and the Independence Year. Ensure you don't match a country to itself, and ensure you don't list the same pair twice (e.g., A-B and B-A).

### Tables Used
* `country`

### Hint
You must join `country co1` to `country co2` on `IndepYear`. To prevent matching USA to USA, use `co1.Code < co2.Code`.

### Expected Learning Outcome
Mastering the Self-Join.

### Solution (MySQL)
```sql
SELECT 
    c1.Name AS Country1,
    c2.Name AS Country2,
    c1.IndepYear
FROM country c1
INNER JOIN country c2 
    ON c1.IndepYear = c2.IndepYear
    AND c1.Code < c2.Code
WHERE c1.IndepYear IS NOT NULL;
```

### Explanation
* `INNER JOIN country c2`: We are opening the same table twice. We MUST use two different aliases (`c1` and `c2`).
* `c1.Code < c2.Code`: This brilliant trick does two things. First, it prevents a country matching itself (because 'USA' is not less than 'USA'). Second, it prevents duplicates. If we match 'FRA' and 'GER', 'FRA' < 'GER' is true. But when it evaluates the reverse ('GER' and 'FRA'), 'GER' < 'FRA' is false, so it drops the duplicate pair!

### Dry Run
1. c1 looks at 'USA' (1776).
2. c2 looks for other countries with 1776. (None exist).
3. c1 looks at 'India' (1947).
4. c2 finds 'Pakistan' (1947). Code 'IND' < 'PAK'. Pair is kept!

### SQL Execution Order
1. FROM (Self Join)
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Using `c1.Code != c2.Code`. This prevents matching a country to itself, but it WILL result in duplicate pairs (You will get a row for India-Pakistan, and a second row for Pakistan-India).

### Interview Tip
The `t1.id < t2.id` trick is the absolute gold standard for solving "find pairs" questions in SQL interviews. Memorize it.

### Related Concepts
* Cross Joins
* Pair Generation

---

## Question 42

### Difficulty
Hard

### SQL Concepts Covered
* LEFT JOIN
* RIGHT JOIN (Conceptual)

### Objective
Understand the directionality of joins.

### Problem Statement
Rewrite the following query using a `RIGHT JOIN` instead of a `LEFT JOIN` so that it produces the exact same results:
```sql
SELECT co.Name, ci.Name
FROM country co
LEFT JOIN city ci ON co.Capital = ci.ID;
```

### Tables Used
* `country`
* `city`

### Hint
A `LEFT JOIN` keeps everything from the first table mentioned. A `RIGHT JOIN` keeps everything from the second table mentioned.

### Expected Learning Outcome
Understanding that LEFT and RIGHT joins are perfectly symmetrical.

### Solution (MySQL)
```sql
SELECT 
    co.Name, 
    ci.Name
FROM city ci
RIGHT JOIN country co 
    ON co.Capital = ci.ID;
```

### Explanation
* By swapping the order of the tables (`FROM city RIGHT JOIN country`), we tell the database to keep all the rows from the `country` table (which is now on the right), achieving the exact same result as `FROM country LEFT JOIN city`.

### Dry Run
1. `country` is on the right. Keep all countries.
2. Look to the left (`city`) for a matching Capital ID.
3. If no match, fill `city.Name` with NULL.

### SQL Execution Order
1. FROM (and JOIN)
2. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Keeping `FROM country RIGHT JOIN city`. This would keep all *cities* instead of all countries, fundamentally changing the result set.

### Interview Tip
In professional environments, `RIGHT JOIN` is almost never used. Engineers overwhelmingly prefer to re-order the tables and use `LEFT JOIN` exclusively because humans read from left to right (Base Table -> Joined Table). If an interviewer asks about `RIGHT JOIN`, tell them you know how it works but prefer `LEFT JOIN` for readability.

### Related Concepts
* FULL OUTER JOIN (Combining LEFT and RIGHT joins via UNION in MySQL)

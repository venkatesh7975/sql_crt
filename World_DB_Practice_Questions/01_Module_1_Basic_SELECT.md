# Module 1 – Basic SELECT

---

## Question 01

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* Specific Columns
* LIMIT

### Objective
Retrieve basic information about countries.

### Problem Statement
Write a query to retrieve the names and continents of the first 5 countries listed in the database.

### Tables Used
* `country`

### Hint
You don't need all columns, just two. Use a clause at the end to restrict the number of rows.

### Expected Learning Outcome
Understanding how to select specific columns and limit the result set.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Continent 
FROM country
LIMIT 5;
```

### Explanation
* `SELECT Name, Continent`: We explicitly request only two columns, reducing network overhead.
* `FROM country`: Specifies the source table.
* `LIMIT 5`: Restricts the output to exactly 5 rows.

### Dry Run
1. The engine looks at the `country` table.
2. It grabs the `Name` and `Continent` for Aruba, Afghanistan, Angola, Anguilla, and Albania.
3. It stops after finding 5 rows.

### SQL Execution Order
1. FROM
2. SELECT
3. LIMIT

### Alternative Solution
No major alternative for such a basic query.

### Common Mistakes
* Using `SELECT *` when only two columns are needed.
* Forgetting that `LIMIT` must be the absolute last clause in the query.

### Interview Tip
Always avoid `SELECT *` in technical interviews unless explicitly told to retrieve all columns. It shows you care about memory and network I/O optimization.

### Related Concepts
* TOP (SQL Server equivalent of LIMIT)
* ROWNUM (Oracle equivalent of LIMIT)

---

## Question 02

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* DISTINCT

### Objective
Find all unique regions present in the database.

### Problem Statement
Write a query to list all the unique regions where countries are located.

### Tables Used
* `country`

### Hint
There are multiple countries in the same region. How do you remove the duplicates from your result?

### Expected Learning Outcome
Mastering the `DISTINCT` keyword to eliminate duplicate rows from a result set.

### Solution (MySQL)
```sql
SELECT DISTINCT 
    Region 
FROM country;
```

### Explanation
* `SELECT DISTINCT`: Instructs MySQL to evaluate the specified column (`Region`) and remove any duplicate values before returning the final result set.

### Dry Run
1. Engine reads `Region` column: "Caribbean", "Southern and Central Asia", "Central Africa", "Caribbean"...
2. `DISTINCT` processes the list. When it sees "Caribbean" the second time, it discards it.
3. Returns a unique list of regions.

### SQL Execution Order
1. FROM
2. SELECT
3. DISTINCT (applied during projection)

### Alternative Solution
```sql
SELECT Region 
FROM country 
GROUP BY Region;
```
*Pros/Cons:* `GROUP BY` achieves the same result, but `DISTINCT` is semantically clearer when you just want a unique list and aren't performing aggregations (like COUNT or SUM).

### Common Mistakes
* Writing `DISTINCT(Region)` as if it were a function. `DISTINCT` is a keyword that applies to all columns selected.

### Interview Tip
If an interviewer asks "How do you find unique values?", `DISTINCT` is the primary answer. If they ask "How does DISTINCT work under the hood?", you can mention it often requires a sorting operation or a hash table to identify the duplicates.

### Related Concepts
* GROUP BY
* Hash Aggregation

---

## Question 03

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* ORDER BY
* ASC / DESC

### Objective
Sort countries by their surface area.

### Problem Statement
Write a query to retrieve the Name and SurfaceArea of all countries, sorted from the largest surface area to the smallest.

### Tables Used
* `country`

### Hint
You need to organize the results. Which keyword sorts data, and which modifier makes it go from biggest to smallest?

### Expected Learning Outcome
Understanding how to use `ORDER BY` with the `DESC` keyword.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    SurfaceArea 
FROM country
ORDER BY SurfaceArea DESC;
```

### Explanation
* `ORDER BY SurfaceArea`: Instructs the database engine to sort the final result set based on the `SurfaceArea` column.
* `DESC`: Specifies Descending order (largest to smallest). The default is `ASC` (Ascending).

### Dry Run
1. Engine selects all Names and SurfaceAreas.
2. It sorts them: Russian Federation (17075400.00) goes to the top. Antarctica (13120000.00) is next.
3. Returns the sorted list.

### SQL Execution Order
1. FROM
2. SELECT
3. ORDER BY

### Alternative Solution
N/A

### Common Mistakes
* Forgetting `DESC`, which results in the smallest countries (or those with 0 surface area) appearing first.

### Interview Tip
Sorting (`ORDER BY`) is an expensive operation in databases. Interviewers will often ask how to make this query faster. The answer is: "Create a B-Tree index on the `SurfaceArea` column."

### Related Concepts
* Indexing for sorting
* LIMIT with ORDER BY (Top N queries)

---

## Question 04

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* Aliases (AS)

### Objective
Rename columns in the output for better readability.

### Problem Statement
Retrieve the `Name` and `GNP` of all countries, but rename the columns in the output to `Country Name` and `Gross National Product`.

### Tables Used
* `country`

### Hint
You can rename columns on the fly using a specific two-letter keyword. Use quotes if your new name has spaces.

### Expected Learning Outcome
Using column aliases to format output for business users or applications.

### Solution (MySQL)
```sql
SELECT 
    Name AS 'Country Name', 
    GNP AS 'Gross National Product'
FROM country;
```

### Explanation
* `AS 'Country Name'`: Creates a temporary alias for the column. Because the alias contains a space, it must be enclosed in single quotes (or backticks in MySQL).

### Dry Run
1. Engine retrieves the `Name` and `GNP` columns.
2. Before sending the output to the client, it relabels the headers.

### SQL Execution Order
1. FROM
2. SELECT (Aliases are created here)

### Alternative Solution
```sql
SELECT 
    Name 'Country Name', 
    GNP 'Gross National Product'
FROM country;
```
*Pros/Cons:* You can omit the `AS` keyword, but including it is considered best practice because it makes the SQL much easier to read.

### Common Mistakes
* Using double quotes `"` instead of single quotes `'` or backticks `` ` ``. While MySQL often tolerates double quotes depending on SQL_MODE, single quotes or backticks are standard for aliases with spaces.

### Interview Tip
Always use `AS` for clarity. If an interviewer asks if an alias can be used in a `WHERE` clause, the answer is NO (because `WHERE` executes before `SELECT`).

### Related Concepts
* Table Aliasing

---

## Question 05

### Difficulty
Easy

### SQL Concepts Covered
* SELECT
* WHERE
* Simple Comparison Operators

### Objective
Filter rows based on a specific condition.

### Problem Statement
Write a query to find all information about the country with the Code 'USA'.

### Tables Used
* `country`

### Hint
You need to restrict the rows returned using a condition.

### Expected Learning Outcome
Basic row filtering using the `WHERE` clause.

### Solution (MySQL)
```sql
SELECT * 
FROM country
WHERE Code = 'USA';
```

### Explanation
* `WHERE Code = 'USA'`: This clause evaluates every row in the table. If the `Code` column exactly matches the string 'USA', the row is kept. Otherwise, it is discarded.

### Dry Run
1. Engine scans `country`.
2. Checks row 1 (Aruba). Code is 'ABW'. Discard.
3. Finds United States. Code is 'USA'. Keep.
4. Returns the single row.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Using `==` instead of `=` for equality. (SQL uses a single equals sign).

### Interview Tip
Since `Code` is the Primary Key of the `country` table, this query performs an "Index Seek" (O(1) or O(log N) complexity) rather than a "Full Table Scan" (O(N) complexity). Mentioning this will impress the interviewer.

### Related Concepts
* Primary Keys
* Index Seeks

---

## Question 06

### Difficulty
Easy

### SQL Concepts Covered
* WHERE
* Multiple Conditions (AND)

### Objective
Filter data using multiple strict criteria.

### Problem Statement
Find the names of all countries that are in the continent of 'Europe' AND have a population greater than 50 million (50,000,000).

### Tables Used
* `country`

### Hint
Use a logical operator to combine two conditions.

### Expected Learning Outcome
Combining filters using the `AND` operator.

### Solution (MySQL)
```sql
SELECT 
    Name 
FROM country
WHERE Continent = 'Europe' 
  AND Population > 50000000;
```

### Explanation
* `AND`: Both conditions must evaluate to TRUE for a row to be included in the result set.

### Dry Run
1. Evaluate 'France': Continent = 'Europe' (TRUE). Population = 59225700 > 50M (TRUE). Row is kept.
2. Evaluate 'Spain': Continent = 'Europe' (TRUE). Population = 39441700 > 50M (FALSE). Row is discarded.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
N/A

### Common Mistakes
* Writing `50,000,000` with commas. In SQL, numbers must not contain commas.

### Interview Tip
When using multiple `AND` conditions, the database optimizer will generally use the index on the most "selective" column first to narrow down the rows as quickly as possible.

### Related Concepts
* Query Optimization
* Selectivity

---

## Question 07

### Difficulty
Easy

### SQL Concepts Covered
* WHERE
* Multiple Conditions (OR)

### Objective
Filter data where at least one condition is true.

### Problem Statement
Retrieve the names and continents of all countries located in either 'North America' or 'South America'.

### Tables Used
* `country`

### Hint
Use a logical operator that allows either condition to be true.

### Expected Learning Outcome
Using the `OR` operator for flexible filtering.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Continent 
FROM country
WHERE Continent = 'North America' 
   OR Continent = 'South America';
```

### Explanation
* `OR`: If the first condition is TRUE, or the second condition is TRUE, the row is kept.

### Dry Run
1. Evaluate 'Canada': Continent = 'North America' (TRUE). Row is kept.
2. Evaluate 'Brazil': Continent = 'South America' (TRUE). Row is kept.
3. Evaluate 'China': Continent = 'Asia' (FALSE). Row is discarded.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, Continent 
FROM country
WHERE Continent IN ('North America', 'South America');
```
*Pros/Cons:* The `IN` operator is much cleaner and easier to read, especially when checking against many values.

### Common Mistakes
* Writing `WHERE Continent = 'North America' OR 'South America'`. You must explicitly declare the column name for every OR condition.

### Interview Tip
In complex queries mixing `AND` and `OR`, always use parentheses to explicitly define the order of operations, as `AND` takes precedence over `OR`.

### Related Concepts
* IN Operator
* Operator Precedence

---

## Question 08

### Difficulty
Easy

### SQL Concepts Covered
* WHERE
* IN Operator

### Objective
Filter based on a list of exact matches.

### Problem Statement
Find the names of all cities located in the countries with the codes: 'USA', 'CAN', and 'MEX'.

### Tables Used
* `city`

### Hint
Instead of writing three `OR` statements, use a single keyword that checks against a list.

### Expected Learning Outcome
Using the `IN` operator to simplify multiple `OR` conditions.

### Solution (MySQL)
```sql
SELECT 
    Name 
FROM city
WHERE CountryCode IN ('USA', 'CAN', 'MEX');
```

### Explanation
* `IN (...)`: Checks if the value in `CountryCode` matches any of the values inside the parentheses.

### Dry Run
1. Scan `city` table.
2. 'Kabul' (CountryCode = 'AFG') -> Not in list. Discard.
3. 'New York' (CountryCode = 'USA') -> In list. Keep.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name 
FROM city
WHERE CountryCode = 'USA' OR CountryCode = 'CAN' OR CountryCode = 'MEX';
```
*Pros/Cons:* This works, but is overly verbose and harder to maintain if the list grows to 20 countries.

### Common Mistakes
* Forgetting the parentheses around the list of values.

### Interview Tip
`IN` lists are heavily optimized by the MySQL engine. If the list is a subquery, MySQL 8.0 will often rewrite it as a `JOIN` or use materialization for performance.

### Related Concepts
* NOT IN
* Subqueries with IN

---

## Question 09

### Difficulty
Medium

### SQL Concepts Covered
* WHERE
* BETWEEN Operator

### Objective
Filter data within a numeric range.

### Problem Statement
Find the Name and Population of all countries whose population is between 10 million and 20 million (inclusive).

### Tables Used
* `country`

### Hint
You can use `>=` and `<=`, or a single keyword designed for ranges.

### Expected Learning Outcome
Using `BETWEEN` to cleanly filter continuous ranges.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Population 
FROM country
WHERE Population BETWEEN 10000000 AND 20000000;
```

### Explanation
* `BETWEEN x AND y`: Checks if the value is greater than or equal to `x`, AND less than or equal to `y`. It is fully inclusive.

### Dry Run
1. 'Netherlands' (Population = 15864000). 15.8M is between 10M and 20M. Keep.
2. 'Belgium' (Population = 10239000). 10.2M is between 10M and 20M. Keep.
3. 'Sweden' (Population = 8861400). 8.8M is less than 10M. Discard.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT

### Alternative Solution
```sql
SELECT Name, Population 
FROM country
WHERE Population >= 10000000 AND Population <= 20000000;
```
*Pros/Cons:* Identical performance. `BETWEEN` is just syntactic sugar that makes the code easier to read.

### Common Mistakes
* Assuming `BETWEEN` is exclusive. It is ALWAYS inclusive in standard SQL.
* Putting the larger number first (e.g., `BETWEEN 20000000 AND 10000000`). This will always return 0 rows.

### Interview Tip
`BETWEEN` is SARGable, meaning it can utilize a B-Tree index effectively (a Range Scan).

### Related Concepts
* SARGability
* Date Ranges with BETWEEN

---

## Question 10

### Difficulty
Medium

### SQL Concepts Covered
* ORDER BY Multiple Columns
* LIMIT

### Objective
Sort by multiple criteria and return the top result.

### Problem Statement
Find the single most populated city in the 'USA'. Return the city Name and its Population.

### Tables Used
* `city`

### Hint
You need to filter by country, sort by population (highest first), and restrict the output to 1 row.

### Expected Learning Outcome
Combining `WHERE`, `ORDER BY`, and `LIMIT` in a single query.

### Solution (MySQL)
```sql
SELECT 
    Name, 
    Population 
FROM city
WHERE CountryCode = 'USA'
ORDER BY Population DESC
LIMIT 1;
```

### Explanation
* `WHERE`: Narrows the dataset to only US cities.
* `ORDER BY Population DESC`: Sorts those US cities so the biggest is row 1.
* `LIMIT 1`: Chops off everything except row 1.

### Dry Run
1. Filter: Keep only USA cities (New York, Los Angeles, Chicago...).
2. Sort: New York (8008278) goes to the top.
3. Limit: Returns only New York.

### SQL Execution Order
1. FROM
2. WHERE
3. SELECT
4. ORDER BY
5. LIMIT

### Alternative Solution
```sql
SELECT Name, Population 
FROM city 
WHERE CountryCode = 'USA' 
  AND Population = (SELECT MAX(Population) FROM city WHERE CountryCode = 'USA');
```
*Pros/Cons:* Using `LIMIT` is much faster and cleaner. The subquery approach requires reading the table twice (once to find the max, once to find the city matching that max).

### Common Mistakes
* Putting `LIMIT 1` before `ORDER BY`. (`LIMIT` must always be the last clause).

### Interview Tip
This `ORDER BY ... LIMIT 1` pattern is the standard, optimized way to answer "Find the most X" or "Find the top X" questions in interviews.

### Related Concepts
* Top N Queries
* Window Functions (`ROW_NUMBER()`)
